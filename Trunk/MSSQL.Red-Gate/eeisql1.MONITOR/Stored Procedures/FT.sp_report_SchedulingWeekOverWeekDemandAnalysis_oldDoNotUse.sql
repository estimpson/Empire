SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE 	PROCEDURE [FT].[sp_report_SchedulingWeekOverWeekDemandAnalysis_oldDoNotUse]
(	@AnalysisDate DATETIME = NULL ,
	@VarianceAllowance INT = NULL)

AS

--Exec [FT].[sp_report_SchedulingWeekOverWeekDemandAnalysis]  '2016-09-20', 30
--Declare variables
DECLARE

@CurrentWeekSnapShotDT DATETIME,
@PriorWeekSnapShotDT DATETIME,
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

SELECT @PriorWeekSnapShotDT = ( SELECT MIN(GeneratedDT) FROM dbo.CustomerReleasePlans WHERE GeneratedDT >= DATEADD(DAY, -7 , @AnalysisDate))
SELECT @CurrentWeekSnapShotDT = ( SELECT MAX(GeneratedDT) FROM dbo.CustomerReleasePlans WHERE GeneratedDT <= @AnalysisDate )


SELECT @FirstPriorWeekSnapShotID =  ( SELECT min(ID)  FROM dbo.CustomerReleasePlans WHERE GeneratedDT >= ft.fn_TruncDate('week', @PriorWeekSnapShotDT) )
SELECT @FirstCurrentWeekSnapShotID =  ( SELECT min(ID)  FROM dbo.CustomerReleasePlans WHERE GeneratedDT >= ft.fn_TruncDate('week', @CurrentWeekSnapShotDT) )
SELECT @PriorWeekSnapShotID =  ( SELECT ID  FROM dbo.CustomerReleasePlans WHERE GeneratedDT = @PriorWeekSnapShotDT )
SELECT @CurrentWeekSnapShotID =  ( SELECT ID FROM dbo.CustomerReleasePlans WHERE GeneratedDT = @CurrentWeekSnapShotDT )

--Get full list of CustomerPart / ShipTos / ReleasePlanIDs for CurrentWeek and PriorWeek

Declare @DemandListA table
	(	MinReleasePlanID Int,
		MaxRelesePlanID Int,
		CustomerPart varchar(35),
		ShipTo varchar(25),
		GeneratedWeekNo Int,
		CurrentWeekNo Int,
		PriorWeekNo Int
	)

Insert @DemandListA
	(	MinReleasePlanID,
		MaxRelesePlanID,
		CustomerPart,
		ShipTo,
		GeneratedWeekNo,
		CurrentWeekNo,
		PriorWeekNo
	)
	SELECT 
	 min(crpr.ReleasePlanID) ,
	 max(crpr.ReleasePlanID),
	 oh.customer_part,
	 oh.destination,
	 crp.GeneratedWeekNo,
	 BaseDate.CurrentWeek,
	 Basedate.CurrentWeek-1
      
FROM dbo.CustomerReleasePlanRaw crpr
CROSS APPLY ( Select top 1 	DateDiff ( wk, Value, GetDate ()) CurrentWeek from	FT.DTGlobals where	Name = 'BaseWeek') BaseDate
JOIN
	dbo.order_header oh ON oh.order_no = crpr.OrderNumber
JOIN
	dbo.CustomerReleasePlans crp ON crp.ID = crpr.ReleasePlanID
	
WHERE ReleasePlanID >= @FirstPriorWeekSnapShotID and 
	  ReleasePlanID <= @CurrentWeekSnapShotID
Group BY
	 oh.customer_part,
	 oh.destination,
	 crp.GeneratedWeekNo,
	 BaseDate.CurrentWeek

--Select * From @DemandListA order by 4,3,5

Declare @DemandListB table
	(	ReleasePlanID Int,
		CustomerPart varchar(35),
		ShipTo varchar(25),
		GeneratedDate datetime
	)

