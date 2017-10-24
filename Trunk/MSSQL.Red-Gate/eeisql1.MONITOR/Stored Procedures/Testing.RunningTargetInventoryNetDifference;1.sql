SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [Testing].[RunningTargetInventoryNetDifference;1]  @RampUpBeginDate datetime, @RampUpEndDate datetime, @MaxRampUpDays int
AS 
    BEGIN tran 
   
  -- exec   [Testing].[RunningTargetInventoryNetDifference]  '2011-10-17', '2011-12-23', 10
   
  --Get Factors For RampUp Min/Max
  
  --Declare Variables
  
declare	@RampWeeks int,
				@CurrentDate datetime,
				@CurrentRampupWeek int,
				@CurrentRampupDays numeric(20,6),
				@IncrementalRampDays numeric(10,6),
				@weeksA int,
				@weeksB int,
				@weekNoA int,
				@weekNoB int,
				@weekA datetime,
				@weekB datetime
  
 select		@CurrentDate =  getdate()
  
if exists (select 1 where datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )>0 )
Begin
select	 @RampWeeks = datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )
select	 @CurrentRampUpWeek =  datediff(WK, ft.fn_TruncDate('WK', @currentDate),ft.fn_TruncDate('WK',@RampUpBeginDate) )
select   @CurrentRampUpDays = case when @RampWeeks != 0 then  (@RampWeeks-@CurrentRampupWeek)+1/@RampWeeks*@MaxRampUpDays else @MaxRampUpDays end
select	  @IncrementalRampDays = (1/@RampWeeks)*@MaxRampUpDays
end
if not exists  (select 1 where datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )>0 )
begin
select @CurrentRampUpDays = 0
end

create	table #HorizonWeeks (
				WeekdayH datetime,
				WeekNoH int
				)


	set	@WeeksA = 16

    set	@WeekNoA = 0
	set	@WeekA = ft.fn_TruncDate('WK', @currentDate)
   
	WHILE @WeekNoA <= @WeeksA 
        BEGIN 
       
       insert #HorizonWeeks
               ( WeekdayH, WeekNoH )
     select		dateadd(wk, @WeekNoA, @WeekA),
					@weekNoA
				
		SET @WeekNoA = @WeekNoA + 1
        end
       
      --select	* from #HorizonWeeks   
     
     create 	table #RampWeeks (
				WeekdayR datetime,
				WeekNoR int,
				IncrementalRampDays numeric(10,2)
				)


	set	@WeeksB = @RampWeeks

    set	@WeekNoB = 1
	set	@WeekB = ft.fn_TruncDate('WK', @RampUpBeginDate)
   
	WHILE @WeekNoB <= @WeeksB 
        BEGIN 
       
       insert #RampWeeks
               ( WeekdayR, WeekNoR, IncrementalRampDays )
     select		dateadd(wk, @WeekNoB, @WeekB),
					@weekNoB,
					(convert(numeric(10,2), @WeekNoB)/convert(numeric(10,2),@weeksB))*@MaxRampUpDays
			
		  SET @WeekNoB = @WeekNoB + 1
        end
       
      --select	* from #RampWeeks   
     
     select
     WeekNoH,
     Coalesce(RW.IncrementalRampDays,0.00) RampDays,
     WeekdayH
     into #IncrementalRampDays
     from
		#HorizonWeeks HW
	left join
		#RampWeeks RW on HW.WeekdayH = RW.WeekdayR 
		
		--select	 *		from	#IncrementalRampDays 
		


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
          PercentofSales Numeric(20,6),
          AccumPercentofSales Numeric(20,6),
          CalculatedABC char(1)
        )
