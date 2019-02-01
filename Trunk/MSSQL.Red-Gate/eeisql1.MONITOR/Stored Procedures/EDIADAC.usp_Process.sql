SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [EDIADAC].[usp_Process]
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

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. EDIADAC.usp_Test
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
,	OpenReleaseQty NUMERIC(20,6)
,	ReleaseDueDate DATETIME
,	RowCreateDT DATETIME
,	NewDocument INT
)

INSERT
	@Current862s
SELECT DISTINCT
	 RawDocumentGUID
,	  ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,		CustomerModelYear
,   OpenReleaseQty
,   ReleaseDate
,	RowCreateDT
,   NewDocument
FROM
	EDIADAC.CurrentShipSchedules ()

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
	@Current830s
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
from
	EDIADAC.CurrentPlanningReleases ()

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
		--where
		--	cd.NewDocument = 1 --@Current862s contain all Open RANs; NewDocument is meaningless in this context  [ Andre S. Boulanger , 2014-02-21]
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
set	@TableName = 'EDIADAC.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIADAC.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIADAC.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDIADAC.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID
		and coalesce(ss.ReleaseNo,'') = coalesce(c.ReleaseNo,'') 
		and ss.ShipToCode = c.ShipToCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(ss.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDIADAC.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIADAC.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIADAC.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Active'))
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
set	@TableName = 'EDIADAC.PlanningReleases'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDIADAC.PlanningReleases PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and coalesce(PR.ReleaseNo,'') = coalesce(c.ReleaseNo,'') 
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active'))
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
set	@TableName = 'EDIADAC.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDIADAC.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDIADAC.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Active'))
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
		EDIADAC.ShipScheduleHeaders fh

	select
		'PlanningHeaders'
		
	SELECT
		*
	FROM
		EDIADAC.PlanningHeaders fh
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
,	ReleaseType int
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
(	ReleaseType
,	OrderNo
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


select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays*-1, (DATEADD(MILLISECOND, convert(numeric(20,8),substring( fr.UserDefined5,4,10))/100, fr.ReleaseDT)) )
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.UserDefined5
,	QtyRelease = c.OpenReleaseQty
--,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = c.OpenReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDIADAC.ShipScheduleHeaders fh
	join EDIADAC.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIADAC.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIADAC.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIADAC.BlanketOrders bo
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
				(Select * From @Current862s ) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
and				c.ReleaseNo =  fr.UserDefined5
--and			fh.Status = 1 --(select dbo.udf_StatusValue('EDIADAC.ShipScheduleHeaders', 'Status', 'Active'))
		

