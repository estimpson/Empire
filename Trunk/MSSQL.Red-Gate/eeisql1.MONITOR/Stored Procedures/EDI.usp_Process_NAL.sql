SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [EDI].[usp_Process_NAL]
	@TranDT DATETIME OUT
,	@Result INTEGER OUT
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

SET	@ProcName = USER_NAME(OBJECTPROPERTY(@@procid, 'OwnerId')) + '.' + OBJECT_NAME(@@procid)  -- e.g. EDI.usp_Test
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
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	CustomerPart VARCHAR(35)
,	NewDocument INT
)

INSERT
	@Current862s
SELECT
	c.RawDocumentGUID
,	c.ShipToCode
,	c.ShipFromCode
,	c.CustomerPart
,	c.NewDocument
FROM
	NALEDI.Current862s() c

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
,	ShipToCode VARCHAR(15)
,	ShipFromCode VARCHAR(15)
,	CustomerPart VARCHAR(35)
,	NewDocument INT
)

INSERT
	@Current830s
SELECT
	c.RawDocumentGUID
,	c.ShipToCode
,	c.ShipFromCode
,	c.CustomerPart
,	c.NewDocument
FROM
	NALEDI.Current830s() c

--<Debug>
IF @Debug & 1 = 1 BEGIN
	PRINT	'...determined.   ' + CONVERT (VARCHAR, DATEDIFF (ms, @StartDT, GETDATE ())) + ' ms'
END
--</Debug>

/*		If the current 862s and 830s are already "Active", done. */
IF	NOT EXISTS
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
--</Debug>
/*	Mark "Active" 862s and 830s. */
--- <Update rows="*">
set	@TableName = 'EDI.NAL_862_Releases'

update
	fr
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI.NAL_862_Releases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI.NAL_862_Releases', 'Status', 'Replaced'))
		end
from
	EDI.NAL_862_Releases fr
	left join @Current862s c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode		
		and fr.CustomerPart = c.CustomerPart

where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.NAL_862_Releases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.NAL_862_Releases', 'Status', 'Active'))
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
set	@TableName = 'EDI.NAL_862_Headers'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDI.NAL_862_Releases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDI.NAL_862_Releases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDI.NAL_862_Headers', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDI.NAL_862_Headers', 'Status', 'Replaced'))
	end
from
	EDI.NAL_862_Headers fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.NAL_862_Headers', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.NAL_862_Headers', 'Status', 'Active'))
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
set	@TableName = 'EDI.NAL_830_Releases'

update
	fr
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI.NAL_830_Releases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI.NAL_830_Releases', 'Status', 'Replaced'))
		end
from
	EDI.NAL_830_Releases fr
	left join @Current830s c
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode		
		and fr.CustomerPart = c.CustomerPart

where
	fr.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.NAL_830_Releases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.NAL_830_Releases', 'Status', 'Active'))
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
set	@TableName = 'EDI.NAL_830_Headers'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDI.NAL_830_Releases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDI.NAL_830_Releases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDI.NAL_830_Headers', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDI.NAL_830_Headers', 'Status', 'Replaced'))
	end
from
	EDI.NAL_830_Headers fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI.NAL_830_Headers', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI.NAL_830_Headers', 'Status', 'Active'))
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
		'NAL_862_Headers'

	select
		*
	from
		EDI.NAL_862_Headers fh

	select
		'NAL_830_Headers'
		
	select
		*
	from
		EDI.NAL_830_Headers fh
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
,	Type tinyint
,	OrderNo int
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	ReferenceAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	ReleaseDT datetime
,	LastRANDT datetime
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
,	ReleaseDT
,	LastRANDT
,	NewDocument
)
select
	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
--,	QtyRelease = [MONITOR].[dbo].[fn_GreaterOf](coalesce( [FT].[fn_GetOriginalRANQty](fr.ReleaseNo, fr.ShipToCode, fr.customerPart),fr.ReleaseQty), fr.ReleaseQty) --Commented this and next column 08/26/2016 per Marty - Empire will ship to latest schedule, not highest RAN
--,	StdQtyRelease = [MONITOR].[dbo].[fn_GreaterOf](coalesce( [FT].[fn_GetOriginalRANQty](fr.ReleaseNo, fr.ShipToCode, fr.customerPart),fr.ReleaseQty), fr.ReleaseQty)
,	QtyRelease =  fr.ReleaseQty
,	StdQtyRelease =  fr.ReleaseQty
,	ReferenceAccum = bo.AccumShipped
--,	ReleaseDT = case datepart(dw, fr.ReleaseDT) when 7 then dateadd(dd,-1, fr.ReleaseDT) when 1 then dateadd(dd,-2, fr.ReleaseDT) else dateadd(dd,0 , fr.ReleaseDT) end
,	ReleaseDT = fr.ReleaseDT
,	LastRANDT =  (select max(ReleaseDT) from EDI.NAL_862_Releases fr3 where fr3.RawDocumentGUID = fr.RawDocumentGUID and fr3.CustomerPart = fr.CustomerPart and fr3.ShipToCode = fr.ShipToCode)
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDI.NAL_862_Headers fh
	join EDI.NAL_862_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	join NALEDI.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
