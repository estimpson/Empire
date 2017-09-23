SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDI].[usp_Process_GMSPO]
	@TranDT datetime out
,	@Result integer out
,	@Testing int = 1
--<Debug>
,	@Debug integer = 0
--</Debug>
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	set	@StartDT = GetDate ()
	print	'START.   ' + Convert (varchar (50), @StartDT)
	set	@ProcStartDT = GetDate ()
end
--</Debug>

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI.usp_Test
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
--<Debug>
if @Debug & 1 = 1 begin
	print	'Determine the current DELFORs and DELJITs.'
	print	'	Active are all DELJITs for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Determine the current DELFORs and DELJITs. */
/*		Active are all DELJITs for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).*/
declare
	@CurrentDELJITs table
(	RawDocumentGUID uniqueidentifier
,	NewDocument int
)

insert
	@CurrentDELJITs
select
	c.RawDocumentGUID
,	c.NewDocument
from
	GMSPOEDI.CurrentDELJITs() c

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.'
end
--</Debug>
/*		Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.  */
declare
	@CurrentDELFORs table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ICCode varchar(15)
,	CustomerPart varchar(35)
,	NewDocument int
)

insert
	@CurrentDELFORs
--select
--	c.RawDocumentGUID
--,	c.ShipToCode
--,	c.ShipFromCode
--,	c.ICCode
--,	c.CustomerPart
--,	c.NewDocument
--from
--	GMSPOEDI.CurrentDELFORs() c

select distinct
	fr.RawDocumentGUID
,	fr.ShipToCode
,	fr.ShipFromCode
,	fr.ICCode
,	fr.CustomerPart
,	case
		when fr.status = 0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'New'))
			then 1
		else 0
	end
from
	EDI.GMSPO_DELFOR_Releases fr
	join EDI.GMSPO_DELFOR_Headers fh
		on fh.RawDocumentGUID = fr.RawDocumentGUID
where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
	)
	and fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'Active'))
	)
	and fh.DocumentDT =
	(	select
			max(fh2.DocumentDT)
		from
			EDI.GMSPO_DELFOR_Headers fh2
			join EDI.GMSPO_DELFOR_Releases fr2
				on fr2.RawDocumentGUID = fh2.RawDocumentGUID
		where
			fr.ShipToCode = fr2.ShipToCode
			and fr.CustomerPart = fr2.CustomerPart
	)
	and fh.DocNumber =
	(	select
			max(fh2.DocNumber)
		from
			EDI.GMSPO_DELFOR_Headers fh2
			join EDI.GMSPO_DELFOR_Releases fr2
				on fr2.RawDocumentGUID = fh2.RawDocumentGUID
		where
			fr.ShipToCode = fr2.ShipToCode
			and fr.CustomerPart = fr2.CustomerPart
			and fh.DocumentDT = fh2.DocumentDT
	)
	and fh.DocumentImportDT =
	(	select
			max(fh2.DocumentImportDT)
		from
			EDI.GMSPO_DELFOR_Headers fh2
			join EDI.GMSPO_DELFOR_Releases fr2
				on fr2.RawDocumentGUID = fh2.RawDocumentGUID
		where
			fr.ShipToCode = fr2.ShipToCode
			and fr.CustomerPart = fr2.CustomerPart
			and fh.DocumentDT = fh2.DocumentDT
			and fh.DocNumber = fh2.DocNumber
			and fh.ControlNumber = fh2.ControlNumber
	)
order by
	fr.ShipToCode
,	fr.ShipFromCode
,	fr.ICCode
,	fr.CustomerPart

--<Debug>
if @Debug & 1 = 1 begin
	print	'...determined.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

/*		If the current DELJITs and DELFORs are already "Active", done. */
if	not exists
	(	select
			*
		from
			@CurrentDELJITs cd
		where
			cd.NewDocument = 1
	)
	and not exists
	(	select
			*
		from
			@CurrentDELFORs cd
		where
			cd.NewDocument = 1
	)
	and @Testing = 0 begin
	set @Result = 100
	rollback transaction @ProcName
	return
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Mark "Active" DELJITs and DELFORs.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Mark "Active" DELJITs and DELFORs. */
--- <Update rows="*">
set	@TableName = 'EDI.GMSPO_DELJIT_Headers'

