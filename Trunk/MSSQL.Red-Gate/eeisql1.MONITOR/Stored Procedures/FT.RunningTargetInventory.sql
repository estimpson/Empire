SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [FT].[RunningTargetInventory]
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
					,PartPhase
					 
    FROM    dbo.RunningInventory
   left join		#ProductionPhase pp on left(part,7) = base_part 
   order by 1 

    DROP	TABLE dbo.RunningInventory

    COMMIT








GO
