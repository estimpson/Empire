SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[OBS_eeisp_rpt_sales_forecast_testdates] 
       as
begin
       	
       	declare 
       		@currentdate						datetime,
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
       		Select	@firstdayofpriormonth = dateadd(mm,-1, @firstdayofcurrentmonth)
       		Select	@lastdayofpriormonth = dateadd( dd, -1 , dateadd( mm, 0, @firstdayofcurrentmonth))
       		

			select 'today',getdate()
			union all
       		
      		Select  'fdom',@firstdayofcurrentmonth
       		union all
       		Select	'ldom',@lastdayofcurrentmonth
       		union all
       		Select 'fdnm',@firstdayofcurrentmonth1
       		union all
       		Select	'ldnm',@lastdayofcurrentmonth1
       		union all
       		Select 'fdm2',@firstdayofcurrentmonth2
       		union all
       		Select	'ldm2',@lastdayofcurrentmonth2
       		union all
			Select 'fdm3',@firstdayofcurrentmonth3
       		union all
       		Select	'ldm3',@lastdayofcurrentmonth3
       		union all
       		
       		Select 'fdpm',@firstdayofpriormonth
       		union all
       		Select	'ldpm',@lastdayofpriormonth
--
--
--
--
--Create table #saleshistoryandforecast (
--						team						varchar (25),
--						customerprefix		char(3),
--						part							varchar (25)
--						)
--						
--						
--						Insert	#saleshistoryandforecast	
--						Select	team,
--									substring(basepart,1,3),
--									basepart
--						from		vw_eei_sales_history
--						Union
--						Select	team,
--									substring(basepart,1,3),
--									basepart
--						from		vw_eei_sales_forecast
--						
--						
--						Create table #sales( 	team varchar(25),
--															customer	varchar(15),
--															part			varchar(25),
--														 	YTDSales numeric (20,6),
--															YTDSalesDollars numeric (20,6),
--														 	PriorMonthSales numeric (20,6),
--														 	PriorMonthSalesDollars numeric (20,6),
--														 	CurrentMonthSales numeric (20,6),
--															CurrentMonthSalesDollars numeric (20,6),
--														 	PastDueOrders numeric (20,6),
--														 	PastDueOrdersSales numeric (20,6),
--															RemainingOrdersDue numeric (20,6),
--															RemainingOrdersDueDollars numeric (20,6),
--															TotalOrdersDue numeric (20,6),
--															TotalOrdersDueDollars numeric (20,6),
--								 							Month1OrdersDue numeric (20,6),
--								 							Month1OrdersDueDollars numeric (20,6),
--															Month2OrdersDue numeric (20,6),
--															Month2OrdersDueDollars numeric (20,6),
--															Month3OrdersDue numeric (20,6),
--															Month3OrdersDueDollars numeric (20,6),
--															SOP	datetime,
--															EOP	datetime)
--							Insert #sales								
--						
--						Select	team,
--									customerprefix,
--									part,
--									isNULL((select sum(qty_shipped) from vw_eei_sales_history where date_shipped>=@firstdayofyear and date_shipped<=@currentdate and basepart=part),0) as YTDSales,
--									isNULL((select sum(extended) from vw_eei_sales_history where date_shipped>=@firstdayofyear and date_shipped<=@currentdate and basepart=part),0) as YTDSalesDollars,
--									isNULL((select sum(qty_shipped) from vw_eei_sales_history where date_shipped>=@firstdayofpriormonth and date_shipped<=@lastdayofpriormonth and basepart=part),0) as PriorMonthSales,
--									isNULL((select sum(extended) from vw_eei_sales_history where date_shipped>=@firstdayofpriormonth and date_shipped<=@lastdayofpriormonth and basepart=part),0) as PriorMonthSalesDollars,
--									isNULL((select sum(qty_shipped) from vw_eei_sales_history where date_shipped>=@firstdayofcurrentmonth and date_shipped<=@lastdayofcurrentmonth and basepart=part),0) as CurrentMonthSales,
--									isNULL((select sum(extended) from vw_eei_sales_history where date_shipped>=@firstdayofcurrentmonth and date_shipped<=@lastdayofcurrentmonth and basepart=part),0) as CurrentMonthSalesDollars,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due<@currentdate and basepart=part),0) as PastDueOrders,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due<@currentdate and basepart=part),0) as PastDueOrdersSales,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due>=@currentdate and date_due<=@lastdayofcurrentmonth and basepart=part),0) as RemainingOrdersDue,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due>=@currentdate and date_due<=@lastdayofcurrentmonth and basepart=part),0) as RemainingOrdersDueDollars,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth and date_due<=@lastdayofcurrentmonth and basepart=part),0) as TotalOrdersDue,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth and date_due<=@lastdayofcurrentmonth and basepart=part),0) as TotalOrdersDueDollars,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth1 and date_due<=@lastdayofcurrentmonth1 and basepart=part),0) as Month1OrdersDue,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth1 and date_due<=@lastdayofcurrentmonth1 and basepart=part),0) as Month1OrdersDueDollars,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth2 and date_due<=@lastdayofcurrentmonth2 and basepart=part),0) as Month2OrdersDue,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth2 and date_due<=@lastdayofcurrentmonth2 and basepart=part),0) as Month2OrdersDueDolars,
--									isNULL((select sum(qty_projected) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth3 and date_due<=@lastdayofcurrentmonth3 and basepart=part),0) as Month3OrdersDue,
--									isNULL((select sum(extended) from vw_eei_sales_forecast where date_due>=@firstdayofcurrentmonth3 and date_due<=@lastdayofcurrentmonth3 and basepart=part),0) as Month3OrdersDueDollars,
--								 	(select max(prod_start) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= #saleshistoryandforecast.part) as SOP,
--								 	(select max(prod_end) from part_eecustom where (case when patindex('%-%', part_eecustom.part)=8 THEN Substring(part_eecustom.part,1, (patindex('%-%', part_eecustom.part)-1)) else part_eecustom.part end)= #saleshistoryandforecast.part) as EOP
--								 		
--									
--									
--									
--									
--						from		#saleshistoryandforecast
--						
--						
--						Select 	* 
--						from 	#sales
--						where	(CurrentMonthSalesDollars +	PastDueOrdersSales + RemainingOrdersDueDollars + TotalOrdersDueDollars +	Month1OrdersDueDollars + 	 	Month2OrdersDueDollars +	Month3OrdersDueDollars) >1 
--									
--							
--       		
--       		
--       
--       		
       	end
GO
