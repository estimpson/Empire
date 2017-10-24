SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_sales_forecast_for_year] (@forecastA varchar(255), @forecastB varchar(255), @ForecastYear Int)

as
begin

exec	[dbo].[eeisp_flatten_csm]

--eeisp_rpt_sales_forecast_for_year '2008 OSF - 2008Q1 Update Using 2007-12 CSM', '2008 OSF - 2008Q3 Update Using 2008-07 CSM', 2008

select isnull(BasePartA,BasepartB) TheBasepart, * into #Forecasts from 
(select 
base_part as BasePartA,
sum((case when forecast_period = 1 then forecast_sales else 0 end)) as 'JanA',
sum((case when forecast_period = 2 then forecast_sales else 0 end)) as 'FebA',
sum((case when forecast_period = 3 then forecast_sales else 0 end)) as 'MarA',
sum((case when forecast_period = 4 then forecast_sales else 0 end)) as 'AprA',
sum((case when forecast_period = 5 then forecast_sales else 0 end)) as 'MayA',
sum((case when forecast_period = 6 then forecast_sales else 0 end)) as 'JunA',
sum((case when forecast_period = 7 then forecast_sales else 0 end)) as 'JulA',
sum((case when forecast_period = 8 then forecast_sales else 0 end)) as 'AugA',
sum((case when forecast_period = 9 then forecast_sales else 0 end)) as 'SepA',
sum((case when forecast_period = 10 then forecast_sales else 0 end)) as 'OctA',
sum((case when forecast_period = 11 then forecast_sales else 0 end)) as 'NovA',
sum((case when forecast_period = 12 then forecast_sales else 0 end)) as 'DecA'
 from		eeiuser.sales_1 
where	forecast_name = @forecastA and 
		forecast_year = @ForecastYear
group by base_part
)a
full outer join
(select 
base_part as BasePartB,
sum((case when forecast_period = 1 then forecast_sales else 0 end)) as 'JanB',
sum((case when forecast_period = 2 then forecast_sales else 0 end)) as 'FebB',
sum((case when forecast_period = 3 then forecast_sales else 0 end)) as 'MarB',
sum((case when forecast_period = 4 then forecast_sales else 0 end)) as 'AprB',
sum((case when forecast_period = 5 then forecast_sales else 0 end)) as 'MayB',
sum((case when forecast_period = 6 then forecast_sales else 0 end)) as 'JunB',
sum((case when forecast_period = 7 then forecast_sales else 0 end)) as 'JulB',
sum((case when forecast_period = 8 then forecast_sales else 0 end)) as 'AugB',
sum((case when forecast_period = 9 then forecast_sales else 0 end)) as 'SepB',
sum((case when forecast_period = 10 then forecast_sales else 0 end)) as 'OctB',
sum((case when forecast_period = 11 then forecast_sales else 0 end)) as 'NovB',
sum((case when forecast_period = 12 then forecast_sales else 0 end)) as 'DecB'
 from eeiuser.sales_1 where forecast_name = @forecastB  and
	forecast_year = @ForecastYear
group by base_part
) b 
on a.basepartA = b.basepartB
order by 1

Select	left(TheBasePart,3) as Customer,
		TheBasePart,
	isNULL(JanA,0) as JanASales,
	isNULL(JanB,0) as JanBSales,
	isNULL(FebA,0) as FebASales,
	isNULL(FebB,0) as FebBSales,
	isNULL(MarA,0) as MarASales,
	isNULL(MarB,0) as MarBSales,
	isNULL(AprA,0) as AprASales,
	isNULL(AprB,0) as AprBSales,
	isNULL(MayA,0) as MayASales,
	isNULL(MayB,0) as MayBSales,
	isNULL(JunA,0) as JunASales,
	isNULL(JunB,0) as JunBSales,
	isNULL(JulA,0) as JulASales,
	isNULL(JulB,0) as JulBSales,
	isNULL(AugA,0) as AugASales,
	isNULL(AugB,0) as AugBSales,
	isNULL(SepA,0) as SepASales,
	isNULL(SepB,0) as SepBSales,
	isNULL(OctA,0) as OctASales,
	isNULL(OctB,0) as OctBSales,
	isNULL(NovA,0) as NovASales,
	isNULL(NovB,0) as NovBSales,
	isNULL(DecA,0) as DecASales,
	isNULL(DecB,0) as DecBSales,
	oem,
	program,
	vehicle,
	sop,
	eop
	
	 
from	#forecasts Forecasts
left join	FlatCSM on Forecasts.TheBasePart = FlatCSM.BasePart
left join	
(Select max(prod_start) SOP,
		max(prod_end) EOP,
	left(part.part,7) basePartee 
from part_eecustom
join	part on part_eecustom.part = part.part
where	part.class = 'P' and part.type = 'F'
group by left(part.part,7)) Parteecustom on Forecasts.TheBasePart = Parteecustom.BasePartee
where	(isNULL(JanA,0)+
	isNULL(JanB,0) +
	isNULL(FebA,0)+
	isNULL(FebB,0) +
	isNULL(MarA,0) +
	isNULL(MarB,0) +
	isNULL(AprA,0) +
	isNULL(AprB,0) +
	isNULL(MayA,0)+
	isNULL(MayB,0) +
	isNULL(JunA,0) +
	isNULL(JunB,0) +
	isNULL(JulA,0) +
	isNULL(JulB,0) +
	isNULL(AugA,0) +
	isNULL(AugB,0) +
	isNULL(SepA,0) +
	isNULL(SepB,0) +
	isNULL(OctA,0) +
	isNULL(OctB,0) +
	isNULL(NovA,0)+
	isNULL(NovB,0) +
	isNULL(DecA,0) +
	isNULL(DecB,0) )>0
end
GO
