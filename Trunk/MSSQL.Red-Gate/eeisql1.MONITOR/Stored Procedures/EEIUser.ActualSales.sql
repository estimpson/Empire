SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- exec eeiuser.actualsales '2011-11-11 PSF', '2011-11-11 00:00:16.513', '2011-01-01','2011-10-31'


CREATE procedure [EEIUser].[ActualSales] (@FromDate datetime , @throughDate datetime)
as

declare 
@TruncatedFromDT datetime,
@TruncatedThroughDT datetime


Set @TruncatedFromDT =  FT.fn_TruncDate ('dd', @FromDate)
Set @TruncatedThroughDT =  FT.fn_TruncDate ('dd', @throughDate) +1 

select	team as ProgramManager,
		left(basepart,3) as Customer,
		basepart as Base_part, 
		datepart(YEAR, date_shipped) as salesYear,		
		datepart(MONTH, date_shipped) as SalesPeriod,
		sum(qty_shipped) as Units,
		case sum(extended) when 0 then 0 else SUM(extended)/SUM(qty_shipped) end as selling_price,
		sum(extended) as Extended
from		vw_eei_sales_history
join		destination on  vw_eei_sales_history.destination = destination.destination
where	date_shipped >= @TruncatedFromDT and date_shipped < @TruncatedThroughDT
group by	team,
		left(basepart,3),
		basepart, 
		datepart(MONTH, date_shipped),
		datepart(YEAR, date_shipped)


GO