where
	fh.Status in
	(	0
	,	1 
	)
	and fr.Status in
	(	0
	,	1 
	)
	order by
	BlanketOrderNo,
	fr.ReleaseDT


insert
	@RawReleases
(	OrderNo
,	Type
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
,	ReleaseDT
,	NewDocument
)
select
	OrderNo = bo.BlanketOrderNo
,	Type = 2
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
,	ReleaseDT = fr.ReleaseDT
--,	ReleaseDT = case datepart(dw, fr.ReleaseDT) when 7 then dateadd(dd,-1, fr.ReleaseDT) when 1 then dateadd(dd,-2, fr.ReleaseDT) else dateadd(dd,0 , fr.ReleaseDT) end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDI.NAL_830_Headers fh
	join EDI.NAL_830_Releases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	join NALEDI.BlanketOrders bo
		on bo.EDIShipToCode in (fr.ICCode, fr.ShipToCode)
		and bo.CustomerPart = fr.CustomerPart
where
	fh.Status in
	(	0
	,	1 
	)
	and fr.Status in
	(	0
	,	1 
	)
order by
	BlanketOrderNo,
	fr.ReleaseDT
--Get Date Into Table For testing
	--Select * Into PreRanAdjustReleases from @RawReleases
	
--Eliminate 830 RANs already signaled by 862 RANs Begin


--Commented 11/9/2012 Andre S. Boulanger. Paul Slifer from NAL states that forecast 830s will be sent on Wednesday and 862s will be sent Mon-Fri. Standard 830 / 862 blending will now occur
--Commented again 02/18/2013 Andre S. Boulanger. Paul Slifer from NAL stated 11/19/2012 that forecast 830s will be sent on Wednesday and 862s will be sent Mon-Fri. Standard 830 / 862 blending will now occur. I do not re-call uncommenting section
--Un Commented again 02/18/2013 Andre S. Boulanger. Talked with Paul Slifer again on 2/18/2013 and found out that 830s pick up where 862s leave off. This will remove any 830s that may fall inside the 862 date horizon and any RANs on 830s that are also in the 862. 830 and 862 blending is no longer required.
update 
	RR5
set		
	RR5.LastRANDT = (select max(LastRANDT) from @RawReleases RR6 where RR5.CustomerPart = RR6.CustomerPart and RR5.ShipToID = RR6.ShipToID)
From	
	@RawReleases RR5
where	
	RR5.Type = 2


delete
from		@RawReleases
where Type =  2 and
releaseNo in (select releaseNo from @rawreleases where type = 1)

delete
from		@RawReleases
where Type =  2 and
ReleaseDT <= LastRANDT

--Eliminate 830 RANs already signaled by 862 RANs End

--- Reduce Releases by Ran Quantities Shipped Begin
	
	
	declare	@OrderRANS table(
			RANNumber	varchar(50),
			OrderNo	int,
			RanQty	numeric(20,6), 
			CustomerPart varchar(25),
			Destination		varchar(15), PRIMARY KEY (RANNumber, CustomerPart, Destination)
			)  
   
       insert	@OrderRANS
                    ( RANNumber ,
                      OrderNo ,
                      RanQty,
                      CustomerPart ,
                      Destination
                    )
          select	
			RANNumber,
			max(OrderNo),
			sum(qty) ,
			sd.customer_part,
			s.destination
          from		
			dbo.NALRanNumbersShipped RANsShipped 
		join
			shipper_detail sd on RANsShipped.Shipper = sd.shipper and
			RANsShipped.OrderNo = sd.order_no
		join
			shipper s on sd.shipper = s.id
		where
			ShipDate>= dateadd(wk, -52, getdate()) 
			and	exists (select 1 from	@RawReleases mrp where mrp.customerpart = sd.customer_part and mrp.shiptoid = s.destination) and
			DATALENGTH(RANNumber) > 13
		group by
			RANNumber,
			sd.customer_part,
			s.destination
	
	--Select * into  RansShipped from @OrderRANS
			
		update	RR
         set		StdQtyRelease = StdQtyRelease-isNULL(ORANs.RanQty,0),
					QtyRelease = QtyRelease-isNULL(ORANs.RanQty,0)
         from		@RawReleases RR 
				left join
						@OrderRANS ORANs on  RR.customerpart = ORANs.CustomerPart and
						RR.shiptoid = ORANs.Destination and
						RR.releaseno = ORANs.RanNumber
				delete
					@RawReleases
				where
					StdQtyRelease<=0
