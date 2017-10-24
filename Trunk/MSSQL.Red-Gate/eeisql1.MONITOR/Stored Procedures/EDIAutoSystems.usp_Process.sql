SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIAutoSystems].[usp_Process]
	@TranDT datetime = null out
,	@Result integer = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIAutosystems.usp_Test
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
	print	'Determine the current 830s and 862s.'
	print	'	Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Determine the current 830s and 862s. */
/*		Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).*/
declare
	@Current862s table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	NewDocument int
)

insert
	@Current862s
select distinct
	RawDocumentGUID
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,   NewDocument
from
	EDIAutosystems.CurrentShipSchedules ()

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.'
end
--</Debug>
/*		Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.  */
declare
	@Current830s table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(30)
,	NewDocument int
)

insert
	@Current830s
select distinct
	RawDocumentGUID
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,   NewDocument
from
	EDIAutosystems.CurrentPlanningReleases ()

--<Debug>
if @Debug & 1 = 1 begin
	print	'...determined.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

/*		If the current 862s and 830s are already "Active", done. */
if	not exists
	(	select
			*
		from
			@Current862s cd
		where
			cd.NewDocument = 1
	)
	and not exists
	(	select
			*
		from
			@Current830s cd
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
	print	'Mark "Active" 862s and 830s.'
	set	@StartDT = GetDate ()
end
--- <Update rows="*">
set	@TableName = 'EDIAutosystems.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIAutosystems.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIAutosystems.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDIAutosystems.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID
		and ss.ShipToCode = c.ShipToCode
		and coalesce(ss.ShipFromCode,'') = c.ShipFromCode
		and coalesce(ss.ConsigneeCode, '') = c.ConsigneeCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.CustomerPO, '') = c.CustomerPO
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDIAutosystems.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIAutosystems.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIAutosystems.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
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

--- <Update rows="*">
set	@TableName = 'EDIAutosystems.PlanningReleases'

update
	fr
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDIAutosystems.PlanningReleases fr
	left join @Current830s c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and coalesce(fr.ShipFromCode,'') = coalesce(c.ShipFromCode,'')
		and coalesce(fr.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')
		and fr.CustomerPart = c.CustomerPart

where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDIAutosystems.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIAutosystems.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIAutosystems.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
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
		'ShipScheduleHeaders'

	select
		*
	from
		EDIAutosystems.ShipScheduleHeaders fh

	select
		'PlanningHeaders'
		
	select
		*
	from
		EDIAutosystems.PlanningHeaders fh
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active 862s and 830s.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Write new releases. */
/*		Calculate raw releases from active 862s and 830s. */
declare
	@RawReleases table
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
,	ReferenceAccum numeric(20,6)
,	CustomerAccum numeric(20,6)
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
,	QtyRelease
,	StdQtyRelease
,	ReferenceAccum
,	CustomerAccum
,	NewDocument
)
/*		Add releases due today when behind and no release for today exists. */
select
	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = ft.fn_TruncDate('dd', getdate())
,	BlanketPart = min(bo.PartCode)
,	CustomerPart = min(bo.CustomerPart)
,	ShipToID = min(bo.ShipToCode)
,	CustomerPO = min(bo.CustomerPO)
,	ModelYear = min(bo.ModelYear)
,	OrderUnit = min(bo.OrderUnit)
,	ReleaseNo = min(fr.ReleaseNo)
,	QtyRelease = 0
,	StdQtyRelease = 0
,	ReferenceAccum = min(bo.AccumShipped)
,	CustomerAccum = min(convert(int,fa.LastAccumQty))
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIAutosystems.ShipScheduleHeaders fh
	join EDIAutosystems.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIAutosystems.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
	join EDIAutosystems.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
where
	convert(int,fa.LastAccumQty) > bo.AccumShipped
	and not exists
		(	select
				*
			from
				EDIAutosystems.ShipSchedules ss
			where
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)
	and fh.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.ShipScheduleHeaders', 'Status', 'Active'))
