SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [RTV].[usp_CreateRTV_ImportSerials]
	@OperatorCode varchar(5)
--,	@SerialList varchar(max)
,	@FirstNewRTVShipper int = null out
,	@RTVShipperCount int = null out
,	@RtvShipperList varchar(250) out
,	@RtvNumber varchar(50) = null out
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 999999


--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
-- Auto-generate a Return to Vendor "number"
declare
	@LastRtvNumber varchar(50) = null
,	@TwoDigitYear char(2)
,	@CurrentTwoDigitYear char(2)
,	@EndingDigits char(4)
	
select
	@LastRtvNumber = lu.RmaRtvNumber
from
	dbo.SerialRMaRtvLookup lu
where
	lu.RowCreateDT = (
			select
				max(lu2.RowCreateDT)
			from
				dbo.SerialRmaRtvLookup lu2
			where
				lu2.TransactionType = 3 )
				

set	@CurrentTwoDigitYear = right(year(getdate()), 2)

if (@LastRtvNumber is not null) begin

	set @EndingDigits = right(@LastRtvNumber, 4)
	set @TwoDigitYear = substring(@LastRtvNumber, (charindex(' ', @LastRtvNumber) + 1), 2)
	
	if (convert(int, @TwoDigitYear) < convert(int, @CurrentTwoDigitYear ) ) begin
		-- Increment the year and reset the ending digits
		set @RtvNumber = 'RTV ' + @CurrentTwoDigitYear + '-1000'
	end
	else begin
		-- Increment the ending digits
		set @RtvNumber = 'RTV ' + @CurrentTwoDigitYear + '-' + convert(char(4), convert(int, @EndingDigits) + 1)
	end
	
end
else begin
	-- The first RTV Number
	set @RtvNumber = 'RTV ' + @CurrentTwoDigitYear + '-1000'
end



/*	Create serial list. */
create table #serialList
(	serial int
,	quantity decimal(20,6)
,	RowID int not null IDENTITY(1, 1) primary key
)

insert
	#serialList
select
	srma.Serial
,	srma.Quantity
from 
	dbo.SerialsQuantitiesToAutoRMA_RTV srma
where
	srma.OperatorCode = @OperatorCode

/*
insert
	#serialList
select
	serial = convert(int, fsstr.value)
from
	dbo.fn_SplitStringToRows(@SerialList, ',') fsstr
where
	fsstr.Value like '%[0-9]%'
	and fsstr.Value not like '%[^0-9]%'
*/


/*	Ensure all serials are valid. */
declare
	@invalidSerialList varchar(max)

select
	@invalidSerialList = Fx.ToList(sl.serial)
from
	#serialList sl
where
	not exists
		(	select
				*
			from
				dbo.object o
			where
				o.serial = sl.serial
		)

if	@invalidSerialList > ''
	begin
	set @Result = 999999
	raiserror ('One or more serials do not exist in the system (object table): (%s).  Procedure %s.', 16, 1, @invalidSerialList, @ProcName)
	rollback tran @ProcName
	return
end

/*	Ensure all serials can be returned to Honduras. */
declare
	@invalidHondurasSerialList varchar(max)

select
	@invalidHondurasSerialList = Fx.ToList(convert(varchar, sl.serial) + ':' +o.part)
from
	#serialList sl
	join dbo.object o
		on o.serial = sl.serial
where
	not exists
		(	select
				*
			from
				dbo.po_header ph
			where
				ph.blanket_part  = o.part
		)

if	@invalidHondurasSerialList > ''
	begin
	set @Result = 999999
	raiserror ('The following serials/parts have PO# issues: (%s).  Procedure %s.', 16, 1, @invalidHondurasSerialList, @ProcName)
	rollback tran @ProcName
	return
end

/*	Ensure serials don't conflict with any in Honduras. */
declare
	@EEHSelect varchar(max)
	
select
	@EEHSelect = 'select serial from eeh.dbo.object where serial in (' + FX.ToList(sl.serial) + ')'
from
	#serialList sl
--print @EEHSelect

declare
	@OpenQuerySyntax nvarchar(max) = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'
--print @OpenQuerySyntax

declare @temp table
(
	Serial int
)

insert into
	@temp
exec 
	sp_executesql @OpenQuerySyntax