--- Reduce Releases by Ran Quantities Shipped End
--Select * Into PostRanAdjustReleases from @RawReleases
---Re-order @RawReleases Begin
select	
        Type ,
        OrderNo ,
        BlanketPart ,
        CustomerPart ,
        ShipToID ,
        CustomerPO ,
        ModelYear ,
        OrderUnit ,
        QtyShipper ,
        Line ,
        ReleaseNo ,
        QtyRelease ,
        StdQtyRelease ,
        ReferenceAccum ,
        RelPrior ,
        RelPost ,
        ReleaseDT ,
        LastRANDT ,
        NewDocument
 into #RawReleasesTemp 
from @RawReleases RR

delete @RawReleases 

insert	@RawReleases
	(	Type,
        OrderNo ,
        BlanketPart ,
        CustomerPart ,
        ShipToID ,
        CustomerPO ,
        ModelYear ,
        OrderUnit ,
        QtyShipper ,
        Line ,
        ReleaseNo ,
        QtyRelease ,
        StdQtyRelease ,
        ReferenceAccum ,
        RelPrior ,
        RelPost ,
        ReleaseDT ,
        LastRANDT ,
        NewDocument)
    
    select	*
   from	#RawReleasesTemp
  order by OrderNo, ReleaseDT   
  
  ---Re-order @RawReleases End
	

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
--No blending Occurs at All for NAL 830s pick up where 862s leave off per paul slifer 2/18/2013
/*update
	@RawReleases
set
	RelPost = ReferenceAccum + coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and type = rr.type
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

/*	Blend Documentts */
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

--select	* from @RawReleases

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



delete
	@RawReleases
where
	RelPrior > RelPost
	*/
update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID)
,	QtyShipper =
	(	select
			sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
			and sd.order_no = rr.OrderNo
	)
from
	@RawReleases rr



if	@Testing = 2 begin
	select
		'@RawReleases'
	
	select
		*
	from
		@RawReleases rr
end

/*	Calculate order line numbers. */


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
		,	ReleaseType
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
		join NALEDI.BlanketOrders bo
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

