SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_DESADV_Delphi_Details]
	@ShipperID int

as

-- FT.usp_DESADV_Delphi_Details 61014
declare
	@result int
set nocount on
set ansi_warnings off
set ansi_padding on

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Body>
/*	Table for DESADV data. */
create table
	#desadvData
(
	ID int identity(1,1) primary key
,	MessageSection varchar(10) default ('') not null
,	EDIFACTData varchar(1000) default ('') not null
,	Data char(80) default ('') not null
)

/*	Pull detail data from shipped serials. */
create table #ShipperSerials
(
	Serial int
,	ParentSerial int
,	Part varchar(25)
,	AccumShipped numeric(20,6)
,	ModelYear varchar(4)
,	CustomerRevLevel varchar(25)
,	CustomerPO varchar(25)
,	PackageType varchar(25)
,	BoxQty int
,	Box bit
,	StorageLocation varchar(35)
)

insert
	#ShipperSerials
(
	Serial
,	ParentSerial
,	Part
,	AccumShipped
,	ModelYear
,	CustomerRevLevel
,	CustomerPO
,	PackageType
,	BoxQty
,	Box
,	StorageLocation
)
select
	Serial = at.serial
,	ParentSerial = at.parent_serial
,	Part = sd.customer_part
,	AccumShipped = ISNULL(accum_shipped,0)
,	ModelYear = ISNULL(oh.model_year,'2010')
,	CustomerRev=COALESCE(oh.engineering_level,oh.customer_part, 'AddRevLevel')
,	CustomerPO = ISNULL(sd.customer_po,'')
,	PackageType = coalesce((select name from dbo.package_materials where code = at.package_type), 'CTN90')
,	BoxQty = at.quantity
,	Box = case at.object_type when 'S' then 0 else 1 end
,	StorageLocation = coalesce (oh.line11, '0001')
from
	dbo.audit_trail at
	left join dbo.shipper_detail sd on
		sd.shipper = @ShipperID
		and
			sd.part_original = at.part
		and
			coalesce (sd.suffix, -1) = coalesce(at.suffix, -1)
	left join dbo.order_header oh on
		oh.order_no = sd.order_no
where
	at.type = 'S'
	and
		at.shipper = convert(varchar, @ShipperID)

/*	Track cps counter. */
declare
	@cps int ; set @cps = 0

/*	Loop through parent serial, part-packs and write details. */
declare
	@parentSerial int
,	@part varchar(25)
,	@AccumShipped int
,	@boxPackageType varchar(25)
,	@ModelYear varchar(4)
,	@CustomerRevLevel varchar(25)
,	@CustomerPO varchar(25)
,	@qtyPerBox int
,	@qtyPacked int
,	@boxes int
,	@boxStorageLocation varchar(35)
,	@Kanban char(35)
,	@KanbanQual char(3)

Select @Kanban = '0000000'
Select @KanbanQual = 'AL'

declare
	PartPacks cursor local for
select
	MAX(0)
,	Part
,	AccumShipped
,	PackageType
,	ModelYear
,	CustomerRevLevel
,	CustomerPO
,	qtyPerBox = BoxQty
,	qtyPacked = sum(BoxQty)
,	boxes = count(*)
,	boxStorageLocation = max(StorageLocation)
from
	#ShipperSerials ss
where
	Box = 1
group by
	Part
,	AccumShipped
,	PackageType
,	BoxQty
,	ModelYear
,	CustomerRevLevel
,	CustomerPO

open
	PartPacks

while
	1 = 1 begin

	fetch
		PartPacks
	into
		@parentSerial
	,	@part
	,	@accumshipped
	,	@boxPackageType
	,	@ModelYear
	,	@CustomerRevLevel
	,	@CustomerPO
	,	@qtyPerBox
	,	@qtyPacked
	,	@boxes
	,	@boxStorageLocation
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
/*		Generate new CPS. */	
	set	@cps = @cps + 1
	
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0370-1', 'CPS+' + convert(varchar, @CPS) + '++' + '1'''/*FlatFile*/,
			'14' + CONVERT(char(3), '4')
	if	@boxPackageType like '%*%' begin
		insert #desadvData (MessageSection, EDIFACTData, Data) select '0410', 'PAC+' + convert(varchar, @boxes) + '+' + substring(@boxPackageType, 1, patindex('%*%', @boxPackageType) - 1) + ''''/*FlatFile*/,
			'15' + CONVERT(char(3), '4')+ convert(char(10), @boxes)+ CONVERT(char(17),substring(@boxPackageType, 1, patindex('%*%', @boxPackageType) - 1))
	end
	else	begin
		insert #desadvData (MessageSection, EDIFACTData, Data) select '0410', 'PAC+' + convert(varchar, @boxes) + '+' + @boxPackageType + ''''/*FlatFile*/,
			'15' + CONVERT(char(3), '4')+ convert(char(10), @boxes)+ CONVERT(char(17),@boxPackageType)
	end
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0480', 'PCI+16+' + @boxStorageLocation + ''''/*FlatFile*/,
			'17' + CONVERT(char(35),@boxStorageLocation)
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0480', 'PCI+16+' + @boxStorageLocation + ''''/*FlatFile*/,
			'18' + @Kanban + @KanbanQual

