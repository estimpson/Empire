SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [Testing].[RunningTargetInventoryNetDifferenceWithBuildUp;1]  @RampUpBeginDate datetime, @RampUpEndDate datetime, @MaxRampUpDays int, @RampUpBeginDate2 datetime, @RampUpEndDate2 datetime, @MaxRampUpDays2 int
AS 
    BEGIN tran 
   
  -- exec    [Testing].[RunningTargetInventoryNetDifferenceWithBuildUp]   '2012-01-22', '2012-02-26', 5, '2012-03-25', '2012-04-15', 5 
   
  --Get Factors For RampUp Min/Max
  
  --Declare Variables
  
declare	@RampWeeks int,
				@RampWeeks2 int,
				@CurrentDate datetime,
				@CurrentRampupWeek int,
				@CurrentRampupDays numeric(20,6),
				@IncrementalRampDays numeric(10,6),
				@CurrentRampupWeek2 int,
				@CurrentRampupDays2 numeric(20,6),
				@IncrementalRampDays2 numeric(10,6),
				@weeksA int,
				@weeksB int,
				@weeksC int,
				@weekNoA int,
				@weekNoB int,
				@weekNoC int,
				@weekA datetime,
				@weekB datetime,
				@weekC datetime
  
 select		@CurrentDate =  getdate()
  
if exists (select 1 where datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )>0  )
Begin
select		@RampWeeks = datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )+1.0000
select		@CurrentRampUpWeek =  case	when ft.fn_TruncDate('WK', @currentDate) = ft.fn_TruncDate('WK',@RampUpBeginDate) then 1 
																		when ft.fn_TruncDate('WK', @currentDate)>ft.fn_TruncDate('WK',@RampUpBeginDate)  then  datediff(WK,ft.fn_TruncDate('WK',@RampUpBeginDate), ft.fn_TruncDate('WK', @currentDate))+1
																		else -2
																		end
select		@CurrentRampUpDays = coalesce((case when @RampWeeks != 0 then  (@CurrentRampUpWeek*1.0000)/(@RampWeeks*1.0000)*(@MaxRampUpDays*1.0000) else @MaxRampUpDays end),0)
select		@IncrementalRampDays = (1.0000/@RampWeeks)*@MaxRampUpDays*1.0000
end
/*print		'RampWeeks  '+ convert(varchar, @RampWeeks)
print		'CurrentRampUpWeek  ' + convert(varchar, @CurrentRampupWeek )
print		'CurrentRampUpDays  ' + convert(varchar, @CurrentRampupDays )
print		'IncrementalRampDays  ' + convert(varchar, @IncrementalRampDays)
print		'MaxRampUpDays  ' + convert(varchar,@MaxRampUpDays)
*/
if exists (select 1 where  datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate2),ft.fn_TruncDate('WK',@RampUpEndDate2) )>0)
Begin
select		@RampWeeks2 = (datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate2),ft.fn_TruncDate('WK',@RampUpEndDate2) )*1.0000)+1.000
select		@IncrementalRampDays2 = (1/(@RampWeeks2*1.0000))*(@MaxRampUpDays2*1.00000)
/*print		'RampWeeks2  '+ convert(varchar, (@RampWeeks2))
print		'IncrementalRampDays2  ' + convert(varchar, @IncrementalRampDays2)
*/
end


if not exists  (select 1 where datediff(WK, ft.fn_TruncDate('WK', @RampUpBeginDate),ft.fn_TruncDate('WK',@RampUpEndDate) )>0 )
begin
select @CurrentRampUpDays = 0
end

