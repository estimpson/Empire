SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE 	PROCEDURE [FT].[sp_report_SchedulingWeekOverWeekDemandAnalysis_testing]
(	@AnalysisDate DATETIME = NULL ,
	@VarianceAllowance INT = NULL)

AS
set nocount ON

Exec [dbo].[eeisp_flatten_csm]
--Exec [FT].[sp_report_SchedulingWeekOverWeekDemandAnalysis_testing]  '2017-01-11', 30
--Declare variables
DECLARE

@CurrentWeekSnapShotDT DATETIME,
@PriorWeekSnapShotDT DATETIME,
@CurrentWeekSnapWeekNo INT,
@PriorWeekSnapWeekNo INT,
@PriorWeekSnapShotID INT,
@FirstPriorWeekSnapShotID INT,
@FirstCurrentWeekSnapShotID INT,
@CurrentWeekSnapShotID INT,

@FourWeeksDT DATETIME,
@EightWeeksDT DATETIME,
@TwelveWeeksDT DATETIME



IF @AnalysisDate IS NULL
BEGIN
	SELECT @AnalysisDate = GETDATE()
END

IF @VarianceAllowance IS NULL
BEGIN
	SELECT @VarianceAllowance= 25
END

SELECT @FourWeeksDT = DATEADD(WK, 4, @AnalysisDate)
SELECT @EightWeeksDT = DATEADD(WK, 8, @AnalysisDate)
SELECT @TwelveWeeksDT = DATEADD(WK, 12, @AnalysisDate)
 
 
--Get SnapShot Dates and IDs

SELECT @PriorWeekSnapShotDT =  ( SELECT MAX(GeneratedDT) FROM dbo.CustomerReleasePlans WHERE GeneratedDT < ft.fn_TruncDate('week', @AnalysisDate)) --Gets last snapshot date prior to current week
SELECT @CurrentWeekSnapShotDT = ( SELECT MAX(GeneratedDT) FROM dbo.CustomerReleasePlans WHERE GeneratedDT <= @AnalysisDate ) -- Gets last snapshot date for current week

SELECT @PriorWeekSnapWeekNo = ( SELECT		MAX(GeneratedWeekNo) FROM dbo.CustomerReleasePlans WHERE GeneratedDT = @PriorWeekSnapShotDT)
SELECT @CurrentWeekSnapWeekNo = ( SELECT	MAX(GeneratedWeekNo) FROM dbo.CustomerReleasePlans WHERE GeneratedDT > coalesce(@PriorWeekSnapShotDT,ft.fn_TruncDate('week', @AnalysisDate)) and GeneratedDT <= @CurrentWeekSnapShotDT)

SELECT @FirstPriorWeekSnapShotID =  ( SELECT min(ID)  FROM dbo.CustomerReleasePlans WHERE GeneratedDT >= ft.fn_TruncDate('week', @PriorWeekSnapShotDT) and GeneratedDT< ft.fn_TruncDate('week', @CurrentWeekSnapShotDT) )
SELECT @FirstCurrentWeekSnapShotID =  ( SELECT min(ID)  FROM dbo.CustomerReleasePlans WHERE GeneratedDT >= ft.fn_TruncDate('week', @CurrentWeekSnapShotDT) )
SELECT @PriorWeekSnapShotID =  ( SELECT ID  FROM dbo.CustomerReleasePlans WHERE GeneratedDT = @PriorWeekSnapShotDT )
SELECT @CurrentWeekSnapShotID =  ( SELECT ID FROM dbo.CustomerReleasePlans WHERE GeneratedDT = @CurrentWeekSnapShotDT )

--Get full list of CustomerPart / ShipTos  for CurrentWeek and PriorWeek
Declare @ReleaseSnapShotList table

	(	ReleasePlanID int,
		ReleasePlanIDForCompare int,
		AnalysisDate datetime,
		GeneratedDT datetime,
		GeneratedWeekNo int,
		GeneratedWeekDay int,
		PreferredSchedDate int,
		BasePart varchar(25),
		Part varchar(25),
		Destination varchar(25),
		SalesOrderNo varchar(25)
	)
Insert @ReleaseSnapShotList
Select	Distinct
		ReleasePlanID,
		NULL,
		@AnalysisDate,
		crp.GeneratedDT,
		crp.GeneratedWeekNo,
		crp.GeneratedWeekDay,
		case when parms.days_to_process = GeneratedWeekDay THEN 1 ELSE 0 end,
		BasePart,
		crpr.part,
		Coalesce(( Select max(destination) from order_header where order_no  = crpr.OrderNumber ), ( Select max(s.destination) from shipper s join shipper_detail sd on sd.shipper = s.id and sd.order_no = crpr.orderNumber), 'NoCurrentSalesOrderExists'),
		crpr.OrderNumber
		