/*		Write parent serial, part-pack serials. */
	--- <Call>	
	set	@CallProcName = 'FT.usp_DESADV_Delphi_ParentSerialPartPackDetails'
	execute
		@ProcReturn = FT.usp_DESADV_Delphi_ParentSerialPartPackDetails 
				@ParentSerial = @parentSerial
			,	@Part = @part
			,	@PackageType = @boxPackageType
			,	@BoxQty = @qtyPerBox
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		return	@Result
	end
	--- </Call>

	insert #desadvData (MessageSection, EDIFACTData, Data) select '0560', 'LIN+++' + @part + ':IN'''/*FlatFile*/,
			'20' + SPACE(6)+CONVERT(char(35), @part)+ convert(char(35), @ModelYear)
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0560', 'LIN+++' + @part + ':IN'''/*FlatFile*/,
			'21' + CONVERT(char(35), @CustomerRevLevel)
			
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0600', 'QTY+3+' + convert(varchar, @AccumShipped) + ':C62'''/*FlatFile*/,
			'23' + CONVERT(char(14), @AccumShipped)+CONVERT(char(3), 'C62')+CONVERT(char(14), @qtyPacked)+CONVERT(char(3), 'C62')
	--insert #desadvData (MessageSection, EDIFACTData, Data) select '0600', 'QTY+12+' + convert(varchar, @qtyPacked) + ':C62'''
	
	insert #desadvData (MessageSection, EDIFACTData, Data) select 'XXXX', 'XXXXXXXX' + convert(varchar, 999999) + 'XXXXXX'''/*FlatFile*/,
			'26' + CONVERT(char(35), @CustomerPO)
	
	
end

close
	PartPacks

deallocate
	PartPacks

/*	Loop through skid/lid packaging and write details. */
declare
	@skidLidPackageType int
,	@packCount varchar(25)

declare
	SkidLidPacks cursor local for
select
	SkidLidPackageType = PackageType
,	PackCount = count(*)
from
	(
		select
			PackageType = substring(PackageType, 1, patindex('%*%', PackageType) - 1)
		from
			#ShipperSerials
		where
			Box = 0
			and
				PackageType like '%*%'
		union all
		select
			PackageType = substring(PackageType, patindex('%*%', PackageType) + 1, 25)
		from
			#ShipperSerials
		where
			Box = 0
			and
				PackageType like '%*%'
		union all
		select
			PackageType
		from
			#ShipperSerials
		where
			Box = 0
			and
				PackageType not like '%*%'
		union all
		select
			PackageType = substring(PackageType, patindex('%*%', PackageType) + 1, 25)
		from
			#ShipperSerials
		where
			Box = 1
			and
				PackageType like '%*%'
	) SkidLidPackages
group by
	PackageType

open
	SkidLidPacks

while
	1 = 1 begin

	fetch
		SkidLidPacks
	into
		@skidLidPackageType
	,	@packCount
	
	if	@@FETCH_STATUS != 0 begin
		break
	end

/*		Write details of skid or lid. */
	set	@cps = @cps + 1
	
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0370-2', 'CPS+' + convert(varchar, @CPS) + '++' + '3'''/*FlatFile*/,
			'14' + CONVERT(char(3), '3')
	insert #desadvData (MessageSection, EDIFACTData, Data) select '0410', 'PAC+' + convert(varchar, @packCount) + '+' + CONVERT(varchar(10),@skidLidPackageType) + ''''/*FlatFile*/,
			'15' + CONVERT(char(3), '4')+ convert(char(10), @packCount)+ CONVERT(char(17),@skidLidPackageType)
end

close
	SkidLidPacks

deallocate
	SkidLidPacks

--- </Body>

---	<Return>
select
	ID
,	MessageSection
,	EDIFACTData
,	CONVERT(char(80),Data) + CONVERT(char(3),ID)
from
	#desadvData
order by
	ID

set	@result = case @@ROWCOUNT when 0 then 100 else 0 end
return
	@result
--- </Return>
GO
