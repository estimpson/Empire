SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Object:			StoredProcedure [dbo].[eeisp_rpt_sales_forecast]    
Script Date:	10/02/2006 16:47:59
Authors:		Andre Boulanger
				Dan West
		
Use:			Generates the Planning Sales Forecast which is run by the schedulers after completing their planning review on Thursdays of each week 
				[SRVDATA1\DATA\GROUPS\EVERYONE\MONITOR4\REPORTS\PLANNING FORECAST\SalesForecastBO.rpt]
				Sets financial expectations and alerts of part SOP and EOP (very important report!)

Dependencies:	StoredProcedure [dbo].[eeisp_insert_sales_1_w_planning_forecast]
				View [dbo].[vw_eei_sales_forecast]
				View [dbo].[vw_eei_sales_history]
				View [eeiuser].[acctg_csm_vw_select_sales_forecast]
				
Change Log:		2012-06-22 2:00 PM; Dan West
				Temporarily removed the union to ES3_BK db because ES3_BK db deleted and dependent reports won't run
				(will distort the YTD and Prior Year Sales for ES3 sales pre- Oct 1, 2011!)
				After Jan 1, 2013, we may remove the ES3_BK references because effective Oct 1, 2011 all ES3 activity is running through the Monitor db

				2014-07-30 9:54 AM; Dan West
				Replaced references to eeiuser.acctg_csm_vw_select_csmdemandwitheeiadjustments_dw2_NEW_with_MaterialCum with
				eeiuser.acctg_csm_vw_select_sales_forecast

*/


-- exec eeisp_rpt_sales_forecast_5Months

CREATE procedure [dbo].[eeisp_rpt_sales_forecast] 
       as
begin
       	exec [dbo].[eeisp_insert_sales_1_w_planning_forecast]
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
       		@firstdayofyear					datetime
       		
       		Select @currentdate = getdate()
       		
       		Select	@firstdayofyear = convert( datetime , convert(char(4),year(@currentdate))+'-'+'01'+'-'+'01')
       		Select	@firstdayofcurrentmonth = convert( datetime , convert(char(4),year(@currentdate))+'-'+convert(char(2),month(@currentdate))+'-'+'01')
       		Select @lastdayofcurrentmonth =  dateadd( dd, -1 , dateadd( mm, 1, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth1 = dateadd(mm,1,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth1 = dateadd( dd, -1 , dateadd( mm, 2, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth2 = dateadd(mm,2,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth2 = dateadd( dd, -1 , dateadd( mm, 3, @firstdayofcurrentmonth))
       		Select	@firstdayofcurrentmonth3 = dateadd(mm,3,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth3 = dateadd( dd, -1 , dateadd( mm, 4, @firstdayofcurrentmonth))
			Select	@firstdayofcurrentmonth4 = dateadd(mm,4,@firstdayofcurrentmonth)
       		Select	@lastdayofcurrentmonth4 = dateadd( dd, -1 , dateadd( mm, 5, @firstdayofcurrentmonth))
       		Select	@firstdayofpriormonth = dateadd(mm,-1, @firstdayofcurrentmonth)
       		Select	@lastdayofpriormonth = dateadd( dd, -1 , dateadd( mm, 0, @firstdayofcurrentmonth))
			Select	@firstdayofpriormonth1 = dateadd(mm,-2, @firstdayofcurrentmonth)
       		Select	@lastdayofpriormonth1 = dateadd( dd, -1 , dateadd( mm, 0, @firstdayofpriormonth))
       		
	Create table #sop_eop
	( 
	   base_part varchar(25) primary key
	  ,sop datetime
	  ,eop datetime
	  ,csm_sop datetime
	  ,csm_eop datetime
	  ,empire_sop datetime
	  ,empire_eop datetime
	)
	  
	insert #sop_eop
	
	select		base_part, 
				min(isnull(csm_sop,empire_sop)) as sop, 
				max(isnull(csm_eop, empire_eop)) as eop, 
				min(csm_sop) as csm_sop, 
				max(csm_eop) as csm_eop, 
				min(empire_sop) as empire_sop, 
				max(empire_eop) as empire_eop 
				
	from		eeiuser.acctg_csm_vw_select_sales_forecast 
	
	group by	base_part
	
		
	select	Team = max (Team),
		Customer,
		Part,
		YTDSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofyear and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Qty end), 0),
		YTDSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofyear and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Amount end), 0),
		PriorMonthSales = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Qty else 0 end), 0),
		PriorMonthSalesDollars = coalesce (sum (case when SalesHistoryAndForecast.type = 'History' and SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth then SalesHistoryAndForecast.Amount else 0 end), 0),
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
		min(sop) as sop,
		max(eop) as eop,
		min(csm_sop) as csm_sop,
		max(csm_eop) as csm_eop,
		min(empire_sop) as empire_sop,
		max(empire_eop) as empire_eop

	from	(	select	Team = team, Type = 'Forecast', Customer = left (BasePart, 3), Part = basepart, ShipDT = date_due, Qty = qty_projected, Amount = extended
			from	vw_eei_sales_forecast
			union all
			select	Team = team, Type = 'History', Customer = left (BasePart, 3), Part = basepart, ShipDT = date_shipped, Qty = qty_shipped, Amount = extended
			from	vw_eei_sales_history) SalesHistoryAndForecast
			left join #sop_eop on part = base_part
	group by
		SalesHistoryAndForecast.Customer,
		SalesHistoryAndForecast.Part
	having	coalesce (sum (case when SalesHistoryAndForecast.ShipDT >= @firstdayofpriormonth and SalesHistoryAndForecast.ShipDT < @firstdayofcurrentmonth4 then SalesHistoryAndForecast.Amount else 0 end), 0) > 0 and
		Part not like 'J[1,3]%'
	order by
		2, 3
       		
       	end



GO