/*		830s. */
Union all
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z') then 2
					else 1
					end
			  )
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays*-1, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,bo.AccumShipped),0)
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
	EDIADAC.PlanningHeaders fh
	join EDIADAC.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDIADAC.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDIADAC.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDIADAC.BlanketOrders bo
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
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
	and		fh.Status = 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningHeaders', 'Status', 'Active'))
	and		fr.Status = 1 --(select dbo.udf_StatusValue('EDIADAC.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
	
order by
	1, 2, 3,4

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
			and ReleaseType = rr.ReleaseType
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
	ReleaseDT = (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1)+1
from
	@RawReleases rr
where
	rr.ReleaseType = 2
	and rr.ReleaseDT < (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1)

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
,		bor.ReleaseType
,		sum(bor.QtyRelease)
from
	@RawReleases bor
WHERE bor.Status != -1
group by
		bor.OrderNo
,		bor.ReleaseNo
,		bor.ReleaseDT
,		bor.ReleaseType

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


--Update Order Detail to capture Ship Window Time to Custom01 for label pinting purposes.

UPDATE dbo.order_detail
SET custom01 = SUBSTRING(release_no,PATINDEX('%~%',release_no)+1, 10)
WHERE 
	customer_part IN (SELECT CustomerPart from @RawReleases) AND
	release_no LIKE '%~%'

UPDATE dbo.order_detail
SET release_no = SUBSTRING(release_no,1,PATINDEX('%~%',release_no)-1)
WHERE
	customer_part IN (SELECT CustomerPart from @RawReleases) AND 
	release_no LIKE '%~%'



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
		RETURN
	END
	
	--- </Insert>
	
	/*	Set dock code, line feed code, and reserve line feed code. */
	/*if  exists
		(	select
				*
			from
				dbo.order_header oh
				join EDIADAC.PlanningHeaders fh
					join EDIADAC.PlanningSupplemental ps
						on ps.RawDocumentGUID = fh.RawDocumentGUID
					join EDIADAC.BlanketOrders bo
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
				join EDIADAC.ShipScheduleHeaders fh
					join EDIADAC.ShipScheduleSupplemental sss
						on sss.RawDocumentGUID = fh.RawDocumentGUID
					join EDIADAC.BlanketOrders bo
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
			EDIADAC.LabelInfoHeader
		(	SystemDT
		)
		select
			@TranDT
		
		insert 	
			EDIADAC.LabelInfoHeader
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
				EDIADAC.blanketOrders bo
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
				EDIADAC.PlanningSupplemental prs
		on
				prs.RawDocumentGUID = cpr.RawDocumentGUID and
				prs.CustomerPart = cpr.CustomerPart and
				coalesce(prs.CustomerPO,'') = cpr.CustomerPO and
				prs.CustomerModelYear = cpr.CustomerModelYear  and
				prs.ShipToCode = cpr.ShipToCode
		
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
			custom01 = rtrim(sss.UserDefined1)
		,	dock_code = rtrim(sss.UserDefined1)
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
		join
				EDIADAC.blanketOrders bo
		on
				bo.BlanketOrderNo = oh.order_no
		join
				(Select * From @Current862s) css 
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
				EDIADAC.ShipScheduleSupplemental sss
		on
				sss.RawDocumentGUID = css.RawDocumentGUID and
				sss.CustomerPart = css.CustomerPart and
				coalesce(sss.CustomerPO,'') = css.CustomerPO and
				sss.CustomerModelYear = css.CustomerModelYear  and
				sss.ShipToCode = css.ShipToCode
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
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
		JOIN EDIADAC.BlanketOrders bo
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
		coalesce(a.newDocument,0) in (0, 1) AND
		a.RowCreateDT >=  dateadd(MINUTE, -60, GETDATE())
and not exists
( Select 1 from 
		EDIADAC.ShipSchedules b
 Join 
	EDIADAC.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
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
		EDIADAC.PlanningReleases b
 Join 
	EDIADAC.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
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
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current862s a
	 Join 
	EDIADAC.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	Where
		coalesce(a.newDocument,0) in (0, 1) AND
		a.RowCreateDT >=  dateadd(MINUTE, -60, GETDATE())

union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current830s a
	 Join 
	EDIADAC.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
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
,	ShipToCode = a.ShipToCode
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
	EDIADAC.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = a.CustomerModelYear)
	left join
		EDIADAC.ShipScheduleAccums ssa on 
		ssa.RawDocumentGUID = a.RawDocumentGUID and
		ssa.ShipToCode = a.ShipToCode and
		ssa.CustomerPart = a.CustomerPart and
		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
		COALESCE(ssa.CustomerModelYear,'') = COALESCE(a.customerModelYear,'')
 	LEFT JOIN
		EDIADAC.ShipScheduleAuthAccums ssaa ON 
		ssaa.RawDocumentGUID = a.RawDocumentGUID AND
		ssaa.ShipToCode = a.ShipToCode AND
		ssaa.CustomerPart = a.CustomerPart AND
		COALESCE(ssaa.CustomerPO,'') = COALESCE(a.customerPO,'') AND
		COALESCE(ssaa.CustomerModelYear,'') = COALESCE(a.customerModelYear,'')
										
	WHERE
		COALESCE(a.newDocument,0) IN (0, 1) AND
		COALESCE(bo.AccumShipped,0) != COALESCE(ssa.LastAccumQty,0) AND
		a.RowCreateDT >=  DATEADD(MINUTE, -60, GETDATE())


UNION
SELECT 
	TradingPartner = COALESCE((SELECT MAX(TradingPartner) FROM fxEDI.EDI.EDIDocuments WHERE GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  COALESCE(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	ConsigneeCode =  COALESCE(a.ConsigneeCode,'')
,	ShipFromCode = COALESCE(a.ShipFromCode,'')
,	CustomerPart = COALESCE(a.CustomerPart,'')
,	CustomerPO = COALESCE(a.CustomerPO,'')
,	CustomerModelYear = COALESCE(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ CONVERT(VARCHAR(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ CONVERT(VARCHAR(15), COALESCE(pra.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ CONVERT(VARCHAR(15), COALESCE(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ CONVERT(VARCHAR(15), COALESCE(pra.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ CONVERT(VARCHAR(15), COALESCE(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ CONVERT(VARCHAR(15), COALESCE(praa.PriorCUM,0))
FROM
	@Current830s  a
	 JOIN 
	EDIADAC.BlanketOrders bo ON a.CustomerPart = bo.CustomerPart
AND
	a.ShipToCode = bo.EDIShipToCode
AND
(	bo.CheckCustomerPOPlanning = 0
	OR bo.CustomerPO = a.CustomerPO)
AND
(	bo.CheckModelYearPlanning = 0
	OR bo.ModelYear830 = a.CustomerModelYear)
	LEFT JOIN
		EDIADAC.PlanningAccums pra ON 
		pra.RawDocumentGUID = a.RawDocumentGUID AND
		pra.ShipToCode = a.ShipToCode AND
		pra.CustomerPart = a.CustomerPart AND
		COALESCE(pra.CustomerPO,'') = COALESCE(a.customerPO,'') AND
		COALESCE(pra.CustomerModelYear,'') = COALESCE(a.customerModelYear,'')
 	LEFT JOIN
		EDIADAC.PlanningAuthAccums praa ON 
		praa.RawDocumentGUID = a.RawDocumentGUID AND
		praa.ShipToCode = a.ShipToCode AND
		praa.CustomerPart = a.CustomerPart AND
		COALESCE(praa.CustomerPO,'') = COALESCE(a.customerPO,'') AND
		COALESCE(praa.CustomerModelYear,'') = COALESCE(a.customerModelYear,'')
										
	WHERE
		COALESCE(a.newDocument,0) = 1 AND
		COALESCE(bo.AccumShipped,0) != COALESCE(pra.LastAccumQty,0)


ORDER BY 1,2,5,4,7
		

SELECT	*
INTO	#EDIAlerts
FROM	@EDIOrdersAlert

SELECT	TradingPartner ,
				DocumentType , --'PR - Planning Release; SS - ShipSchedule'
				AlertType ,
				ReleaseNo ,
				ShipToCode,
				ConsigneeCode ,				
				CustomerPart ,
				CustomerPO ,
				Description 
				
INTO	#EDIAlertsEmail
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
			@EmailTableName sysname  = N'#EDIAlertsEmail'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,	@OrderBy = '[AlertType], [TradingPartner],  [DocumentType], [ShipToCode], [CustomerPart]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'EDI Processing for EDIADAC' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailAddress-- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 
					



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
	@ProcReturn = EDIADAC.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

--commit transaction
rollback transaction

go

set statistics io off
set statistics time off
go

}

Results {
}
*/
















GO