update
	fh
set
	Status =
		case
			when cd.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELJIT_Headers', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI.GMSPO_DELJIT_Headers', 'Status', 'Replaced'))
		end
from
	EDI.GMSPO_DELJIT_Headers fh
	left join @CurrentDELJITs cd
		on fh.RawDocumentGUID = cd.RawDocumentGUID
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELJIT_Headers', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELJIT_Headers', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDI.GMSPO_DELFOR_Releases'

update
	fr
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Replaced'))
		end
from
	EDI.GMSPO_DELFOR_Releases fr
	left join @CurrentDELFORs c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and fr.CustomerPart = c.CustomerPart

where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*">

--- <Update rows="*">
set	@TableName = 'EDI.GMSPO_DELFOR_Cumulatives'

update
	fr
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Replaced'))
		end
from
	EDI.GMSPO_DELFOR_Cumulatives fr
	left join @CurrentDELFORs c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and fr.CustomerPart = c.CustomerPart

where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*">

set	@TableName = 'EDI.GMSPO_DELFOR_Headers'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDI.GMSPO_DELFOR_Releases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'Replaced'))
	end
from
	EDI.GMSPO_DELFOR_Headers fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

if	@Testing > 1 begin
	select
		'GMSPO_DELJIT_Headers'

	select
		*
	from
		EDI.GMSPO_DELJIT_Headers fh

	select
		'GMSPO_DELFOR_Headers'
		
	select
		*
	from
		EDI.GMSPO_DELFOR_Headers fh
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active DELJITs and DELFORs.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Write new releases. */
/*		Calculate raw releases from active DELJITs and DELFORs. */
declare @RawReleases table
(	RowID int not null IDENTITY(1, 1) primary key
,	Status int default(0)
,	OrderNo int
,	Type tinyint
,	ReleaseDT datetime
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	DockCode varchar(30) null
,	LineFeedCode varchar(30) null
,	ReserveLineFeedCode varchar(30) null
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	CustomerAccum numeric(20,6)
,	OurAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	NewDocument int
,	unique
	(	OrderNo
	,	NewDocument
	,	RowID
	)
,	unique
	(	OrderNo
	,	RowID
	,	RelPost
	,	QtyRelease
	,	StdQtyRelease
	)
,	unique
	(	OrderNo
	,	Type
	,	RowID
	)
)

insert
	@RawReleases
(	OrderNo
,	Type
,	ReleaseDT
,	BlanketPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	OrderUnit
,	ReleaseNo
,	DockCode
,	LineFeedCode
,	ReserveLineFeedCode
,	QtyRelease
,	StdQtyRelease
,	CustomerAccum
,	OurAccum
,	NewDocument
)
select
	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = fr.ReleaseDT
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.InternalShipTo
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	DockCode = fr.DockCode
,	LineFeedCode = fr.LineFeedCode
,	ReserveLineFeedCode = fr.ReserveLineFeedCode
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	CustomerAccum = bo.AccumShipped
,	OurAccum = bo.AccumShipped
,	NewDocument = c.NewDocument
from
	EDI.GMSPO_DELJIT_Headers fh
	join EDI.GMSPO_DELJIT_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	join GMSPOEDI.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart

	left join @CurrentDELJITs c
		on c.RawDocumentGUID = fh.RawDocumentGUID
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELJIT_Headers', 'Status', 'Active'))
union all
select
	OrderNo = bo.BlanketOrderNo