create	table #HorizonWeeks (
				WeekdayH datetime,
				WeekNoH int
				)


	set	@WeeksA = 20

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

    set	@WeekNoB = 0
	set	@WeekB = ft.fn_TruncDate('WK', @RampUpBeginDate)
   
	WHILE @WeekNoB <= @WeeksB 
        BEGIN 
       
       insert #RampWeeks
               ( WeekdayR, WeekNoR, IncrementalRampDays )
     select		dateadd(wk, @WeekNoB, (@WeekB)),
					@weekNoB,
					((convert(numeric(10,2), @WeekNoB)/convert(numeric(10,2),@weeksB))*@MaxRampUpDays)+@IncrementalRampDays
			
		  SET @WeekNoB = @WeekNoB + 1
        end
       
     -- select	* from #RampWeeks   
     
     select
     WeekNoH,
     Coalesce(RW.IncrementalRampDays,0.00) RampDays,
     WeekdayH
     into #IncrementalRampDays
     from
		#HorizonWeeks HW
	left join
		#RampWeeks RW on HW.WeekdayH = RW.WeekdayR 
	where
		RW.IncrementalRampDays<= @MaxRampUpDays
		
		--select	 *		from	#IncrementalRampDays 
		
		
		create 	table #RampWeeks2 (
				WeekdayR datetime,
				WeekNoR int,
				IncrementalRampDays numeric(10,2)
				)


	set	@WeeksC = @RampWeeks2

    set	@WeekNoC = 0
	set	@WeekC = ft.fn_TruncDate('WK', @RampUpBeginDate2)
   
	WHILE @WeekNoC <= @WeeksC 
        BEGIN 
       
       insert #RampWeeks2
               ( WeekdayR, WeekNoR, IncrementalRampDays )
     select		dateadd(wk, @WeekNoC, @WeekC),
					@weekNoC,
					((convert(numeric(10,2), @WeekNoC)/convert(numeric(10,2),@weeksC))*@MaxRampUpDays2)+@IncrementalRampDays2
			
		  SET @WeekNoC = @WeekNoC + 1
        end
       
      --select	* from #RampWeeks2 
     
     select
     WeekNoH,
     Coalesce(RW.IncrementalRampDays,0.00) RampDays,
     WeekdayH
     into #IncrementalRampDays2
     from
		#HorizonWeeks HW
	left join
		#RampWeeks2 RW on HW.WeekdayH = RW.WeekdayR 
	where
		RW.IncrementalRampDays<= @MaxRampUpDays2
		
	--select *  from #IncrementalRampDays2
	
	select	
		HW.WeekdayH ,
		HW.WeekNoH ,
	    Coalesce(RD.RampDays, RD2.RampDays,0) RampDays
	 into
		#HorizonWeeksWithRampDays
	       
	from		
		#HorizonWeeks HW
	left join
		#IncrementalRampDays RD on HW.WeekNoH = RD.WeekNoH
	left join
		#IncrementalRampDays2 RD2 on HW.WeekNoH =RD2.WeekNoH

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
                    and not exists  (select 1 from bill_of_material bom where bom.parent_part = po_detail.part_number)
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
                                    WHERE   type = 'F' )  
                                    and not exists  (select 1 from bill_of_material bom where bom.parent_part = O.part)
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
          SELECT   WeekNo = DATEDIFF(week, ft.fn_TruncDate('wk',GETDATE()), ft.fn_TruncDate('wk',dbo.order_detail.due_date)) ,
					WeekDate =  ft.fn_TruncDate('wk',dbo.order_detail.due_date), 
                    Part = part_number ,
                    Qty = SUM(case when isNull(eeiqty,0) = 0 then quantity else eeiqty end ) ,
                    Cost = SUM(case when isNull(eeiqty,0) = 0 then quantity else eeiqty end * material_cum)
            FROM    dbo.order_detail
					join	dbo.order_header on dbo.order_detail.order_no = dbo.order_header.order_no
					join	customer on order_header.customer = customer.customer
                    JOIN dbo.part_standard ON part_number = part
    WHERE   DATEDIFF(week, GETDATE(), order_detail.due_date) <= 16 
							and not exists (select 1 from bill_of_material bom where bom.parent_part = order_detail.part_number)
							and (case when isNull(eeiqty,0) = 0 then quantity else eeiqty end)  > 1
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
          FixedMinDays numeric(10,2),
          FixedMaxDays numeric(10,2),
          CalculatedMinDays numeric(10,2),
          CalculatedMaxDays numeric(10,2),
          EffectiveMinDays as coalesce(FixedMinDays, CalculatedMinDays),
          EffectiveMaxDays as coalesce(FixedMaxDays, CalculatedMaxDays),
          CurrentEffectiveMinDays as coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays,
          CurrentEffectiveMaxDays as coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays,
          CalculatedABC char(1),
          UnitCost numeric (10,6),
          CurrentMinQty  as convert(int,AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays)) ,
          CurrentMaxQty as convert(int,AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays)),
          CurrentMinCost as convert(int,AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays)*UnitCost),
          CurrentMaxCost as convert(int,AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays)*UnitCost),
          CurrentMinQtyVariance as convert(int,(case when currentonhand<AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays) then currentonhand-(AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays)) else 0 end)),
          CurrentMaxQtyVariance as convert(int,(case when currentonhand>AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays) then currentonhand-(AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays)) else 0 end)),
          CurrentMinCostVariance as convert(int,(case when currentonhand<AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays) then currentonhand-(AvgDailyDemand*(coalesce(FixedMinDays, CalculatedMinDays)+CurrentRampupDays)) else 0 end)*UnitCost),
          CurrentMaxCostVariance as convert(int,(case when currentonhand>AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays) then currentonhand-(AvgDailyDemand*(coalesce(FixedMaxDays, CalculatedMaxDays)+CurrentRampupDays)) else 0 end)*UnitCost)
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

    SET @Weeks = 20

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
,	RampUpDays0 numeric(10,2)
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
,	RampUpDays' + CONVERT (VARCHAR, @Week) + ' numeric(10,2)
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
              MaxDays0,
			  RampUpDays0       
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
                    MinDays0 =  CurrentEffectiveMinDays,
                    MaxDays0 =CurrentEffectiveMaxDays,
                    RampUpDays0 = Coalesce(CurrentRampUpDays,0.00)
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
                + ' = (select min(WeekdayH) from #HorizonWeeksWithRampDays where WeekNoH = '
                + CONVERT(VARCHAR, @Week) + ')
,	Mindays' + CONVERT(VARCHAR, @Week)
                + ' = (select min(RD1.RampDays) + min(EffectiveMinDays) from #BaseParts cross join #HorizonWeeksWithRampDays RD1  where BasePart = RunningInventory.BasePart and RD1.WeekNoH = '
                + CONVERT(VARCHAR, @Week) + ') 
,	Maxdays' + CONVERT(VARCHAR, @Week)
                + ' = (select min(RD1.RampDays)  + min(EffectiveMaxDays) from #BaseParts cross join #HorizonWeeksWithRampDays RD1 where BasePart = RunningInventory.BasePart and RD1.WeekNoH =  '
                + CONVERT(VARCHAR, @Week) + ') 