group by
	bo.BlanketOrderNo
,	fh.RawDocumentGUID

/*		862s. */
union all
select
	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = fr.ReleaseDT
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = bo.AccumShipped
,	CustomerAccum = convert(int,fa.LastAccumQty)
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIAutosystems.ShipScheduleHeaders fh
	join EDIAutosystems.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIAutosystems.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.customerpart = fr.customerpart 
		and	fa.shipToCode = fr.ShipToCode
	join EDIAutosystems.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
		or	bo.ModelYear = fr.UserDefined4
		)
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.ShipScheduleHeaders', 'Status', 'Active'))
and
	bo.ActiveOrder = 1
/*		830s. */
union all
select
	OrderNo = bo.BlanketOrderNo
,	Type = 2
,	ReleaseDT = fr.ReleaseDT
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = bo.AccumShipped
,	CustomerAccum = fa.LastAccumQty
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIAutosystems.PlanningHeaders fh
	join EDIAutosystems.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIAutosystems.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.customerpart = fr.customerpart 
		and	fa.shipToCode = fr.ShipToCode
	join EDIAutosystems.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear = fr.UserDefined4
		)
where
	/*convert(int,fa.LastAccumQty) > bo.AccumShipped
	and not exists
		(	select
				*
			from
				EDIAutosystems.PlanningReleases ss
			where
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)*/
		fh.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningHeaders', 'Status', 'Active'))
	and fr.Status = 1 --(select dbo.udf_StatusValue('EDIAutosystems.PlanningReleases', 'Status', 'Active'))
	and	bo.ActiveOrder = 1
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

if	@Testing = 0 begin
	delete
		rr
	from
		@RawReleases rr
	where
		rr.NewDocument = 0
end

/*		Update accums for Orders where Accum Difference has been inserted for immediate delivery */
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
	rr
set
	RelPost = case when rr.ReferenceAccum > rr.RelPost then rr.ReferenceAccum else rr.RelPost end
from
	@RawReleases rr


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
			and	RowID < rr.RowID), ReferenceAccum)
from
	@RawReleases rr



update
	rr
set
	ReleaseDT = (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and Type = 1)
from
	@RawReleases rr
where
	rr.Type = 2
	and rr.ReleaseDT < (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and Type = 1)

update
	rr
set
	QtyRelease = RelPost - RelPrior
,	StdQtyRelease = RelPost - RelPrior
from
	@RawReleases rr

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0

/*	Calculate order line numbers and committed quantity. */
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
			and Status = 0
	)
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
where
	rr.status = 0

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

if	@Testing = 2 begin
	select
		'@RawReleases'
	
	select
		*
	from
		@RawReleases rr
end

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
		,	ReferenceAccum
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
	,	notes = case rr.Type when 1 then '862 Release' when 2 then '830 Release' end
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
		join EDIAutosystems.BlanketOrders bo
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


DECLARE			@EmailAddress nvarchar(max),
											@scheduler varchar(max)

Select
		@scheduler = max(scheduler) 
				from
						destination
				where
						exists
								( select 1 from @RawReleases rr where  rr.ShipToID = destination.destination )

Select 
		@EmailAddress = [FT].[fn_ReturnSchedulerEMailAddress] (@scheduler)
SELECT @EmailAddress = @EmailAddress + ';mminth@empireelect.com'