declare @Sales8Weeks int
select   @Sales8Weeks =sum(Cost) from #Demand Demand
            where		WeekNo <= 8 and WeekNo>=-1
    INSERT  #TotalDemand
            (	BasePart ,
				Qty,
				Cost,
				PercentofSales
            )
            SELECT  BasePart = SUBSTRING(Demand.Part, 1, 7) ,
							Qty = SUM(Qty),
							Cost = SUM(Cost),
							PercentofSales = (SUM(Cost)/@Sales8Weeks ) *100
							          
            FROM    #Demand Demand
            where		WeekNo <= 8 and WeekNo>=-1 and
							Demand.Qty>1
            GROUP BY SUBSTRING(Demand.Part, 1, 7)
            ORDER BY SUM(Cost) desc
            
            update	#TotalDemand 
            set AccumPercentofSales = (select sum(PercentofSales) from #TotalDemand TD2 where TD2.id<=#TotalDemand.ID)
            
            update	 #TotalDemand
            set		CalculatedABC = (case when AccumPercentofSales<= 80 then 'A' when AccumPercentofSales> 80 and AccumPercentofSales<=95 then 'B' else 'C' End)
            
  create table #BaseParts (
	      BasePart CHAR(7) PRIMARY KEY NONCLUSTERED ,
	      AvgDailyDemand int,
	      CurrentOnHand int, 
	      CurrentOnHandCost as convert(int, (CurrentOnHand*UnitCost)),
	      CurrentRampUpDays numeric(10,2),
          FixedMinDays int,
          FixedMaxDays int,
          CalculatedMinDays int,
          CalculatedMaxDays int,
          EffectiveMinDays as coalesce(FixedMinDays, CalculatedMinDays),
          EffectiveMaxDays as coalesce(FixedMaxDays, CalculatedMaxDays),
          CurrentEffectiveMinDays as coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays,
          CurrentEffectiveMaxDays as coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays,
          CalculatedABC char(1),
          UnitCost numeric (10,6),
          CurrentMinQty  as convert(int,AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays) ,
          CurrentMaxQty as convert(int,AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays),
          CurrentMinCost as convert(int,AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays*UnitCost),
          CurrentMaxCost as convert(int,AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays*UnitCost),
          CurrentMinQtyVariance as convert(int,(case when currentonhand<AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays then AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays-currentonhand else 0 end)),
          CurrentMaxQtyVariance as convert(int,(case when currentonhand>AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays then currentonhand-AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays else 0 end)),
          CurrentMinCostVariance as convert(int,(case when currentonhand<AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays then AvgDailyDemand*coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays-currentonhand else 0 end)*UnitCost),
          CurrentMaxCostVariance as convert(int,(case when currentonhand>AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays then currentonhand-AvgDailyDemand*coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays else 0 end)*UnitCost)
          )
          
   insert #BaseParts
           ( BasePart ,
			 AvgDailyDemand,
			 CurrentOnHand,
			 CurrentRampUpdays,
             FixedMinDays ,
             FixedMaxDays ,
             CalculatedMinDays ,
             CalculatedMaxDays ,
             CalculatedABC,
             UnitCost 
           )
	select
		left(peec.part,7),
		min(Qty)/40,
		(select sum(Qty)from #Inventory where left(Part,7) = left(peec.part,7)),
		(select rampDays from #IncrementalRampDays where weeknoH =0   ),
		min(peec.MinDaysDemandOnHand),
		min(peec.MaxDaysDemandOnHand),
		min(COALESCE(case when CalculatedABC = 'A'  then 7 when CalculatedABC = 'B' then 12 else 15 end, 15)),
		min(COALESCE(case when CalculatedABC = 'A'  then 12 when CalculatedABC = 'B' then 17 else 20 end, 20)),
		min(coalesce(CalculatedABC,'C')),
		avg(ps.material_cum)
	from
		part_eecustom peec
	join
		part_standard ps on peec.part = ps.part
	left join
		#TotalDemand TD on left(peec.part,7) = TD.BasePart
	where
		isNull(ServicePart,'N') !='Y' and
		peec.part in ( select part from #Demand union select part from #Inventory union select part from #OnPO )
	group by
		left(peec.part,7)
	--select * from #BaseParts

    DECLARE @Weeks INT ,
        @Week INT ,
        @ResultsSyntax NVARCHAR(MAX)

    SET @Weeks = 16

    SET @Week = 1

    SET @ResultsSyntax = '
CREATE TABLE dbo.RunningInventory
(	Part VARCHAR(25) PRIMARY KEY NONCLUSTERED
,	BasePart varchar(7)
,	WeekDate0 datetime
,	OnOrder0 int
,	Demand0 int
,	Balance0 int
,	OnOrderCost0 int
,	DemandCost0 int
,	BalanceCost0 int
,	MinDays0 numeric(10,2)
,	MaxDays0 numeric(10,2)
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
,	MinDays' + CONVERT (VARCHAR, @Week) + ' numeric(10,2)
,	MaxDays' + CONVERT (VARCHAR, @Week) + ' numeric(10,2)
'	
            SET @Week = @Week + 1
        END

    SET @ResultsSyntax = @ResultsSyntax + '
)'

--PRINT	@ResultsSyntax

    DECLARE @ProcResult INT

    EXEC @ProcResult = sp_executesql @ResultsSyntax

    INSERT  dbo.RunningInventory
            ( Part ,
              BasePart,
              WeekDate0,  
              OnOrder0 ,
              Demand0 ,
              Balance0,
              OnOrderCost0,
              DemandCost0,
              BalanceCost0,
              MinDays0,
              MaxDays0        
            )
            SELECT  Parts.Part ,
					BasePart = BPs.BasePart,
					Weekdate0 = (select min(WeekdayH) from #HorizonWeeks),
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
                                                   ), 0), 0) ,
                    MinDays0 = EffectiveMinDays,
                    MaxDays0 = EffectiveMaxDays
            FROM    ( SELECT    Part
                      FROM      #OnPO
                      UNION
                      SELECT    Part
                      FROM      #Demand
                      UNION
                      SELECT    Part
                      FROM      #Inventory
                    ) Parts
                   join	part_eecustom on Parts.part = part_eecustom.part
                  join    #BaseParts BPs on left(Parts.part,7) = BPs.BasePart 
                  where		isNull(ServicePart ,'N')!= 'Y'

   

    DECLARE @UpdateSyntax NVARCHAR(Max)

    SET @Week = 1

    WHILE @Week <= @Weeks 
        BEGIN
	
            SET @UpdateSyntax = '
update
	dbo.RunningInventory
set
	WeekDate' + CONVERT(VARCHAR, @Week)
                + ' = (select min(WeekdayH) from #HorizonWeeks where WeekNoH = '
                + CONVERT(VARCHAR, @Week) + ')
,	Mindays' + CONVERT(VARCHAR, @Week)
                + ' = (select min(RampDays) + min(EffectiveMinDays) from #BaseParts cross join #IncrementalRampDays where BasePart = RunningInventory.BasePart and WeekNoH = '
                + CONVERT(VARCHAR, @Week) + ') 
,	Maxdays' + CONVERT(VARCHAR, @Week)
                + ' = (select min(RampDays) + min(EffectiveMaxDays) from #BaseParts cross join #IncrementalRampDays where BasePart = RunningInventory.BasePart and WeekNoH =  '
                + CONVERT(VARCHAR, @Week) + ')    
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
            (case 
				when 
					(ISNULL(empire_sop, csm_sop) between dateadd(m,-6,getdate()) and getdate()) or ISNULL(empire_sop, csm_sop)>getdate() 
				 then 
					'Launch'  
				when 
					(ISNULL(empire_eop, csm_eop) between  getdate() and dateadd(m,6,getdate()))or ISNULL(empire_eop, csm_eop)< getdate() 
				then 
					'Close-out'   
				else 
					'Production' 
				end) as PartPhase
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


create table 
	#TargetPreResults 
	(	CalculatedABC char(1),
		BasePart char(7),
		UnitCost numeric (10,6),
		SOP datetime,
		EOP datetime,
		PartPhase varchar(15),
		CurrentMinDays numeric(10,2),
		CurrentMaxDays numeric(10,2),
		CurrentInventory int,
		CurrentMinQty int,
		CurrentMaxQty int,
		CurrentMinCost int,
		CurrentMaxCost int,
		CurrentMinQtyVariance int,
		CurrentMaxQtyVariance int,
		CurrentMinCostVariance int,
		CurrentMaxCostVariance int,
		AvgDailyDemand int,
		WeekDate0 datetime,
		Week0Balance int,
		MinDays0 int,
		MaxDays0 int,
		Week0MinQty as AvgDailyDemand*MinDays0,
		Week0MaxQty as AvgDailyDemand*MaxDays0,
		WeekDate1 datetime,
		Week1Balance int,
		MinDays1 int,
		MaxDays1 int,
		Week1MinQty as AvgDailyDemand*MinDays1,
		Week1MaxQty as AvgDailyDemand*MaxDays1,
		WeekDate2 datetime,
		Week2Balance int,
		MinDays2 int,
		MaxDays2 int,
		Week2MinQty as AvgDailyDemand*MinDays2,
		Week2MaxQty as AvgDailyDemand*MaxDays2,
		WeekDate3 datetime,
		Week3Balance int,
		MinDays3 int,
		MaxDays3 int,
		Week3MinQty as AvgDailyDemand*MinDays3,
		Week3MaxQty as AvgDailyDemand*MaxDays3,
		WeekDate4 datetime,
		Week4Balance int,
		MinDays4 int,
		MaxDays4 int,
		Week4MinQty as AvgDailyDemand*MinDays4,
		Week4MaxQty as AvgDailyDemand*MaxDays4,
		WeekDate5 datetime,
		Week5Balance int,
		MinDays5 int,
		MaxDays5 int,
		Week5MinQty as AvgDailyDemand*MinDays5,
		Week5MaxQty as AvgDailyDemand*MaxDays5,
		WeekDate6 datetime,
		Week6Balance int,
		MinDays6 int,
		MaxDays6 int,
		Week6MinQty as AvgDailyDemand*MinDays6,
		Week6MaxQty as AvgDailyDemand*MaxDays6,
		WeekDate7 datetime,
		Week7Balance int,
		MinDays7 int,
		MaxDays7 int,
		Week7MinQty as AvgDailyDemand*MinDays7,
		Week7MaxQty as AvgDailyDemand*MaxDays7,
		WeekDate8 datetime,
		Week8Balance int,
		MinDays8 int,
		MaxDays8 int,
		Week8MinQty as AvgDailyDemand*MinDays8,
		Week8MaxQty as AvgDailyDemand*MaxDays8,
		WeekDate9 datetime,
		Week9Balance int,
		MinDays9 int,
		MaxDays9 int,
		Week9MinQty as AvgDailyDemand*MinDays9,
		Week9MaxQty as AvgDailyDemand*MaxDays9,
		WeekDate10 datetime,
		Week10Balance int,
		MinDays10 int,
		MaxDays10 int,
		Week10MinQty as AvgDailyDemand*MinDays10,
		Week10MaxQty as AvgDailyDemand*MaxDays10,
		WeekDate11 datetime,
		Week11Balance int,
		MinDays11 int,
		MaxDays11 int,
		Week11MinQty as AvgDailyDemand*MinDays11,
		Week11MaxQty as AvgDailyDemand*MaxDays11,
		WeekDate12 datetime,
		Week12Balance int,
		MinDays12 int,
		MaxDays12 int,
		Week12MinQty as AvgDailyDemand*MinDays12,
		Week12MaxQty as AvgDailyDemand*MaxDays12,
		WeekDate13 datetime,
		Week13Balance int,
		MinDays13 int,
		MaxDays13 int,
		Week13MinQty as AvgDailyDemand*MinDays13,
		Week13MaxQty as AvgDailyDemand*MaxDays13,
		WeekDate14 datetime,
		Week14Balance int,
		MinDays14 int,
		MaxDays14 int,
		Week14MinQty as AvgDailyDemand*MinDays14,
		Week14MaxQty as AvgDailyDemand*MaxDays14,
		WeekDate15 datetime,
		Week15Balance int,
		MinDays15 int,
		MaxDays15 int,
		Week15MinQty as AvgDailyDemand*MinDays15,
		Week15MaxQty as AvgDailyDemand*MaxDays15,
		WeekDate16 datetime,
		Week16Balance int,
		MinDays16 int,
		MaxDays16 int,
		Week16MinQty as AvgDailyDemand*MinDays16,
		Week16MaxQty as AvgDailyDemand*MaxDays16)
		
		
 insert #TargetPreResults (CalculatedABC,
 BasePart,
 UnitCost, 
 SOP,
 EOP,
 PartPhase,
 CurrentMinDays,
 CurrentMaxDays,
 CurrentInventory,
 CurrentMinQty,
 CurrentMaxQty,
 CurrentMinCost,
 CurrentMaxCost,
 CurrentMinQtyVariance,
 CurrentMaxQtyVariance,
 CurrentMinCostVariance,
 CurrentMaxCostVariance,
 AvgDailyDemand,
 WeekDate0,
 Week0Balance,
 MinDays0,
 MaxDays0,
 WeekDate1,
 Week1Balance,
 MinDays1,
 MaxDays1,
 WeekDate2,
 Week2Balance,
 MinDays2,
 MaxDays2,
 WeekDate3,
 Week3Balance,
 MinDays3,
 MaxDays3,
 WeekDate4,
 Week4Balance,
 MinDays4,
 MaxDays4,
 WeekDate5,
 Week5Balance,
 MinDays5,
 MaxDays5,
 WeekDate6,
 Week6Balance,
 MinDays6,
 MaxDays6,
  WeekDate7,
 Week7Balance,
 MinDays7,
 MaxDays7,
 WeekDate8,
 Week8Balance,
 MinDays8,
 MaxDays8,
 WeekDate9,
 Week9Balance,
 MinDays9,
 MaxDays9,
 WeekDate10,
 Week10Balance,
 MinDays10,
 MaxDays10,
 WeekDate11,
 Week11Balance,
 MinDays11,
 MaxDays11,
 WeekDate12,
 Week12Balance,
 MinDays12,
 MaxDays12,
 WeekDate13,
 Week13Balance,
 MinDays13,
 MaxDays13,
 WeekDate14,
 Week14Balance,
 MinDays14,
 MaxDays14,
 WeekDate15,
 Week15Balance,
 MinDays15,
 MaxDays15,
 WeekDate16,
 Week16Balance,
 MinDays16,
 MaxDays16) 
    
   
    SELECT	CalculatedABC,
 BP.BasePart,