,	RampUpDays' + CONVERT(VARCHAR, @Week)
                + ' = (select min(RD1.RampDays)  from #BaseParts cross join #HorizonWeeksWithRampDays RD1 where BasePart = RunningInventory.BasePart and RD1.WeekNoH =  '
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
		FixedMinDays numeric(6,2),
		FixedMaxDays numeric(6,2),
		CalculatedMinDays numeric (6,2),
		CalculatedMaxDays numeric(6,2),
		CurrentRampUpDays numeric(6,2),
		CurrentMinDays numeric(10,2),
		CurrentMaxDays numeric(10,2),
		CurrentInventory int,
		CurrentInventoryCost int,
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
		MinDays0 numeric(6,2),
		MaxDays0 numeric(6,2),
		RampUpDays0 numeric(6,2),
		Week0MinQty as AvgDailyDemand*MinDays0,
		Week0MaxQty as AvgDailyDemand*MaxDays0,
		WeekDate1 datetime,
		Week1Balance int,
		MinDays1 numeric(6,2),
		MaxDays1 numeric(6,2),
		RampUpDays1 numeric(6,2),
		Week1MinQty as AvgDailyDemand*MinDays1,
		Week1MaxQty as AvgDailyDemand*MaxDays1,
		WeekDate2 datetime,
		Week2Balance int,
		MinDays2 numeric(6,2),
		MaxDays2 numeric(6,2),
		RampUpDays2 numeric(6,2),
		Week2MinQty as AvgDailyDemand*MinDays2,
		Week2MaxQty as AvgDailyDemand*MaxDays2,
		WeekDate3 datetime,
		Week3Balance int,
		MinDays3 numeric(6,2),
		MaxDays3 numeric(6,2),
		RampUpDays3 numeric(6,2),
		Week3MinQty as AvgDailyDemand*MinDays3,
		Week3MaxQty as AvgDailyDemand*MaxDays3,
		WeekDate4 datetime,
		Week4Balance int,
		MinDays4 numeric(6,2),
		MaxDays4 numeric(6,2),
		RampUpDays4 numeric(6,2),
		Week4MinQty as AvgDailyDemand*MinDays4,
		Week4MaxQty as AvgDailyDemand*MaxDays4,
		WeekDate5 datetime,
		Week5Balance int,
		MinDays5 numeric(6,2),
		MaxDays5 numeric(6,2),
		RampUpDays5 numeric(6,2),
		Week5MinQty as AvgDailyDemand*MinDays5,
		Week5MaxQty as AvgDailyDemand*MaxDays5,
		WeekDate6 datetime,
		Week6Balance int,
		MinDays6 numeric(6,2),
		MaxDays6 numeric(6,2),
		RampUpDays6 numeric(6,2),
		Week6MinQty as AvgDailyDemand*MinDays6,
		Week6MaxQty as AvgDailyDemand*MaxDays6,
		WeekDate7 datetime,
		Week7Balance int,
		MinDays7 numeric(6,2),
		MaxDays7 numeric(6,2),
		RampUpDays7 numeric(6,2),
		Week7MinQty as AvgDailyDemand*MinDays7,
		Week7MaxQty as AvgDailyDemand*MaxDays7,
		WeekDate8 datetime,
		Week8Balance int,
		MinDays8 numeric(6,2),
		MaxDays8 numeric(6,2),
		RampUpDays8 numeric(6,2),
		Week8MinQty as AvgDailyDemand*MinDays8,
		Week8MaxQty as AvgDailyDemand*MaxDays8,
		WeekDate9 datetime,
		Week9Balance int,
		MinDays9 numeric(6,2),
		MaxDays9 numeric(6,2),
		RampUpDays9 numeric(6,2),
		Week9MinQty as AvgDailyDemand*MinDays9,
		Week9MaxQty as AvgDailyDemand*MaxDays9,
		WeekDate10 datetime,
		Week10Balance int,
		MinDays10 numeric(6,2),
		MaxDays10 numeric(6,2),
		RampUpDays10 numeric(6,2),
		Week10MinQty as AvgDailyDemand*MinDays10,
		Week10MaxQty as AvgDailyDemand*MaxDays10,
		WeekDate11 datetime,
		Week11Balance int,
		MinDays11 numeric(6,2),
		MaxDays11 numeric(6,2),
		RampUpDays11 numeric(6,2),
		Week11MinQty as AvgDailyDemand*MinDays11,
		Week11MaxQty as AvgDailyDemand*MaxDays11,
		WeekDate12 datetime,
		Week12Balance int,
		MinDays12 numeric(6,2),
		MaxDays12 numeric(6,2),
		RampUpDays12 numeric(6,2),
		Week12MinQty as AvgDailyDemand*MinDays12,
		Week12MaxQty as AvgDailyDemand*MaxDays12,
		WeekDate13 datetime,
		Week13Balance int,
		MinDays13 numeric(6,2),
		MaxDays13 numeric(6,2),
		RampUpDays13 numeric(6,2),
		Week13MinQty as AvgDailyDemand*MinDays13,
		Week13MaxQty as AvgDailyDemand*MaxDays13,
		WeekDate14 datetime,
		Week14Balance int,
		MinDays14 numeric(6,2),
		MaxDays14 numeric(6,2),
		RampUpDays14 numeric(6,2),
		Week14MinQty as AvgDailyDemand*MinDays14,
		Week14MaxQty as AvgDailyDemand*MaxDays14,
		WeekDate15 datetime,
		Week15Balance int,
		MinDays15 numeric(6,2),
		MaxDays15 numeric(6,2),
		RampUpDays15 numeric(6,2),
		Week15MinQty as AvgDailyDemand*MinDays15,
		Week15MaxQty as AvgDailyDemand*MaxDays15,
		WeekDate16 datetime,
		Week16Balance int,
		MinDays16 numeric(6,2),
		MaxDays16 numeric(6,2),
		RampUpDays16 numeric(6,2),
		Week16MinQty as AvgDailyDemand*MinDays16,
		Week16MaxQty as AvgDailyDemand*MaxDays16)
		
		
 insert #TargetPreResults (
 CalculatedABC,
 BasePart,
 UnitCost, 
 SOP,
 EOP,
 PartPhase,
 FixedMinDays,
 FixedMaxDays,
 CalculatedMinDays ,
 CalculatedMaxDays,
 CurrentRampUpDays , 
 CurrentMinDays,
 CurrentMaxDays,
 CurrentInventory,
 CurrentInventoryCost, 
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
 RampUpDays0, 
 WeekDate1,
 Week1Balance,
 MinDays1,
 MaxDays1,
 RampUpDays1,  
 WeekDate2,
 Week2Balance,
 MinDays2,
 MaxDays2,
 RampUpDays2,  
 WeekDate3,
 Week3Balance,
 MinDays3,
 MaxDays3,
 RampUpDays3,  
 WeekDate4,
 Week4Balance,
 MinDays4,
 MaxDays4,
 RampUpDays4,  
 WeekDate5,
 Week5Balance,
 MinDays5,
 MaxDays5,
 RampUpDays5,  
 WeekDate6,
 Week6Balance,
 MinDays6,
 MaxDays6,
 RampUpDays6,  
  WeekDate7,
 Week7Balance,
 MinDays7,
 MaxDays7,
 RampUpDays7,  
 WeekDate8,
 Week8Balance,
 MinDays8,
 MaxDays8,
 RampUpDays8,  
 WeekDate9,
 Week9Balance,
 MinDays9,
 MaxDays9,
 RampUpDays9,  
 WeekDate10,
 Week10Balance,
 MinDays10,
 MaxDays10,
 RampUpDays10,  
 WeekDate11,
 Week11Balance,
 MinDays11,
 MaxDays11,
 RampUpDays11,  
 WeekDate12,
 Week12Balance,
 MinDays12,
 MaxDays12,
 RampUpDays12,  
 WeekDate13,
 Week13Balance,
 MinDays13,
 MaxDays13,
 RampUpDays13,  
 WeekDate14,
 Week14Balance,
 MinDays14,
 MaxDays14,
 RampUpDays14,  
 WeekDate15,
 Week15Balance,
 MinDays15,
 MaxDays15,
 RampUpDays15,  
 WeekDate16,
 Week16Balance,
 MinDays16,
 MaxDays16,
 RampUpDays16  ) 
    
   
    SELECT	
 CalculatedABC,
 BP.BasePart,
 UnitCost, 
 SOP,
 EOP,
 PartPhase,
 FixedMinDays,
 FixedMaxDays,
 CalculatedMinDays ,
 CalculatedMaxDays,
 CurrentRampUpDays ,  
 CurrentEffectiveMinDays,
 CurrentEffectiveMaxDays,
 CurrentOnHand,
 CurrentOnHand*UnitCost ,
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
 RAmpUpDays0, 
 WeekDate1,
 Balance1,
 MinDays1,
 MaxDays1,
 RampUpDays1,  
 WeekDate2,
 Balance2,
 MinDays2,
 MaxDays2,
 RampUpDays2,  
 WeekDate3,
 Balance3,
 MinDays3,
 MaxDays3,
 RampUpDays3,  
 WeekDate4,
 Balance4,
 MinDays4,
 MaxDays4,
 RampUpDays4,  
 WeekDate5,
 Balance5,
 MinDays5,
 MaxDays5,
 RampUpDays5,  
 WeekDate6,
 Balance6,
 MinDays6,
 MaxDays6,
 RampUpDays6,  
  WeekDate7,
 Balance7,
 MinDays7,
 MaxDays7,
 RampUpDays7,  
 WeekDate8,
 Balance8,
 MinDays8,
 MaxDays8,
 RampUpDays8,  
 WeekDate9,
 Balance9,
 MinDays9,
 MaxDays9,
 RampUpDays9,  
 WeekDate10,
 Balance10,
 MinDays10,
 MaxDays10,
 RampUpDays10,  
 WeekDate11,
 Balance11,
 MinDays11,
 MaxDays11,
 RampUpDays11,  
 WeekDate12,
 Balance12,
 MinDays12,
 MaxDays12,
 RampUpDays12,  
 WeekDate13,
 Balance13,
 MinDays13,
 MaxDays13,
 RampUpDays13,  
 WeekDate14,
 Balance14,
 MinDays14,
 MaxDays14,
 RampUpDays14,  
 WeekDate15,
 Balance15,
 MinDays15,
 MaxDays15,
