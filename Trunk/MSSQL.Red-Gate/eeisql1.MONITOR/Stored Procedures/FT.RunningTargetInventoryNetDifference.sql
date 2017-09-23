SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [FT].[RunningTargetInventoryNetDifference]
AS 
    BEGIN TRAN

    IF OBJECT_ID('dbo.RunningInventory') IS NOT NULL 
        DROP TABLE dbo.RunningInventory

    SET NOCOUNT ON

    CREATE TABLE #OnPO
        (
          WeekNo INT ,
          WeekDate datetime,
          Part VARCHAR(25) ,
          Qty NUMERIC(20, 6) ,
          Cost NUMERIC(20,6)
          PRIMARY KEY NONCLUSTERED ( WeekNo, Part )
        )

    INSERT  #OnPO
            SELECT  WeekNo = DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dateadd(dd,(COALESCE(backdays,0))*-1,date_due))) ,
					WeekDate =  ft.fn_TruncDate('wk',dateadd(dd,(COALESCE(backdays,0))*-1,date_due)),
					Part = COALESCE((select min(parent_part) from bill_of_material where dbo.bill_of_material.part =part_number), part_number) ,
                    Qty = SUM(balance),
                    Cost = SUM(balance*material_cum)
            FROM    dbo.po_detail
            JOIN	dbo.part_standard ON po_detail.part_number = part
            join		dbo.part_eecustom on dbo.part_standard.part = part_eecustom.part
            WHERE   
					vendor_code = 'EEH'
                    AND balance > 0 
            GROUP BY 
					DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dateadd(dd,(COALESCE(backdays,0))*-1,date_due))) ,
					 ft.fn_TruncDate('wk',dateadd(dd,(COALESCE(backdays,0))*-1,date_due)),
					 part_number

    CREATE TABLE #Inventory
        (
          Part VARCHAR(25) PRIMARY KEY NONCLUSTERED ,
          Qty NUMERIC(20, 6),
          Cost NUMERIC(20,6)
        )

    INSERT  #Inventory
            SELECT  Part = o.part ,
                    Qty = SUM(std_quantity),
                    Cost = SUM(std_quantity*material_cum)
            FROM    object O
					JOIN dbo.part_standard ps ON O.part = ps.part
                    LEFT JOIN location l ON o.location = l.code
            WHERE   ISNULL(secured_location, 'N') != 'Y'
                    AND O.part IN ( SELECT  part
                                    FROM    part
                                    WHERE   type = 'F' )  and
                    not exists (select 1 from order_header oh  join customer c on oh.customer = c.customer where c.region_code = 'INTERNAL' and blanket_part = O.part)
            GROUP BY o.part

    CREATE TABLE #Demand
        (
          WeekNo INT ,
          WeekDate datetime,
          Part VARCHAR(25) ,
          Qty NUMERIC(20, 6) ,
          Cost NUMERIC(20, 6) ,
          PRIMARY KEY NONCLUSTERED ( WeekNo, Part )
        )

    INSERT  #Demand
            ( WeekNo ,
				WeekDate,
              Part ,
              Qty ,
              Cost 
            )
            SELECT  WeekNo = DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dbo.order_detail.due_date)) ,
					WeekDate =  ft.fn_TruncDate('wk',dbo.order_detail.due_date), 
                    Part = part_number ,
                    Qty = SUM(eeiqty) ,
                    Cost = SUM(eeiqty * material_cum)
            FROM    dbo.order_detail
					join	dbo.order_header on dbo.order_detail.order_no = dbo.order_header.order_no
					join	customer on order_header.customer = customer.customer
                    JOIN dbo.part_standard ON part_number = part
            WHERE   DATEDIFF(week, GETDATE(), order_detail.due_date) <= 16 and
							eeiqty>1 
							and isNull(customer.region_code,'') != 'Internal'
            GROUP BY 
					DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dbo.order_detail.due_date)) ,
					 ft.fn_TruncDate('wk',dbo.order_detail.due_date),
                    part_number

    CREATE TABLE #TotalDemand
        (
          ID INT IDENTITY ,
          BasePart CHAR(7) PRIMARY KEY NONCLUSTERED ,
          Qty NUMERIC(20, 6),
          Cost NUMERIC (20,6),
          WeekCount Int,
          PercentofSales Numeric(20,6),
          AccumPercentofSales Numeric(20,6),
          CalculatedABC char(1),
          FixedABC char(1)
        )