From 
	CustomerReleasePlans crp
Join
	CustomerReleasePlanRaw crpr on crpr.ReleasePlanID = crp.ID	
cross join
	[parameters] parms
Where 
	crp.GeneratedWeekNo in ( @PriorWeekSnapWeekNo, @CurrentWeekSnapWeekNo)


--Select * from @ReleaseSnapShotList order by 7,3

delete A
From @ReleaseSnapShotList A
where exists ( select 1 from @ReleaseSnapShotList B where B.GeneratedWeekNo = a.GeneratedWeekNo and b.Basepart = a.BasePart and b.destination = a.Destination and b.PreferredSchedDate = 1)
and a.PreferredSchedDate != 1 

Update A
Set a.ReleasePlanIDForCompare = ReleasePlanID
From @ReleaseSnapShotList A
Where PreferredSchedDate =  1

Update A
Set a.ReleasePlanIDForCompare = ( select top 1 c.ReleasePlanID from @ReleaseSnapShotList C where c.ReleasePlanIDForCompare is NULL and c.GeneratedWeekNo = a.GeneratedWeekNo and c.BasePart = a.BasePart and c.Destination = a.Destination order by GeneratedWeekDay ASC)
From @ReleaseSnapShotList A
Where PreferredSchedDate !=  1 and
		a.ReleasePlanIDForCompare is NULL

--Select * from @ReleaseSnapShotList order by 7,3

delete @ReleaseSnapShotList where ReleasePlanID != ReleasePlanIDForCompare

--Select * from @ReleaseSnapShotList order by 7,3

SELECT @PriorWeekSnapWeekNo = ( SELECT		MIN(GeneratedWeekNo) FROM @ReleaseSnapShotList)
SELECT @CurrentWeekSnapWeekNo = ( SELECT	MAX(GeneratedWeekNo) FROM @ReleaseSnapShotList )

create  Table #ReleasePlanRaw
(	ReleasePlanID int,
	OrderNumber int,
	BasePart varchar(25),
	Part varchar(25),
	Quantity numeric(20,6),
	ShipDT datetime
)

CREATE UNIQUE CLUSTERED INDEX IX_1 on #ReleasePlanRaw (ReleasePlanID, OrderNumber, Basepart, ShipDT)

Insert #ReleasePlanRaw
Select	ReleasePlanID,
		OrderNumber,
		BasePart,
		part,
		sum(StdQty),
		crpr.DueDT
From 
	CustomerReleasePlanRaw crpr
	Where crpr.ReleasePlanID in ( select distinct ReleasePlanID from @ReleaseSnapShotList )
Group by
	ReleasePlanID,
	OrderNumber,
	BasePart,
	part,
	DueDT

	--Select * from #ReleasePlanRaw

create table #DemandSnapShot 
(	AnalysisDT datetime,
	ReleasePlanID int,
	GeneratedweekNo int,
	basepart varchar(25),
	part varchar(25),
	Destination varchar(25),
	SalesOrderNo int,
	QtyShippedBetweenSnapShots int,
	Week4Date datetime,
	Week4Qty int,
	Week8Date datetime,
	Week8Qty int,
	Week12Date datetime,
	Week12Qty int,
	TotalQty int
)

CREATE UNIQUE CLUSTERED INDEX IX_2 on #DemandSnapShot (ReleasePlanID, GeneratedweekNo, Basepart, SalesOrderno)

