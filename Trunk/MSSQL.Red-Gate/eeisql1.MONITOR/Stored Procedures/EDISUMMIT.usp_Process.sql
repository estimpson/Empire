SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EDISUMMIT].[usp_Process]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDISUMMIT.usp_Test
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
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current862s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDISUMMIT.CurrentShipSchedules ()

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
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current830s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDISUMMIT.CurrentPlanningReleases ()

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
set	@TableName = 'EDISUMMIT.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDISUMMIT.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDISUMMIT.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDISUMMIT.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID
		and coalesce(ss.ReleaseNo,'') = coalesce(c.ReleaseNo,'') 
		and ss.ShipToCode = c.ShipToCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.ShipFromCode,'') = coalesce(c.ShipFromCode,'') 
		and coalesce(ss.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')		
		and coalesce(ss.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(ss.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDISUMMIT.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDISUMMIT.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDISUMMIT.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
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
set	@TableName = 'EDISUMMIT.PlanningReleases'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDISUMMIT.PlanningReleases PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and coalesce(PR.ReleaseNo,'') = coalesce(c.ReleaseNo,'') 
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.ShipFromCode,'') = coalesce(c.ShipFromCode,'') 
		and coalesce(PR.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')		
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDISUMMIT.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDISUMMIT.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDISUMMIT.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
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
		EDISUMMIT.ShipScheduleHeaders fh

	select
		'PlanningHeaders'
		
	select
		*
	from
		EDISUMMIT.PlanningHeaders fh
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

Select
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
,	ReferenceAccum = min(coalesce(bo.AccumShipped,convert(int,fa.LastAccumQty),0))
,	CustomerAccum = min(Coalesce(faa.PriorCum,convert(int,fa.LastAccumQty),0))
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.ShipScheduleHeaders fh
	join EDISUMMIT.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
where
	convert(int,fa.LastAccumQty) > bo.AccumShipped
	and not exists
		(	select
				*
			from
				EDISUMMIT.ShipSchedules ss
			where
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)
	and fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.ShipScheduleHeaders', 'Status', 'Active'))
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
,	ReferenceAccum = coalesce(bo.AccumShipped,convert(int,fa.LastAccumQty),0)
,	CustomerAccum = coalesce(faa.PriorCum,convert(int,fa.LastAccumQty),0)
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.ShipScheduleHeaders fh
	join EDISUMMIT.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.ShipScheduleHeaders', 'Status', 'Active'))

/*		830s. */
Union all
select
	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType = '4' then 2
					else 2
					end
			  )
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
,	ReferenceAccum = coalesce(bo.AccumShipped,convert(int,fa.LastAccumQty),0)
,	CustomerAccum = coalesce(faa.PriorCum,convert(int,fa.LastAccumQty),0)
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.PlanningHeaders fh
	join EDISUMMIT.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
where
	/*convert(int,fa.LastAccumQty) > bo.AccumShipped
	and not exists
		(	select
				*
			from
				EDISUMMIT.PlanningReleases ss
			where
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)*/
		fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
	and fr.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')



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
		,	ReleaseType
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
,		bor.Type
,   sum(bor.QtyRelease)
from
	@RawReleases bor
group by
		bor.OrderNo
,   bor.ReleaseNo
,   bor.ReleaseDT
,		bor.Type

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


delete
	##BlanketOrderReleases_Edit
where
	SPID = @@SPID
	


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
	if  exists
		(	select
				*
			from
				dbo.order_header oh
				join EDISUMMIT.PlanningHeaders fh
					join EDISUMMIT.PlanningSupplemental ps
						on ps.RawDocumentGUID = fh.RawDocumentGUID
					join EDISUMMIT.BlanketOrders bo
						on bo.EDIShipToCode = coalesce (ps.ConsigneeCode, ps.ShipToCode)
						and bo.CustomerPart = ps.CustomerPart
					on bo.BlanketOrderNo = oh.order_no
				join @Current830s c
					on ps.RawDocumentGUID = c.RawDocumentGUID
					and ps.ShipToCode = c.ShipToCode
					and coalesce(ps.ShipFromCode,'') = coalesce(c.ShipFromCode,'')
					and coalesce(ps.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')
					and ps.CustomerPart = c.CustomerPart
			where 
				coalesce(oh.dock_code,'') != coalesce(ps.UserDefined1, '')
				or coalesce(oh.line_feed_code,'') != coalesce(ps.UserDefined2,'')
				or coalesce(oh.zone_code,'') != coalesce(ps.UserDefined3,'')
		) or
		exists
		(	select
				*
			from
				dbo.order_header oh
				join EDISUMMIT.ShipScheduleHeaders fh
					join EDISUMMIT.ShipScheduleSupplemental sss
						on sss.RawDocumentGUID = fh.RawDocumentGUID
					join EDISUMMIT.BlanketOrders bo
						on bo.EDIShipToCode = sss.ShipToCode
						and bo.CustomerPart = sss.CustomerPart
					on bo.BlanketOrderNo = oh.order_no
				join @Current862s c
					on sss.RawDocumentGUID = c.RawDocumentGUID
					and sss.ShipToCode = c.ShipToCode
					and sss.CustomerPart = c.CustomerPart
			where 
				coalesce(oh.dock_code,'') != coalesce(sss.UserDefined1, '')
				or coalesce(oh.line_feed_code,'') != coalesce(sss.UserDefined2,'')
				or coalesce(oh.zone_code,'') != coalesce(sss.UserDefined3,'')
				OR 	COALESCE(oh.line11,'') = coalesce(sss.UserDefined11,'')
				OR 	COALESCE(oh.line12,'') = coalesce(sss.UserDefined12,'')
		
		) begin
		
		/*
		insert
			EDISUMMIT.LabelInfoHeader
		(	SystemDT
		)
		select
			@TranDT
		
		insert 	
			EDISUMMIT.LabelInfoHeader
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
		*/
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set	
			dock_code = rtrim(ps.UserDefined1)
		,	line_feed_code = rtrim(ps.UserDefined2)
		,	zone_code = rtrim(ps.UserDefined3)
		from
			dbo.order_header oh
			join 
				EDISUMMIT.PlanningHeaders fh
			join 
				EDISUMMIT.PlanningSupplemental ps on ps.RawDocumentGUID = fh.RawDocumentGUID
			join 
				EDISUMMIT.BlanketOrders bo	on bo.EDIShipToCode = coalesce (nullif(ps.ConsigneeCode,''), ps.ShipToCode)
					and bo.CustomerPart = ps.CustomerPart
					and	(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = ps.CustomerPO
						)
					and	(	bo.CheckModelYearPlanning = 0
							or bo.ModelYear = ps.CustomerModelYear
						)
				on	bo.BlanketOrderNo = oh.order_no
			join 
				@Current830s c on ps.RawDocumentGUID = c.RawDocumentGUID
				and coalesce(ps.ReleaseNo,'') = coalesce(c.ReleaseNo,'')
				and ps.ShipToCode = c.ShipToCode
				and coalesce(ps.ShipFromCode,'') = coalesce(c.ShipFromCode,'')
				and coalesce(ps.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')
				and ps.CustomerPart = c.CustomerPart
				and	(	bo.CheckCustomerPOPlanning = 0
						or bo.CustomerPO = c.CustomerPO
					)
				and	(	bo.CheckModelYearPlanning = 0
						or bo.ModelYear = c.CustomerModelYear
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
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set	
			dock_code = rtrim(ps.UserDefined1)
		,	line_feed_code = rtrim(ps.UserDefined2)
		,	zone_code = rtrim(ps.UserDefined3)
		,	line11 = rtrim(ps.UserDefined11)
		,	line12 = rtrim(ps.UserDefined12)
		,	line13 = rtrim(ps.UserDefined13)
		,	line14 = rtrim(ps.UserDefined14)
		,	line15 = rtrim(ps.UserDefined15)
		,	line16 = rtrim(ps.UserDefined16)
		,	line17 = rtrim(ps.UserDefined17)
		from
			dbo.order_header oh
			join 
				EDISUMMIT.ShipScheduleHeaders fh
			join 
				EDISUMMIT.ShipScheduleSupplemental ps on ps.RawDocumentGUID = fh.RawDocumentGUID
			join 
				EDISUMMIT.BlanketOrders bo	on bo.EDIShipToCode = coalesce (nullif(ps.ConsigneeCode,''), ps.ShipToCode)
					and bo.CustomerPart = ps.CustomerPart
					and	(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = ps.CustomerPO
						)
					and	(	bo.CheckModelYearPlanning = 0
							or bo.ModelYear = ps.CustomerModelYear
						)
				on	bo.BlanketOrderNo = oh.order_no
			join 
				@Current862s c on ps.RawDocumentGUID = c.RawDocumentGUID
				and coalesce (ps.ReleaseNo,'') = coalesce(c.ReleaseNo,'')
				and ps.ShipToCode = c.ShipToCode
				and coalesce(ps.ShipFromCode,'') = coalesce(c.ShipFromCode,'')
				and coalesce(ps.ConsigneeCode, '') = coalesce(c.ConsigneeCode, '')
				and ps.CustomerPart = c.CustomerPart
				and	(	bo.CheckCustomerPOShipSchedule = 0
						or bo.CustomerPO = c.CustomerPO
					)
				and	(	bo.CheckModelYearShipSchedule = 0
						or bo.ModelYear = c.CustomerModelYear
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
	end
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
		join EDISUMMIT.BlanketOrders bo
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

Declare @EDIOrdersAlert table (
	DocumentType varchar(30) NULL, --'PR - Planning Release; SS - ShipSchedule'
	AlertType varchar(100) NULL,
	ReleaseNo varchar(100) NULL,
	ShipToCode varchar(100) NULL,
	ConsigneeCode varchar(100) NULL,
	ShipFromCode varchar(100) NULL,
	CustomerPart varchar(100) NULL,
	CustomerPO varchar(100) NULL,
	CustomerModelYear varchar NULL,
	Description varchar (max)
	)
		
insert	
	@EDIOrdersAlert
(	DocumentType,
	AlertType,
	ReleaseNo ,
	ShipToCode,
	ConsigneeCode,
	ShipFromCode,
	CustomerPart,
	CustomerPO,
	CustomerModelYear,
	Description 
)

Select 
	DocumentType = 'SS'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  coalesce(b.ConsigneeCode,'')
,	ShipFromCode = coalesce(b.ShipFromCode,'')
,	CustomerPart = Coalesce(b.CustomerPart,'')
,	CustomerPO = Coalesce(b.CustomerPO,'')
,	CustomerModelYear = Coalesce(b.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current862s a
join
	EDISUMMIT.ShipSchedules b on a.RawDocumentGUID = b.RawDocumentGUID and a.NewDocument = 1
and
	a.CustomerPart = b.CustomerPart
and
	a.ShipToCode = b.ShipToCode
and
	coalesce(a.ConsigneeCode,'') = coalesce(b.ConsigneeCode,'')
and
	coalesce(a.ShipFromCode, '') = coalesce(b.ShipFromCode,'')
Left Join 
	EDISUMMIT.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = b.CustomerPO
)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear = b.CustomerModelYear
)
Where
bo.BlanketOrderNo is Null
union
Select 
	DocumentType = 'PR'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  coalesce(b.ConsigneeCode,'')
,	ShipFromCode = coalesce(b.ShipFromCode,'')
,	CustomerPart = Coalesce(b.CustomerPart,'')
,	CustomerPO = Coalesce(b.CustomerPO,'')
,	CustomerModelYear = Coalesce(b.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current830s a
left join
	EDISUMMIT.PlanningReleases b on a.RawDocumentGUID = b.RawDocumentGUID and a.NewDocument = 1
and
	a.CustomerPart = b.CustomerPart
and
	a.ShipToCode = b.ShipToCode
and
	coalesce(a.ConsigneeCode,'') = coalesce(b.ConsigneeCode,'')
and
	coalesce(a.ShipFromCode, '') = coalesce(b.ShipFromCode,'')
Left Join 
	EDISUMMIT.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = b.CustomerPO
)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear = b.CustomerModelYear
)
Where
bo.BlanketOrderNo is Null
union

--Orders Processed
Select 
	DocumentType = 'SS'
,	AlertType =  'Order Processed'
,	ReleaseNo =  Coalesce(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  coalesce(b.ConsigneeCode,'')
,	ShipFromCode = coalesce(b.ShipFromCode,'')
,	CustomerPart = Coalesce(b.CustomerPart,'')
,	CustomerPO = Coalesce(b.CustomerPO,'')
,	CustomerModelYear = Coalesce(b.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current862s a
join
	EDISUMMIT.ShipSchedules b on a.RawDocumentGUID = b.RawDocumentGUID and a.NewDocument = 1
and
	a.CustomerPart = b.CustomerPart
and
	a.ShipToCode = b.ShipToCode

Join 
	EDISUMMIT.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = b.CustomerPO
)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear = b.CustomerModelYear
)
Where
bo.BlanketOrderNo is not Null
union
Select 
	DocumentType = 'PR'
,	AlertType =  'Order Processed'
,	ReleaseNo =  Coalesce(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  coalesce(b.ConsigneeCode,'')
,	ShipFromCode = coalesce(b.ShipFromCode,'')
,	CustomerPart = Coalesce(b.CustomerPart,'')
,	CustomerPO = Coalesce(b.CustomerPO,'')
,	CustomerModelYear = Coalesce(b.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current830s a
join
	EDISUMMIT.PlanningReleases b on a.RawDocumentGUID = b.RawDocumentGUID and a.NewDocument = 1
and
	a.CustomerPart = b.CustomerPart
and
	a.ShipToCode = b.ShipToCode

Join 
	EDISUMMIT.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = b.CustomerPO
)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear = b.CustomerModelYear
)
Where
bo.BlanketOrderNo is not Null

--Accums Reporting
union
Select 
	DocumentType = 'SS'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  coalesce(b.ConsigneeCode,'')
,	ShipFromCode = coalesce(b.ShipFromCode,'')
,	CustomerPart = Coalesce(b.CustomerPart,'')
,	CustomerPO = Coalesce(b.CustomerPO,'')
,	CustomerModelYear = Coalesce(b.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(b.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(b.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(c.PriorCUM,0))
FROM
	@Current862s a
JOIN
	EDISUMMIT.ShipScheduleAccums b ON a.RawDocumentGUID = b.RawDocumentGUID AND a.NewDocument = 1
AND
	a.CustomerPart = b.CustomerPart
AND
	a.ShipToCode = b.ShipToCode

JOIN
	EDISUMMIT.ShipScheduleAuthAccums c ON a.RawDocumentGUID = c.RawDocumentGUID AND a.NewDocument = 1
AND
	a.CustomerPart = c.CustomerPart
AND
	a.ShipToCode = c.ShipToCode

JOIN 
	EDISUMMIT.BlanketOrders bo ON a.CustomerPart = bo.CustomerPart
AND
	a.ShipToCode = bo.EDIShipToCode
AND
(	bo.CheckCustomerPOPlanning = 0
	OR bo.CustomerPO = b.CustomerPO
)
AND
(	bo.CheckModelYearPlanning = 0
	OR bo.ModelYear = b.CustomerModelYear
)
WHERE
bo.BlanketOrderNo IS NOT NULL
UNION
SELECT 
	DocumentType = 'PR'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  COALESCE(b.ReleaseNo,'')
,	ShipToCode = b.ShipToCode
,	ConsigneeCode =  COALESCE(b.ConsigneeCode,'')
,	ShipFromCode = COALESCE(b.ShipFromCode,'')
,	CustomerPart = COALESCE(b.CustomerPart,'')
,	CustomerPO = COALESCE(b.CustomerPO,'')
,	CustomerModelYear = COALESCE(b.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ CONVERT(VARCHAR(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ CONVERT(VARCHAR(15), COALESCE(b.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ CONVERT(VARCHAR(15), COALESCE(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ CONVERT(VARCHAR(15), COALESCE(b.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ CONVERT(VARCHAR(15), COALESCE(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ CONVERT(VARCHAR(15), COALESCE(c.PriorCUM,0))
FROM
	@Current830s a
JOIN
	EDISUMMIT.PlanningAccums b ON a.RawDocumentGUID = b.RawDocumentGUID AND a.NewDocument = 1
AND
	a.CustomerPart = b.CustomerPart
AND
	a.ShipToCode = b.ShipToCode
AND
	COALESCE(a.ConsigneeCode,'') = COALESCE(b.ConsigneeCode,'')
AND
	COALESCE(a.ShipFromCode, '') = COALESCE(b.ShipFromCode,'')
JOIN
	EDISUMMIT.PlanningAuthAccums c ON a.RawDocumentGUID = c.RawDocumentGUID AND a.NewDocument = 1
AND
	a.CustomerPart = c.CustomerPart
AND
	a.ShipToCode = c.ShipToCode
AND
	COALESCE(a.ConsigneeCode,'') = COALESCE(c.ConsigneeCode,'')
AND
	COALESCE(a.ShipFromCode, '') = COALESCE(c.ShipFromCode,'')
JOIN 
	EDISUMMIT.BlanketOrders bo ON a.CustomerPart = bo.CustomerPart
AND
	a.ShipToCode = bo.EDIShipToCode
AND
(	bo.CheckCustomerPOPlanning = 0
	OR bo.CustomerPO = b.CustomerPO
)
AND
(	bo.CheckModelYearPlanning = 0
	OR bo.ModelYear = b.CustomerModelYear
)
WHERE
	bo.BlanketOrderNo IS NOT NULL AND
	COALESCE(bo.AccumShipped,0) != COALESCE(b.LastAccumQty,0)


ORDER BY 1,4,7
		

SELECT	*
INTO	#EDIAlerts
FROM	@EDIOrdersAlert


IF EXISTS (SELECT 1 FROM #EDIAlerts)

BEGIN

DECLARE			@EmailAddress NVARCHAR(MAX),
											@scheduler VARCHAR(MAX)

SELECT
		@scheduler = MAX(scheduler) 
				FROM
						destination
				WHERE
						EXISTS
								( SELECT 1 FROM @RawReleases rr WHERE  rr.ShipToID = destination.destination )

SELECT 
		@EmailAddress = [FT].[fn_ReturnSchedulerEMailAddress] (@scheduler)
		
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#EDIAlerts'
		
		EXEC [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		, @OrderBy = '[DocumentType], [AlertType], [ShipToCode], [CustomerPart]'
		,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'EDISummit Alert' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = @EmailAddress -- varchar(max)
	,	@copy_recipients = 'dwest@empireelect.com' -- varchar(max)
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,	@importance = 'High'  -- varchar(6)	

/*
Insert [EDIAlerts].[ProcessedReleases]

(	EDIGroup
	,DocumentType --'PR - Planning Release; SS - ShipSchedule'
	,AlertType 
	,ReleaseNo
	,ShipToCode
	,ConsigneeCode 
	,ShipFromCode 
	,CustomerPart
	,CustomerPO
	,CustomerModelYear
	,Description
)

Select 
	'EDISUMMIT'
	,*
From
	#EDIAlerts
*/

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
	@ProcReturn = EDISUMMIT.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go


go

commit transaction
--rollback transaction

go

set statistics io off
set statistics time off
go

}

Results {
}
*/






























GO