Insert @DemandListB
	(	ReleasePlanID,
		CustomerPart,
		ShipTo
	)
	Select CASE WHEN GeneratedWeekNo=CurrentWeekNo THEN MaxRelesePlanID ELSE MinReleasePlanID  END, 
	Customerpart,
	ShipTo
From
	@DemandListA



Declare @DemandList table
	(	ReleasePlanID Int,
		CustomerPart varchar(35),
		ShipTo varchar(25),
		GeneratedDate datetime
	)

Insert @DemandList
	(	ReleasePlanID,
		CustomerPart,
		ShipTo,
		GeneratedDate
	)


Select 
ReleasePlanID,
CustomerPart,
ShipTo,
GenDate
From
	@DemandListB DL
outer apply ( select top 1 GeneratedDT GenDate from CustomerReleasePlans CRP where CRP.ID = DL.ReleasePlanID) GenDT


Declare @DemandListPriorWeekCurrentWeek table
	(	PriorWeekReleasePlanID Int,
		CurrentWeekReleasePlanID Int,
		CustomerPart varchar(35),
		ShipTo varchar(25),
		PriorWeekGeneratedDate datetime,
		CurrentWeekGeneratedDate datetime
	)

Insert @DemandListPriorWeekCurrentWeek
	(	PriorWeekReleasePlanID,
		CurrentWeekReleasePlanID,
		CustomerPart,
		ShipTo,
		PriorWeekGeneratedDate,
		CurrentWeekGeneratedDate
	)

Select 
min(ReleasePlanID),
max(ReleasePlanID),
CustomerPart,
ShipTo,
min(GeneratedDate),
max(GeneratedDate)
From
	@DemandList DL
Group by 
	CustomerPart,
	ShipTo
 
 Update DLPW
 Set	CurrentWeekReleasePlanID =  0,
		CurrentWeekGeneratedDate = NULL
 From @DemandListPriorWeekCurrentWeek DLPW
 Where	PriorWeekReleasePlanID = CurrentWeekReleasePlanID and
		CurrentWeekReleasePlanID < @FirstCurrentWeekSnapShotID

 Update DLPW
 Set	PriorWeekReleasePlanID =  0,
		PriorWeekGeneratedDate = NULL
 From @DemandListPriorWeekCurrentWeek DLPW
 Where	PriorWeekReleasePlanID = CurrentWeekReleasePlanID and
		CurrentWeekReleasePlanID >= @FirstCurrentWeekSnapShotID

 --Select * From @DemandListPriorWeekCurrentWeek --where CurrentWeekReleasePlanID = 0 or PriorWeekReleasePlanID = 0    order by 4,3


 Declare @ReleasePlanRaw Table
(	ReleasePlanID int,
	CustomerPart varchar(35),
	BasePart varchar(25),
	Customer varchar(35),
	ShipTo varchar(25),
	Quantity numeric(20,6),
	ShipDT datetime

	)

Insert @ReleasePlanRaw
Select	ReleasePlanID,
		oh.customer_part,
		left(oh.blanket_part, 7),
		oh.customer,
		oh.destination,
		rpr.StdQty,
		rpr.DueDT
From
	CustomerReleasePlanRaw rpr
join
	order_header oh on oh.order_no = rpr.OrderNumber
Where
	ReleasePlanID in (
	Select PriorWeekReleasePlanID from @DemandListPriorWeekCurrentWeek
	UNION
	Select CurrentWeekReleasePlanID from @DemandListPriorWeekCurrentWeek
	)

--Select * from @ReleasePlanRaw



CREATE TABLE #Releases
(	PriorWeekReleaseplanId INT,
	CurrentWeekReleaseplanId INT,
	PriorWeekReleasePlanDT DATETIME,
	CurrentWeekReleasePlanDT DATETIME,
	Customer VARCHAR(25),
	ShipTo VARCHAR(25),
	BasePart VARCHAR(25),
	CustomerPart VARCHAR(35)
)

CREATE CLUSTERED INDEX IX_1 on #Releases (ShipTo, CustomerPart, PriorWeekReleasePlanID, CurrentWeekReleasePlanID)