,	Type = 2
,	ReleaseDT = fr.ReleaseDT
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.InternalShipTo
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	DockCode = null
,	LineFeedCode = null
,	ReserveLineFeedCode = null
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	CustomerAccum = coalesce(bo.AccumShipped, 0)
,	OurAccum = coalesce(bo.AccumShipped, 0)
,	NewDocument = c.NewDocument
from
	EDI.GMSPO_DELFOR_Headers fh
	join EDI.GMSPO_DELFOR_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDI.GMSPO_DELFOR_Cumulatives dcv
		on	dcv.RawDocumentGUID = fh.RawDocumentGUID
		and  dcv.CustomerPart = fr.CustomerPart
		and	dcv.ShipToCode = fr.ShipToCode 
		and	dcv.QtyQualifier = 1
		and	isNull(dcv.Status,-1) != -1
	left join GMSPOEDI.BlanketOrders bo
		on bo.EDIShipToCode =  fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart

	left join @CurrentDELFORs c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and fr.CustomerPart = c.CustomerPart
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Headers', 'Status', 'Active'))
	and fr.Status = 1--(select dbo.udf_StatusValue('EDI.GMSPO_DELFOR_Releases', 'Status', 'Active'))
	and	dcv.status = 1
	
order by
	1, 2, 3

/*		Calculate orders to update. */
update
	rr
set
	NewDocument =
	(	select
			max(NewDocument)
		from
			@RawReleases rr2
		where
			rr2.OrderNo = rr.OrderNo
	)
from
	@RawReleases rr

delete
	rr
from
	@RawReleases rr
where
	rr.NewDocument = 0

/*		Calculate running cumulatives. */
update
	@RawReleases
set
	RelPost = CustomerAccum + coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and Type = rr.Type
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

/*	Blend DELJITs and DELFORs. */
update
	rr
set
	RelPrior = coalesce (
	(	select
			max(RelPost)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), CustomerAccum)
from
	@RawReleases rr
--select	* from @RawReleases
delete
	@RawReleases
where
	RelPost <= OurAccum
	
update rr
set	rr.QtyRelease =  rr.RelPost-rr.OurAccum,
		rr.RelPrior = rr.OurAccum
from
	@RawReleases rr
where
	rr.OurAccum between RelPrior and RelPost
--select	* from @RawReleases
if	@Testing = 2 begin
	select
		'@RawReleases'
	
	select
		*
	from
		@RawReleases rr
end

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0

/*	Calculate order line numbers. */
update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID
			and StdQtyRelease > 0)
,	QtyShipper = shipSchedule.qtyRequired
from
	@RawReleases rr
	left join
	(	select
			orderNo = sd.order_no
		,	qtyRequired = sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
		group by
			sd.order_no
	) shipSchedule
		on shipSchedule.orderNo = rr.OrderNo

--<Debug>
if @Debug & 1 = 1 begin
	print	'	...calculated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Replace order detail.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*		Replace order detail. */
if	@Testing = 0 begin

	if	objectproperty(object_id('dbo.order_detail_deleted'), 'IsTable') is not null begin
		drop table dbo.order_detail_deleted
	end
	select
		*
	into
		dbo.order_detail_deleted
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	order by
		order_no
	,	due_date
	,	sequence
	
	--- <Delete rows="*">
	set	@TableName = 'dbo.order_detail'
	
	delete
		od
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Delete>
	
	--- <Insert rows="*">
	set	@TableName = 'dbo.order_detail'
	
if	object_id('tempdb.dbo.##BlanketOrderReleases_Edit') is null begin

	create table ##BlanketOrderReleases_Edit
	(	SPID int default @@SPID
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	ActiveOrderNo int
	,	ReleaseNo varchar(30)
	,	ReleaseDT datetime
	,	ReleaseType char(1)
	,	QtyRelease numeric(20,6)
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	SPID
		,	ActiveOrderNo
		,	ReleaseNo
		,	ReleaseDT
		)
	)
end

delete
	##BlanketOrderReleases_Edit
where
	SPID = @@SPID

insert
	##BlanketOrderReleases_Edit
(	ActiveOrderNo
,	ReleaseNo
,	ReleaseDT
,	ReleaseType
,	QtyRelease
)
select
	bor.OrderNo
,   bor.ReleaseNo
,   bor.ReleaseDT
,	bor.Type
,   sum(bor.QtyRelease)
from
	@RawReleases bor
group by
	bor.OrderNo
,   bor.ReleaseNo
,   bor.ReleaseDT
,	bor.Type