RampUpDays15,  
 WeekDate16,
 Balance16,
 MinDays16,
 MaxDays16,
RampUpDays16
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
 max(FixedMinDays) as FixedMinDays,
 max(FixedMaxDays) as FixedMaxDays,
 max(CalculatedMinDays) as CalculatedMindays ,
 max(CalculatedMaxDays) as CalculatedMaxDays,
 max(CurrentRampUpDays) as CurrentRampUpDays,  
 max(CurrentMinDays) as CurrentMinDays,
 max(CurrentMaxDays) as CurrentMaxDays,
 max(CurrentInventory) as CurrentInventory,
 max(CurrentInventorycost) as CurrentInventoryCost, 
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
 max(RampUpDays0) as RampDays0, 
 case when sum(Week0Balance) < (max(Mindays0)*max(AvgDailyDemand)) then sum(Week0Balance) - (max(Mindays0)*max(AvgDailyDemand)) else 0 end as Week0MinVariance,
 case when sum(Week0Balance) > (max(Maxdays0)*max(AvgDailyDemand)) then (sum(Week0Balance) - (max(Maxdays0)*max(AvgDailyDemand)) ) else 0 end as Week0MaxVariance,
 max(WeekDate1) as WeekDate1,
 sum(Week1Balance) as Week1Balance,
 max(MinDays1) as MinDays1,
 max(MaxDays1) as MaxDays1,
 max(RampUpDays1) as RampDays1,  
 case when sum(Week1Balance) < (max(Mindays1)*max(AvgDailyDemand)) then sum(Week1Balance) - (max(Mindays1)*max(AvgDailyDemand)) else 0 end as Week1MinVariance,
 case when sum(Week1Balance) > (max(Maxdays1)*max(AvgDailyDemand)) then (sum(Week1Balance) - (max(Maxdays1)*max(AvgDailyDemand))) else 0 end as Week1MaxVariance,
 max(WeekDate2) as WeekDate2,
 sum(Week2Balance) as Week2Balance,
 max(MinDays2) as MinDays2,
 max(MaxDays2) as MaxDays2,
 max(RampUpDays2) as RampDays2,  
 case when sum(Week2Balance) < (max(Mindays2)*max(AvgDailyDemand)) then sum(Week2Balance) - (max(Mindays2)*max(AvgDailyDemand)) else 0 end as Week2MinVariance,
 case when sum(Week2Balance) > (max(Maxdays2)*max(AvgDailyDemand)) then (sum(Week2Balance) - (max(Maxdays2)*max(AvgDailyDemand))) else 0 end as Week2MaxVariance,
 max(WeekDate3) as WeekDate3,
 sum(Week3Balance) as Week3Balance,
 max(MinDays3) as MinDays3,
 max(MaxDays3) as MaxDays3,
 max(RampUpDays3) as RampDays3,  
 case when sum(Week3Balance) < (max(Mindays3)*max(AvgDailyDemand)) then sum(Week3Balance) - (max(Mindays3)*max(AvgDailyDemand)) else 0 end as Week3MinVariance,
 case when sum(Week3Balance) > (max(Maxdays3)*max(AvgDailyDemand)) then (sum(Week3Balance) - (max(Maxdays3)*max(AvgDailyDemand))) else 0 end as Week3MaxVariance,
 max(WeekDate4) as WeekDate4,
 sum(Week4Balance) as Week4Balance,
 max(MinDays4) as MinDays4,
 max(MaxDays4) as MaxDays4,