if	exists
		(	select
  	 			*
  	 		from
  	 			@temp t
		) begin

	declare @conflictHondurasSerialList varchar(max)
	select
		@conflictHondurasSerialList = FX.ToList(t.Serial)
	from
		@temp t
	set @Result = 999999
	raiserror ('One or more serials already in Honduras: (%s).  Procedure %s.', 16, 1, @conflictHondurasSerialList, @ProcName)
	rollback tran @ProcName
	return
end



/*  Make sure none of the parts are raw parts  */
declare @tempPartsList table
(
	Part varchar(30)
,	PartValidated int
)

insert into
	@tempPartsList
select 
	o.part
,	0
from
	#serialList sl
	join dbo.object o
		on o.serial = sl.serial
group by
	o.part

declare
	@currentPart varchar(30)
	
	
while ( ( select count(1) from @tempPartsList tpl where tpl.PartValidated = 0) > 0 ) begin
	
	select 
		@currentPart = min(tpl.Part)
	from
		@tempPartsList tpl
	where
		tpl.PartValidated = 0
	
	if ( (	
			select
				p.type
			from
				dbo.part p
			where
				p.part = @currentPart ) = 'R' ) begin
				
		set	@Result = 999200
		RAISERROR ('%s is a raw part.  Cannot RMA / RTV raw parts here.  Procedure %s.', 16, 1, @currentPart, @ProcName)
		rollback tran @ProcName
		return
	end
	
	update
		@tempPartsList
	set
		PartValidated = 1
	where
		Part = @currentPart

end



/*	Create RTV shippers. */
/*	Generate a list of parts and get GL segment from Honduras. */
declare
	@PartList varchar(max)

select
	@PartList =
	(	select
			FX.ToList(distinct '''''' + o.part + '''''')
		from
			#serialList sl
			join dbo.object o
				on o.serial = sl.serial
	)
	

select
	@EEHSelect = '
select
	p.part
,	pl.gl_segment
from
	eeh.dbo.part p
		join eeh.dbo.product_line pl
			on pl.id = p.product_line
where
	p.part in (' + @PartList + ')'
--print @EEHSelect

set	@OpenQuerySyntax = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'
--print @OpenQuerySyntax

declare
	@RTVPartGLSegments table
(	Part varchar(25) primary key
,	GLSegment varchar(50)
)

insert into
	@RTVPartGLSegments
exec 
	sp_executesql @OpenQuerySyntax

--select
--	*
--from
--	@RTVPartGLSegments rpgs

/*	Get shipper number(s) per GLSegment. */
declare
	@RTVShippers table
(	GLSegment varchar(50) primary key
,	ShipperID int
)

insert
	@RTVShippers
(	GLSegment
,	ShipperID
)
select
	rpgs.GLSegment
,	p.shipper + row_number() over (order by rpgs.GLSegment) - 1
from
	(	select
			rpgs.GLSegment
		from
			@RTVPartGLSegments rpgs
		group by
			rpgs.GLSegment
	) rpgs
	cross join dbo.parameters p with(tablockx)
	


-- Return the list of RTV shippers
select
	@RtvShipperList = Fx.ToList(s.ShipperID)
from
	@RTVShippers s
	
	

/*  Insert RtvNumber and serials into a look-up table for reporting purposes  */
--- <Insert rows="1+">
insert dbo.SerialRmaRtvLookup
(
	RmaRtvNumber
,	Serial
,	GlSegment
,	TransactionType
,	RowCreateUser
,	RowModifiedUser
)
select
	RmaRtvNumber = @RtvNumber
,	Serial = sl.serial
,	GlSegment = rpgs.GLSegment
,	TransactionType = 3
,	RowCreateUser = @OperatorCode
,	RowModifiedUser = @OperatorCode
from 
	#serialList sl
	join dbo.object o
		join dbo.part p
			on p.part = o.part
		join dbo.part_inventory pInv
			on pInv.part = o.part
		on o.serial = sl.serial
	join @RTVPartGLSegments rpgs
		on rpgs.Part = o.part
--	join @RTVShippers rs
--		on rs.GLSegment = rpgs.GLSegment
--group by
--	rs.ShipperID
--</Insert>
	
	
	
	

update
	p
set	shipper = p.shipper	+
		(	select
				count(ShipperID)
			from
				@RTVShippers rs
		)
from
	dbo.parameters p

/*	Create shipper header(s). */
--- <Insert rows="1+">
set	@TableName = 'dbo.shipper'

insert
	dbo.shipper
