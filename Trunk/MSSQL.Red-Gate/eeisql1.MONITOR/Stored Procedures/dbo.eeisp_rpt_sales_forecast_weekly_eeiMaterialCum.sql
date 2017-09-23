SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_rpt_sales_forecast_weekly_eeiMaterialCum] 
       as
begin
       	-- eeisp_rpt_sales_forecast_weekly
       	declare 
       		@currentdate				datetime,
		@firstdayofpriorweek		datetime,
       		@firstdayofweek0			datetime,
       		@firstdayofweek1			datetime,
       		@firstdayofweek2			datetime,
       		@firstdayofweek3 			datetime,
       		@firstdayofweek4 			datetime,
       		@firstdayofweek5			datetime,
       		@firstdayofweek6 			datetime,
       		@firstdayofweek7 			datetime,
       		@firstdayofweek8 			datetime,
       		@firstdayofweek9 			datetime,
		@firstdayofweek10 			datetime,
       		@firstdayofweek11 			datetime,
       		@firstdayofweek12 			datetime,
       		@firstdayofweek13 			datetime,
		@firstdayofweek14 			datetime,
		@firstdayofweek15 			datetime,
       		@firstdayofweek16 			datetime,
       		@firstdayofweek17 			datetime,
       		@firstdayofweek18 			datetime,
		@firstdayofweek19 			datetime,
		@firstdayofyear			datetime
       		
		Select @currentdate = getdate()
       		
       		Select	@firstdayofyear = convert( datetime , convert(char(4),year(@currentdate))+'-'+'01'+'-'+'01')
       		Select	@firstdayofpriorweek = Dateadd(wk, -1, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek0 = Dateadd(wk, 0, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek1 = Dateadd(wk, 1, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek2 = Dateadd(wk, 2, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek3 = Dateadd(wk, 3, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek4 = Dateadd(wk, 4, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek5 = Dateadd(wk, 5, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek6 = Dateadd(wk, 6, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek7 = Dateadd(wk, 7, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek8 = Dateadd(wk, 8, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek9 = Dateadd(wk, 9, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek10 = Dateadd(wk, 10, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek11 = Dateadd(wk, 11, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek12 = Dateadd(wk, 12, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek13 = Dateadd(wk, 13, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek14 = Dateadd(wk, 14, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek15 = Dateadd(wk, 15, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek16 = Dateadd(wk, 16, ft.fn_truncDate('wk', @currentdate))
		Select	@firstdayofweek17 = Dateadd(wk, 17, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek18 = Dateadd(wk, 18, ft.fn_truncDate('wk', @currentdate))
       		Select	@firstdayofweek19 = Dateadd(wk, 19, ft.fn_truncDate('wk', @currentdate))
		
       		
	select	Company,
			Team = max (Team),
		Customer,
		Part,
		YTDSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofyear  then SalesHistoryAndForecast.Amount end), 0),
		PriorWeekSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriorweek  and SalesHistoryAndForecast.ShipDT < @firstdayofweek0 then SalesHistoryAndForecast.Amount else 0 end), 0),
		Week0Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek0 and SalesHistoryAndForecast.ShipDT < @firstdayofweek1 then SalesHistoryAndForecast.Amount else 0 end), 0)+ 
					coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek0 and SalesHistoryAndForecast.ShipDT <  @firstdayofweek1  then SalesHistoryAndForecast.Amount else 0 end), 0)+
					coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= dateadd(wk,-2, getdate()) and SalesHistoryAndForecast.ShipDT < @firstdayofweek0 then SalesHistoryAndForecast.Amount else 0 end), 0) ,
		Week1Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek1 and SalesHistoryAndForecast.ShipDT < @firstdayofweek2 then SalesHistoryAndForecast.Amount end), 0),
		Week2Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek2 and SalesHistoryAndForecast.ShipDT < @firstdayofweek3 then SalesHistoryAndForecast.Amount end), 0),
		Week3Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT  >= @firstdayofweek3 and SalesHistoryAndForecast.ShipDT < @firstdayofweek4 then SalesHistoryAndForecast.Amount end), 0),
		Week4Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT  >= @firstdayofweek4 and SalesHistoryAndForecast.ShipDT < @firstdayofweek5 then SalesHistoryAndForecast.Amount end), 0),
		Week5Sales= coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek5 and SalesHistoryAndForecast.ShipDT < @firstdayofweek6 then SalesHistoryAndForecast.Amount end), 0),
		Week6Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek6 and SalesHistoryAndForecast.ShipDT < @firstdayofweek7 then SalesHistoryAndForecast.Amount end), 0),
		Week7Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek7 and SalesHistoryAndForecast.ShipDT < @firstdayofweek8 then SalesHistoryAndForecast.Amount end), 0),
		Week8Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek8 and SalesHistoryAndForecast.ShipDT < @firstdayofweek9 then SalesHistoryAndForecast.Amount end), 0),
		Week9Sales= coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek9 and SalesHistoryAndForecast.ShipDT < @firstdayofweek10 then SalesHistoryAndForecast.Amount end), 0),
		Week10Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek10 and SalesHistoryAndForecast.ShipDT < @firstdayofweek11 then SalesHistoryAndForecast.Amount end), 0),
		Week11Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek11 and SalesHistoryAndForecast.ShipDT < @firstdayofweek12 then SalesHistoryAndForecast.Amount end), 0),
		Week12Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek12 and SalesHistoryAndForecast.ShipDT < @firstdayofweek13 then SalesHistoryAndForecast.Amount end), 0),
		Week13Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek13 and SalesHistoryAndForecast.ShipDT < @firstdayofweek14 then SalesHistoryAndForecast.Amount end), 0),
		Week14Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek14 and SalesHistoryAndForecast.ShipDT < @firstdayofweek15 then SalesHistoryAndForecast.Amount end), 0),
		Week15Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek15 and SalesHistoryAndForecast.ShipDT < @firstdayofweek16 then SalesHistoryAndForecast.Amount end), 0),
		Week16Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek16 and SalesHistoryAndForecast.ShipDT < @firstdayofweek17 then SalesHistoryAndForecast.Amount end), 0),
		Week17Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek17 and SalesHistoryAndForecast.ShipDT < @firstdayofweek18 then SalesHistoryAndForecast.Amount end), 0),
		Week18Sales = coalesce (sum (case when SalesHistoryAndForecast.type = 'Forecast' and SalesHistoryAndForecast.ShipDT >= @firstdayofweek18 and SalesHistoryAndForecast.ShipDT < @firstdayofweek19 then SalesHistoryAndForecast.Amount end), 0),

		(select max(prod_start) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= SalesHistoryAndForecast.part) as SOP,
		(select max(prod_end) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= SalesHistoryAndForecast.part) as EOP,
		FirstDayofCurrentWeek = max(@firstdayofweek0)
	from	(	select	Team = team, Type = 'Forecast', Customer = left (BasePart, 3), Part = basepart, ShipDT = date_due, Qty = qty_projected, Amount = eeiMaterialCumExt, Company = Company
			from	vw_eei_sales_forecast
			union all
			select	Team = team, Type = 'History', Customer = left (BasePart, 3), Part = basepart, ShipDT = date_shipped, Qty = qty_shipped, Amount = eeiMaterialCumExt, Company=Company
			from	vw_eei_sales_history ) SalesHistoryAndForecast
	group by
		SalesHistoryAndForecast.Company,
		SalesHistoryAndForecast.Customer,
		SalesHistoryAndForecast.Part
	having	Part not like 'J[1,3]%'
	order by
		 3,4
       		
       	end
GO