INSERT #Releases
        ( PriorWeekReleaseplanId ,
		  CurrentWeekReleaseplanId,
		  PriorWeekReleasePlanDT,
		  CurrentWeekReleasePlanDT,
		  Customer,
          ShipTo ,
		  BasePart,
          CustomerPart 
		        )

SELECT DISTINCT
	 Rplans.PriorWeekReleasePlanID,
	 RPlans.CurrentWeekReleasePlanID,
	 Rplans.PriorWeekGeneratedDate,
	 Rplans.CurrentWeekGeneratedDate,
	 Coalesce(PriorWeekID.Customer, CurrentWeekID.Customer),
     Coalesce(PriorWeekID.ShipTo, CurrentWeekID.ShipTo) ,
	 Coalesce(PriorWeekID.BasePart, CurrentWeekID.BasePart),
	 Coalesce(PriorWeekID.CustomerPart, CurrentWeekID.CustomerPart)

FROM   @DemandListPriorWeekCurrentWeek    Rplans

LEFT  JOIN @ReleasePlanRaw PriorWeekID ON    PriorWeekID.ReleasePlanID = Rplans.PriorWeekReleasePlanID and PriorWeekID.Customerpart = RPlans.CustomerPart and  PriorWeekID.ShipTo = RPlans.ShipTo  
LEFT  JOIN @ReleasePlanRaw CurrentWeekID ON  CurrentWeekID.ReleasePlanID = Rplans.CurrentWeekReleasePlanID and  CurrentWeekID.Customerpart = RPlans.CustomerPart and   CurrentWeekID.ShipTo = RPlans.ShipTo 


	
--WHERE ReleasePlanID IN ( @PriorWeekSnapShotID, @CurrentWeekSnapShotID)

--SELECT * FROM #Releases WHERE BasePart = 'NAL0896' ORDER BY 1,8

SELECT			@AnalysisDate AS AnalysisDT,
				PriorWeekReleaseplanId,
				CurrentWeekReleaseplanId,
				PriorWeekReleasePlanDT,
				CurrentWeekReleasePlanDT,
				Customer,
				ShipTo,
				CustomerPart,
				r1.BasePart,
				COALESCE(( SELECT SUM(qty_packed) 
					FROM Shipper_detail sd
					JOIN shipper s ON
						s.id = sd.shipper AND
                        sd.customer_part = r1.customerpart AND
                        s.destination = r1.shipto
						WHERE s.type IS NULL AND
							s.date_shipped > Coalesce(r1.PriorWeekReleasePlanDT, @PriorWeekSnapShotDT ) AND
                            s.date_shipped <= Coalesce(r1.CurrentWeekReleasePlanDT, @CurrentWeekSnapShotDT )
						),0) AS ShippedQtyBetweenSnapShots,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.PriorWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @FourWeeksDT ), 0) AS PriorWeek4WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.CurrentWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @FourWeeksDT ),0) AS CurrentWeek4WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.PriorWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @EightWeeksDT ), 0) AS PriorWeek8WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.CurrentWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @EightWeeksDT ),0) AS CurrentWeek8WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.PriorWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @TwelveWeeksDT ), 0) AS PriorWeek12WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.CurrentWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT <= @TwelveWeeksDT ),0) AS CurrentWeek12WeekDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.PriorWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT > @TwelveWeeksDT ), 0) AS PriorWeekFutureDemand,
				COALESCE(( SELECT SUM(Quantity)
					FROM @ReleasePlanRaw rr
					WHERE rr.ReleaseplanId = r1.CurrentWeekReleasePlanID AND
								 rr.CustomerPart = r1.CustomerPart AND
								 rr.ShipTo = r1.ShipTo AND
								 rr.ShipDT > @TwelveWeeksDT ),0) AS CurrentWeekFutureDemand
	INTO
		#ReleaseAnalysis1
FROM 
	#Releases r1