Declare @EDIOrdersAlert table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseNo] [varchar](100) NULL,
	[CustomerPart] [varchar](100) NULL,
	[CustomerPO] [varchar](100) NULL,
	[ShipToCode] [varchar](100) NULL,
	[Type] [varchar](100) NULL,
	[Notes] [varchar](255) NULL
	)

	
		if exists (select 1 
						from 
							@Current862s F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is null
						union
						select 1 
						from 
							@Current830s F830c
						join	
							EDI.NAL_830_Releases F830r on F830c.RawDocumentGUID = F830r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode in (F830r.ICCode, F830r.ShipToCode)
						and 
							bo.CustomerPart = F830r.CustomerPart
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
				Coalesce(ReleaseNo,'')
			,	Coalesce(CustomerPart,'')
			,	Coalesce(CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Exception'
			,	'Blanket sales order not found; please add blanket sales order and reprocess EDI'
		         
		from (select
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID
						from 
							@Current862s F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is null
						union
					select
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID						 
						from 
							@Current830s F830c
						join	
							EDI.NAL_830_Releases F830r on F830c.RawDocumentGUID = F830r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode in (F830r.ICCode, F830r.ShipToCode)
						and 
							bo.CustomerPart = F830r.CustomerPart
						where 
							bo.BlanketOrderNo is null
					
				) NALEDIExceptions
		
		
	order by
		2,3,4



		
		DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>NAL xml EDI Exceptions</H1>' +
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
    @subject = N'EDI Data Exception when processing NAL EDI Document(s)', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
		end
		
		
		if exists (select 
						1
						from 
							@Current862s F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						union
						select 
						1
						from 
							@Current830s F830c
						join	
							EDI.NAL_830_Releases F830r on F830c.RawDocumentGUID = F830r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode in (F830r.ICCode, F830r.ShipToCode)
						and 
							bo.CustomerPart = F830r.CustomerPart
						where 
							bo.BlanketOrderNo is not null)
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
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo
						from 
							@Current862s F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						union
					select
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID,
						bo.BlanketOrderNo OrderNo						 
						from 
							@Current830s F830c
						join	
							EDI.NAL_830_Releases F830r on F830c.RawDocumentGUID = F830r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode in (F830r.ICCode, F830r.ShipToCode)
						and 
							bo.CustomerPart = F830r.CustomerPart

						where 
							bo.BlanketOrderNo is not null
					
				) NALEDIAlerts
		
		
	order by
		2,3,4
		
		DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>NAL EDI Alert</H1>' +
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
            order by 4,2,1 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'EDI Document(s) Updated NAL Sales Orders', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
   end
  
  --Report Partial RANs
  
  
  Declare @EDIOrdersAlertRANs table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseNo] [varchar](100) NULL,
	[CustomerPart] [varchar](100) NULL,
	[CustomerPO] [varchar](100) NULL,
	[ShipToCode] [varchar](100) NULL,
	[Type] [varchar](100) NULL,
	[OriginalRANOrderQty] [numeric](20,6) NULL,
	[RANOrderQty] [numeric](20,6) NULL,
	[RANQtyShipped] [numeric](20,6) NULL,
	[MonitorOrderQty] [numeric](20,6) NULL,
	[Notes] [varchar](255) NULL
	)
  
  insert	@EDIOrdersAlertRANs
		        (	ReleaseNo ,
					CustomerPart ,
					ShipToCode ,
					Type ,
					OriginalRANOrderQty,
					RANOrderQty ,
					RANQtyShipped,
					MonitorOrderqty,
					Notes 
		           )
		select		
				distinct
				ReleaseNo = Coalesce(ReleaseNo,'')
			,	Customerpart = Coalesce(NALEDIAlerts.CustomerPart,'')
			,	ShipToID = Coalesce(ShipToID,'')
			,	'Ran Shipped Alert'
			,	OriginalRAN = coalesce(OriginalRANQty,0)
			,	CurrentRANQty = coalesce(ReleaseQty,0)
			,	ShippedRANQty = coalesce(ORans.RanQty,0)
			,	MonitorOrderQty =  coalesce((Select sum(quantity) from order_detail where release_no = ReleaseNo),0)
			,	'Verify Correct RAN quantity remains'
		         
		from (select
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID,
						coalesce( [FT].[fn_GetOriginalRANQty](F862r.ReleaseNo, F862r.ShipToCode, F862r.customerPart),F862r.ReleaseQty) as OriginalRANQty,
						F862r.ReleaseQty ReleaseQty,
						bo.BlanketOrderNo OrderNo
						from 
							( Select * from NALEDI.Current862s()) F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID 
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is not null
						
					
				) NALEDIAlerts Left join @OrderRANs ORans on NALEDIAlerts.ReleaseNo = ORans.RanNumber
				where OriginalRANQty != ReleaseQty
		
		
	order by
		2,3,4
		
		DECLARE @tableHTMLZ  NVARCHAR(MAX) ;