order by
	bor.orderNo
,	bor.ReleaseDT
,	bor.ReleaseNo

--select	* from ##BlanketOrderReleases_Edit
--select	* from	@Rawreleases

--Call Procedure to Spread the demand
DECLARE @RC2 int
DECLARE @TranDT2 datetime
DECLARE @Result2 int


EXECUTE @RC2 = [MONITOR].[dbo].[usp_GetBlanketOrderDistributedReleases] 
   @TranDT2 OUTPUT
  ,@Result2 OUTPUT
  ,@Debug = 0


DECLARE @RC3 int
DECLARE @TranDT3 datetime
DECLARE @Result3 int

EXECUTE @RC3 = [MONITOR].[dbo].[usp_SaveBlanketOrderDistributedReleases] 
   @TranDT3 OUTPUT
  ,@Result3 output
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
	
	/*	Set dock code, line feed code, and reserve line feed code. */
	
	/*if  exists
		(	select
				*
			from
				dbo.order_header oh
				join @RawReleases rr
					on rr.OrderNo = oh.order_no
					and rr.RowID =
					(	select
							min(rr2.RowID)
						from
							@RawReleases rr2
						where
							rr2.OrderNo = oh.order_no
							and rr2.Type = 1
					)
			where 
				coalesce(oh.dock_code,'') != coalesce(rr.DockCode,'')
				or coalesce(oh.line_feed_code,'') != coalesce(rr.LineFeedCode,'')
				or coalesce(oh.zone_code,'') != coalesce(rr.ReserveLineFeedCode,'')
		) begin
	
		insert
			EDI.GMSPODELJITDockHeader
		(	SystemDT
		)
		select
			@TranDT
		
		insert 	
			EDI.GMSPODELJITDockDetails
		(	HeaderTimeStamp
		,	OrderNo
		,	NewDockCode
		,	OldDockCode
		,	NewLineFeed
		,	OldLineFeed
		,	NewReserveLineFeed
		,	OldReserveLineFeed
		)
		select
			HeaderTimeStamp
		,	rr.OrderNo
		,	rr.DockCode
		,	oh.dock_code
		,	rr.LineFeedCode
		,	oh.line_feed_code
		,	rr.ReserveLineFeedCode
		,	oh.zone_code
		from
			dbo.order_header oh
			join @RawReleases rr
				on rr.OrderNo = oh.order_no
				   and rr.RowID =
				   (	select
							min(rr2.RowID)
						from
							@RawReleases rr2
						where
							rr2.OrderNo = oh.order_no
							and rr2.Type = 1
					)
			cross join
			(	select
					convert(int,@@DBTS) as HeaderTimeStamp
			) HeaderTimeStamp
		where
			coalesce(oh.dock_code,'') != coalesce(rr.DockCode,'')
			or coalesce(oh.line_feed_code,'') != coalesce(rr.LineFeedCode,'')
			or coalesce(oh.zone_code,'') != coalesce(rr.ReserveLineFeedCode,'')
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set
			dock_code = COALESCE(rr.DockCode,'')
		,	line_feed_code = COALESCE(rr.LineFeedCode,'')
		,	zone_code = COALESCE(rr.ReserveLineFeedCode,'')
		from
			dbo.order_header oh
			join @RawReleases rr
				on rr.OrderNo = oh.order_no
				and rr.RowID =
				(	select
						min(rr2.RowID)
					from
						@RawReleases rr2
					where
						rr2.OrderNo = oh.order_no
						and rr2.Type = 1
				)
				where (COALESCE(rr.DockCode,'')!= COALESCE(oh.dock_code,'') or COALESCE(line_feed_code,'') != COALESCE(rr.LineFeedCode,'') or COALESCE(zone_code,'') != COALESCE(rr.ReserveLineFeedCode,''))
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
	end*/
	--- </Update>