max(RampUpDays4) as RampDays4,  
 case when sum(Week4Balance) < (max(Mindays4)*max(AvgDailyDemand)) then sum(Week4Balance) - (max(Mindays4)*max(AvgDailyDemand)) else 0 end as Week4MinVariance,
 case when sum(Week4Balance) > (max(Maxdays4)*max(AvgDailyDemand)) then (sum(Week4Balance) - (max(Maxdays4)*max(AvgDailyDemand))) else 0 end as Week4MaxVariance,
 max(WeekDate5) as WeekDate5,
 sum(Week5Balance) as Week5Balance,
 max(MinDays5) as MinDays5,
 max(MaxDays5) as MaxDays5,
 max(RampUpDays5) as RampDays5,   
 case when sum(Week5Balance) < (max(Mindays5)*max(AvgDailyDemand)) then sum(Week5Balance) - (max(Mindays5)*max(AvgDailyDemand)) else 0 end as Week5MinVariance,
 case when sum(Week5Balance) > (max(Maxdays5)*max(AvgDailyDemand)) then (sum(Week5Balance) - (max(Maxdays5)*max(AvgDailyDemand))) else 0 end as Week5MaxVariance, 
 case when sum(Week5Balance) > (max(Maxdays5)*max(AvgDailyDemand)) then ((sum(Week5Balance)-(max(Maxdays5)*max(AvgDailyDemand)))*max(UnitCost) ) else 0 end as Week5MaxVarianceCost,   
 max(WeekDate6) as WeekDate6,
 sum(Week6Balance) as Week6Balance,
 max(MinDays6) as MinDays6,
 max(MaxDays6) as MaxDays6,
 max(RampUpDays6) as RampDays6,   
 case when sum(Week6Balance) < (max(Mindays6)*max(AvgDailyDemand)) then sum(Week6Balance) - (max(Mindays6)*max(AvgDailyDemand)) else 0 end as Week6MinVariance,
 case when sum(Week6Balance) > (max(Maxdays6)*max(AvgDailyDemand)) then (sum(Week6Balance) - (max(Maxdays6)*max(AvgDailyDemand))) else 0 end as Week6MaxVariance, 
 max(WeekDate7) as WeekDate7,
 sum(Week7Balance) as Week7Balance,
 max(MinDays7) as MinDays7,
 max(MaxDays7) as MaxDays7,
 max(RampUpDays7) as RampDays7,   
 case when sum(Week7Balance) < (max(Mindays7)*max(AvgDailyDemand)) then sum(Week7Balance) - (max(Mindays7)*max(AvgDailyDemand)) else 0 end as Week7MinVariance,
 case when sum(Week7Balance) > (max(Maxdays7)*max(AvgDailyDemand)) then (sum(Week7Balance) - (max(Maxdays7)*max(AvgDailyDemand))) else 0 end as Week7MaxVariance, 
 max(WeekDate8) as WeekDate8,
 sum(Week8Balance) as Week8Balance,
 max(MinDays8) as MinDays8,
 max(MaxDays8) as MaxDays8,
 max(RampUpDays8) as RampDays8,   
 case when sum(Week8Balance) < (max(Mindays8)*max(AvgDailyDemand)) then sum(Week8Balance) - (max(Mindays8)*max(AvgDailyDemand)) else 0 end as Week8MinVariance,
 case when sum(Week8Balance) > (max(Maxdays8)*max(AvgDailyDemand)) then (sum(Week8Balance) - (max(Maxdays8)*max(AvgDailyDemand))) else 0 end as Week8MaxVariance,
 max(WeekDate9) as WeekDate9,
 sum(Week9Balance) as Week9Balance,
 max(MinDays9) as MinDays9,
 max(MaxDays9) as MaxDays9,
 max(RampUpDays9) as RampDays9,   
 case when sum(Week9Balance) < (max(Mindays9)*max(AvgDailyDemand)) then sum(Week9Balance) - (max(Mindays9)*max(AvgDailyDemand)) else 0 end as Week9MinVariance,
 case when sum(Week9Balance) > (max(Maxdays9)*max(AvgDailyDemand)) then (sum(Week9Balance) - (max(Maxdays9)*max(AvgDailyDemand))) else 0 end as Week9MaxVariance,
 max(WeekDate10) as WeekDate10,
 sum(Week10Balance) as Week10Balance,
 max(MinDays10) as MinDays10,
 max(MaxDays10) as MaxDays10,
 max(RampUpDays10) as RampDays10,   
 case when sum(Week10Balance) < (max(Mindays10)*max(AvgDailyDemand)) then sum(Week10Balance) - (max(Mindays10)*max(AvgDailyDemand)) else 0 end as Week10MinVariance,
 case when sum(Week10Balance) > (max(Maxdays10)*max(AvgDailyDemand)) then (sum(Week10Balance) - (max(Maxdays10)*max(AvgDailyDemand))) else 0 end as Week10MaxVariance, 