--Select * from #ReleaseAnalysis1
	SELECT 
		   AnalysisDT ,
		   PriorWeekReleasePlanDT AS PriorWeekSnapShotDT,
		   CurrentWeekReleasePlanDT AS CurrentWeekSnapShotDT,
           Customer ,
           ShipTo ,
		   BasePart,
           CustomerPart ,
           ShippedQtyBetweenSnapShots ,
           PriorWeek4WeekDemand ,
           ShippedQtyBetweenSnapShots + CurrentWeek4WeekDemand AS CurrentWeek4WeekDemand ,
           PriorWeek8WeekDemand ,
           ShippedQtyBetweenSnapShots+ CurrentWeek8WeekDemand AS CurrentWeek8WeekDemand ,
           PriorWeek12WeekDemand ,
           ShippedQtyBetweenSnapShots+ CurrentWeek12WeekDemand AS CurrentWeek12WeekDemand ,
           PriorWeekFutureDemand ,
           ShippedQtyBetweenSnapShots+ CurrentWeekFutureDemand AS CurrentWeekFutureDemand 
		INTO
			#ReleaseAnalysis2
	FROM
		#ReleaseAnalysis1

		TRUNCATE TABLE  FT.ReleaseAnalysisWeekOverweek
		INSERT FT.ReleaseAnalysisWeekOverweek
		SELECT 
			   ReleaseAnalysis.AnalysisDT ,
               ReleaseAnalysis.PriorWeekSnapShotDT ,
               ReleaseAnalysis.CurrentWeekSnapShotDT ,
               ReleaseAnalysis.Customer ,
               ReleaseAnalysis.ShipTo ,
			   ReleaseAnalysis.BasePart,
               ReleaseAnalysis.CustomerPart ,
               ReleaseAnalysis.ShippedQtyBetweenSnapShots ,
               ReleaseAnalysis.PriorWeek4WeekDemand ,
               ReleaseAnalysis.CurrentWeek4WeekDemand ,
			   CASE WHEN ReleaseAnalysis.CurrentWeek4WeekDemand = 0 AND ReleaseAnalysis.PriorWeek4WeekDemand > 0 THEN 1
						 WHEN ReleaseAnalysis.CurrentWeek4WeekDemand = ReleaseAnalysis.PriorWeek4WeekDemand  THEN 0
						 WHEN	ReleaseAnalysis.CurrentWeek4WeekDemand < ReleaseAnalysis.PriorWeek4WeekDemand THEN (ReleaseAnalysis.PriorWeek4WeekDemand - ReleaseAnalysis.CurrentWeek4WeekDemand ) / NULLIF(ReleaseAnalysis.PriorWeek4WeekDemand,0)
						 ELSE (ReleaseAnalysis.CurrentWeek4WeekDemand - ReleaseAnalysis.PriorWeek4WeekDemand) / NULLIF(ReleaseAnalysis.CurrentWeek4WeekDemand,0) END AS Week4Variance,
               ReleaseAnalysis.PriorWeek8WeekDemand ,
               ReleaseAnalysis.CurrentWeek8WeekDemand ,
			 	   CASE WHEN ReleaseAnalysis.CurrentWeek8WeekDemand = 0 AND ReleaseAnalysis.PriorWeek8WeekDemand > 0 THEN 1
						 WHEN ReleaseAnalysis.CurrentWeek8WeekDemand = ReleaseAnalysis.PriorWeek8WeekDemand  THEN 0
						 WHEN	ReleaseAnalysis.CurrentWeek8WeekDemand < ReleaseAnalysis.PriorWeek8WeekDemand THEN (ReleaseAnalysis.PriorWeek8WeekDemand - ReleaseAnalysis.CurrentWeek8WeekDemand ) / NULLIF(ReleaseAnalysis.PriorWeek8WeekDemand,0)
						 ELSE (ReleaseAnalysis.CurrentWeek8WeekDemand - ReleaseAnalysis.PriorWeek8WeekDemand) / NULLIF(ReleaseAnalysis.CurrentWeek8WeekDemand,0) END AS Week8Variance,
				ReleaseAnalysis.PriorWeek12WeekDemand ,
				ReleaseAnalysis.CurrentWeek12WeekDemand ,
				 CASE WHEN ReleaseAnalysis.CurrentWeek12WeekDemand = 0 AND ReleaseAnalysis.PriorWeek12WeekDemand > 0 THEN 1
						 WHEN ReleaseAnalysis.CurrentWeek12WeekDemand = ReleaseAnalysis.PriorWeek12WeekDemand  THEN 0
						 WHEN	ReleaseAnalysis.CurrentWeek12WeekDemand < ReleaseAnalysis.PriorWeek12WeekDemand THEN (ReleaseAnalysis.PriorWeek12WeekDemand - ReleaseAnalysis.CurrentWeek12WeekDemand ) / NULLIF(ReleaseAnalysis.PriorWeek12WeekDemand,0)
						 ELSE (ReleaseAnalysis.CurrentWeek12WeekDemand - ReleaseAnalysis.PriorWeek12WeekDemand) / NULLIF(ReleaseAnalysis.CurrentWeek12WeekDemand,0) END AS Week12Variance,
				ReleaseAnalysis.PriorWeekFutureDemand ,
				ReleaseAnalysis.CurrentWeekFutureDemand,
			 CASE WHEN ReleaseAnalysis.CurrentWeekFutureDemand = 0 AND ReleaseAnalysis.PriorWeekFutureDemand > 0 THEN 1
						 WHEN ReleaseAnalysis.CurrentWeekFutureDemand = ReleaseAnalysis.PriorWeekFutureDemand  THEN 0
						 WHEN	ReleaseAnalysis.CurrentWeekFutureDemand < ReleaseAnalysis.PriorWeekFutureDemand THEN (ReleaseAnalysis.PriorWeekFutureDemand - ReleaseAnalysis.CurrentWeekFutureDemand ) / NULLIF(ReleaseAnalysis.PriorWeekFutureDemand,0)
						 ELSE (ReleaseAnalysis.CurrentWeekFutureDemand - ReleaseAnalysis.PriorWeekFutureDemand) / NULLIF(ReleaseAnalysis.CurrentWeekFutureDemand,0) END AS FutureVariance

		
		FROM #ReleaseAnalysis2 ReleaseAnalysis