Insert #DemandSnapShot
Select @AnalysisDate,
		ReleasePlanID,
		GeneratedWeekNo,
		rsl.BasePart,
		rsl.part,
		rsl.Destination,
		rsl.SalesOrderNo,
		NULL,
		DATEADD(week, 4 , @AnalysisDate),
		coalesce((Select sum(Quantity) from #ReleasePlanRaw rpr where rpr.ReleasePlanID = rsl.releaseplanID and rpr.OrderNumber = rsl.SalesOrderNo and rpr.ShipDT<= DATEADD(week, 4 , @AnalysisDate) ),0),
		DATEADD(week, 8 , @AnalysisDate),
		coalesce((Select sum(Quantity) from #ReleasePlanRaw rpr where rpr.ReleasePlanID = rsl.releaseplanID and rpr.OrderNumber = rsl.SalesOrderNo and rpr.ShipDT <= DATEADD(week, 8 , @AnalysisDate) ),0),
		DATEADD(week, 12 , @AnalysisDate),
		coalesce((Select sum(Quantity) from #ReleasePlanRaw rpr where rpr.ReleasePlanID = rsl.releaseplanID and rpr.OrderNumber = rsl.SalesOrderNo and rpr.ShipDT <= DATEADD(week, 12 , @AnalysisDate) ),0),
		coalesce((Select sum(Quantity) from #ReleasePlanRaw rpr where rpr.ReleasePlanID = rsl.releaseplanID and rpr.OrderNumber = rsl.SalesOrderNo   ),0)

From 
	@ReleaseSnapShotList rsl

--Select * From #DemandSnapShot order by 4,2


Create table #DemandSnapShotFlat 

(	AnalysisDT datetime,
	Basepart varchar(25),
	part varchar(25),
	Destination varchar(25),
	SalesOrderNo int,
	QtyShippedBetweenSnapShots int,
	PriorWeekReleasePlanID int,
	PriorWeekSnapShotDate datetime,
	PriorWeekSnapShotDay varchar(25),
	AnalysisWeekReleasePlanID int,
	AnalysisWeekSnapShotDate datetime,
	AnalysisWeekSnapShotDay varchar(25),
	Week4Date datetime,
	Week4QtyPriorWeek numeric(20,6),
	Week4QtyAnalysisWeek numeric(20,6),
	Week8Date datetime,
	Week8QtyPriorWeek numeric(20,6),
	Week8QtyAnalysisWeek numeric(20,6),
	Week12Date datetime,
	Week12QtyPriorWeek numeric(20,6),
	Week12QtyAnalysisWeek numeric(20,6),
	TotalQtyPriorWeek numeric(20,6),
	TotalQtyAnalysisWeek numeric(20,6)
)


Insert #DemandSnapShotFlat

(	AnalysisDT,
	Basepart,
	part,
	destination,
	SalesOrderNo

	)

Select  AnalysisDT,
		BasePart,
		part,
		Destination,
		SalesOrderNo

From #DemandSnapShot
group by 
		AnalysisDT,
		BasePart,
		part,
		destination,
		SalesOrderNo

update f
Set f.PriorWeekReleasePlanID = coalesce(( Select dss.releasePlanID From #DemandSnapShot dss where dss.SalesOrderNo =  f.salesorderno and dss.basepart = f.basePart and dss.Destination = f.destination and dss.GeneratedweekNo = @PriorWeekSnapWeekNo ),0),
    f.AnalysisWeekReleasePlanID = coalesce(( Select dss.releaseplanID From #DemandSnapShot dss where dss.SalesOrderNo =  f.salesorderno and dss.basepart = f.basePart and dss.Destination = f.destination and dss.GeneratedweekNo = @CurrentWeekSnapWeekNo ),0)
From	#DemandSnapShotFlat f



update f
Set  Week4Date = ( Select min(Week4Date) from #DemandSnapShot ),
	 Week4QtyPriorWeek = coalesce(( Select sum(week4Qty) from #DemandSnapShot dss where dss.ReleasePlanID = PriorWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 Week4QtyAnalysisWeek = coalesce(( Select sum(week4Qty) from #DemandSnapShot dss where dss.ReleasePlanID = AnalysisWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 Week8QtyPriorWeek = coalesce(( Select sum(week8Qty) from #DemandSnapShot dss where dss.ReleasePlanID = PriorWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 Week8QtyAnalysisWeek = coalesce(( Select sum(week8Qty) from #DemandSnapShot dss where dss.ReleasePlanID = AnalysisWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 Week12QtyPriorWeek = coalesce(( Select sum(week12Qty) from #DemandSnapShot dss where dss.ReleasePlanID = PriorWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 Week12QtyAnalysisWeek = coalesce(( Select sum(week12Qty) from #DemandSnapShot dss where dss.ReleasePlanID = AnalysisWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 TotalQtyPriorWeek = coalesce(( Select sum(TotalQty) from #DemandSnapShot dss where dss.ReleasePlanID = PriorWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 
	 TotalQtyAnalysisWeek = coalesce(( Select sum(TotalQty) from #DemandSnapShot dss where dss.ReleasePlanID = AnalysisWeekReleasePlanID and dss.SalesOrderNo = f.SalesOrderNo  ),0), 	 
	 Week8Date = ( Select min(Week8Date) from #DemandSnapShot ),	
	 Week12Date = ( Select min(Week12Date) from #DemandSnapShot ),
	 PriorWeekSnapShotDate = ( Select max(GeneratedDT) from  @ReleaseSnapShotList rssl where rssl.ReleasePlanID = f.PriorWeekReleasePlanID ),
	 AnalysisWeekSnapShotDate = ( Select max(GeneratedDT) from  @ReleaseSnapShotList rssl where rssl.ReleasePlanID = f.AnalysisWeekReleasePlanID )

	
	
From	#DemandSnapShotFlat f

Update f
set 
	f.QtyShippedBetweenSnapShots = coalesce(( Select sum(qty_packed) from shipper_detail sd where sd.order_no = f.SalesOrderNo and sd.date_shipped>= coalesce(f.PriorWeekSnapShotDate,dateadd(wk,-1, @analysisDate ))  and sd.date_shipped< coalesce(f.AnalysisWeekSnapShotDate,dateadd(wk,0, @analysisDate )) ),0),
	 PriorWeekSnapShotDay = (CASE WHEN datepart(day,PriorWeekSnapShotDate) = 2 THEN 'Monday' 
											WHEN datepart(dw,PriorWeekSnapShotDate) = 3 THEN 'Tuesday'
											WHEN datepart(dw,PriorWeekSnapShotDate) = 4 THEN 'Wednesday'
											WHEN datepart(dw,PriorWeekSnapShotDate) = 5 THEN 'Thursday'
											WHEN datepart(dw,PriorWeekSnapShotDate) = 6 THEN 'Friday'
											WHEN datepart(dw,PriorWeekSnapShotDate) = 7 THEN 'Saturday'
											WHEN datepart(dw,PriorWeekSnapShotDate) = 1 THEN 'Sunday'
											ELSE 'NoSnapShot' END ),
	 AnalysisWeekSnapShotDay = (CASE WHEN datepart(dw,AnalysisWeekSnapShotDate) = 2 THEN 'Monday' 
											WHEN datepart(DW,AnalysisWeekSnapShotDate) = 3 THEN 'Tuesday'
											WHEN datepart(dw,AnalysisWeekSnapShotDate) = 4 THEN 'Wednesday'
											WHEN datepart(dw,AnalysisWeekSnapShotDate) = 5 THEN 'Thursday'
											WHEN datepart(dw,AnalysisWeekSnapShotDate) = 6 THEN 'Friday'
											WHEN datepart(dw,AnalysisWeekSnapShotDate) = 7 THEN 'Saturday'
											WHEN datepart(dw,AnalysisWeekSnapShotDate) = 1 THEN 'Sunday'
											ELSE 'NoSnapshot' END )
	
From
	#DemandSnapShotFlat f

--Select * from #DemandSnapShotFlat order by 2,10

Update f
set 
	Week4QtyAnalysisWeek = Week4QtyAnalysisWeek+QtyShippedBetweenSnapShots,
	Week8QtyAnalysisWeek = Week8QtyAnalysisWeek+QtyShippedBetweenSnapShots,
	Week12QtyAnalysisWeek = Week12QtyAnalysisWeek+QtyShippedBetweenSnapShots,
	TotalQtyAnalysisWeek = TotalQtyAnalysisWeek+QtyShippedBetweenSnapShots
From
	#DemandSnapShotFlat f

--select * from #DemandSnapShotFlat

		TRUNCATE TABLE   Ft.CustomerDemandAnalysisWeekOverWeek
		INSERT into Ft.CustomerDemandAnalysisWeekOverWeek
		SELECT 
			   ReleaseAnalysis.AnalysisDT ,
               ReleaseAnalysis.PriorWeekSnapShotDate ,
               ReleaseAnalysis.AnalysisWeekSnapShotDate ,
               LEFT(ReleaseAnalysis.basePart,3) as Customer ,
               ReleaseAnalysis.Destination ,
			   ReleaseAnalysis.BasePart,
			   releaseAnalysis.part,
               ReleaseAnalysis.QtyShippedBetweenSnapShots ,
			   ReleaseAnalysis.PriorWeekSnapShotDay,
			   ReleaseAnalysis.AnalysisWeekSnapShotDay,
               ReleaseAnalysis.Week4QtyPriorWeek ,
               ReleaseAnalysis.Week4QtyAnalysisWeek ,
			   convert( numeric(20,6), CASE WHEN ReleaseAnalysis.Week4QtyAnalysisWeek = 0.00000 AND ReleaseAnalysis.Week4QtyPriorWeek > 0.000000 THEN -1.00000
						WHEN ReleaseAnalysis.Week4QtyAnalysisWeek > 0.000000 AND ReleaseAnalysis.Week4QtyPriorWeek = 0.000000 THEN 1.00000
						 WHEN ReleaseAnalysis.Week4QtyAnalysisWeek = ReleaseAnalysis.Week4QtyPriorWeek  THEN 0.000000
						 ELSE (ReleaseAnalysis.Week4QtyAnalysisWeek - ReleaseAnalysis.Week4QtyPriorWeek) / NULLIF(ReleaseAnalysis.Week4QtyPriorWeek,0.000000) END ) AS Week4Variance,
               ReleaseAnalysis.Week8QtyPriorWeek ,
               ReleaseAnalysis.Week8QtyAnalysisWeek ,
			 	    convert( numeric(20,6), CASE WHEN ReleaseAnalysis.Week8QtyAnalysisWeek = 0 AND ReleaseAnalysis.Week8QtyPriorWeek > 0 THEN -1
						WHEN ReleaseAnalysis.Week8QtyAnalysisWeek > 0 AND ReleaseAnalysis.Week8QtyPriorWeek = 0 THEN 1
						 WHEN ReleaseAnalysis.Week8QtyAnalysisWeek = ReleaseAnalysis.Week8QtyPriorWeek  THEN 0
						 ELSE (ReleaseAnalysis.Week8QtyAnalysisWeek - ReleaseAnalysis.Week8QtyPriorWeek) / NULLIF(ReleaseAnalysis.Week8QtyPriorWeek,0) END ) AS Week8Variance,
				ReleaseAnalysis.Week12QtyPriorWeek ,
				ReleaseAnalysis.Week12QtyAnalysisWeek ,
				  convert( numeric(20,6), CASE WHEN ReleaseAnalysis.Week12QtyAnalysisWeek = 0 AND ReleaseAnalysis.Week12QtyPriorWeek > 0 THEN -1
						WHEN ReleaseAnalysis.Week12QtyAnalysisWeek > 0 AND ReleaseAnalysis.Week12QtyPriorWeek = 0 THEN 1
						 WHEN ReleaseAnalysis.Week12QtyAnalysisWeek = ReleaseAnalysis.Week12QtyPriorWeek  THEN 0
						 ELSE (ReleaseAnalysis.Week12QtyAnalysisWeek - ReleaseAnalysis.Week12QtyPriorWeek) / NULLIF(ReleaseAnalysis.Week12QtyPriorWeek,0) END ) AS Week12Variance,
				ReleaseAnalysis.TotalQtyPriorWeek ,
				ReleaseAnalysis.TotalQtyAnalysisWeek,
			       convert( numeric(20,6),CASE WHEN ReleaseAnalysis.TotalQtyAnalysisWeek = 0 AND ReleaseAnalysis.TotalQtyPriorWeek > 0 THEN -1
						WHEN ReleaseAnalysis.TotalQtyAnalysisWeek > 0 AND ReleaseAnalysis.TotalQtyPriorWeek = 0 THEN 1
						 WHEN ReleaseAnalysis.TotalQtyAnalysisWeek = ReleaseAnalysis.TotalQtyPriorWeek  THEN 0
						 ELSE (ReleaseAnalysis.TotalQtyAnalysisWeek - ReleaseAnalysis.TotalQtyPriorWeek) / NULLIF(ReleaseAnalysis.TotalQtyPriorWeek,0) END ) AS FutureVariance
		
		
		FROM #DemandSnapShotFlat ReleaseAnalysis
		left Join	
			order_header oh on oh.order_no = ReleaseAnalysis.SalesOrderNo
		where isNULL(oh.customer,'X') != 'EEA'
 SELECT [AnalysisDT]
      ,[PriorWeekSnapShotDate]
      ,[AnalysisWeekSnapShotDate]
      ,[Customer]
      ,[Destination]
      ,wow.[BasePart]
	  ,wow.part
	  ,ProductLine	  
      ,[QtyShippedBetweenSnapShots]
      ,[PriorWeekSnapShotDay]
      ,[AnalysisWeekSnapShotDay]
      ,[Week4QtyPriorWeek]
      ,[Week4QtyAnalysisWeek]
	  , [Week4QtyAnalysisWeek]-[Week4QtyPriorWeek] as Week4QtyDifference
      ,[Week4Variance]
	  , abs([Week4Variance]) as Week4AbsVariance
      ,[Week8QtyPriorWeek]
      ,[Week8QtyAnalysisWeek]
	  , [Week8QtyAnalysisWeek]-[Week8QtyPriorWeek] as Week8QtyDifference
      ,[Week8Variance]
	  , abs([Week8Variance]) as Week8AbsVariance
      ,[Week12QtyPriorWeek]
      ,[Week12QtyAnalysisWeek]
	  , [Week12QtyAnalysisWeek]-[Week12QtyPriorWeek] as Week12QtyDifference
      ,[Week12Variance]
	  , abs([Week12Variance]) as Week12AbsVariance
      ,[TotalQtyPriorWeek]
      ,[TotalQtyAnalysisWeek]
	  , [totalQtyAnalysisWeek]-[totalQtyPriorWeek] as TotalQtyDifference
      ,[FutureVariance]
	  , abs([FutureVariance]) as FutureAbsVariance
	   ,HIS.*
	     
,Week4QtyPriorWeekGrpOrder as Wk4GrpOrderPW
		 ,Week4QtyAnalysisWeekGrpOrder as Wk4GrpOrderAW
		 ,Week8QtyPriorWeekGrpOrder as Wk8GrpOrderPW
		 ,Week8QtyAnalysisWeekGrpOrder as Wk8GrpOrderAW
		 ,Week12QtyPriorWeekGrpOrder as Wk12GrpOrderPW
		 ,Week12QtyAnalysisWeekGrpOrder as Wk12GrpOrderAW
		, totalQtyPriorWeekGrpOrder as TtlGrpOrderPW
		, TotalQtyAnalysisWeekGrpOrder as TtlGrpOrderAW
			,abs(Week4QtyAnalysisWeekGrpOrder-Week4QtyPriorWeekGrpOrder) as Week4GrpOrderDiff
			, CASE	when (Week4QtyAnalysisWeekGrpOrder-Week4QtyPriorWeekGrpOrder)>0 Then 'Increase'
					when (Week4QtyAnalysisWeekGrpOrder-Week4QtyPriorWeekGrpOrder)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week4GrpOrderChng
			,ABS(convert( numeric(20,6), CASE WHEN Week4QtyAnalysisWeekGrpOrder = 0.00000 AND Week4QtyPriorWeekGrpOrder > 0.000000 THEN -1.00000
						WHEN Week4QtyAnalysisWeekGrpOrder > 0.000000 AND Week4QtyPriorWeekGrpOrder = 0.000000 THEN 1.00000
						 WHEN Week4QtyAnalysisWeekGrpOrder  = Week4QtyPriorWeekGrpOrder  THEN 0.000000
						 ELSE ( Week4QtyAnalysisWeekGrpOrder - Week4QtyPriorWeekGrpOrder) / NULLIF(Week4QtyPriorWeekGrpOrder,0.000000) END )) AS Week4GrpOrderVariance
			,abs(Week8QtyAnalysisWeekGrpOrder-Week8QtyPriorWeekGrpOrder) as Week8GrpOrderDiff
			, CASE	when (Week8QtyAnalysisWeekGrpOrder-Week8QtyPriorWeekGrpOrder)>0 Then 'Increase'
					when (Week8QtyAnalysisWeekGrpOrder-Week8QtyPriorWeekGrpOrder)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week8GrpOrderChng
			,ABS(convert( numeric(20,6), CASE WHEN Week8QtyAnalysisWeekGrpOrder = 0.00000 AND Week8QtyPriorWeekGrpOrder > 0.000000 THEN -1.00000
						WHEN Week8QtyAnalysisWeekGrpOrder > 0.000000 AND Week8QtyPriorWeekGrpOrder = 0.000000 THEN 1.00000
						 WHEN Week8QtyAnalysisWeekGrpOrder  = Week8QtyPriorWeekGrpOrder  THEN 0.000000
						 ELSE ( Week8QtyAnalysisWeekGrpOrder - Week8QtyPriorWeekGrpOrder) / NULLIF(Week8QtyPriorWeekGrpOrder,0.000000) END )) AS Week8GrpOrderVariance
			,abs(Week12QtyAnalysisWeekGrpOrder-Week12QtyPriorWeekGrpOrder) as Week12GrpOrderDiff
			, CASE	when (Week12QtyAnalysisWeekGrpOrder-Week12QtyPriorWeekGrpOrder)>0 Then 'Increase'
					when (Week12QtyAnalysisWeekGrpOrder-Week12QtyPriorWeekGrpOrder)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week12GrpOrderChng
			,ABS(convert( numeric(20,6), CASE WHEN Week12QtyAnalysisWeekGrpOrder = 0.00000 AND Week12QtyPriorWeekGrpOrder > 0.000000 THEN -1.00000
						WHEN Week12QtyAnalysisWeekGrpOrder > 0.000000 AND Week12QtyPriorWeekGrpOrder = 0.000000 THEN 1.00000
						 WHEN Week12QtyAnalysisWeekGrpOrder  = Week12QtyPriorWeekGrpOrder  THEN 0.000000
						 ELSE ( Week12QtyAnalysisWeekGrpOrder - Week12QtyPriorWeekGrpOrder) / NULLIF(Week12QtyPriorWeekGrpOrder,0.000000) END )) AS Week12GrpOrderVariance
			,abs(TotalQtyAnalysisWeekGrpOrder-totalQtyPriorWeekGrpOrder) as TotalGrpOrderDiff
			, CASE	when (TotalQtyAnalysisWeekGrpOrder-TotalQtyPriorWeekGrpOrder)>0 Then 'Increase'
					when (TotalQtyAnalysisWeekGrpOrder-TotalQtyPriorWeekGrpOrder)<0 Then 'Decrease'
					else 'NoChange'
					End  as TotalGrpOrderChng			
			,ABS(convert( numeric(20,6), CASE WHEN TotalQtyAnalysisWeekGrpOrder = 0.00000 AND TotalQtyPriorWeekGrpOrder > 0.000000 THEN -1.00000
						WHEN TotalQtyAnalysisWeekGrpOrder > 0.000000 AND TotalQtyPriorWeekGrpOrder = 0.000000 THEN 1.00000
						 WHEN TotalQtyAnalysisWeekGrpOrder  = TotalQtyPriorWeekGrpOrder  THEN 0.000000
						 ELSE ( TotalQtyAnalysisWeekGrpOrder - TotalQtyPriorWeekGrpOrder) / NULLIF(TotalQtyPriorWeekGrpOrder,0.000000) END )) AS TotalGrpOrderVariance

		,Week4QtyPriorWeekGrpBP as Wk4GrpBPPW
		 ,Week4QtyAnalysisWeekGrpBP as Wk4GrpBPAW
		 ,Week8QtyPriorWeekGrpBP as Wk8GrpBPPW
		 ,Week8QtyAnalysisWeekGrpBP as Wk8GrpBPAW
		 ,Week12QtyPriorWeekGrpBP as Wk12GrpBPPW
		 ,Week12QtyAnalysisWeekGrpBP as Wk12GrpBPAW
		, totalQtyPriorWeekGrpBP as TtlGrpBPPW
		, TotalQtyAnalysisWeekGrpBP as TtlGrpBPAW
			,abs(Week4QtyAnalysisWeekGrpBP-Week4QtyPriorWeekGrpBP) as Week4GrpBPDiff
			, CASE	when (Week4QtyAnalysisWeekGrpBP-Week4QtyPriorWeekGrpBP)>0 Then 'Increase'
					when (Week4QtyAnalysisWeekGrpBP-Week4QtyPriorWeekGrpBP)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week4GrpBPChng
			,ABS(convert( numeric(20,6), CASE WHEN Week4QtyAnalysisWeekGrpBP = 0.00000 AND Week4QtyPriorWeekGrpBP > 0.000000 THEN -1.00000
						WHEN Week4QtyAnalysisWeekGrpBP > 0.000000 AND Week4QtyPriorWeekGrpBP = 0.000000 THEN 1.00000
						 WHEN Week4QtyAnalysisWeekGrpBP  = Week4QtyPriorWeekGrpBP  THEN 0.000000
						 ELSE ( Week4QtyAnalysisWeekGrpBP - Week4QtyPriorWeekGrpBP) / NULLIF(Week4QtyPriorWeekGrpBP,0.000000) END )) AS Week4GrpBPVariance
			,abs(Week8QtyAnalysisWeekGrpBP-Week8QtyPriorWeekGrpBP) as Week8GrpBPDiff
			, CASE	when (Week8QtyAnalysisWeekGrpBP-Week8QtyPriorWeekGrpBP)>0 Then 'Increase'
					when (Week8QtyAnalysisWeekGrpBP-Week8QtyPriorWeekGrpBP)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week8GrpBPChng
			,ABS(convert( numeric(20,6), CASE WHEN Week8QtyAnalysisWeekGrpBP = 0.00000 AND Week8QtyPriorWeekGrpBP > 0.000000 THEN -1.00000
						WHEN Week8QtyAnalysisWeekGrpBP > 0.000000 AND Week8QtyPriorWeekGrpBP = 0.000000 THEN 1.00000
						 WHEN Week8QtyAnalysisWeekGrpBP  = Week8QtyPriorWeekGrpBP  THEN 0.000000
						 ELSE ( Week8QtyAnalysisWeekGrpBP - Week8QtyPriorWeekGrpBP) / NULLIF(Week8QtyPriorWeekGrpBP,0.000000) END )) AS Week8GrpBPVariance
			,abs(Week12QtyAnalysisWeekGrpBP-Week12QtyPriorWeekGrpBP) as Week12GrpBPDiff
			, CASE	when (Week12QtyAnalysisWeekGrpBP-Week12QtyPriorWeekGrpBP)>0 Then 'Increase'
					when (Week12QtyAnalysisWeekGrpBP-Week12QtyPriorWeekGrpBP)<0 Then 'Decrease'
					else 'NoChange'
					End  as Week12GrpBPChng
			,ABS(convert( numeric(20,6), CASE WHEN Week12QtyAnalysisWeekGrpBP = 0.00000 AND Week12QtyPriorWeekGrpBP > 0.000000 THEN -1.00000
						WHEN Week12QtyAnalysisWeekGrpBP > 0.000000 AND Week12QtyPriorWeekGrpBP = 0.000000 THEN 1.00000
						 WHEN Week12QtyAnalysisWeekGrpBP  = Week12QtyPriorWeekGrpBP  THEN 0.000000
						 ELSE ( Week12QtyAnalysisWeekGrpBP - Week12QtyPriorWeekGrpBP) / NULLIF(Week12QtyPriorWeekGrpBP,0.000000) END )) AS Week12GrpBPVariance
			,abs(TotalQtyAnalysisWeekGrpBP-totalQtyPriorWeekGrpBP) as TotalGrpBPDiff
			, CASE	when (TotalQtyAnalysisWeekGrpBP-TotalQtyPriorWeekGrpBP)>0 Then 'Increase'
					when (TotalQtyAnalysisWeekGrpBP-TotalQtyPriorWeekGrpBP)<0 Then 'Decrease'
					else 'NoChange'
					End  as TotalGrpBPChng			
			,ABS(convert( numeric(20,6), CASE WHEN TotalQtyAnalysisWeekGrpBP = 0.00000 AND TotalQtyPriorWeekGrpBP > 0.000000 THEN -1.00000
						WHEN TotalQtyAnalysisWeekGrpBP > 0.000000 AND TotalQtyPriorWeekGrpBP = 0.000000 THEN 1.00000
						 WHEN TotalQtyAnalysisWeekGrpBP  = TotalQtyPriorWeekGrpBP  THEN 0.000000
						 ELSE ( TotalQtyAnalysisWeekGrpBP - TotalQtyPriorWeekGrpBP) / NULLIF(TotalQtyPriorWeekGrpBP,0.000000) END )) AS TotalGrpBPVariance
  FROM [FT].[CustomerDemandAnalysisWeekOverWeek] wow
  outer apply ( select top 1 product_line ProductLine from part where part.part= wow.part ) part
  outer apply ( Select top 1 * from FlatCSM where FlatCSM.basepart = wow.basepart ) HIS
  outer apply ( Select	Sum(week4QtyPriorWeek) Week4QtyPriorWeekGrpOrder,  
						Sum(week4QtyAnalysisWeek) Week4QtyAnalysisWeekGrpOrder,
						Sum(week8QtyPriorWeek) Week8QtyPriorWeekGrpOrder,  
						Sum(week8QtyAnalysisWeek) Week8QtyAnalysisWeekGrpOrder,
						Sum(week12QtyPriorWeek) Week12QtyPriorWeekGrpOrder,  
						Sum(week12QtyAnalysisWeek) Week12QtyAnalysisWeekGrpOrder,
						Sum(TotalQtyPriorWeek) TotalQtyPriorWeekGrpOrder,  
						Sum(TotalQtyAnalysisWeek) TotalQtyAnalysisWeekGrpOrder 
						from [FT].[CustomerDemandAnalysisWeekOverWeek] wowgrpO where wowgrpO.basepart = wow.basepart and  wowgrpO.destination = wow.destination ) GroupedByOrder

	 outer apply ( Select	Sum(week4QtyPriorWeek) Week4QtyPriorWeekGrpBP,  
						Sum(week4QtyAnalysisWeek) Week4QtyAnalysisWeekGrpBP,
						Sum(week8QtyPriorWeek) Week8QtyPriorWeekGrpBP,  
						Sum(week8QtyAnalysisWeek) Week8QtyAnalysisWeekGrpBP,
						Sum(week12QtyPriorWeek) Week12QtyPriorWeekGrpBP,  
						Sum(week12QtyAnalysisWeek) Week12QtyAnalysisWeekGrpBP,
						Sum(TotalQtyPriorWeek) TotalQtyPriorWeekGrpBP,  
						Sum(TotalQtyAnalysisWeek) TotalQtyAnalysisWeekGrpBP 
						from [FT].[CustomerDemandAnalysisWeekOverWeek] wowgrpO where wowgrpO.basepart = wow.basepart  ) GroupedByBasePart

 WHERE ((100*abs(week4variance)) > @VarianceAllowance OR (100*abs(week8variance))> @VarianceAllowance OR (100*abs(week12variance)) > @VarianceAllowance OR (100*abs(FutureVariance)) > @VarianceAllowance) 

 order by 6,3
  





GO