(	id
,	destination
,	status
,	customer
,	staged_objs
,	type
,	date_stamp
,	cs_status
,	operator
)
select
	id = rs.ShipperID
,	destination = 'EmpHond'
,	status = 'S'
,	customer = ''
,	staged_objs = count(*)
,	type = 'V'
,	date_stamp = @TranDT
,	cs_status = 'Approved'
,	operator = @OperatorCode
from
	#serialList sl
	join dbo.object o
		join dbo.part p
			on p.part = o.part
		join dbo.part_inventory pInv
			on pInv.part = o.part
		on o.serial = sl.serial
	join @RTVPartGLSegments rpgs
		on rpgs.Part = o.part
	join @RTVShippers rs
		on rs.GLSegment = rpgs.GLSegment
group by
	rs.ShipperID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Create shipper details(s). */
--- <Insert rows="1+">
set	@TableName = 'dbo.shipper_detail'

insert
	dbo.shipper_detail
(	shipper
,	part
,	qty_required
,	qty_packed
,	qty_original
,	accum_shipped
,	order_no
,	type
,	account_code
,	operator
,	boxes_staged
,	alternative_qty
,	alternative_unit
,	price_type
,	customer_part
,	part_name
,	part_original
,	stage_using_weight
)
select
	shipper = rs.ShipperID
,	part = o.part
,	qty_required = sum(sl.quantity)
,	qty_packed = sum(sl.quantity)
,	qty_original = sum(sl.quantity)
,	accum_shipped = 0
,	order_no = 0
,	type = 'I'
,	account_code = '4030'
,	operator = @OperatorCode
,	boxes_staged = count(*)
,	alternative_qty = sum(o.std_quantity)
,	alternative_unit = max(pInv.standard_unit)
,	price_type = 'P'
,	customer_part = o.part
,	part_name = max(p.name)
,	part_original = o.part
,	stage_using_weight = 'N'
from
	#serialList sl
	join dbo.object o
		join dbo.part p
			on p.part = o.part
		join dbo.part_inventory pInv
			on pInv.part = o.part
		on o.serial = sl.serial
	join @RTVPartGLSegments rpgs
		on rpgs.Part = o.part
	join @RTVShippers rs
		on rs.GLSegment = rpgs.GLSegment
group by
	rs.ShipperID
,	o.part

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>

--select
--	*
--from
--	dbo.shipper s
--	join dbo.shipper_detail sd
--		on sd.shipper = s.id
--	join @RTVShippers rs
--		on rs.ShipperID = s.id


/*	Stage objects to shippers. */
--- <Update rows="1+">
set	@TableName = 'dbo.object'

update
	o
set	shipper = rs.ShipperID
,	show_on_shipper = 'Y'
from
	#serialList sl
	join dbo.object o
		join dbo.part p
			on p.part = o.part
		join dbo.part_inventory pInv
			on pInv.part = o.part
		on o.serial = sl.serial
	join @RTVPartGLSegments rpgs
		on rpgs.Part = o.part
	join @RTVShippers rs
		on rs.GLSegment = rpgs.GLSegment

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>


/*
/*	Get the RTV shipper info to return. */
select
	@FirstNewRTVShipper = min(rs.ShipperID)
,	@RTVShipperCount = count(*)
from
	@RTVShippers rs
*/

-- Return data
--select
--	convert(varchar(50), rs.ShipperID) as Shipper
--from
--	@RTVShippers rs
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@OperatorCode varchar(5)
,	@SerialList varchar(max)
,	@FirstNewRTVShipper int
,	@RTVShipperCount int

set @OperatorCode = 'EES'
set	@SerialList = '36264629,36307338,36267319,'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = RTV.usp_CreateRTV_ImportSerials
	@OperatorCode = @OperatorCode
,	@SerialList = @SerialList
,	@FirstNewRTVShipper = @FirstNewRTVShipper out
,	@RTVShipperCount = @RTVShipperCount out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @FirstNewRTVShipper, @RTVShipperCount

select
	*
from
	dbo.shipper s
where
	s.id between @FirstNewRTVShipper and @FirstNewRTVShipper + @RTVShipperCount - 1

select
	*
from
	dbo.shipper_detail sd
where
	sd.shipper between @FirstNewRTVShipper and @FirstNewRTVShipper + @RTVShipperCount - 1

select
	*
from
	dbo.object o
where
	o.shipper between @FirstNewRTVShipper and @FirstNewRTVShipper + @RTVShipperCount - 1
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