UnitCost, 
 SOP,
 EOP,
 PartPhase,
 CurrentEffectiveMinDays,
 CurrentEffectiveMaxDays,
 CurrentOnHand,
 CurrentMinQty,
 CurrentMaxQty,
 CurrentMinCost,
 CurrentMaxCost,
 CurrentMinQtyVariance,
 CurrentMaxQtyVariance,
 CurrentMinCostVariance,
 CurrentMaxCostVariance,
 AvgDailyDemand,
 WeekDate0,
 Balance0,
 MinDays0,
 MaxDays0,
 WeekDate1,
 Balance1,
 MinDays1,
 MaxDays1,
 WeekDate2,
 Balance2,
 MinDays2,
 MaxDays2,
 WeekDate3,
 Balance3,
 MinDays3,
 MaxDays3,
 WeekDate4,
 Balance4,
 MinDays4,
 MaxDays4,
 WeekDate5,
 Balance5,
 MinDays5,
 MaxDays5,
 WeekDate6,
 Balance6,
 MinDays6,
 MaxDays6,
  WeekDate7,
 Balance7,
 MinDays7,
 MaxDays7,
 WeekDate8,
 Balance8,
 MinDays8,
 MaxDays8,
 WeekDate9,
 Balance9,
 MinDays9,
 MaxDays9,
 WeekDate10,
 Balance10,
 MinDays10,
 MaxDays10,
 WeekDate11,
 Balance11,
 MinDays11,
 MaxDays11,
 WeekDate12,
 Balance12,
 MinDays12,
 MaxDays12,
 WeekDate13,
 Balance13,
 MinDays13,
 MaxDays13,
 WeekDate14,
 Balance14,
 MinDays14,
 MaxDays14,
 WeekDate15,
 Balance15,
 MinDays15,
 MaxDays15,
 WeekDate16,
 Balance16,
 MinDays16,
 MaxDays16
	FROM    dbo.RunningInventory RI
	join			#BaseParts BP on RI.BasePart = BP.BasePart
	left join		#ProductionPhase pp on left(RI.Basepart,7) = base_part 
   order by 2
  
  --select * From
  --#TargetPreResults
  
 