case when sum(Week10Balance) > (max(Maxdays10)*max(AvgDailyDemand)) then ((sum(Week10Balance)-(max(Maxdays10)*max(AvgDailyDemand)))*max(UnitCost) ) else 0 end as Week10MaxVarianceCost,   
 max(WeekDate11) as WeekDate11,
 sum(Week11Balance) as Week11Balance,
 max(MinDays11) as MinDays11,
 max(MaxDays11) as MaxDays11,
 max(RampUpDays11) as RampDays11,   
 case when sum(Week11Balance) < (max(Mindays11)*max(AvgDailyDemand)) then sum(Week11Balance) - (max(Mindays11)*max(AvgDailyDemand)) else 0 end as Week11MinVariance,
 case when sum(Week11Balance) > (max(Maxdays11)*max(AvgDailyDemand)) then (sum(Week11Balance) - (max(Maxdays11)*max(AvgDailyDemand))) else 0 end as Week11MaxVariance, 
 max(WeekDate12) as WeekDate12,
 sum(Week12Balance) as Week12Balance,
 max(MinDays12) as MinDays12,
 max(MaxDays12) as MaxDays12,
 max(RampUpDays12) as RampDays12,   
 case when sum(Week12Balance) < (max(Mindays12)*max(AvgDailyDemand)) then sum(Week12Balance) - (max(Mindays12)*max(AvgDailyDemand)) else 0 end as Week12MinVariance,
 case when sum(Week12Balance) > (max(Maxdays12)*max(AvgDailyDemand)) then (sum(Week12Balance) - (max(Maxdays12)*max(AvgDailyDemand))) else 0 end as Week12MaxVariance, 
 max(WeekDate13) as WeekDate13,
 sum(Week13Balance) as Week13Balance,
 max(MinDays13) as MinDays13,
 max(MaxDays13) as MaxDays13,
 max(RampUpDays13) as RampDays13,   
 case when sum(Week13Balance) < (max(Mindays13)*max(AvgDailyDemand)) then sum(Week13Balance) - (max(Mindays13)*max(AvgDailyDemand)) else 0 end as Week13MinVariance,
 case when sum(Week13Balance) > (max(Maxdays13)*max(AvgDailyDemand)) then (sum(Week13Balance) - (max(Maxdays13)*max(AvgDailyDemand))) else 0 end as Week13MaxVariance,  
 max(WeekDate14) as WeekDate14,
 sum(Week14Balance) as Week14Balance,
 max(MinDays14) as MinDays14,
 max(MaxDays14) as MaxDays14,
 max(RampUpDays14) as RampDays14,   
 case when sum(Week14Balance) < (max(Mindays14)*max(AvgDailyDemand)) then sum(Week14Balance) - (max(Mindays14)*max(AvgDailyDemand)) else 0 end as Week14MinVariance,
 case when sum(Week14Balance) > (max(Maxdays14)*max(AvgDailyDemand)) then (sum(Week14Balance) - (max(Maxdays14)*max(AvgDailyDemand))) else 0 end as Week14MaxVariance, 
 max(WeekDate15) as WeekDate15,
 sum(Week15Balance) as Week15Balance,
 max(MinDays15) as MinDays15,
 max(MaxDays15) as MaxDays15,
 max(RampUpDays15) as RampDays15,   
 case when sum(Week15Balance) < (max(Mindays15)*max(AvgDailyDemand)) then sum(Week15Balance) - (max(Mindays15)*max(AvgDailyDemand)) else 0 end as Week15MinVariance,
 case when sum(Week15Balance) > (max(Maxdays15)*max(AvgDailyDemand)) then (sum(Week15Balance) - (max(Maxdays15)*max(AvgDailyDemand))) else 0 end as Week15MaxVariance, 
 max(WeekDate16) as WeekDate16,
 sum(Week16Balance) as Week16Balance,
 max(MinDays16) as MinDays16,
 max(MaxDays16) as MaxDays16,
 max(RampUpDays16) as RampDays16,   
 case when sum(Week16Balance) < (max(Mindays16)*max(AvgDailyDemand)) then sum(Week16Balance) - (max(Mindays16)*max(AvgDailyDemand)) else 0 end as Week16MinVariance,
 case when sum(Week16Balance) > (max(Maxdays16)*max(AvgDailyDemand)) then (sum(Week16Balance) - (max(Maxdays16)*max(AvgDailyDemand))) else 0 end as Week16MaxVariance,
  COALESCE((SELECT MAX(scheduler) FROM dbo.destination JOIN dbo.customer ON destination.customer = dbo.customer.customer JOIN dbo.part_customer ON dbo.customer.customer = dbo.part_customer.customer WHERE left(part_customer.part,7) = BasePart), 'NotDefined' )as Scheduler 
  into #TargetPreResults2