declare @Sales8Weeks int
select @Sales8Weeks =sum(Cost) from #Demand Demand
            where		WeekNo <= 8 and WeekNo>=-1
    INSERT  #TotalDemand
            (	BasePart ,
				Qty,
				Cost,
				WeekCount,
				PercentofSales 
            )
            SELECT  BasePart = SUBSTRING(Part, 1, 7) ,
							Qty = SUM(Qty),
							Cost = SUM(Cost),
							WeekCount =  (select count(distinct WeekNo) from #Demand Demand2 where Substring(Demand2.part,1,7) = Substring(Demand.part,1,7) and Demand2.WeekNo<=8 ),
							PercentofSales = (SUM(Cost)/@Sales8Weeks ) *100          
            FROM    #Demand Demand
            where		WeekNo <= 8 and WeekNo>=-1 and
							Demand.Qty>1
            GROUP BY SUBSTRING(Part, 1, 7)
            ORDER BY SUM(Cost) desc
            
            update	#TotalDemand 
            set AccumPercentofSales = (select sum(PercentofSales) from #TotalDemand TD2 where TD2.id<=#TotalDemand.ID)
            
            update	 #TotalDemand
            set		CalculatedABC = (case when AccumPercentofSales<= 80 then 'A' when AccumPercentofSales> 80 and AccumPercentofSales<=95 then 'B' else 'C' End)
            
         --  select	*
          -- from		#TotalDemand

    DECLARE @A INT ,
        @B INT

    SELECT  @A = COUNT(*) * .2 ,
            @B = COUNT(*) * .35
    FROM    #TotalDemand
   
  --select	@A, @B  

    DECLARE @Weeks INT ,
        @Week INT ,
        @ResultsSyntax NVARCHAR(4000)

    SET @Weeks = 16

    SET @Week = 1

    SET @ResultsSyntax = '
CREATE TABLE dbo.RunningInventory
(	Part VARCHAR(25) PRIMARY KEY NONCLUSTERED
,	Class char(1)
,	WeekCount int
,	MinQty int
,	MaxQty int
,	MinQtyCost int
,	MaxQtyCost int
,	CurrentInventory int
,	CurrentInventoryCost int
,	WeekDate0 datetime
,	OnOrder0 int
,	Demand0 int
,	Balance0 int
,	OnOrderCost0 int
,	DemandCost0 int
,	BalanceCost0 int
'
    WHILE @Week <= @Weeks 
        BEGIN
	
            SET @ResultsSyntax = @ResultsSyntax + '
,	WeekDate' + CONVERT (VARCHAR, @Week) + '  datetime
,	OnOrder' + CONVERT (VARCHAR, @Week) + ' int
,	Demand' + CONVERT (VARCHAR, @Week) + ' int
,	Balance' + CONVERT (VARCHAR, @Week) + ' int
,	OnOrderCost' + CONVERT (VARCHAR, @Week) + ' int
,	DemandCost' + CONVERT (VARCHAR, @Week) + ' int
,	BalanceCost' + CONVERT (VARCHAR, @Week) + ' int
'	
            SET @Week = @Week + 1
        END

    SET @ResultsSyntax = @ResultsSyntax + '
)'

--PRINT
--	@ResultsSyntax

    DECLARE @ProcResult INT

    EXEC @ProcResult = sp_executesql @ResultsSyntax

    INSERT  dbo.RunningInventory
            ( Part ,
              Class ,
              WeekCount,
              CurrentInventory,
			  CurrentInventoryCost,  
              WeekDate0,  
              OnOrder0 ,
              Demand0 ,
              Balance0,
              OnOrderCost0,
              DemandCost0,
              BalanceCost0  
              
            )
            SELECT  Part ,
                    Class = (select max(CalculatedABC) from #TotalDemand where BasePart = Substring(part,1,7) ),
					WeekCount =  (select max(WeekCount) from #TotalDemand where BasePart = Substring(part,1,7) ),
					CurrentInventory = COALESCE((SELECT  Qty
                                            FROM    #Inventory
                                            WHERE   Part = Parts.Part),0),
                    CurrentInventoryCost = COALESCE((SELECT  Cost
                                            FROM    #Inventory
                                            WHERE   Part = Parts.Part),0), 
					Weekdate0 = (select min(WeekDate) from #Demand where Part = part and WeekNo = 0 ),
                    OnOrder0 = COALESCE(0,( SELECT    SUM(Qty)
                                          FROM      #OnPO
                                          WHERE     Part = Parts.Part
                                                    AND WeekNo <= 0
                                        )) ,
                    Demand0 = COALESCE(( SELECT SUM(Qty)
                                         FROM   #Demand
                                         WHERE  Part = Parts.Part
                                                AND WeekNo <= 0
                                       ), 0) ,
                    Balance0 = COALESCE(( ( SELECT  Qty
                                            FROM    #Inventory
                                            WHERE   Part = Parts.Part
                                          )
                                          + COALESCE(( SELECT SUM(Qty)
                                                       FROM   #OnPO
                                                       WHERE  Part = Parts.Part
                                                              AND WeekNo <= 0
                                                     ), 0) )
                                        - COALESCE(( SELECT SUM(Qty)
                                                     FROM   #Demand
                                                     WHERE  Part = Parts.Part
                                                            AND WeekNo <= 0
                                                   ), 0), 0),
					 OnOrderCost0 = COALESCE(( SELECT    SUM(Cost)
                                          FROM      #OnPO
                                          WHERE     Part = Parts.Part
                                                    AND WeekNo <= 0
                                        ), 0) ,
                    DemandCost0 = COALESCE(( SELECT SUM(Cost)
                                         FROM   #Demand
                                         WHERE  Part = Parts.Part
                                                AND WeekNo <= 0
                                       ), 0) ,
                    BalanceCost0 = COALESCE(( ( SELECT  cost
                                            FROM    #Inventory
                                            WHERE   Part = Parts.Part
                                          )
                                          + COALESCE(( SELECT SUM(Cost)
                                                       FROM   #OnPO
                                                       WHERE  Part = Parts.Part
                                                              AND WeekNo <= 0
                                                     ), 0) )
                                        - COALESCE(( SELECT SUM(Cost)
                                                     FROM   #Demand
                                                     WHERE  Part = Parts.Part
                                                            AND WeekNo <= 0
                                                   ), 0), 0) 
            FROM    ( SELECT    Part
                      FROM      #OnPO
                      UNION
                      SELECT    Part
                      FROM      #Demand
                      UNION
                      SELECT    Part
                      FROM      #Inventory
                    ) Parts

    UPDATE  dbo.RunningInventory
    SET     MinQty = ( ( SELECT Qty FROM   #TotalDemand  WHERE  BasePart = SUBSTRING(RunningInventory.Part, 1,7)) / (40 ) ) * CASE WHEN Class = 'A' THEN 7 WHEN Class = 'B' THEN 12 ELSE 15 END ,
				MaxQty = ( ( SELECT Qty FROM   #TotalDemand WHERE  BasePart = SUBSTRING(RunningInventory.Part, 1,7)) / ( 40 ) ) * CASE WHEN Class = 'A' THEN 12 WHEN Class = 'B' THEN 17 ELSE 20 END,
				MinQtyCost = ( ( SELECT Cost FROM   #TotalDemand  WHERE  BasePart = SUBSTRING(RunningInventory.Part, 1,7)) / ( 40 ) ) * CASE WHEN Class = 'A' THEN 7 WHEN Class = 'B' THEN 12 ELSE 15 END ,
				MaxQtyCost = ( ( SELECT Cost FROM   #TotalDemand WHERE  BasePart = SUBSTRING(RunningInventory.Part, 1,7)) / ( 40 ) ) * CASE WHEN Class = 'A' THEN 12 WHEN Class = 'B' THEN 17 ELSE 20 END
    FROM    dbo.RunningInventory RunningInventory

    DECLARE @UpdateSyntax NVARCHAR(4000)

    SET @Week = 1

    WHILE @Week <= @Weeks 
        BEGIN
	
            SET @UpdateSyntax = '
update
	dbo.RunningInventory
set
	WeekDate' + CONVERT(VARCHAR, @Week)
                + ' = COALESCE((SELECT min(WeekDate) FROM #Demand WHERE Part = RunningInventory.Part AND WeekNo = '
                + CONVERT(VARCHAR, @Week) + '), getdate()) 
,	OnOrder' + CONVERT(VARCHAR, @Week)
                + ' = COALESCE((SELECT SUM(Qty) FROM #OnPO WHERE Part = RunningInventory.Part AND WeekNo = '
                + CONVERT(VARCHAR, @Week) + '), 0)
,	Demand' + CONVERT(VARCHAR, @Week)
                + ' = COALESCE((SELECT SUM(Qty) FROM #Demand WHERE Part = RunningInventory.Part AND WeekNo = '
                + CONVERT(VARCHAR, @Week) + '), 0)
,	DemandCost' + CONVERT(VARCHAR, @Week)
                + ' = COALESCE((SELECT SUM(Cost) FROM #Demand WHERE Part = RunningInventory.Part AND WeekNo = '
                + CONVERT(VARCHAR, @Week) + '), 0) 
,	OnOrderCost' + CONVERT(VARCHAR, @Week)
                + ' = COALESCE((SELECT SUM(Cost) FROM #OnPO WHERE Part = RunningInventory.Part AND WeekNo = '
                + CONVERT(VARCHAR, @Week) + '), 0)  
from
	dbo.RunningInventory RunningInventory
	
update
	dbo.RunningInventory
set
	Balance' + CONVERT(VARCHAR, @Week) + ' = OnOrder'
                + CONVERT(VARCHAR, @Week) + ' - Demand'
                + CONVERT(VARCHAR, @Week) + ' + Balance'
                + CONVERT(VARCHAR, @Week - 1) + '
from
	dbo.RunningInventory RunningInventory
	
update
	dbo.RunningInventory
set
	BalanceCost' + CONVERT(VARCHAR, @Week) + ' = OnOrderCost'
                + CONVERT(VARCHAR, @Week) + ' - DemandCost'
                + CONVERT(VARCHAR, @Week) + ' + BalanceCost'
                + CONVERT(VARCHAR, @Week - 1) + '
from
	dbo.RunningInventory RunningInventory

'
	--PRINT
	--	@UpdateSyntax

            EXEC sp_executesql @UpdateSyntax

            SET @Week = @Week + 1
        END

    SET @UpdateSyntax = @UpdateSyntax + '
)'


select      base_part
            ,ISNULL(empire_sop, csm_sop) Sop
            ,ISNULL(empire_eop, csm_eop) Eop,
            (case when (ISNULL(empire_sop, csm_sop) between dateadd(m,-6,getdate()) and getdate()) or ISNULL(empire_sop, csm_sop)>getdate() then 'Launch'  when (ISNULL(empire_eop, csm_eop) between  getdate() and dateadd(m,6,getdate()))or ISNULL(empire_eop, csm_eop)< getdate() then 'Close-out'   else 'Production' end) as PartPhase
 into #ProductionPhase
from
            (
                  select      base_part
                              ,MIN(empire_sop) as empire_sop
                              ,MIN(csm_sop) as csm_sop
                              ,MAX(empire_eop) as empire_eop
                              ,MAX(CSM_eop) as csm_eop
                  from  eeiuser.acctg_csm_vw_select_csmdemandwitheeiadjustments_dw2_NEW
                  group by base_part
            ) a




    SELECT	*, 
					 COALESCE((SELECT MAX(scheduler) FROM dbo.destination JOIN dbo.customer ON destination.customer = dbo.customer.customer JOIN dbo.part_customer ON dbo.customer.customer = dbo.part_customer.customer WHERE part_customer.part = RunningInventory.part), 'NotDefined' ) AS Scheduler
					, case when   (select count(1) from RunningInventory RI2 where  substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) and RI2.part<= RunningInventory.part) = 1     
						then ( select sum(CurrentInventoryCost) from RunningInventory RI2 where substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) )
						else 0 End as CurrentInventoryDollars 
					, case when   (select count(1) from RunningInventory RI2 where  substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) and RI2.part<= RunningInventory.part) = 1     
						then dbo.fn_GreaterOf(( select sum(CurrentInventoryCost) - max(MaxQtyCost)  from RunningInventory RI2 where substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) ),0)
						else 0 End as CurrentExcessDollars
					, case when   (select count(1) from RunningInventory RI2 where  substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) and RI2.part<= RunningInventory.part) = 1     
						then dbo.fn_LesserOf(( select sum(CurrentInventoryCost) - max(MinQtyCost)  from RunningInventory RI2 where substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) ),0)
						else 0 End as CurrentShortDollars
					, case when   (select count(1) from RunningInventory RI2 where  substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) and RI2.part<= RunningInventory.part) = 1     
						then dbo.fn_GreaterOf(( select sum(BalanceCost5) - max(MaxQtyCost)  from RunningInventory RI2 where substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) ),0)
						else 0 End as Week5ExcessDollars
					,(select count(1) from RunningInventory RI2 where  substring(RI2.part,1,7) = substring(RunningInventory.part,1,7) and RI2.part<= RunningInventory.part) as PartCount
	into			#partRunningInventory				 
    FROM    dbo.RunningInventory
   left join		#ProductionPhase pp on left(part,7) = base_part 
   order by 1 
  
 select		left(part,7) BasePart,
          max(Class) Class,
          Max(WeekCount) WeekCount ,
          Max(MinQty) MinQty ,
          Max(MaxQty) MaxQty ,
          Max(MinQtyCost) MinQtyCost ,
          Max(MaxQtyCost) MaxQtyCost ,
          Sum(CurrentInventory) CurrentInventory ,
          Sum(CurrentInventoryCost) CurrentInventoryCost ,
          max(WeekDate0) WeekDate0,
          sum(OnOrder0) OnOrder0,
          sum(Demand0) Demand0,
          SUM(Balance0) Balance0,
          sum(OnOrderCost0) OnOrderCost0,
          sum(DemandCost0) DemandCost0,
          sum(BalanceCost0)BalanceCost0,
          max(WeekDate1)WeekDate1,
          sum(OnOrder1)OnOrder1,
          sum(Demand1)Demand1,
          sum(Balance1)Balance1,
          sum(OnOrderCost1)OnOrderCost1,
          sum(DemandCost1)DemandCost1,
          sum(BalanceCost1)BalanceCost1,
          max(WeekDate2) WeekDate2,
          sum(OnOrder2) OnOrder2,
          sum(Demand2) Demand2,
         	sum(Balance2) Balance2,
          sum(OnOrderCost2) OnOrderCost2,
          sum(DemandCost2) DemandCost2,
          sum(BalanceCost2)BalanceCost2,
         	max(WeekDate3) WeekDate3,
          sum(OnOrder3) OnOrder3,
          sum(Demand3)Demand3,
          sum(Balance3) Balance3,
          sum(OnOrderCost3) OnOrderCost3,
          sum(DemandCost3) DemandCost3,
          sum(BalanceCost3) BalanceCost3,
          max(WeekDate4) WeekDate4,
          sum(OnOrder4) OnOrder4,
          sum(Demand4) Demand4,
          sum(Balance4) Balance4,
          sum(OnOrderCost4) OnOrderCost4,
          sum(DemandCost4) DemandCost4,
          sum(BalanceCost4) BalanceCost4,
          max(WeekDate5) WeekDate5,
          sum(OnOrder5) OnOrder5,
          sum(Demand5) Demand5,
          sum(Balance5) Balance5,
          sum(OnOrderCost5) OnOrderCost5,
          sum(DemandCost5)DemandCost5,
          sum(BalanceCost5) BalanceCost5,
          max(WeekDate6) WeekDate6,
          sum(OnOrder6) OnOrder6,
          sum(Demand6) Demand6,
          sum(Balance6) Balance6,
          sum(OnOrderCost6) OnOrderCost6,
          sum(DemandCost6)DemandCost6,
          sum(BalanceCost6) BalanceCost6,
          max(WeekDate7) WeekDate7,
          sum(OnOrder7) OnOrder7,
          sum(Demand7) Demand7,
          sum(Balance7) Balance7,
          sum(OnOrderCost7) OnOrderCost7,
          sum(DemandCost7)DemandCost7,
          sum(BalanceCost7) BalanceCost7,
          max(WeekDate8) WeekDate8,
          sum(OnOrder8) OnOrder8,
          sum(Demand8) Demand8,
          sum(Balance8) Balance8,
          sum(OnOrderCost8) OnOrderCost8,
          sum(DemandCost8)DemandCost8,
          sum(BalanceCost8) BalanceCost8,
         	max(WeekDate9) WeekDate9,
          sum(OnOrder9) OnOrder9,
          sum(Demand9) Demand9,
          sum(Balance9) Balance9,
          sum(OnOrderCost9) OnOrderCost9,
          sum(DemandCost9)DemandCost9,
          sum(BalanceCost9) BalanceCost9,
          max(WeekDate10) WeekDate10,
          sum(OnOrder10) OnOrder10,
          sum(Demand10) Demand10,
          sum(Balance10) Balance10,
          sum(OnOrderCost10) OnOrderCost10,
          sum(DemandCost10)DemandCost10,
          sum(BalanceCost10) BalanceCost10,
          max(WeekDate11) WeekDate11,
          sum(OnOrder11) OnOrder11,
          sum(Demand11) Demand11,
          sum(Balance11) Balance11,
          sum(OnOrderCost11) OnOrderCost11,
          sum(DemandCost11)DemandCost11,
          sum(BalanceCost11) BalanceCost11,
          max(WeekDate12) WeekDate12,
          sum(OnOrder12) OnOrder12,
          sum(Demand12) Demand12,
          sum(Balance12) Balance12,
          sum(OnOrderCost12) OnOrderCost12,
          sum(DemandCost12)DemandCost12,
          sum(BalanceCost12) BalanceCost12,
          max(WeekDate13) WeekDate13,
          sum(OnOrder13) OnOrder13,
          sum(Demand13) Demand13,
          sum(Balance13) Balance13,
          sum(OnOrderCost13) OnOrderCost13,
          sum(DemandCost13)DemandCost13,
          sum(BalanceCost13) BalanceCost13,
         max(WeekDate14) WeekDate14,
          sum(OnOrder14) OnOrder14,
          sum(Demand14) Demand14,
          sum(Balance14) Balance14,
          sum(OnOrderCost14) OnOrderCost14,
          sum(DemandCost14)DemandCost14,
          sum(BalanceCost14) BalanceCost14,
          max(WeekDate15) WeekDate15,
          sum(OnOrder15) OnOrder15,
          sum(Demand15) Demand15,
          sum(Balance15) Balance15,
          sum(OnOrderCost15) OnOrderCost15,
          sum(DemandCost15)DemandCost15,
          sum(BalanceCost15) BalanceCost15,
          max(WeekDate16) WeekDate16,
          sum(OnOrder16) OnOrder16,
          sum(Demand16) Demand16,
          sum(Balance16) Balance16,
          sum(OnOrderCost16) OnOrderCost16,
          sum(DemandCost16)DemandCost16,
          sum(BalanceCost16) BalanceCost16,
          max(base_part) base_part,
          max(Sop)  sop,
          max(Eop) eop,
          max(PartPhase) partphase ,
          max(Scheduler) scheduler ,
          max(CurrentInventoryDollars) CurrentInventoryDollars ,
          max(CurrentExcessDollars) CurrentExcessDollars,
          max(CurrentShortDollars) CurrentShortDollars ,
          max(Week5ExcessDollars) Week5ExcessDollars ,
          max(PartCount) PartCount1,
          max(PartPhase) PartPhase1
  into		#basePartRunningInventory
  from		#partRunningInventory
  group 	by left(part,7)
  
select	 BasePart,
          Class,
          WeekCount ,
          MinQty ,
          MaxQty ,
          MinQtyCost ,
          MaxQtyCost ,
          CurrentInventory ,
          CurrentInventoryCost ,
			WeekDate0,
           OnOrder0,
          Demand0,
		(case when Balance0<MinQty then Balance0	-MinQty when Balance0>MaxQty then Balance0-MaxQty else 0 end 	)			 Balance0,
         OnOrderCost0,
         DemandCost0,
         BalanceCost0,
         WeekDate1,
         OnOrder1,
          Demand1,
          (case when Balance1<MinQty then Balance1	-MinQty when Balance1>MaxQty then Balance1-MaxQty else 0 end 	)Balance1,
         OnOrderCost1,
          DemandCost1,
          BalanceCost1,
           WeekDate2,
          OnOrder2,
           Demand2,
         	  (case when Balance2<MinQty then Balance2	-MinQty when Balance2>MaxQty then Balance2-MaxQty else 0 end 	) Balance2,
          OnOrderCost2,
           DemandCost2,
          BalanceCost2,
         	 WeekDate3,
          OnOrder3,
          Demand3,
           (case when Balance3<MinQty then Balance3	-MinQty when Balance3>MaxQty then Balance3-MaxQty else 0 end 	) Balance3,
           OnOrderCost3,
          DemandCost3,
           BalanceCost3,
           WeekDate4,
           OnOrder4,
          Demand4,
            (case when Balance4<MinQty then Balance4	-MinQty when Balance4>MaxQty then Balance4-MaxQty else 0 end 	) Balance4,
           OnOrderCost4,
          DemandCost4,
           BalanceCost4,
           WeekDate5,
           OnOrder5,
          Demand5,
           (case when Balance5<MinQty then Balance5	-MinQty when Balance5>MaxQty then Balance5-MaxQty else 0 end 	) Balance5,
           OnOrderCost5,
          DemandCost5,
          BalanceCost5,
          WeekDate6,
           OnOrder6,
          Demand6,
           (case when Balance6<MinQty then Balance6	-MinQty when Balance6>MaxQty then Balance6-MaxQty else 0 end 	) Balance6,
           OnOrderCost6,
          DemandCost6,
           BalanceCost6,
           WeekDate7,
           OnOrder7,
           Demand7,
          (case when Balance7<MinQty then Balance7	-MinQty when Balance7>MaxQty then Balance7-MaxQty else 0 end 	) Balance7,
           OnOrderCost7,
          DemandCost7,
           BalanceCost7,
           WeekDate8,
          OnOrder8,
           Demand8,
          (case when Balance8<MinQty then Balance8	-MinQty when Balance8>MaxQty then Balance8-MaxQty else 0 end 	) Balance8,
           OnOrderCost8,
          DemandCost8,
          BalanceCost8,
         	 WeekDate9,
          OnOrder9,
           Demand9,
           (case when Balance9<MinQty then Balance9	-MinQty when Balance9>MaxQty then Balance9-MaxQty else 0 end 	) Balance9,
           OnOrderCost9,
          DemandCost9,
           BalanceCost9,
           WeekDate10,
           OnOrder10,
          Demand10,
           (case when Balance10<MinQty then Balance10	-MinQty when Balance10>MaxQty then Balance10-MaxQty else 0 end 	) Balance10,
           OnOrderCost10,
          DemandCost10,
          BalanceCost10,
          WeekDate11,
           OnOrder11,
          Demand11,
           (case when Balance11<MinQty then Balance11	-MinQty when Balance11>MaxQty then Balance11-MaxQty else 0 end 	) Balance11,
           OnOrderCost11,
          DemandCost11,
           BalanceCost11,
           WeekDate12,
           OnOrder12,
          Demand12,
           (case when Balance12<MinQty then Balance12	-MinQty when Balance12>MaxQty then Balance12-MaxQty else 0 end 	) Balance12,
           OnOrderCost12,
          DemandCost12,
          BalanceCost12,
           WeekDate13,
           OnOrder13,
          Demand13,
           (case when Balance13<MinQty then Balance13	-MinQty when Balance13>MaxQty then Balance13-MaxQty else 0 end 	) Balance13,
           OnOrderCost13,
          DemandCost13,
           BalanceCost13,
          WeekDate14,
           OnOrder14,
          Demand14,
           (case when Balance14<MinQty then Balance14	-MinQty when Balance14>MaxQty then Balance14-MaxQty else 0 end 	) Balance14,
           OnOrderCost14,
          DemandCost14,
          BalanceCost14,
           WeekDate15,
           OnOrder15,
          Demand15,
           (case when Balance15<MinQty then Balance15	-MinQty when Balance15>MaxQty then Balance15-MaxQty else 0 end 	) Balance15,
           OnOrderCost15,
          DemandCost15,
           BalanceCost15,
           WeekDate16,
           OnOrder16,
          Demand16,
           (case when Balance16<MinQty then Balance16	-MinQty when Balance16>MaxQty then Balance16-MaxQty else 0 end 	) Balance16,
           OnOrderCost16,
          DemandCost16,
           BalanceCost16,
           base_part,
           sop,
           eop,
           partphase ,
          scheduler ,
          CurrentInventoryDollars ,
           CurrentExcessDollars,
           CurrentShortDollars ,
           Week5ExcessDollars ,
          PartCount1,
         PartPhase1
  from		#basePartRunningInventory


 DROP	TABLE dbo.RunningInventory

    COMMIT







GO