select   
max(CalculatedABC) as CalculatedABC,
max(UnitCost) as UnitCost,
 BasePart,
 max(SOP) as SOP,
 max(EOP)as EOP,
 max(PartPhase) as PartPhase,
 max(CurrentMinDays) as CurrentMinDays,
 max(CurrentMaxDays) as CurrentMaxDays,
 max(CurrentInventory) as CurrentInventory,
 max(CurrentMinQty) as CurrentMinQty,
 max(CurrentMaxQty) as CurrentMaxQty,
 max(CurrentMinCost) as CurrentMinCost,
 max(CurrentMaxCost) as CurrentMaxCost,
 max(CurrentMinQtyVariance) as CurrentMinQtyVariance,
 max(CurrentMaxQtyVariance) as CurrentMaxQtyVariance,
 max(CurrentMinCostVariance) as CurrentMinCostVariance,
 max(CurrentMaxCostVariance) as CurrentMaxCostVariance,
 max(AvgDailyDemand) as AvgDailyDemand,
 max(WeekDate0) as WeekDate0,
 sum(Week0Balance) as Week0Balance,
 max(MinDays0) as MinDays0,
 max(MaxDays0) as MaxDays0,
 case when sum(Week0Balance) < (max(Mindays0)*max(AvgDailyDemand)) then sum(Week0Balance) - (max(Mindays0)*max(AvgDailyDemand)) else 0 end as Week0MinVariance,
 case when sum(Week0Balance) > (max(Maxdays0)*max(AvgDailyDemand)) then (sum(Week0Balance) - (max(Maxdays0)*max(AvgDailyDemand)) ) else 0 end as Week0MaxVariance,
 max(WeekDate1) as WeekDate1,
 sum(Week1Balance) as Week1Balance,
 max(MinDays1) as MinDays1,
 max(MaxDays1) as MaxDays1,
 case when sum(Week1Balance) < (max(Mindays1)*max(AvgDailyDemand)) then sum(Week1Balance) - (max(Mindays1)*max(AvgDailyDemand)) else 0 end as Week1MinVariance,
 case when sum(Week1Balance) > (max(Maxdays1)*max(AvgDailyDemand)) then (sum(Week1Balance) - (max(Maxdays1)*max(AvgDailyDemand))) else 0 end as Week1MaxVariance,
 max(WeekDate2) as WeekDate2,
 sum(Week2Balance) as Week2Balance,
 max(MinDays2) as MinDays2,
 max(MaxDays2) as MaxDays2,
 case when sum(Week2Balance) < (max(Mindays2)*max(AvgDailyDemand)) then sum(Week2Balance) - (max(Mindays2)*max(AvgDailyDemand)) else 0 end as Week2MinVariance,
 case when sum(Week2Balance) > (max(Maxdays2)*max(AvgDailyDemand)) then (sum(Week2Balance) - (max(Maxdays2)*max(AvgDailyDemand))) else 0 end as Week2MaxVariance,
 max(WeekDate3) as WeekDate3,
 sum(Week3Balance) as Week3Balance,
 max(MinDays3) as MinDays3,
 max(MaxDays3) as MaxDays3,
 case when sum(Week3Balance) < (max(Mindays3)*max(AvgDailyDemand)) then sum(Week3Balance) - (max(Mindays3)*max(AvgDailyDemand)) else 0 end as Week3MinVariance,
 case when sum(Week3Balance) > (max(Maxdays3)*max(AvgDailyDemand)) then (sum(Week3Balance) - (max(Maxdays3)*max(AvgDailyDemand))) else 0 end as Week3MaxVariance,
 max(WeekDate4) as WeekDate4,
 sum(Week4Balance) as Week4Balance,
 max(MinDays4) as MinDays4,
 max(MaxDays4) as MaxDays4,
 case when sum(Week4Balance) < (max(Mindays4)*max(AvgDailyDemand)) then sum(Week4Balance) - (max(Mindays4)*max(AvgDailyDemand)) else 0 end as Week4MinVariance,
 case when sum(Week4Balance) > (max(Maxdays4)*max(AvgDailyDemand)) then (sum(Week4Balance) - (max(Maxdays4)*max(AvgDailyDemand))) else 0 end as Week4MaxVariance,
 max(WeekDate5) as WeekDate5,
 sum(Week5Balance) as Week5Balance,
 max(MinDays5) as MinDays5,
 max(MaxDays5) as MaxDays5,
 case when sum(Week5Balance) < (max(Mindays5)*max(AvgDailyDemand)) then sum(Week5Balance) - (max(Mindays5)*max(AvgDailyDemand)) else 0 end as Week5MinVariance,
 case when sum(Week5Balance) > (max(Maxdays5)*max(AvgDailyDemand)) then (sum(Week5Balance) - (max(Maxdays5)*max(AvgDailyDemand))) else 0 end as Week5MaxVariance, 
 case when sum(Week10Balance) > (max(Maxdays5)*max(AvgDailyDemand)) then ((sum(Week5Balance)-(max(Maxdays5)*max(AvgDailyDemand)))*max(UnitCost) ) else 0 end as Week5MaxVarianceCost, 
 max(WeekDate6) as WeekDate6,
 sum(Week6Balance) as Week6Balance,
 max(MinDays6) as MinDays6,
 max(MaxDays6) as MaxDays6,
 case when sum(Week6Balance) < (max(Mindays6)*max(AvgDailyDemand)) then sum(Week6Balance) - (max(Mindays6)*max(AvgDailyDemand)) else 0 end as Week6MinVariance,
 case when sum(Week6Balance) > (max(Maxdays6)*max(AvgDailyDemand)) then (sum(Week6Balance) - (max(Maxdays6)*max(AvgDailyDemand))) else 0 end as Week6MaxVariance, 
 max(WeekDate7) as WeekDate7,
 sum(Week7Balance) as Week7Balance,
 max(MinDays7) as MinDays7,
 max(MaxDays7) as MaxDays7,
 case when sum(Week7Balance) < (max(Mindays7)*max(AvgDailyDemand)) then sum(Week7Balance) - (max(Mindays7)*max(AvgDailyDemand)) else 0 end as Week7MinVariance,
 case when sum(Week7Balance) > (max(Maxdays7)*max(AvgDailyDemand)) then (sum(Week7Balance) - (max(Maxdays7)*max(AvgDailyDemand))) else 0 end as Week7MaxVariance, 
 max(WeekDate8) as WeekDate8,
 sum(Week8Balance) as Week8Balance,
 max(MinDays8) as MinDays8,
 max(MaxDays8) as MaxDays8,
 case when sum(Week8Balance) < (max(Mindays8)*max(AvgDailyDemand)) then sum(Week8Balance) - (max(Mindays8)*max(AvgDailyDemand)) else 0 end as Week8MinVariance,
 case when sum(Week8Balance) > (max(Maxdays8)*max(AvgDailyDemand)) then (sum(Week8Balance) - (max(Maxdays8)*max(AvgDailyDemand))) else 0 end as Week8MaxVariance,
 max(WeekDate9) as WeekDate9,
 sum(Week9Balance) as Week9Balance,
 max(MinDays9) as MinDays9,
 max(MaxDays9) as MaxDays9,
 case when sum(Week9Balance) < (max(Mindays9)*max(AvgDailyDemand)) then sum(Week9Balance) - (max(Mindays9)*max(AvgDailyDemand)) else 0 end as Week9MinVariance,
 case when sum(Week9Balance) > (max(Maxdays9)*max(AvgDailyDemand)) then (sum(Week9Balance) - (max(Maxdays9)*max(AvgDailyDemand))) else 0 end as Week9MaxVariance,
 max(WeekDate10) as WeekDate10,
 sum(Week10Balance) as Week10Balance,
 max(MinDays10) as MinDays10,
 max(MaxDays10) as MaxDays10,
 case when sum(Week10Balance) < (max(Mindays10)*max(AvgDailyDemand)) then sum(Week10Balance) - (max(Mindays10)*max(AvgDailyDemand)) else 0 end as Week10MinVariance,
 case when sum(Week10Balance) > (max(Maxdays10)*max(AvgDailyDemand)) then (sum(Week10Balance) - (max(Maxdays10)*max(AvgDailyDemand))) else 0 end as Week10MaxVariance, 