SET @tableHTMLZ =
    N'<H1>NAL EDI Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>RanNo</th>' +
    N'<th>CustomerPart</th><th>ShipToCode</th><th>OriginalRANOrderQty</th><th>CurrentRANOrderQty</th><th>RANQtyShipped</th><th>MonitorOrderQty</th><th>RANQtyDiff</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.ShipToCode, '',
					 td = convert(int,eo.OriginalRANOrderQty), '',
                     td = convert(int,eo.RANOrderQty), '',
                     td = convert(int,eo.RANQtyShipped), '', 
					 td = convert(int,eo.MonitorOrderQty), '',
                     td = (convert(int,eo.OriginalRANOrderQty)-convert(int,eo.RANQtyShipped)) - convert(int,eo.RANOrderQty) , '', 
                    td = eo.notes
              FROM @EDIOrdersAlertRANs  eo
             where	[type] = 'Ran Shipped Alert'
            order by 5,3,1 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
   
  if exists (select 1 from @EDIOrdersAlertRANs where	type = 'Ran Shipped Alert')  
    begin
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'NAL RANs Shipped Alert', -- nvarchar(255)
    @body = @TableHTMLZ, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)  
  end
  --End Report Partial RANs
  
  
  
  --Report Standard Pack Dicrepancy
  
  
  Declare @EDIOrdersAlertStdPack table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ReleaseNo] [varchar](100) NULL,
	[CustomerPart] [varchar](100) NULL,
	[EmpirePart]  [varchar](25) NULL,
	[CustomerPO] [varchar](100) NULL,
	[ShipToCode] [varchar](100) NULL,
	[Type] [varchar](100) NULL,
	[RANOrderQty] [numeric](20,6) NULL,
	[EmpireStdPack] [numeric](20,6) NULL,
	[Notes] [varchar](255) NULL
	)
  
  insert	 @EDIOrdersAlertStdPack
		        (	ReleaseNo ,
					CustomerPart ,
					EmpirePart,
					CustomerPO,
					ShipToCode ,
					Type ,
					RANOrderQty ,
					EmpireStdPack,
					Notes 
		           )
		select		
				distinct
				Coalesce(ReleaseNo,'')
			,	Coalesce(NALEDIAlerts.CustomerPart,'')
			,	Coalesce(NALEDIAlerts.CustomerPart,'')
			,	Coalesce(NALEDIAlerts.CustomerPO,'')
			,	Coalesce(ShipToID,'')
			,	'Std Pack Alert'
			,	Coalesce(ReleaseQty,0)
			,	Coalesce(StdPack,0)
			, case when StdPack<0 then  'Empire to Correct Std. Pack Quantity' else 'Std. Pack / RAN Quantity Issue' end
		         
		from (select
						F862r.ReleaseNo ReleaseNo, 
						F862r.CustomerPart CustomerPart,
						bo.PartCode,
						F862r.CustomerPO CustomerPO,
						F862r.ShipToCode ShipToID,
						F862r.ReleaseQty ReleaseQty,
						bo.StdPack StdPack,
						bo.BlanketOrderNo OrderNo
						from 
							@Current862s F862c
						join	
							EDI.NAL_862_Releases F862r on F862c.RawDocumentGUID = F862r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode = F862r.ShipToCode
						and 
							bo.CustomerPart = F862r.CustomerPart
						where 
							bo.BlanketOrderNo is not null
							and ReleaseQty%StdPack <> 0
						union
					select
						F830r.ReleaseNo ReleaseNo, 
						F830r.CustomerPart CustomerPart,
						bo.PartCode,
						F830r.CustomerPO CustomerPO,
						F830r.ShipToCode ShipToID,
						F830r.ReleaseQty,
						bo.StdPack StdPack,
						bo.BlanketOrderNo OrderNo	
										 
						from 
							@Current830s F830c
						join	
							EDI.NAL_830_Releases F830r on F830c.RawDocumentGUID = F830r.RawDocumentGUID and NewDocument = 1
						left join 
							NALEDI.BlanketOrders bo	on bo.EDIShipToCode in (F830r.ICCode, F830r.ShipToCode)
						and 
							bo.CustomerPart = F830r.CustomerPart

						where 
							bo.BlanketOrderNo is not null
							and ReleaseQty%StdPack <> 0
					
				) NALEDIAlerts
		
		
	order by
		2,3,4
		
		DECLARE @tableHTMLZZ  NVARCHAR(MAX) ;

SET @tableHTMLZZ =
    N'<H1>NAL EDI Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>RanNo</th>' +
    N'<th>CustomerPart</th><th>ShipToCode</th><th>OrderQty</th><th>EmpireStdPack</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.ReleaseNo, '',
                    td = eo.CustomerPart, '',
                    td = eo.ShipToCode, '',
                     td = convert(int,eo.RANOrderQty), '',
                     td = convert(int,eo.EmpireStdPack), '', 
                    td = eo.notes
              FROM @EDIOrdersAlertStdPack  eo
             where	[type] = 'Std Pack Alert'
            order by 5,3,1 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
   
  if exists(select 1 from @EDIOrdersAlertStdPack)
  begin  
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'NAL Std Pack Alert', -- nvarchar(255)
    @body = @TableHTMLZZ, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)  
  end
 --End Report Partial RANs
  
--Email Report of RAN Audit Begin

Declare @EDIOrdersAlertRANAudit table (
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[EDIRANNumber] [varchar](50) NULL,
	[ShipToCode] varchar(50) NULL,
	[MonitorOrderNo] int NULL,
	[ActiveOrderNo] int NULL,
	[CustomerPart] [varchar](50) NULL,
	[EmpirePart]  [varchar](25) NULL,
	[EDIQty] int NULL,
	[MonitorQty] int NULL,
	[Notes] [varchar](255) NULL
	)