from
#TargetPreResults
group by BasePart

select	CalculatedABC ,
            UnitCost ,
            BasePart ,
            SOP ,
            EOP ,
            PartPhase ,
            FixedMinDays,
			FixedMaxDays,
			CalculatedMinDays ,
			CalculatedMaxDays,
			CurrentRampUpDays , 
            CurrentMinDays ,
            CurrentMaxDays ,
            CurrentInventory ,
            Convert(numeric(10,2), round((case when CurrentMinQtyVariance<0 then CurrentMinQtyVariance*1.00/nullif(AvgDailyDemand*1.00,0.00) when CurrentMaxQtyVariance>0 then CurrentMaxQtyVariance*1.00/nullif(AvgDailyDemand*1.00,0.00) else 0.00 end ),2))  as CurrentTargetDaysVAriance,
            CurrentInventoryCost ,
            CurrentMinQty ,
            CurrentMaxQty ,
            CurrentMinCost ,
            CurrentMaxCost ,
            CurrentMinQtyVariance ,
            CurrentMaxQtyVariance ,
            CurrentMinCostVariance ,
            CurrentMaxCostVariance ,
            AvgDailyDemand ,
            WeekDate0 ,
            Week0Balance ,
            MinDays0 ,
            MaxDays0 ,
            RampDays0,
            case when Week0MinVariance<0 then Week0MinVariance when Week0MaxVariance>0 then Week0MaxVariance else 0 end as Week0TargetVariance ,
            Convert(numeric(6,1), round((case when Week0MinVariance<0 then Week0MinVariance/nullif(AvgDailyDemand,0) when Week0MaxVariance>0 then Week0MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week0TargetDaysVariance ,
            WeekDate1 ,
            Week1Balance ,
            MinDays1 ,
            MaxDays1 ,
            RampDays1,
            case when Week1MinVariance<0 then Week1MinVariance when Week1MaxVariance>0 then Week1MaxVariance else 0 end as Week1TargetVariance ,
            Convert(numeric(6,1), round((case when Week1MinVariance<0 then Week1MinVariance/nullif(AvgDailyDemand,0) when Week1MaxVariance>0 then Week1MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week1TargetDaysVariance ,
            WeekDate2 ,
            Week2Balance ,
            MinDays2 ,
            MaxDays2 ,
             RampDays2,
            case when Week2MinVariance<0 then Week2MinVariance when Week2MaxVariance>0 then Week2MaxVariance else 0 end as Week2TargetVariance ,
            Convert(numeric(6,1), round((case when Week2MinVariance<0 then Week2MinVariance/nullif(AvgDailyDemand,0) when Week2MaxVariance>0 then Week2MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week2TargetDaysVariance ,
            WeekDate3 ,
            Week3Balance ,
            MinDays3 ,
            MaxDays3 ,
             RampDays3,
            case when Week3MinVariance<0 then Week3MinVariance when Week3MaxVariance>0 then Week3MaxVariance else 0 end as Week3TargetVariance ,
            Convert(numeric(6,1), round((case when Week3MinVariance<0 then Week3MinVariance/nullif(AvgDailyDemand,0) when Week3MaxVariance>0 then Week3MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week3TargetDaysVariance ,
            WeekDate4 ,
            Week4Balance ,
            MinDays4 ,
            MaxDays4 ,
             RampDays4,
            case when Week4MinVariance<0 then Week4MinVariance when Week4MaxVariance>0 then Week4MaxVariance else 0 end as Week4TargetVariance ,
            Convert(numeric(6,1), round((case when Week4MinVariance<0 then Week4MinVariance/nullif(AvgDailyDemand,0) when Week4MaxVariance>0 then Week4MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week4TargetDaysVariance ,
            WeekDate5 ,
            Week5Balance ,
            MinDays5 ,
            MaxDays5 ,
             RampDays5,
           case when Week5MinVariance<0 then Week5MinVariance when Week5MaxVariance>0 then Week5MaxVariance else 0 end as Week5TargetVariance ,
           Convert(numeric(6,1), round((case when Week5MinVariance<0 then Week5MinVariance/nullif(AvgDailyDemand,0) when Week5MaxVariance>0 then Week5MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week5TargetDaysVariance , 
            Week5MaxVarianceCost ,
            WeekDate6 ,
            Week6Balance ,
            MinDays6 ,
            MaxDays6 ,
             RampDays6,
            case when Week6MinVariance<0 then Week6MinVariance when Week6MaxVariance>0 then Week6MaxVariance else 0 end as Week6TargetVariance ,
            Convert(numeric(6,1), round((case when Week6MinVariance<0 then Week6MinVariance/nullif(AvgDailyDemand,0) when Week6MaxVariance>0 then Week6MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week6TargetDaysVariance ,
            WeekDate7 ,
            Week7Balance ,
            MinDays7 ,
            MaxDays7 ,
             RampDays7,
            case when Week7MinVariance<0 then Week7MinVariance when Week7MaxVariance>0 then Week7MaxVariance else 0 end as Week7TargetVariance ,
            Convert(numeric(6,1), round((case when Week7MinVariance<0 then Week7MinVariance/nullif(AvgDailyDemand,0) when Week7MaxVariance>0 then Week7MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week7TargetDaysVariance ,
            WeekDate8 ,
            Week8Balance ,
            MinDays8 ,
            MaxDays8 ,
             RampDays8,
           case when Week8MinVariance<0 then Week8MinVariance when Week8MaxVariance>0 then Week8MaxVariance else 0 end as Week8TargetVariance ,
          Convert(numeric(6,1), round((case when Week8MinVariance<0 then Week8MinVariance/nullif(AvgDailyDemand,0) when Week8MaxVariance>0 then Week8MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week8TargetDaysVariance , 
            WeekDate9 ,
            Week9Balance ,
            MinDays9 ,
            MaxDays9 ,
             RampDays9,
            case when Week9MinVariance<0 then Week9MinVariance when Week9MaxVariance>0 then Week9MaxVariance else 0 end as Week9TargetVariance ,
            Convert(numeric(6,1), round((case when Week9MinVariance<0 then Week9MinVariance/nullif(AvgDailyDemand,0) when Week9MaxVariance>0 then Week9MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week9TargetDaysVariance ,
            WeekDate10 ,
            Week10Balance ,
            MinDays10 ,
            MaxDays10 ,
             RampDays10,
           case when Week10MinVariance<0 then Week10MinVariance when Week10MaxVariance>0 then Week10MaxVariance else 0 end as Week10TargetVariance ,
          Convert(numeric(6,1), round((case when Week10MinVariance<0 then Week10MinVariance/nullif(AvgDailyDemand,0) when Week10MaxVariance>0 then Week10MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week10TargetDaysVariance , 
            Week10MaxVarianceCost ,
            WeekDate11 ,
            Week11Balance ,
            MinDays11 ,
            MaxDays11 ,
             RampDays11,
            case when Week11MinVariance<0 then Week11MinVariance when Week11MaxVariance>0 then Week11MaxVariance else 0 end as Week11TargetVariance ,
            Convert(numeric(6,1), round((case when Week11MinVariance<0 then Week11MinVariance/nullif(AvgDailyDemand,0) when Week11MaxVariance>0 then Week11MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week11TargetDaysVariance ,
            WeekDate12 ,
            Week12Balance ,
            MinDays12 ,
            MaxDays12 ,
             RampDays12,
            case when Week12MinVariance<0 then Week12MinVariance when Week12MaxVariance>0 then Week12MaxVariance else 0 end as Week12TargetVariance ,
            Convert(numeric(6,1), round((case when Week12MinVariance<12 then Week12MinVariance/nullif(AvgDailyDemand,0) when Week12MaxVariance>0 then Week12MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week12TargetDaysVariance ,
            WeekDate13 ,
            Week13Balance ,
            MinDays13 ,
            MaxDays13 ,
             RampDays13,
            case when Week13MinVariance<0 then Week13MinVariance when Week13MaxVariance>0 then Week13MaxVariance else 0 end as Week13TargetVariance ,
            Convert(numeric(6,1), round((case when Week13MinVariance<1 then Week13MinVariance/nullif(AvgDailyDemand,0) when Week13MaxVariance>0 then Week13MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week13TargetDaysVariance ,
            WeekDate14 ,
            Week14Balance ,
            MinDays14 ,
            MaxDays14 ,
             RampDays14,
            case when Week14MinVariance<0 then Week14MinVariance when Week14MaxVariance>0 then Week14MaxVariance else 0 end as Week14TargetVariance ,
            Convert(numeric(6,1), round((case when Week14MinVariance<1 then Week14MinVariance/nullif(AvgDailyDemand,0) when Week14MaxVariance>0 then Week14MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1)) as Week14TargetDaysVariance ,
            WeekDate15 ,
            Week15Balance ,
            MinDays15 ,
            MaxDays15 ,
             RampDays15,
            case when Week15MinVariance<0 then Week15MinVariance when Week15MaxVariance>0 then Week15MaxVariance else 0 end as Week15TargetVariance ,
            Convert(numeric(6,1), round((case when Week15MinVariance<1 then Week15MinVariance/nullif(AvgDailyDemand,0) when Week15MaxVariance>0 then Week15MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1))as Week15TargetDaysVariance ,
            WeekDate16 ,
            Week16Balance ,
            MinDays16 ,
            MaxDays16 ,
             RampDays16,
            case when Week16MinVariance<0 then Week16MinVariance when Week16MaxVariance>0 then Week16MaxVariance else 0 end as Week16TargetVariance ,
            Convert(numeric(6,1), round((case when Week16MinVariance<1 then Week16MinVariance/nullif(AvgDailyDemand,0) when Week16MaxVariance>0 then Week16MaxVariance/nullif(AvgDailyDemand,0) else 0 end ),1))as Week16TargetDaysVariance ,
            Scheduler,
            round((case when nullif(AvgDailyDemand,0) = 0 then 999 else convert(numeric(10,2),CurrentInventory)/nullif(AvgDailyDemand,0.00) end),2)/1.00 as CurrentDaysOnHand
from	 #TargetPreResults2
order by basePart
 

 DROP	TABLE dbo.RunningInventory

    COMMIT


















GO