Declare @EDIOrdersAlert table (
	RowID int IDENTITY(1,1) NOT NULL,
	ReleaseNo varchar(100) NULL,
	DocumentType varchar(30) NULL,
	CustomerPart varchar(100) NULL,
	CustomerPO varchar(100) NULL,
	ShipToCode varchar(100) NULL,
	Type varchar(100) NULL,
	Notes1 varchar (100),
	Notes varchar(255) NULL
	)
		
		if exists (Select 1 from
							@Current862s C830
						join
							EDIAutosystems.ShipSchedules F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart
						and
							C830.ShipToCode = F862r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						Where
							BlanketOrderNo is Null
						union
						select 1 
						from
							@Current830s C830
						join
							EDIAutosystems.PlanningReleases F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart 
						and
							C830.ShipToCode = F862r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						Where
							BlanketOrderNo is Null )
		Begin
		insert	@EDIOrdersAlert
				( DocumentType,
				  ReleaseNo ,
				  CustomerPart ,
				  CustomerPO ,
				  ShipToCode ,
				  Type ,
				  Notes 
				)
		select		
				distinct
				coalesce(DocumentType, '')
			,	Coalesce(ReleaseNo,'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Exception'
			,	'Blanket sales order not found; please add blanket sales order and reprocess EDI'
				 
		from (select	'Ship Schedule' DocumentType,
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID
						from
							@Current862s C830
						join
							EDIAutosystems.ShipSchedules F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart
						and
							C830.ShipToCode = F862r.ShipToCode
						Left Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode and bo.ActiveOrder = 1
						Where
							BlanketOrderNo is Null
						union
					select
						'Planning Release',
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID						 
						from
							@Current830s C830
						join
							EDIAutosystems.PlanningReleases F830r on C830.RawDocumentGUID = F830r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F830r.CustomerPart 
						and
							C830.ShipToCode = F830r.ShipToCode
						left Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode and bo.ActiveOrder = 1
						Where
							BlanketOrderNo is Null
					
				) AutosystemsEDIExceptions
		
		
	order by
		2,3,4
		
		DECLARE @tableHTML  NVARCHAR(MAX) ;



SET @tableHTML =
	N'<H1>Autosystems EDI Exceptions</H1>' +
	N'<table border="1">' +
	N'<tr><th>Document Type</th>' +
	N'<th>ReleaseNo</th>' +
	N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
	N'<th>Notes</th></tr>' +
	CAST ( ( SELECT td = eo.DocumentType, '',
					td = eo.ReleaseNo, '',
					td = eo.CustomerPart, '',
					td = eo.CustomerPO, '',
					td = eo.ShipToCode, '',
					td = eo.notes
			  FROM @EDIOrdersAlert  eo
			 where	type = 'Exception'
			 order by 5,3,1  
			  FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) ) +
	N'</table>' ;
	
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
	@recipients = @EmailAddress, -- varchar(max)
	@copy_recipients = 'dwest@empireelect.com', -- varchar(max)
	--@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
	@subject = N'EDI Data Exception when processing Autosystems EDI Document(s)', -- nvarchar(255)
	@body = @TableHTML, -- nvarchar(max)
	@body_format = 'HTML', -- varchar(20)
	@importance = 'High' -- varchar(6)
	
		end
		
		
		if exists (Select 1 
						from
							@Current862s C830
						join
							EDIAutosystems.ShipSchedules F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart
						and
							C830.ShipToCode = F862r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						join
							order_detail od on bo.BlanketOrderNo = od.order_no 
						and
							od.release_no = F862r.ReleaseNo
						union
						select 1 
						from
							@Current830s C830
						join
							EDIAutosystems.PlanningReleases F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and C830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart 
						and
							C830.ShipToCode = F862r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						join
							order_detail od on bo.BlanketOrderNo = od.order_no 
						and
							od.release_no = F862r.ReleaseNo 
							)
		Begin
		insert	@EDIOrdersAlert
				( DocumentType,
					ReleaseNo ,
				  CustomerPart ,
				  CustomerPO ,
				  ShipToCode ,
				  Type ,
				  Notes 
				)
		select		
				distinct
				DocumentType
			,	Coalesce(ReleaseNo,'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Update Alert'
			,	'Blanket sales order  ' + convert(varchar (8), OrderNo)+ ' Updated'
				 
		from (select	'Ship Schedule' DocumentType,
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo
						from 	
							@Current862s C830
						join
							EDIAutosystems.ShipSchedules F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and c830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart
						and
							C830.ShipToCode = F862r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						join
							order_detail od on bo.BlanketOrderNo = od.order_no 
						and
							od.release_no = F862r.ReleaseNo
						union
					select
						'Planning Release' DocumentType,
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo						 
						from
							@Current830s C830
						join
							EDIAutosystems.PlanningReleases F830r on C830.RawDocumentGUID = F830r.RawDocumentGUID and c830.NewDocument = 1
						and
							C830.CustomerPart = F830r.CustomerPart
						and
							C830.ShipToCode = F830r.ShipToCode
						Join 
							EDIAutosystems.BlanketOrders bo on C830.CustomerPart = bo.CustomerPart
						and
							C830.ShipToCode = bo.EDIShipToCode
						join
							order_detail od on bo.BlanketOrderNo = od.order_no 
						and
							od.release_no = F830r.ReleaseNo 
					
				) AutosystemsEDIAlerts
		
		
	order by
		2,3,4


--Get Accum Differences

insert	@EDIOrdersAlert
				(	DocumentType,
					ReleaseNo ,
					CustomerPart ,
					CustomerPO ,
					ShipToCode ,
					Type ,
					Notes1,
					Notes 
				)
		select		
				distinct
				DocumentType
			,	Coalesce(ReleaseNo,'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Accum Alert'
			,	OrderAdjust
			,	'Blanket sales order  ' + convert(varchar (8), OrderNo)+ ' Verify Accums' +'---Our Accum: '+ convert(varchar (50),OurAccumShipped)+'---Customer Accum: '+ convert(varchar (50), CustomerAccumAcknowledged)+'---Customer Desired Accum: '+ convert(varchar (50), CustomerAuthAccum)
				 
		from (select	'Ship Schedule' DocumentType,
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo,
						convert(int, coalesce(bo.AccumShipped,0)) OurAccumShipped,
						convert(int, coalesce(F862r.LastAccumQty,0)) CustomerAccumAcknowledged,
						convert(int, coalesce(F862r.UserDefined1,'0')) CustomerAuthAccum,
						(case when convert(int, coalesce(F862r.UserDefined1,'0')) > coalesce(bo.AccumShipped,0) then 'Adjustment Up' else 'Adjustment Down'end) as OrderAdjust
						from
							@Current862s C830
						join
							EDIAutosystems.ShipScheduleAccums F862r on C830.RawDocumentGUID = F862r.RawDocumentGUID and c830.NewDocument = 1
						and
							C830.CustomerPart = F862r.CustomerPart
						AND
							C830.ShipToCode = F862r.ShipToCode
						JOIN 
							EDIAutosystems.BlanketOrders bo ON C830.CustomerPart = bo.CustomerPart
						AND
							C830.ShipToCode = bo.EDIShipToCode
						JOIN
							order_detail od ON bo.BlanketOrderNo = od.order_no 
						AND
							od.release_no = F862r.ReleaseNo 
						WHERE 
							bo.BlanketOrderNo IS NOT NULL AND
							(COALESCE(F862r.LastAccumQty,0) != COALESCE(bo.AccumShipped,0) )
						UNION
					SELECT
						'Planning Release' DocumentType,
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo,
						CONVERT(INT, COALESCE(bo.AccumShipped,0)) OurAccumShipped,
						CONVERT(INT, COALESCE(F830r.LastAccumQty,0)) CustomerAccumAcknowledged,
						CONVERT(INT, COALESCE(F830r.LastAccumQty,'0')) CustomerAuthAccum,
						(CASE WHEN CONVERT(INT, COALESCE(F830r.LastAccumQty,'0')) > COALESCE(bo.AccumShipped,0) THEN 'Adjustment Up' ELSE 'Adjustment Down'END) AS OrderAdjust			 
						FROM
							@Current830s C830
						JOIN
							EDIAutosystems.PlanningAccums F830r ON C830.RawDocumentGUID = F830r.RawDocumentGUID
						AND
							C830.CustomerPart = F830r.CustomerPart
						AND
							C830.ShipToCode = F830r.ShipToCode
						JOIN 
							EDIAutosystems.BlanketOrders bo ON C830.CustomerPart = bo.CustomerPart
						AND
							C830.ShipToCode = bo.EDIShipToCode
						JOIN
							order_detail od ON bo.BlanketOrderNo = od.order_no 
						AND
							od.release_no = F830r.ReleaseNo 

						WHERE 
							bo.BlanketOrderNo IS NOT NULL AND
							COALESCE(F830r.LastAccumQty,0) != COALESCE(bo.AccumShipped,0)
					
				) AutosystemsEDIAlerts
		
		
	ORDER BY
		2,3,4

---End Get Accum Differences
		
		DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
	N'<H1>Autosystems EDI Alert</H1>' +
	N'<table border="1">' +
	N'<tr><th>Document Type</th>' +
	N'<th>ReleaseNo</th>' +
	N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
	N'<th>Notes</th></tr>' +
	CAST ( ( SELECT td = eo.DocumentType, '',
					td = eo.ReleaseNo, '',
					td = eo.CustomerPart, '',
					td = eo.CustomerPO, '',
					td = eo.ShipToCode, '',
					td = eo.notes
			  FROM @EDIOrdersAlert  eo
			 WHERE	type = 'Update Alert'
			ORDER BY 5,3,1 
			  FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) ) +
	N'</table>' ;
	
EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
	@recipients = @EmailAddress, -- varchar(max)
	@copy_recipients = 'dwest@empireelect.com', -- varchar(max)
	--@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
	@subject = N'EDI Data Alert Autosystems EDI Document(s) Updated FX Sales Orders', -- nvarchar(255)
	@body = @TableHTMLA, -- nvarchar(max)
	@body_format = 'HTML', -- varchar(20)
	@importance = 'Normal' -- varchar(6)

	IF EXISTS (SELECT 1 FROM @EDIOrdersAlert WHERE Type = 'Accum Alert')
	BEGIN

			DECLARE @tableHTMLZ  NVARCHAR(MAX) ;

SET @tableHTMLZ =
	N'<H1>Autosystems Accum Alert</H1>' +
	N'<table border="1">' +
	N'<tr><th>Document Type</th>' +
	N'<th>ReleaseNo</th>' +
	N'<th>CustomerPart</th><th>CustomerPO</th><th>ShipToCode</th>' +
	N'<th>AdjustmentType</th>' +N'<th>Notes</th></tr>' +
	CAST ( ( SELECT td = eo.DocumentType, '',
					td = eo.ReleaseNo, '',
					td = eo.CustomerPart, '',
					td = eo.CustomerPO, '',
					td = eo.ShipToCode, '',
					td = eo.Notes1, '',
					td = eo.notes
			  FROM @EDIOrdersAlert  eo
			 WHERE	type = 'Accum Alert'
			ORDER BY 5,6 DESC, 3,1 
			  FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) ) +
	N'</table>' ;
	
EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
	@recipients = @EmailAddress, -- varchar(max)
	@copy_recipients = 'dwest@empireelect.com', -- varchar(max)
	--@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
	@subject = N'EDI Data Alert Autosystems EDI Document(s) - Verify Accums with Updated FX Sales Orders', -- nvarchar(255)
	@body = @TableHTMLZ, -- nvarchar(max)
	@body_format = 'HTML', -- varchar(20)
	@importance = 'Normal' -- varchar(6)
	
	END
END


/* End E-Mail and Exceptions */


---	<Return>
SET	@Result = 0
RETURN
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

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDIAutosystems.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0
,	@Debug = 1

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


go

commit transaction
--rollback

go

set statistics io off
set statistics time off
go

}

Results {
}
*/











GO
