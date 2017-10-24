SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[web_sales_TwoForecastsToActual] (@ActualFiscalYear char(4), @ActualPeriod char(2), @ForecastFiscalYear char(4), @ForeCastPeriod char(2),@ForecastFiscalYear2 char(4), @ForeCastPeriod2 char(2), @FN1 varchar(50) )
as

--  [EEIUser].[web_sales_TwoForecastsToActual] '2008', '8','2009', '2', '2009', '3', '2009 OSF - 2008Q4 Update Using 2008-10 CSM'
declare 
@SD datetime,
@ED datetime,
@SD2 datetime,
@ED2 datetime


Select @SD = @ActualFiscalYear+'-'+@ActualPeriod+'-'+'01'
Select @ED = dateadd(mm,1,@SD)


Select @SD2 = @ActualFiscalYear+'-'+@ActualPeriod+'-'+'01'
Select @ED2 = dateadd(mm,1,@SD2)


-- create populate two with distinct parts from actual and forecast

declare	@Forecast1 table
		(	BasePart1 varchar(25),
			ForecastName1 varchar(255),
			ForecastYear1 varchar(4),
			ForeCastPeriod1 varchar(2),
			ForeCastUnits1 numeric (20,6),
			ForecastSales1 numeric(20,6),
			Primary Key (BasePart1))

declare	@Forecast2 table
		(	BasePart2 varchar(25),
			ForecastName2 varchar(255),
			ForecastYear2 varchar(4),
			ForeCastPeriod2 varchar(2),
			ForeCastUnits2 numeric (20,6),
			ForecastSales2 numeric(20,6),
			Primary Key (BasePart2))


declare	@ActualSales table
		(	BasePart varchar(25),
			ActualYear varchar(4),
			ActualPeriod varchar(2),
			ActualUnits numeric (20,6),
			ActualSales numeric(20,6),
			Primary Key (BasePart))
			
			
insert into @Forecast1
select	base_part,
		forecast_name,		 
		forecast_year, 
		forecast_period,
		forecast_units,
		forecast_sales
		
from		sales_1 
where	forecast_year=@ForecastFiscalYear and 
		forecast_period= @ForeCastPeriod and 
		forecast_name=@FN1

insert into @Forecast2
select	base_part,
		forecast_name,		 
		forecast_year, 
		forecast_period,
		forecast_units,
		forecast_sales
		
from		sales_1 
where	forecast_year=@ForecastFiscalYear2 and 
		forecast_period= @ForeCastPeriod2 and 
		forecast_name=@FN1




insert into @ActualSales
select	BasePart,
		@ActualFiscalYear,
		@ActualPeriod,		 
		sum(qty_shipped),
		sum(extended)		
from		vw_eei_sales_history
where	 date_shipped >= @SD and 
		date_shipped < @ED
group by  basepart



Select	Coalesce(left(BasePart,3), Left(BasePart1,3), Left(BasePart2,3) ) as Customer,
		Coalesce(BasePart, BasePart1,BasePart2 ) as BasepartNumber,
		isNULL(ForeCastUnits1,0) as ForeCastUnits,
		isNULL(ForecastSales1,0) as ForeCastSales,
		isNULL(ForeCastUnits2,0) as ForeCastUnits2,
		isNULL(ForecastSales2,0) as ForeCastSales2,
		isNULL(ActualUnits,0) as ActualUnits,
		isNULL(ActualSales,0) as ActualSales,
		isNULL(ForeCastUnits1,0)-isNULL(ActualUnits,0) as UnitVariance1,
		isNULL(ForeCastSales1,0) -isNULL(Actualsales,0) as SalesVariance1,
		isNULL(ForeCastUnits2,0)-isNULL(ActualUnits,0) as UnitVariance2,
		isNULL(ForeCastSales2,0) -isNULL(Actualsales,0) as SalesVariance2
		
		
from		@ActualSales ActualSales
full join	@Forecast1  ForeCast1 on ActualSales.BasePart = Forecast1.BasePart1
full join	@Forecast2  ForeCast2 on ActualSales.BasePart = Forecast2.BasePart2



GO