case when sum(Week10Balance) > (max(Maxdays10)*max(AvgDailyDemand)) then ((sum(Week10Balance)-(max(Maxdays10)*max(AvgDailyDemand)))*max(UnitCost) ) else 0 end as Week10MaxVarianceCost,   
 max(WeekDate11) as WeekDate11,
 sum(Week11Balance) as Week11Balance,
 max(MinDays11) as MinDays11,
 max(MaxDays11) as MaxDays11,
 case when sum(Week11Balance) < (max(Mindays11)*max(AvgDailyDemand)) then sum(Week11Balance) - (max(Mindays11)*max(AvgDailyDemand)) else 0 end as Week11MinVariance,
 case when sum(Week11Balance) > (max(Maxdays11)*max(AvgDailyDemand)) then (sum(Week11Balance) - (max(Maxdays11)*max(AvgDailyDemand))) else 0 end as Week11MaxVariance, 
 max(WeekDate12) as WeekDate12,
 sum(Week12Balance) as Week12Balance,
 max(MinDays12) as MinDays12,
 max(MaxDays12) as MaxDays12,
 case when sum(Week12Balance) < (max(Mindays12)*max(AvgDailyDemand)) then sum(Week12Balance) - (max(Mindays12)*max(AvgDailyDemand)) else 0 end as Week12MinVariance,
 case when sum(Week12Balance) > (max(Maxdays12)*max(AvgDailyDemand)) then (sum(Week12Balance) - (max(Maxdays12)*max(AvgDailyDemand))) else 0 end as Week12MaxVariance, 
 max(WeekDate13) as WeekDate13,
 sum(Week13Balance) as Week13Balance,
 max(MinDays13) as MinDays13,
 max(MaxDays13) as MaxDays13,
 case when sum(Week13Balance) < (max(Mindays13)*max(AvgDailyDemand)) then sum(Week13Balance) - (max(Mindays13)*max(AvgDailyDemand)) else 0 end as Week13MinVariance,
 case when sum(Week13Balance) > (max(Maxdays13)*max(AvgDailyDemand)) then (sum(Week13Balance) - (max(Maxdays13)*max(AvgDailyDemand))) else 0 end as Week13MaxVariance,  
 max(WeekDate14) as WeekDate14,
 sum(Week14Balance) as Week14Balance,
 max(MinDays14) as MinDays14,
 max(MaxDays14) as MaxDays14,
 case when sum(Week14Balance) < (max(Mindays14)*max(AvgDailyDemand)) then sum(Week14Balance) - (max(Mindays14)*max(AvgDailyDemand)) else 0 end as Week14MinVariance,
 case when sum(Week14Balance) > (max(Maxdays14)*max(AvgDailyDemand)) then (sum(Week14Balance) - (max(Maxdays14)*max(AvgDailyDemand))) else 0 end as Week14MaxVariance, 
 max(WeekDate15) as WeekDate15,
 sum(Week15Balance) as Week15Balance,
 max(MinDays15) as MinDays15,
 max(MaxDays15) as MaxDays15,
 case when sum(Week15Balance) < (max(Mindays15)*max(AvgDailyDemand)) then sum(Week15Balance) - (max(Mindays15)*max(AvgDailyDemand)) else 0 end as Week15MinVariance,
 case when sum(Week15Balance) > (max(Maxdays15)*max(AvgDailyDemand)) then (sum(Week15Balance) - (max(Maxdays15)*max(AvgDailyDemand))) else 0 end as Week15MaxVariance, 
 max(WeekDate16) as WeekDate16,
 sum(Week16Balance) as Week16Balance,
 max(MinDays16) as MinDays16,
 max(MaxDays16) as MaxDays16,
 case when sum(Week16Balance) < (max(Mindays16)*max(AvgDailyDemand)) then sum(Week16Balance) - (max(Mindays16)*max(AvgDailyDemand)) else 0 end as Week16MinVariance,
 case when sum(Week16Balance) > (max(Maxdays16)*max(AvgDailyDemand)) then (sum(Week16Balance) - (max(Maxdays16)*max(AvgDailyDemand))) else 0 end as Week16MaxVariance
from
#TargetPreResults
group by BasePart
 

 DROP	TABLE dbo.RunningInventory

    COMMIT










GO