end
else begin
	if	@Testing > 1 begin
		select 'raw releases'
		
		select
			Type
		,	OrderNo
		,	BlanketPart
		,	CustomerPart
		,	ShipToID
		,	CustomerPO
		,	ModelYear
		,	OrderUnit
		,	QtyShipper
		,	Line
		,	ReleaseNo
		,	QtyRelease
		,	StdQtyRelease
		,	OurAccum
		,	CustomerAccum
		,	RelPrior
		,	RelPost
		,	ReleaseDT
		from
			@RawReleases
		order by
			OrderNo
		,	RowID
		
		select 'to be deleted'

		select
			od.*
		from
			dbo.order_detail od
		where
			od.order_no in (select OrderNo from @RawReleases)
		order by
			order_no
		,	due_date
		
		/*	to be inserted*/
		
		select 'to be inserted'
	end
		
	select
		order_no = rr.OrderNo
	,	sequence = rr.Line
	,	part_number = rr.BlanketPart
	,	product_name = (select name from dbo.part where part = rr.BlanketPart)
	,	type = case rr.Type when 1 then 'F' when 2 then 'P' end
	,	quantity = rr.RelPost - rr.relPrior
	,	status = ''
	,	notes = case rr.Type when 1 then 'DELJIT Release' when 2 then 'DELFOR Release' end
	,	unit = (select unit from order_header where order_no = rr.OrderNo)
	,	due_date = rr.ReleaseDT
	,	release_no = rr.ReleaseNo
	,	destination = rr.ShipToID
	,	customer_part = rr.CustomerPart
	,	row_id = rr.Line
	,	flag = 1
	,	ship_type = 'N'
	,	packline_qty = 0
	,	packaging_type = bo.PackageType
	,	weight = (rr.RelPost - rr.relPrior) * bo.UnitWeight
	,	plant = (select plant from order_header where order_no = rr.OrderNo)
	,	week_no = datediff(wk, (select fiscal_year_begin from parameters), rr.ReleaseDT) + 1
	,	std_qty = rr.RelPost - rr.relPrior
	,	our_cum = rr.RelPrior
	,	the_cum = rr.RelPost
	,	price = (select price from order_header where order_no = rr.OrderNo)
	,	alternate_price = (select alternate_price from order_header where order_no = rr.OrderNo)
	,	committed_qty = coalesce
		(	case
				when rr.QtyShipper > rr.RelPost - bo.AccumShipped then rr.RelPost - rr.relPrior
				when rr.QtyShipper > rr.RelPrior - bo.AccumShipped then rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
			end
		,	0
		)
	from
		@RawReleases rr
		join GMSPOEDI.BlanketOrders bo
			on bo.BlanketOrderNo = rr.OrderNo
	order by
		1, 2
end
--<Debug>
if @Debug & 1 = 1 begin
	print	'	...replaced.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>
