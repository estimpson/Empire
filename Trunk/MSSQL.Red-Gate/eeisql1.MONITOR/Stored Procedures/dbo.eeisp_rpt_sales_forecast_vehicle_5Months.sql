SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE	procedure [dbo].[eeisp_rpt_sales_forecast_vehicle_5Months] (@forecastID varchar(10))
as
--eeisp_rpt_sales_forecast_vehicle_5Months '2015-11'
begin 

Select	BasePart.Base_Part,
		Vehicle,
		(CASE WHEN BasePart_Demand =  0 THEN BasePartCountPercent ELSE isNULL(BasePart_vehicle_Demand/nullif(BasePart_Demand,0),0) END) as DemandPercentage,
		BasePartCountPercent,
		BasePartCount
into		#BasePartVehiclePercent
from		(
select	base_part as base_part, 
		b.badge+' '+b.nameplate as vehicle,
		(isNULL(SUM(JAN_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(FEB_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(MAR_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(MAY_16*a.take_rate*a.family_allocation*a.qty_per),0)) as BasePart_vehicle_Demand
from		eeiuser.acctg_csm_base_part_mnemonic a 
left join	eeiuser.acctg_csm_nacsm b on a.mnemonic = b.mnemonic 
where	b.release_id = @forecastID
   and	b.program <> '' 
   and	a.take_rate*a.family_allocation*a.qty_per <> 0  and
		version != 'Empire'
group by base_part,
		b.badge+' '+b.nameplate
) BasePartVehicle join

(select	base_part as base_part, 
		(isNULL(SUM(JAN_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(FEB_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(MAR_16*a.take_rate*a.family_allocation*a.qty_per),0) + isNULL(SUM(MAY_16*a.take_rate*a.family_allocation*a.qty_per),0))  as BasePart_Demand,
		convert( numeric (20,6) , [MONITOR].[dbo].[ReturnInverse](count(a.mnemonic))) as BasePartCountPercent,
		count(a.mnemonic) as BasePartCount
from		eeiuser.acctg_csm_base_part_mnemonic a 
left join	eeiuser.acctg_csm_nacsm b on a.mnemonic = b.mnemonic 
where	b.release_id = @forecastID
   and	b.program <> '' 
   and	a.take_rate*a.family_allocation*a.qty_per <> 0 and
		version != 'Empire'
group by base_part
) BasePart on BasePartVehicle.Base_Part = BasePart.Base_Part 
order by 1, 2



  	declare 
       		@currentdate						datetime,
		@firstdayofpriormonth1		datetime,
       		@lastdayofpriormonth1			datetime,
       		@firstdayofpriormonth		datetime,
       		@lastdayofpriormonth			datetime,
       		@firstdayofcurrentmonth 	datetime,
       		@lastdayofcurrentmonth 	datetime,
       		@firstdayofcurrentmonth1 	datetime,
       		@lastdayofcurrentmonth1 	datetime,
       		@firstdayofcurrentmonth2 	datetime,
       		@lastdayofcurrentmonth2 	datetime,
       		@firstdayofcurrentmonth3 	datetime,
       		@lastdayofcurrentmonth3	datetime,
		@firstdayofcurrentmonth4 	datetime,
       		@lastdayofcurrentmonth4	datetime,
		@firstdayofcurrentmonth5 	datetime,
       		@lastdayofcurrentmonth5	datetime,
		@firstdayofcurrentmonth6 	datetime,
       		@lastdayofcurrentmonth6	datetime,
		@firstdayofcurrentmonth7 	datetime,
       		@lastdayofcurrentmonth7	datetime,
       		@firstdayofyear					datetime
       		
       		Select @currentdate = getdate()
       		
       		Select	@firstdayofyear = convert( datetime , convert(char(4),year(@currentdate))+'-'+'01'+'-'+'01')
       		Select	@firstdayofcurrentmonth = convert( datetime , convert(char(4),year(@currentdate))+'-'+convert(char(2),month(@currentdate))+'-'+'01')
       		Select	@lastdayofcurrentmonth =  dateadd( dd, -1 , dateadd( mm, 1, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth1 = dateadd(mm,1,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth1 = dateadd( dd, -1 , dateadd( mm, 2, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth2 = dateadd(mm,2,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth2 = dateadd( dd, -1 , dateadd( mm, 3, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth3 = dateadd(mm,3,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth3 = dateadd( dd, -1 , dateadd( mm, 4, @firstdayofcurrentmonth))
		Select	@firstdayofcurrentmonth4 = dateadd(mm,4,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth4 = dateadd( dd, -1 , dateadd( mm, 5, @firstdayofcurrentmonth))
		Select	@firstdayofcurrentmonth5 = dateadd(mm,5,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth5 = dateadd( dd, -1 , dateadd( mm, 6, @firstdayofcurrentmonth))
		Select	@firstdayofcurrentmonth6 = dateadd(mm,6,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth6 = dateadd( dd, -1 , dateadd( mm, 7, @firstdayofcurrentmonth))
		Select	@firstdayofcurrentmonth7 = dateadd(mm,7,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth7 = dateadd( dd, -1 , dateadd( mm, 8, @firstdayofcurrentmonth))
       		Select	@firstdayofpriormonth = dateadd(mm,-1, @firstdayofcurrentmonth)
       		Select	@lastdayofpriormonth = dateadd( dd, -1 , dateadd( mm, 0, @firstdayofcurrentmonth))
		Select	@firstdayofpriormonth1 = dateadd(mm,-2, @firstdayofcurrentmonth)
       		Select	@lastdayofpriormonth1 = dateadd( dd, -1 , dateadd( mm, 0, @firstdayofpriormonth))
       		

      




create table #saleshistoryandforecast1 (
						team						varchar (25),
						customerprefix		char(3),
						part							varchar (25)
						)
Create table #saleshistoryandforecast (
						team						varchar (25),
						customerprefix		char(3),
						part							varchar (25)
						)
						
						Insert	#saleshistoryandforecast1	
						Select		Team,
									substring(basepart,1,3),
									basepart
						from		vw_eei_sales_history
						Union
						Select		Team,
									substring(basepart,1,3),
									basepart
						from		vw_eei_sales_forecast

Insert	#saleshistoryandforecast	
						Select		max(Team),
									CustomerPrefix,
									part
						from			#saleshistoryandforecast1
						Group by		CustomerPrefix,
									part
						
						
						Create table #sales( 	team varchar(25),
								customer	varchar(15),
								part			varchar(25),
							 	YTDSales numeric (20,6),
								YTDSalesDollars numeric (20,6),
							 	PriorMonthSales numeric (20,6),
							 	PriorMonthSalesDollars numeric (20,6),
								PriorMonth1Sales numeric (20,6),
							 	PriorMonthSales1Dollars numeric (20,6),
							 	CurrentMonthSales numeric (20,6),
								CurrentMonthSalesDollars numeric (20,6),
							 	PastDueOrders numeric (20,6),
							 	PastDueOrdersSales numeric (20,6),
								RemainingOrdersDue numeric (20,6),
								RemainingOrdersDueDollars numeric (20,6),
								TotalOrdersDue numeric (20,6),
								TotalOrdersDueDollars numeric (20,6),
	 							Month1OrdersDue numeric (20,6),
	 							Month1OrdersDueDollars numeric (20,6),
								Month2OrdersDue numeric (20,6),
								Month2OrdersDueDollars numeric (20,6),
								Month3OrdersDue numeric (20,6),
								Month3OrdersDueDollars numeric (20,6),
								Month4OrdersDue numeric (20,6),
								Month4OrdersDueDollars numeric (20,6),
								Month5OrdersDue numeric (20,6),
								Month5OrdersDueDollars numeric (20,6),
								Month6OrdersDue numeric (20,6),
								Month6OrdersDueDollars numeric (20,6),
								SOP	datetime,
								EOP	datetime)
															
	insert	#sales					
	select	Team = max (Team),
		CustomerPrefix,
		Part,
		YTDSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofyear and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Qty end), 0),
		YTDSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofyear and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Amount end), 0),
		PriorMonthSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Qty end), 0),
		PriorMonthSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Amount end), 0),
		PriorMonth1Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth1 and SalesHistoryAndForecast.ShipDT < @firstdayofpriormonth then SalesHistoryAndForecast.Qty end), 0),
		PriorMonth1SalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth1 and SalesHistoryAndForecast.ShipDT < @firstdayofpriormonth then SalesHistoryAndForecast.Amount end), 0),
		CurrentMonthSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Qty end), 0),
		CurrentMonthSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Amount end), 0),
		PastDueOrders = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT < @currentdate then SalesHistoryAndForecast.Qty end), 0),
		PastDueOrdersSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT < @currentdate then SalesHistoryAndForecast.Amount end), 0),
		RemainingOrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Qty end), 0),
		RemainingOrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Amount end), 0),
		TotalOrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Qty end), 0),
		TotalOrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth1 then SalesHistoryAndForecast.Amount end), 0),
		Month1OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth1 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth2 then SalesHistoryAndForecast.Qty end), 0),
		Month1OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth1 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth2 then SalesHistoryAndForecast.Amount end), 0),
		Month2OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth2 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth3 then SalesHistoryAndForecast.Qty end), 0),
		Month2OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth2 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth3 then SalesHistoryAndForecast.Amount end), 0),
		Month3OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth3 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth4 then SalesHistoryAndForecast.Qty end), 0),
		Month3OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth3 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth4 then SalesHistoryAndForecast.Amount end), 0),
		Month4OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth4 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth5 then SalesHistoryAndForecast.Qty end), 0),
		Month4OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth4 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth5 then SalesHistoryAndForecast.Amount end), 0),
		Month5OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth5 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth6 then SalesHistoryAndForecast.Qty end), 0),
		Month5OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth5 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth6 then SalesHistoryAndForecast.Amount end), 0),
		Month6OrdersDue = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth6 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth7 then SalesHistoryAndForecast.Qty end), 0),
		Month6OrdersDueDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofcurrentmonth6 and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth7 then SalesHistoryAndForecast.Amount end), 0),
		(select max(prod_start) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= SalesHistoryAndForecast.part) as SOP,
		(select max(prod_end) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= SalesHistoryAndForecast.part) as EOP
	from	(	select	Team = team, Type = 'Forecast', CustomerPrefix = left (BasePart, 3), Part = basepart, ShipDT = date_due, Qty = qty_projected, Amount = extended
			from	vw_eei_sales_forecast
			union all
			select	Team = team, Type = 'History', CustomerPrefix = left (BasePart, 3), Part = basepart, ShipDT = date_shipped, Qty = qty_shipped, Amount = extended
			from	vw_eei_sales_history) SalesHistoryAndForecast
	group by
		SalesHistoryAndForecast.CustomerPrefix,
		SalesHistoryAndForecast.Part


	Select 				team,
						Customer,
						Part,
						(CASE WHEN vehicle is NULL THEN 1*YTDsales ELSE  DemandPercentage*YTDSales END) as YTDsales,
						(CASE WHEN vehicle is NULL THEN 1*YTDsalesDollars ELSE  DemandPercentage*YTDSalesDollars END) as YTDsalesDollars,
						(CASE WHEN vehicle is NULL THEN 1*PriorMonthSales ELSE  DemandPercentage*PriorMonthSales END) as PriorMonthSales,
						(CASE WHEN vehicle is NULL THEN 1*PriorMonthSalesDollars ELSE  DemandPercentage*PriorMonthSalesDollars END) as PriorMonthSalesDollars,
						(CASE WHEN vehicle is NULL THEN 1*PriorMonth1Sales ELSE  DemandPercentage*PriorMonth1Sales END) as PriorMonth1Sales,
						(CASE WHEN vehicle is NULL THEN 1*PriorMonthSales1Dollars ELSE  DemandPercentage*PriorMonthSales1Dollars END) as PriorMonthSales1Dollars,
						(CASE WHEN vehicle is NULL THEN 1*CurrentMonthSales ELSE  DemandPercentage*CurrentMonthSales END) as CurrentMonthSales,
						(CASE WHEN vehicle is NULL THEN 1*CurrentMonthSalesDollars ELSE  DemandPercentage*CurrentMonthSalesDollars END) as CurrentMonthSalesDollars,
						(CASE WHEN vehicle is NULL THEN 1*PastDueOrders ELSE  DemandPercentage*PastDueOrders END) as PastDueOrders,
						(CASE WHEN vehicle is NULL THEN 1*PastDueOrdersSales ELSE  DemandPercentage*PastDueOrdersSales END) as PastDueOrdersSales,
						(CASE WHEN vehicle is NULL THEN 1*RemainingOrdersDue ELSE  DemandPercentage*RemainingOrdersDue END) as RemainingOrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*RemainingOrdersDueDollars ELSE  DemandPercentage*RemainingOrdersDueDollars END) as RemainingOrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*TotalOrdersDue ELSE  DemandPercentage*TotalOrdersDue END) as TotalOrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*TotalOrdersDueDollars ELSE  DemandPercentage*TotalOrdersDueDollars END) as TotalOrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month1OrdersDue ELSE  DemandPercentage*Month1OrdersDue END) as Month1OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month1OrdersDueDollars ELSE  DemandPercentage*Month1OrdersDueDollars END) as Month1OrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month2OrdersDue ELSE  DemandPercentage*Month2OrdersDue END) as Month2OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month2OrdersDueDollars ELSE  DemandPercentage*Month2OrdersDueDollars END) as Month2OrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month3OrdersDue ELSE  DemandPercentage*Month3OrdersDue END) as Month3OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month3OrdersDueDollars ELSE  DemandPercentage*Month3OrdersDueDollars END) as Month3OrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month4OrdersDue ELSE  DemandPercentage*Month4OrdersDue END) as Month4OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month4OrdersDueDollars ELSE  DemandPercentage*Month4OrdersDueDollars END) as Month4OrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month5OrdersDue ELSE  DemandPercentage*Month5OrdersDue END) as Month5OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month5OrdersDueDollars ELSE  DemandPercentage*Month5OrdersDueDollars END) as Month5OrdersDueDollars,
						(CASE WHEN vehicle is NULL THEN 1*Month6OrdersDue ELSE  DemandPercentage*Month6OrdersDue END) as Month6OrdersDue,
						(CASE WHEN vehicle is NULL THEN 1*Month6OrdersDueDollars ELSE  DemandPercentage*Month6OrdersDueDollars END) as Month6OrdersDueDollars,
						SOP,
						EOP,
						IsNULL(Vehicle, 'Not Assigned') as CSMVehicle,
						100*isNULL(DemandPercentage,0) as DemandPercentage,
						BasePartCountPercent,
						BasePartCount
						
						
						
						from 	#sales
						left join	#BasePartVehiclePercent on #Sales.Part = #BasePartVehiclePercent.Base_Part
						where	(PriorMonthSalesDollars+ PriorMonthSales1Dollars+CurrentMonthSalesDollars +	Month1OrdersDueDollars + 	Month2OrdersDueDollars ) >1  and
									part not like 'J1%' and part not like 'J3%'
									order by Part
end

GO
