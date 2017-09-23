SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EDILiteTek].[usp_Process_ManualImport]
	@Destination varchar(20)
,	@TranDT datetime = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILiteTek.usp_Test
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
	print	'Determine the current 830s.'
	set	@StartDT = GetDate ()
end
--</Debug>

/*	Determine the current 830s. */
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
	EDILiteTek.CurrentPlanningReleases_ManualImport()

--<Debug>
if @Debug & 1 = 1 begin
	print	'...determined.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

/*		If the current 830s are already "Active", done. */
if	not exists
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
	print	'Mark "Active" 830s.'
	set	@StartDT = GetDate ()
end

--- <Update rows="*">
set	@TableName = 'EDILiteTek.PlanningReleases_ManualImport'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'Replaced'))
		end
from
	EDILiteTek.PlanningReleases_ManualImport PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'Active'))
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
set	@TableName = 'EDILiteTek.PlanningHeaders_ManualImport'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDILiteTek.PlanningReleases_ManualImport fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningHeaders_ManualImport', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDILiteTek.PlanningHeaders_ManualImport', 'Status', 'Replaced'))
	end
from
	EDILiteTek.PlanningHeaders_ManualImport fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDILiteTek.PlanningHeaders_ManualImport', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningHeaders_ManualImport', 'Status', 'Active'))
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
		'PlanningHeaders'
		
	select
		*
	from
		EDILiteTek.PlanningHeaders_ManualImport fh
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active 830s.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Write new releases. */
/*		Calculate raw releases from active 830s. */
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
/*		Add releases due today when behind and no release for today exists. */
/*		830s. */
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
--,	Type = (	case 
--					when bo.PlanningFlag = 'P' then 2
--					when bo.PlanningFlag = 'F' then 1
--					when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z') then 2
--					else 1
--					end
--			  )
,	Type = 2
--,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	ReleaseDT = fr.ReleaseDT
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = case  WHEN fr.suppliercode =  'A0144' then fr.Userdefined5 WHEN fr.suppliercode IN ( 'ARM701', 'ARM101' ) AND fr.Userdefined5 IS NOT NULL THEN fr.UserDefined5 ELSE fr.ReleaseNo end
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = 0
,	CustomerAccum = 0
,	NewDocument = 1
from
	EDILiteTek.PlanningHeaders_ManualImport fh
	join EDILiteTek.PlanningReleases_ManualImport fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
		/*
	left join EDILiteTek.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDILiteTek.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
		*/
	left join EDILiteTek.BlanketOrders bo
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
		left join
				(Select * From @Current830s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOPlanning = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearplanning = 0
							or bo.ModelYear830 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
	and		fh.Status = 1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningHeaders_ManualImport', 'Status', 'Active'))
	and		fr.Status = 1 --(select dbo.udf_StatusValue('EDILiteTek.PlanningReleases_ManualImport', 'Status', 'Active'))
	and		bo.ShipToCode = @Destination
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
	
order by
	2,1,4

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
--update
--	@RawReleases
--set
--	RelPost = CustomerAccum + coalesce (
--	(	select
--			sum (StdQtyRelease)
--		from
--			@RawReleases
--		where
--			OrderNo = rr.OrderNo
--			and Type = rr.Type
--			and	RowID <= rr.RowID), 0)
--from
--	@RawReleases rr

	
--/*		Calculate orders to update. */
--update
--	rr
--set
--	NewDocument =
--	(	select
--			max(NewDocument)
--		from
--			@RawReleases rr2
--		where
--			rr2.OrderNo = rr.OrderNo
--	)
--from
--	@RawReleases rr

--if	@Testing = 0 begin
--	delete
--		rr
--	from
--		@RawReleases rr
--	where
--		rr.NewDocument = 0
--end

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

	
--/*		Calculate orders to update. */
--update
--	rr
--set
--	NewDocument =
--	(	select
--			max(NewDocument)
--		from
--			@RawReleases rr2
--		where
--			rr2.OrderNo = rr.OrderNo
--	)
--from
--	@RawReleases rr

--delete
--	rr
--from
--	@RawReleases rr
--where
--	rr.NewDocument = 0


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
	,	notes = 'Processed Date : '+ convert(varchar, getdate(), 120) + ' ~ ' + case rr.Type when 1 then 'EDI Processed Release' when 2 then 'EDI Processed Release' end
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
		join EDILiteTek.BlanketOrders bo
			on bo.BlanketOrderNo = rr.OrderNo
	where
		bo.ShipToCode = @Destination
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
	commit tran @ProcName
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
		EDILiteTek.PlanningReleases_ManualImport b
 Join 
	EDILiteTek.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
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
				and bo.ShipToCode = @Destination
)
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
	EDILiteTek.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
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
		and bo.ShipToCode = @Destination

/*
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
	EDILiteTek.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	left join
		EDILiteTek.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDILiteTek.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')								
	Where
		coalesce(a.newDocument,0) = 1 and
		coalesce(bo.AccumShipped,0) != coalesce(pra.LastAccumQty,0)
*/

order by 1,2,5,4,7


/*
Update oh
		set oh.fab_cum = coalesce(pra.LastAccumQty,0)
from
	@Current830s  a
	 Join 
	EDILiteTek.BlanketOrders bo on a.CustomerPart = bo.CustomerPart
and
	a.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOPlanning = 0
	or bo.CustomerPO = a.CustomerPO)
and
(	bo.CheckModelYearPlanning = 0
	or bo.ModelYear830 = a.CustomerModelYear)
	left join
		EDILiteTek.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDILiteTek.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
join
		order_header oh on oh.order_no = bo.BlanketOrderNo
										
	Where
		coalesce(a.newDocument,0) = 1
*/


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
			, @OrderBy = '[AlertType], [TradingPartner],  [DocumentType], [ShipToCode], [CustomerPart]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'EDI Processing for EDILiteTek' 

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
					

/*Insert [EDIAlerts].[ProcessedReleases]

(	 EDIGroup
	,TradingPartner
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
	'EDI3060'
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
	@ProcReturn = EDILiteTek.usp_Process
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