--- </Body>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert (varchar, DateDiff (ms, @ProcStartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Closetran AutoRollback=Yes>
if	@TranCount = 0 begin
	rollback tran @ProcName
end
--- </Closetran>

---	<Return>
--if	@Testing != 0
--	and @@trancount > 0 begin
--	rollback tran @ProcName
--end
/* Start E-Mail Alerts and Exceptions*/

if @Testing = 0
begin

DECLARE @EmailAddress nvarchar(max) 

Select 
		@EmailAddress = coalesce(max(nullif(text_6,'')),'eeischedulers@empireelect.com') 
		from 
		ar_customer_attributes where customer in 
		( Select		destination.customer 
				from		destination
				where exists (Select 1 
												from 
												@RawReleases rr 
												where rr.ShipToID = destination.destination
											)
		)
		

Declare @EDIOrdersAlert table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseNo] [varchar](100) NULL,
	[CustomerPart] [varchar](100) NULL,
	[CustomerPO] [varchar](100) NULL,
	[ShipToCode] [varchar](100) NULL,
	[Type] [varchar](100) NULL,
	[Notes] [varchar](5000) NULL
	)
		
		if exists (select 1 
						from 
							@CurrentDELJITs FDELJITc
						join	
							EDI.GMSPO_DELJIT_Releases FDELJITr on FDELJITc.RawDocumentGUID = FDELJITr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode = FDELJITr.ShipToCode
						and 
							bo.CustomerPart = FDELJITr.CustomerPart
						where 
							bo.BlanketOrderNo is null
						union
						select 1 
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Releases FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode in (FDELFORr.ICCode, FDELFORr.ShipToCode)
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
							
						where 
							bo.BlanketOrderNo is null)
		Begin
		insert	@EDIOrdersAlert
		        ( ReleaseNo ,
		          CustomerPart ,
		          CustomerPO ,
		          ShipToCode ,
		          Type ,
		          Notes 
		        )
		select		
				distinct
				Coalesce(left(ReleaseNo,2),'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Exception'
			,	'Blanket sales order not found; please add blanket sales order and reprocess EDI'
		         
		from (select
						FDELJITr.ReleaseNo ReleaseNo, 
						FDELJITr.CustomerPart CustomerPart,
						FDELJITr.CustomerPO CustomerPO,
						FDELJITr.ShipToCode ShipToID
						from 
							@CurrentDELJITs FDELJITc
						join	
							EDI.GMSPO_DELJIT_Releases FDELJITr on FDELJITc.RawDocumentGUID = FDELJITr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode = FDELJITr.ShipToCode
						and 
							bo.CustomerPart = FDELJITr.CustomerPart
						where 
							bo.BlanketOrderNo is null
						union
					select
						FDELFORr.ReleaseNo ReleaseNo, 
						FDELFORr.CustomerPart CustomerPart,
						FDELFORr.CustomerPO CustomerPO,
						FDELFORr.ShipToCode ShipToID						 
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Releases FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode =  FDELFORr.ShipToCode
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
						where 
							bo.BlanketOrderNo is null
					
				) GMSPOEDIExceptions
		
		
	order by
		2,3,4



		DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>GMSPO EDI Exceptions</H1>' +
    N'<table border="1">' +
    N'<tr><th>ReleaseNo</th>' +
    N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.CustomerPO, '',
                    td = eo.ShipToCode, '',
                    td = eo.notes
              FROM @EDIOrdersAlert  eo
             where	type = 'Exception'
             order by 1,2,3  
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'EDI Data Exception when processing GMSPO EDI Document(s)', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
		end
		
		
		-- E-Mail Alerts for Accum discrepancy
		
			if exists (
						select 
						1
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Cumulatives FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode =  FDELFORr.ShipToCode
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							convert(int,bo.AccumShipped) != coalesce(CumulativeQty,0)
						)
		Begin
		insert	@EDIOrdersAlert
		        ( ReleaseNo ,
		          CustomerPart ,
		          CustomerPO ,
		          ShipToCode ,
		          Type ,
		          Notes 
		        )
		select		
				distinct
				Coalesce(left(ReleaseNo,2),'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Accum Discrepancy'
			,	'Blanket sales order  ' + convert(varchar (8), OrderNo) + ' Accum Discrepancy ' + ' Customer Accum : '+ convert(varchar (max), isNull(CumulativeQty,0)) + ' / ' + 'Our Accum : ' +  convert(varchar (max), isNull(convert(int,AccumShipped),0))
		         
		from (select
						(select max(ReleaseNo) from EDI.GMSPO_DELFOR_Releases SPOR where SPOR.RawDocumentGUID = FDELFORr.RawDocumentGUID and SPOR.CustomerPart = FDELFORr.CustomerPart  ) ReleaseNo, 
						FDELFORr.CustomerPart CustomerPart,
						FDELFORr.CustomerPO CustomerPO,
						FDELFORr.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo,
						bo.AccumShipped,
						FDELFORr.CumulativeQty						 
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Cumulatives FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode =  FDELFORr.ShipToCode
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							convert(int,bo.AccumShipped) != coalesce(CumulativeQty,0)
					
				) GMSPOEDIAlerts
		
		
	order by
		2,3,4
		
		
		
		DECLARE @tableHTMLAA  NVARCHAR(MAX) ;

SET @tableHTMLAA =
    N'<H1>GMSPO Accum Discrepancy</H1>' +
    N'<table border="1">' +
    N'<tr><th>ReleaseNo</th>' +
    N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.CustomerPO, '',
                    td = eo.ShipToCode, '',
                    td = eo.notes
              FROM @EDIOrdersAlert  eo
             where	[type] = 'Accum Discrepancy'
            order by 1,2,3 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'EDI Data Alert - GMSPO EDI Document(s) Accum Dicrepancy', -- nvarchar(255)
    @body = @TableHTMLAA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
   end
	
	
		
	--E-Mail Alerts that Orders were update	
		if exists (select 
						1
						from 
							@CurrentDELJITs FDELJITc
						join	
							EDI.GMSPO_DELJIT_Releases FDELJITr on FDELJITc.RawDocumentGUID = FDELJITr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode = FDELJITr.ShipToCode
						and 
							bo.CustomerPart = FDELJITr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							exists (select 1 from dbo.order_detail od where od.customer_part = FDELJITr.CustomerPart and od.destination = bo.InternalShipTo and od.release_no = FDELJITr.ReleaseNo)
						union
						select 
						1
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Releases FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode in (FDELFORr.ICCode, FDELFORr.ShipToCode)
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							exists (select 1 from dbo.order_detail od where od.customer_part = FDELFORr.CustomerPart and od.destination = bo.InternalShipTo and od.release_no = FDELFORr.ReleaseNo))
		Begin
		insert	@EDIOrdersAlert
		        ( ReleaseNo ,
		          CustomerPart ,
		          CustomerPO ,
		          ShipToCode ,
		          Type ,
		          Notes 
		        )
		select		
				distinct
				Coalesce(ReleaseNo,'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Alert'
			,	'Blanket sales order  ' + convert(varchar (8), OrderNo)+ ' Updated'
		         
		from (select
						FDELJITr.ReleaseNo ReleaseNo, 
						FDELJITr.CustomerPart CustomerPart,
						FDELJITr.CustomerPO CustomerPO,
						FDELJITr.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo
						from 
							@CurrentDELJITs FDELJITc
						join	
							EDI.GMSPO_DELJIT_Releases FDELJITr on FDELJITc.RawDocumentGUID = FDELJITr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode = FDELJITr.ShipToCode
						and 
							bo.CustomerPart = FDELJITr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							exists (select 1 from dbo.order_detail od where od.customer_part = FDELJITr.CustomerPart and od.destination = bo.InternalShipTo and od.release_no = FDELJITr.ReleaseNo)
						union
					select
						FDELFORr.ReleaseNo ReleaseNo, 
						FDELFORr.CustomerPart CustomerPart,
						FDELFORr.CustomerPO CustomerPO,
						FDELFORr.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo						 
						from 
							@CurrentDELFORs FDELFORc
						join	
							EDI.GMSPO_DELFOR_Releases FDELFORr on FDELFORc.RawDocumentGUID = FDELFORr.RawDocumentGUID and NewDocument = 1
						left join 
							GMSPOEDI.BlanketOrders bo	on bo.EDIShipToCode in (FDELFORr.ICCode, FDELFORr.ShipToCode)
						and 
							bo.CustomerPart = FDELFORr.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						and
							exists (select 1 from dbo.order_detail od where od.customer_part = FDELFORr.CustomerPart and od.destination = bo.InternalShipTo and od.release_no = FDELFORr.ReleaseNo)
					
				) GMSPOEDIAlerts
		
		
	order by
		2,3,4
		
		DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>GMSPO EDI Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>ReleaseNo</th>' +
    N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.CustomerPO, '',
                    td = eo.ShipToCode, '',
                    td = eo.notes
              FROM @EDIOrdersAlert  eo
             where	[type] = 'Alert'
            order by 1,2,3 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'EDI Data Alert - GMSPO EDI Document(s) Updated FX Sales Orders', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'Normal' -- varchar(6)
   end
  
  --select	* from @EDIOrdersAlert  
end

/* End E-Mail and Exceptions */


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

begin transaction
go

go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI.usp_Process_GMSPO
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0
,	@Debug = 1

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


go

--commit transaction
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
