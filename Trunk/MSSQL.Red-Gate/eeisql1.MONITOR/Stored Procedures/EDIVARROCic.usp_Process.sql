SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [EDIVARROCic].[usp_Process]
--modified update statement on order header from 862 data so that trading partner like 'AF52M' would not update order header Andre 2014-10-23 
--modified update statement on order header from 830 data so that trading partner like 'AF52M' updates order header with IC Andre 2015-03-19 

	@TranDT DATETIME = NULL OUT
,	@Result INTEGER = NULL OUT
,	@Testing INT = 1
--<Debug>
,	@Debug INTEGER = 0
--</Debug>
AS
SET NOCOUNT ON
SET ANSI_WARNINGS ON
SET	@Result = 999999

--<Debug>
DECLARE	@ProcStartDT DATETIME
DECLARE	@StartDT DATETIME
IF @Debug & 1 = 1 BEGIN
	SET	@StartDT = GETDATE ()
	PRINT	'START.   ' + CONVERT (VARCHAR (50), @StartDT)
	SET	@ProcStartDT = GETDATE ()
END
--</Debug>

--- <Error Handling>
DECLARE
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn INTEGER,
	@ProcResult INTEGER,
	@Error INTEGER,
	@RowCount INTEGER

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. EDIVARROCic.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
DECLARE
	@TranCount SMALLINT

SET	@TranCount = @@TranCount
IF	@TranCount = 0 BEGIN
	BEGIN TRAN @ProcName
END
ELSE BEGIN
	SAVE TRAN @ProcName
END
SET	@TranDT = COALESCE(@TranDT, GETDATE())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--<Debug>
IF @Debug & 1 = 1 BEGIN
	PRINT	'Determine the current 830s and 862s.'
	PRINT	'	Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).'
	SET	@StartDT = GETDATE ()
END
--</Debug>
/*	Determine the current 830s and 862s. */
/*		Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).*/
DECLARE
	@Current862s TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
,	ReleaseNo VARCHAR(50)
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	ConsigneeCode VARCHAR(15)
,	CustomerPart VARCHAR(35)
,	CustomerPO VARCHAR(35)
,	CustomerModelYear VARCHAR(35)
,	NewDocument INT
)

INSERT
	@Current862s
SELECT DISTINCT
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
FROM
	EDIVARROCic.CurrentShipSchedules ()

--<Debug>
IF @Debug & 1 = 1 BEGIN
	PRINT	'	Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.'
END
--</Debug>
/*		Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.  */
DECLARE
	@Current830s TABLE
(	RawDocumentGUID UNIQUEIDENTIFIER
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
	EDIVARROCic.CurrentPlanningReleases ()

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
	RETURN
END

--<Debug>
if @Debug & 1 = 1 begin
	print	'Mark "Active" 862s and 830s.'
	SET	@StartDT = GETDATE ()
END
--- <Update rows="*">
set	@TableName = 'EDIVARROCic.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIVARROCic.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIVARROCic.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDIVARROCic.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID
		and ss.ShipToCode = c.ShipToCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(ss.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDIVARROCic.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIVARROCic.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIVARROCic.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Update rows="*">
set	@TableName = 'EDIVARROCic.PlanningReleases'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDIVARROCic.PlanningReleases PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDIVARROCic.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIVARROCic.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIVARROCic.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	RETURN
END
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
		EDIVARROCic.ShipScheduleHeaders fh

	select
		'PlanningHeaders'
		
	SELECT
		*
	FROM
		EDIVARROCic.PlanningHeaders fh
END

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active 862s and 830s.'
	SET	@StartDT = GETDATE ()
END
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
,	RelPost
,	ReferenceAccum
,	NewDocument
)

Select
	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
, RelPost = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,fa.LastAccumQty),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end

	,	(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIVARROCic.ShipScheduleHeaders fh
	join EDIVARROCic.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIVARROCic.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIVARROCic.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIVARROCic.BlanketOrders bo
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
		join
				(Select * From @Current862s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where
				c.RawDocumentGUID = fr.RawDocumentGUID
and	fh.Status = 1 --(select dbo.udf_StatusValue('EDIVARROCic.ShipScheduleHeaders', 'Status', 'Active'))
		

/*		830s. */
Union all
select
	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType = 'D' then 2
					else 1
					end
			  )
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
, RelPost = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,fa.LastAccumQty),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIVARROCic.PlanningHeaders fh
	join EDIVARROCic.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIVARROCic.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIVARROCic.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIVARROCic.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear830 = fr.CustomerModelYear
		)
		join
				(Select * From @Current830s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearplanning = 0
							or bo.ModelYear830= c.CustomerModelYear
				)