Select	NAL862Releases.ShipToCode as RAWEDIShipToCode,
		NAL862Releases.CustomerPart as RAWEDICustomerPart,
		ReleaseDT as RAWEDIReleaseDT,
		ReleaseQty as RAWEDIReleaseQty,
		ReleaseNo as RawEDIRAN,
		Release_no  as SalesOrderRAN,
		Coalesce(Quantity,0) as SalesOrderQuantity,
		due_date as SalesOrderDueDate,
		Order_no as SalesOrderNumber,
		BlanketOrderNo as ActiveOrderNo,
		Part_number as SalesOrderPartNumber,
		destination as SalesOrderDestination,
		RANShippedRAN,
		Coalesce(RANQtyShipped,0) as RANShippedQTY,
		NewDocument
Into #RanAudit
		 From
(SELECT	distinct 
		RawDocumentGUID,
		shipToCode CurrentShipToCode, 
		CustomerPart  CurrentCustomerPart,
		NewDocument
FROM 
	[NALEDI].[Current862s] ()) CurrentNAL862s
join
	EDI.NAL_862_Releases NAL862Releases on NAL862Releases.RawDocumentGUID = CurrentNAL862s.RawDocumentGUID and ShipToCode = CurrentShipToCode and CustomerPart = CurrentCustomerPart
left join
	order_detail od on od.release_no =  NAL862Releases.ReleaseNo and od.customer_part = CustomerPart
left join ( Select RanNumber RANShippedRAN, Sum(Qty) RANQtyShipped From NALRanNumbersShipped group by RANNumber) RANSShipped on RANShippedRAN = ReleaseNo
left Join NALEDI.BlanketOrders NALBo on order_no = BlanketOrderNo
--where NewDocument = 1

--Select * into RANaudit from #RanAudit

Insert @EDIOrdersAlertRANAudit

	(	EDIRANNumber ,
		ShipToCode,
		MonitorOrderNo ,
		ActiveOrderNo ,
		CustomerPart ,
		EmpirePart  ,
		EDIQty ,
		MonitorQty,
		Notes )

Select	RawEDIRAN,
		RawEDIShipToCode,
		SalesOrderNumber,
		coalesce(ActiveOrderNo,0),
		RAWEDICustomerPart,
		SalesOrderPartNumber,
		RAWEDIReleaseQty,
		SalesOrderQuantity,
		'Check Monitor Order RAN Quantities'
From	#RanAudit
Where (RAWEDIReleaseQty-RANShippedQty) != SalesOrderQuantity
order by RAWEDIShipToCode, RAWEDICustomerPart, RAWEDIReleaseDT
 
 
 if exists(select 1 from @EDIOrdersAlertRANAudit)
  begin  

DECLARE @tableHTMLZZZ  NVARCHAR(MAX) ;

SET @tableHTMLZZZ =
    N'<H1>NAL RAN Audit Alert</H1>' +
    N'<table border="1">' +
    N'<tr><th>RanNo</th>' +
	N'<th>ShipToCode</th><th>SalesOrderNo</th><th>ActiveOrder</th><th>CustomerPart</th>' +
    N'<th>EmpirePart</th><th>EDIRanQty</th><th>SalesOrderQty</th>' +
    N'<th>Notes</th></tr>' +
    CAST ( ( SELECT td = eo.EDIRANNumber, '',
                    td = eo.ShipToCode, '',
					td = eo.MonitorOrderNo, '',
					td = eo.ActiveOrderNo, '',
					td = eo.CustomerPart, '',
					td = eo.EmpirePart, '',
                    td = convert(int,eo.EDIQty), '',
                    td = convert(int,eo.MonitorQty), '', 
                    td = eo.notes
              FROM @EDIOrdersAlertRANAudit  eo
            order by 5,3,1 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
   
  
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = @EmailAddress, -- varchar(max)
    @copy_recipients = 'dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'NAL RAN Audit Alert', -- nvarchar(255)
    @body = @TableHTMLZZZ, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)  
  end


 
-- EMail Report of RAN Audit End
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

update
	sdhv
set	Status = 0
from
	EDI.NAL_862_Headers sdhv
where
	RawDocumentGUID = 'FDF9D8F2-0C03-4021-BECB-68995E7E19CD'
go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI.usp_Process_NAL
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