SELECT 
	   [AnalysisDT]
      ,[PWSSDT]
      ,[CWSSDT]
      ,[Customer]
      ,[ShipTo]
      ,[BasePart]
      ,[CustomerPart]
      ,[ShippedBtwSS]
      ,[PW4WkDmd]
      ,[CW4WkDmd]
      ,[Wk4Variance]
	  , CASE 
		WHEN [CW4WkDmd] > [PW4WkDmd] THEN 'Increase'
		WHEN [CW4WkDmd] < [PW4WkDmd] THEN 'Decrease'
		ELSE '' 
	END AS Week4
      ,[PW8WkDmd]
      ,[CW8WkDmd]
      ,[Wk8Variance]
	   , CASE 
		WHEN [CW8WkDmd] > [PW8WkDmd] THEN 'Increase'
		WHEN [CW8WkDmd] < [PW8WkDmd] THEN 'Decrease'
		ELSE '' 
	END AS Week8
      ,[PW12WkDmd]
      ,[CW12WkDmd]
      ,[Wk12Variance]
	  , CASE 
		WHEN [CW12WkDmd] > [PW12WkDmd] THEN 'Increase'
		WHEN [CW12WkDmd] < [PW12WkDmd] THEN 'Decrease'
		ELSE '' 
	END AS Week12
      ,[PWFutureDmd]
      ,[CWFutureDmd]
      ,[FutureVariance]
	  , CASE 
		WHEN [CWFutureDmd] > [PWFutureDmd] THEN 'Increase'
		WHEN [CWFutureDmd] < [PWFutureDmd] THEN 'Decrease'
		ELSE '' 
	END AS Future
  FROM [FT].[ReleaseAnalysisWeekOverweek]
  WHERE ((100*Wk4Variance) > @VarianceAllowance OR (100*Wk8Variance)> @VarianceAllowance OR (100*Wk12Variance) > @VarianceAllowance OR (100*FutureVariance) > @VarianceAllowance) and Customer != 'EEA'

  

GO