where
				c.RawDocumentGUID = fr.RawDocumentGUID
	and	fh.Status = 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningHeaders', 'Status', 'Active'))
	and		fr.Status = 1 --(select dbo.udf_StatusValue('EDIVARROCic.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
	
order by
	1, 2, 3

/*		Calculate orders to update. */
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

		--For Armada Only..Update Release Number with Accum Increase if customer's accum causes the qty to be increased
	update
	rr
set
		releaseNo = 'Accum Increase'
from
	@RawReleases rr
where
		RelPost-RelPrior > QtyRelease


update
	rr
set
	QtyRelease = RelPost - RelPrior
,	StdQtyRelease = RelPost - RelPrior
from
	@RawReleases rr

if	@Testing = 2 begin
	select
		'@RawReleases'
	
	SELECT
		*
	FROM
		@RawReleases rr
END

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0

	update
	rr
set
	ReleaseDT = dateadd(dd,1,(select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and Type = 1and Status>-1))
from
	@RawReleases rr
where
	rr.Type = 2
	and rr.ReleaseDT <= (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and Type = 1 and Status>-1)

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
	SET	@StartDT = GETDATE ()
END
--</Debug>

if	@Testing = 2 begin
	select
		'@RawReleases'
	
	SELECT
		*
	FROM
		@RawReleases rr
END

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
		RETURN
	END
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
,		bor.ReleaseNo
,		bor.ReleaseDT
,		bor.Type
,		sum(bor.QtyRelease)
from
	@RawReleases bor
group by
		bor.OrderNo
,		bor.ReleaseNo
,		bor.ReleaseDT
,		bor.Type





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

--select * Into TempBOReleases from ##BlanketOrderReleases_Edit
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
	--- </Insert>
	
	/*	Set dock code, line feed code, and reserve line feed code. */
	/*if  exists
		(	select
				*
			from
				dbo.order_header oh
				join EDIVARROCic.PlanningHeaders fh
					join EDIVARROCic.PlanningSupplemental ps
						on ps.RawDocumentGUID = fh.RawDocumentGUID
					join EDIVARROCic.BlanketOrders bo
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
				join EDIVARROCic.ShipScheduleHeaders fh
					join EDIVARROCic.ShipScheduleSupplemental sss
						on sss.RawDocumentGUID = fh.RawDocumentGUID
					join EDIVARROCic.BlanketOrders bo
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
		) begin
		*/
		/*
		insert
			EDIVARROCic.LabelInfoHeader
		(	SystemDT
		)
		select
			@TranDT
		
		insert 	
			EDIVARROCic.LabelInfoHeader
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
			custom01 = rtrim(prs.UserDefined1)
		,	dock_code = rtrim(prs.UserDefined1)
		,	line_feed_code = rtrim(prs.UserDefined2)
		,	zone_code = rtrim(prs.UserDefined3)

		from
			dbo.order_header oh
		join
				EDIVARROCic.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From @Current830s) cpr 
			on
				cpr.CustomerPart = bo.customerpart and
				cpr.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = cpr.CustomerPO
				)
					and	(	bo.CheckModelYearPlanning= 0
							or bo.ModelYear830 = cpr.CustomerModelYear
				)
		  join
				EDIVARROCic.PlanningSupplemental prs
		on
				prs.RawDocumentGUID = cpr.RawDocumentGUID and
				prs.CustomerPart = cpr.CustomerPart and
				coalesce(prs.CustomerPO,'') = cpr.CustomerPO and
				prs.CustomerModelYear = cpr.CustomerModelYear  and
				prs.ShipToCode = cpr.ShipToCode

--Added 3-19-2015 Andre S. Boulanger to allow for new Af52M data structure
update
			oh
		set
			
			dock_code = rtrim(cpr.ConsigneeCode),
			oh.custom01 =  rtrim(cpr.ConsigneeCode)
	 

		from
			dbo.order_header oh
		join
				EDIVARROCic.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From EDIVARROCic.CurrentPlanningReleases()) cpr 
			on
				cpr.CustomerPart = bo.customerpart and
				cpr.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = cpr.CustomerPO
				)
					and	(	bo.CheckModelYearPlanning= 0
							or bo.ModelYear830 = cpr.CustomerModelYear
				)
		  
		JOIN
			EDIVARROCic.PlanningHeaders ph ON ph.RawDocumentGUID = cpr.RawDocumentGUID
		WHERE
			ph.TradingPartner LIKE '%AF52M%'
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
		
		--- <Update rows="*">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set
			custom01 = CASE WHEN es.trading_partner_code LIKE '%AF52M%' THEN RTRIM(css.ConsigneeCode) ELSE   RTRIM(sss.UserDefined1) END
		,	dock_code = CASE WHEN es.trading_partner_code LIKE '%AF52M%' THEN RTRIM(css.ConsigneeCode) ELSE   RTRIM(sss.UserDefined1) END
		,	line_feed_code = rtrim(sss.UserDefined2)
		,	zone_code = rtrim(sss.UserDefined3)
		,	line11 = rtrim(sss.UserDefined11)
		,	line12 = rtrim(sss.UserDefined12)
		,	line13 = rtrim(sss.UserDefined13)
		,	line14 = rtrim(sss.UserDefined14)
		,	line15 = rtrim(sss.UserDefined15)
		,	line16 = rtrim(sss.UserDefined16)
		,	line17 = rtrim(sss.UserDefined17)
		from
			dbo.order_header oh
		JOIN
			edi_setups es ON es.destination = oh.destination
		join
				EDIVARROCic.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From EDIVARROCic.CurrentShipSchedules()) css 
			on
				css.CustomerPart = bo.customerpart and
				css.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = css.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = css.CustomerModelYear
				)
		  join
				EDIVARROCic.ShipScheduleSupplemental sss
		on
				sss.RawDocumentGUID = css.RawDocumentGUID and
				sss.CustomerPart = css.CustomerPart and
				coalesce(sss.CustomerPO,'') = css.CustomerPO and
				sss.CustomerModelYear = css.CustomerModelYear  and
				sss.ShipToCode = css.ShipToCode
		--WHERE es.trading_partner_code NOT LIKE '%AF52M%'
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
	

					/* Custom For Armada Rubber*/

		/*				update
			oh
		set	
		custom01 = c.ConsigneeCode,
		location = left(oh.destination,5)+c.ConsigneeCode
		from
			dbo.order_header oh
		join
				EDIVARROCic.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From @Current830s) cpr 
			on
				cpr.CustomerPart = bo.customerpart and
				cpr.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = cpr.CustomerPO
				)
					and	(	bo.CheckModelYearPlanning= 0
							or bo.ModelYear830 = cpr.CustomerModelYear
				)
		  join
				EDIVARROCic.PlanningSupplemental prs
		on
				prs.RawDocumentGUID = cpr.RawDocumentGUID and
				prs.CustomerPart = cpr.CustomerPart and
				coalesce(prs.CustomerPO,'') = cpr.CustomerPO and
				prs.CustomerModelYear = cpr.CustomerModelYear  and
				prs.ShipToCode = cpr.ShipToCode
	*/
	/*update
			oh
		set	
		custom01 = c.ConsigneeCode,
		location = left(oh.destination,5)+c.ConsigneeCode
		from
			dbo.order_header oh
			join 
				EDIVARROCic.ShipScheduleHeaders fh
			join 
				EDIVARROCic.ShipSchedules ps on ps.RawDocumentGUID = fh.RawDocumentGUID
			join 
				EDIVARROCic.BlanketOrders bo	on bo.EDIShipToCode =  ps.ShipToCode
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
				and ps.ShipToCode = c.ShipToCode
				
				and ps.CustomerPart = c.CustomerPart
				and	(	bo.CheckCustomerPOPlanning = 0
						or bo.CustomerPO = c.CustomerPO
					)
				and	(	bo.CheckModelYearPlanning = 0
						or bo.ModelYear = c.CustomerModelYear
					)
*/

				/* End Custom For Armada Rubber	*/
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
		
	
		IF	@Error != 0 BEGIN
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN
		END
	END
	--- </Update>
--end
ELSE BEGIN
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
		
		SELECT 'to be inserted'
	END
		
	SELECT
		order_no = rr.OrderNo
	,	sequence = rr.Line
	,	part_number = rr.BlanketPart
	,	product_name = (SELECT name FROM dbo.part WHERE part = rr.BlanketPart)
	,	type = CASE rr.Type WHEN 1 THEN 'F' WHEN 2 THEN 'P' END
	,	quantity = rr.RelPost - rr.relPrior
	,	status = ''
	,	notes = 'Processed Date : '+ CONVERT(VARCHAR, GETDATE(), 120) + ' ~ ' + CASE rr.Type WHEN 1 THEN 'EDI Processed Release' WHEN 2 THEN 'EDI Processed Release' END
	,	unit = (SELECT unit FROM order_header WHERE order_no = rr.OrderNo)
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
	,	plant = (SELECT plant FROM order_header WHERE order_no = rr.OrderNo)
	,	week_no = DATEDIFF(wk, (SELECT fiscal_year_begin FROM parameters), rr.ReleaseDT) + 1
	,	std_qty = rr.RelPost - rr.relPrior
	,	our_cum = rr.RelPrior
	,	the_cum = rr.RelPost
	,	price = (SELECT price FROM order_header WHERE order_no = rr.OrderNo)
	,	alternate_price = (SELECT alternate_price FROM order_header WHERE order_no = rr.OrderNo)
	,	committed_qty = COALESCE
		(	CASE
				WHEN rr.QtyShipper > rr.RelPost - bo.AccumShipped THEN rr.RelPost - rr.relPrior
				WHEN rr.QtyShipper > rr.RelPrior - bo.AccumShipped THEN rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
			END
		,	0
		)
	FROM
		@RawReleases rr
		JOIN EDIVARROCic.BlanketOrders bo
			ON bo.BlanketOrderNo = rr.OrderNo
	ORDER BY
		1, 2
END
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
	TradingPartner varchar(30) NULL,
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
(	TradingPartner,
	DocumentType,
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
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current862s a
Where
		coalesce(a.newDocument,0) = 1
and not exists
( Select 1 from 
		EDIVARROCic.ShipSchedules b
 Join 
	EDIVARROCic.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
and
	b.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = b.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = b.CustomerModelYear)
where
				a.RawDocumentGUID = b.RawDocumentGUID and
				a.CustomerPart = b.CustomerPart and
				a.ShipToCode = b.ShipToCode and
				coalesce(a.customerPO,'') = coalesce(b.CustomerPO,'') and
				coalesce(a.CustomerModelYear,'') = coalesce(b.CustomerModelYear,'')
)
union
Select
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current830s a
Where
		coalesce(a.newDocument,0) = 1
and not exists
( Select 1 from 
		EDIVARROCic.PlanningReleases b
 Join 
	EDIVARROCic.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
and
	b.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = b.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = b.CustomerModelYear)
where
				a.RawDocumentGUID = b.RawDocumentGUID and
				a.CustomerPart = b.CustomerPart and
				a.ShipToCode = b.ShipToCode and
				coalesce(a.customerPO,'') = coalesce(b.CustomerPO,'') and
				coalesce(a.CustomerModelYear,'') = coalesce(b.CustomerModelYear,'')
)
union

--Orders Processed
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current862s a
	 Join 
	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	Where
		coalesce(a.newDocument,0) = 1 

union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current830s a
	 Join 
	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	Where
		coalesce(a.newDocument,0) = 1

--Accums Reporting
union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(ssa.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(ssa.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(ssaa.PriorCUM,0))
from
	@Current862s a
	 Join 
	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	left join
		EDIVARROCic.ShipScheduleAccums ssa on 
		ssa.RawDocumentGUID = a.RawDocumentGUID and
		ssa.ShipToCode = a.ShipToCode and
		ssa.CustomerPart = a.CustomerPart and
		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIVARROCic.ShipScheduleAuthAccums ssaa on 
		ssaa.RawDocumentGUID = a.RawDocumentGUID and
		ssaa.ShipToCode = a.ShipToCode and
		ssaa.CustomerPart = a.CustomerPart and
		coalesce(ssaa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssaa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
										
	Where
		coalesce(a.newDocument,0) = 1 and
		coalesce(bo.AccumShipped,0) != coalesce(ssa.LastAccumQty,0)


union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(pra.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(pra.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(praa.PriorCUM,0))
from
	@Current830s  a
	 Join 
	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	left join
		EDIVARROCic.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDIVARROCic.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
										
	Where
		coalesce(a.newDocument,0) = 1 and
		coalesce(bo.AccumShipped,0) != coalesce(pra.LastAccumQty,0)


order by 1,2,5,4,7


--Update Order Header with Customer's Accum Received ---Armada Only

--Update oh
--		set oh.raw_cum = coalesce(ssa.LastAccumQty,0)
--from
--	@Current862s a
--	 Join 
--	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
--and
--	a.ShipToCode = bo.EDIShipToCode
--and
--(	bo.CheckCustomerPOShipSchedule = 0
--	or bo.CustomerPO = a.CustomerPO)
--and
--(	bo.CheckModelYearShipSchedule = 0
--	or bo.ModelYear862 = a.CustomerModelYear)
--	left join
--		EDIVARROCic.ShipScheduleAccums ssa on 
--		ssa.RawDocumentGUID = a.RawDocumentGUID and
--		ssa.ShipToCode = a.ShipToCode and
--		ssa.CustomerPart = a.CustomerPart and
--		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
--		coalesce(ssa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
-- 	left join
--		EDIVARROCic.ShipScheduleAuthAccums ssaa on 
--		ssaa.RawDocumentGUID = a.RawDocumentGUID and
--		ssaa.ShipToCode = a.ShipToCode and
--		ssaa.CustomerPart = a.CustomerPart and
--		coalesce(ssaa.CustomerPO,'') = coalesce(a.customerPO,'') and
--		coalesce(ssaa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
--join
--		order_header oh on oh.order_no = bo.BlanketOrderNo
										
--	Where
--		coalesce(a.newDocument,0) = 1

--Update oh
--		set oh.fab_cum = coalesce(pra.LastAccumQty,0)
--from
--	@Current830s  a
--	 Join 
--	EDIVARROCic.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
--and
--	a.ShipToCode = bo.EDIShipToCode
--and
--(	bo.CheckCustomerPOPlanning = 0
--	or bo.CustomerPO = a.CustomerPO)
--and
--(	bo.CheckModelYearPlanning = 0
--	or bo.ModelYear830 = a.CustomerModelYear)
--	left join
--		EDIVARROCic.PlanningAccums pra on 
--		pra.RawDocumentGUID = a.RawDocumentGUID and
--		pra.ShipToCode = a.ShipToCode and
--		pra.CustomerPart = a.CustomerPart and
--		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
--		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
-- 	left join
--		EDIVARROCic.PlanningAuthAccums praa on 
--		praa.RawDocumentGUID = a.RawDocumentGUID and
--		praa.ShipToCode = a.ShipToCode and
--		praa.CustomerPart = a.CustomerPart and
--		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
--		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
--join
--		order_header oh on oh.order_no = bo.BlanketOrderNo
										
--	Where
--		coalesce(a.newDocument,0) = 1
		
Select	*
into	#EDIAlerts
From	@EDIOrdersAlert

Select	TradingPartner ,
				DocumentType , --'PR - Planning Release; SS - ShipSchedule'
				AlertType ,
				ReleaseNo ,
				ShipToCode,
				ConsigneeCode ,				
				CustomerPart ,
				CustomerPO ,
				Description 
				
into	#EDIAlertsEmail
From	@EDIOrdersAlert


IF EXISTS (SELECT 1 FROM #EDIAlertsEmail)

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
			@EmailTableName sysname  = N'#EDIAlertsEmail'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			, @OrderBy = '[AlertType], [TradingPartner],  [DocumentType], [ShipToCode], [CustomerPart]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'EDI Processing for VARROC' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailAddress -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 

--INSERT [EDIAlerts].[ProcessedReleases]

--(	 EDIGroup
--	,TradingPartner
--	,DocumentType --'PR - Planning Release; SS - ShipSchedule'
--	,AlertType 
--	,ReleaseNo
--	,ShipToCode
--	,ConsigneeCode 
--	,ShipFromCode 
--	,CustomerPart
--	,CustomerPO
--	,CustomerModelYear
--	,Description
--)


--SELECT 
--	'EDIVARROCic'
--	,*
--FROM
--	#EDIAlerts
--UNION
--SELECT
--	'EDIVARROCic'
--	,TradingPartner = COALESCE((SELECT MAX(TradingPartner) FROM fxEDI.EDI.EDIDocuments WHERE GUID = a.RawDocumentGUID) ,'')
--,	DocumentType = 'SS'
--,	AlertType =  'Exception Quantity Due'
--,	ReleaseNo =  COALESCE(a.ReleaseNo,'')
--,	ShipToCode = a.ShipToCode
--,	ConsigneeCode =  COALESCE(a.ConsigneeCode,'')
--,	ShipFromCode = COALESCE(a.ShipFromCode,'')
--,	CustomerPart = COALESCE(a.CustomerPart,'')
--,	CustomerPO = COALESCE(a.CustomerPO,'')
--,	CustomerModelYear = COALESCE(a.CustomerModelYear,'')
--, Description = 'Qty Due : ' + CONVERT(VARCHAR(MAX), c.ReleaseQty) + ' on - ' + CONVERT(VARCHAR(MAX), c.ReleaseDT)
--FROM
--	@Current862s a
--JOIN
--		EDIVARROCic.ShipSchedules c
--ON			c.RawDocumentGUID = a.RawDocumentGUID AND
--				a.CustomerPart = c.CustomerPart AND
--				a.ShipToCode =c.ShipToCode AND
--				COALESCE(a.customerPO,'') = COALESCE(c.CustomerPO,'') AND
--				COALESCE(a.CustomerModelYear,'') = COALESCE(c.CustomerModelYear,'')
--WHERE
--		COALESCE(a.newDocument,0) = 1
--AND NOT EXISTS
--( SELECT 1 FROM 
--		EDIVARROCic.ShipSchedules b
-- JOIN 
--	EDIVARROCic.BlanketOrders bo ON b.CustomerPart = bo.CustomerPart
--AND
--	b.ShipToCode = bo.EDIShipToCode
--AND
--(	bo.CheckCustomerPOShipSchedule = 0
--	OR bo.CustomerPO = b.CustomerPO)
--AND
--(	bo.CheckModelYearShipSchedule = 0
--	OR bo.ModelYear862 = b.CustomerModelYear)
--WHERE
--				a.RawDocumentGUID = b.RawDocumentGUID AND
--				a.CustomerPart = b.CustomerPart AND
--				a.ShipToCode = b.ShipToCode AND
--				COALESCE(a.customerPO,'') = COALESCE(b.CustomerPO,'') AND
--				COALESCE(a.CustomerModelYear,'') = COALESCE(b.CustomerModelYear,''))

--UNION
--SELECT
--	'EDIVARROCic'
--	,TradingPartner = COALESCE((SELECT MAX(TradingPartner) FROM fxEDI.EDI.EDIDocuments WHERE GUID = a.RawDocumentGUID) ,'')
--,	DocumentType = 'PR'
--,	AlertType =  'Exception Quantity Due'
--,	ReleaseNo =  COALESCE(a.ReleaseNo,'')
--,	ShipToCode = a.ShipToCode
--,	ConsigneeCode =  COALESCE(a.ConsigneeCode,'')
--,	ShipFromCode = COALESCE(a.ShipFromCode,'')
--,	CustomerPart = COALESCE(a.CustomerPart,'')
--,	CustomerPO = COALESCE(a.CustomerPO,'')
--,	CustomerModelYear = COALESCE(a.CustomerModelYear,'')
--,  Description = 'Qty Due : ' + CONVERT(VARCHAR(MAX), c.ReleaseQty) + ' on - ' + CONVERT(VARCHAR(MAX), c.ReleaseDT)
--FROM
--	@Current830s a
--JOIN
--		EDIVARROCic.PlanningReleases c
--ON			c.RawDocumentGUID = a.RawDocumentGUID AND
--				a.CustomerPart = c.CustomerPart AND
--				a.ShipToCode =c.ShipToCode AND
--				COALESCE(a.customerPO,'') = COALESCE(c.CustomerPO,'') AND
--				COALESCE(a.CustomerModelYear,'') = COALESCE(c.CustomerModelYear,'')
--WHERE
--		COALESCE(a.newDocument,0) = 1
--AND  NOT EXISTS
--( SELECT 1 FROM 
--		EDIVARROCic.PlanningReleases b
-- JOIN 
--	EDIVARROCic.BlanketOrders bo ON b.CustomerPart = bo.CustomerPart
--AND
--	b.ShipToCode = bo.EDIShipToCode
--AND
--(	bo.CheckCustomerPOPlanning = 0
--	OR bo.CustomerPO = b.CustomerPO)
--AND
--(	bo.CheckModelYearPlanning = 0
--	OR bo.ModelYear830 = b.CustomerModelYear)
--WHERE
--				a.RawDocumentGUID = b.RawDocumentGUID AND
--				a.CustomerPart = b.CustomerPart AND
--				a.ShipToCode = b.ShipToCode AND
--				COALESCE(a.customerPO,'') = COALESCE(b.CustomerPO,'') AND
--				COALESCE(a.CustomerModelYear,'') = COALESCE(b.CustomerModelYear,''))


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
	@ProcReturn = EDIVARROCic.usp_Process
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
