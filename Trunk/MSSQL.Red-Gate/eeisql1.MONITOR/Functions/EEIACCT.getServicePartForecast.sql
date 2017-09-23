SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEIACCT].[getServicePartForecast] ()
returns @servicePartForecast table
(	BasePart char(7) primary key
,	PartNumber varchar(max)
,	EndOfServiceYear int
,	Scheduler char(2)
,	Comment varchar(max)
,	Cy int
,	ActiveCyDemand int
,	ActiveNyDemand int
,	ShippedCy int
,	ServiceDemandCyP1 int
,	ServiceDemandCyP2 int
,	ServiceDemandCyP3 int
,	ServiceDemandCyP4 int
,	ServiceDemandCyP5 int
,	ServiceDemandCyP6 int
,	ServiceDemandCyP7 int
,	ServiceDemandCyP8 int
,	ServiceDemandCyP9 int
,	ServiceDemandCyP10 int
)
as 
begin
--- <Body>
	declare @cYear int
	
	set @cYear = datepart(year,getdate())

	insert  @servicePartForecast
	(	BasePart
	,	PartNumber
	,	EndOfServiceYear
	,	Scheduler
	,	Comment
	,	Cy
	,	ActiveCyDemand
	,	ActiveNyDemand
	,	ShippedCy
	,	ServiceDemandCyP1
	,	ServiceDemandCyP2
	,	ServiceDemandCyP3
	,	ServiceDemandCyP4
	,	ServiceDemandCyP5
	,	ServiceDemandCyP6
	,	ServiceDemandCyP7
	,	ServiceDemandCyP8
	,	ServiceDemandCyP9
	,	ServiceDemandCyP10
	)
	select
		sp.BasePart
	,	sp.PartNumber
	,	sp.EndOfServiceYear
	,	sp.Scheduler
	,	sp.Comments
	,	Cy = @cYear
	,	ActiveCyDemand = sp.Active2011Demand
	,	ActiveNyDemand = sp.Active2012Demand
	,	ShippedCy = sp.Shipped2011Demand
	,	ServiceDemandCyP1 = case when @cYear + 1 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP1.ForecastAmount
		,	(sp.Active2011Demand + sp.Shipped2011Demand) * convert(float, .7)
		,	0
		) else 0 end
	,	ServiceDemandCyP2 = case when @cYear + 2 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP2.ForecastAmount
		,	spfCyP1.ForecastAmount * convert(float, .6)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * convert(float, .6), 0)
		) else 0 end
	,	ServiceDemandCyP3 = case when @cYear + 3 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP3.ForecastAmount
		,	spfCyP2.ForecastAmount * convert(float, .6)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 2)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 2), 0)
		) else 0 end
	,	ServiceDemandCyP4 = case when @cYear + 4 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP4.ForecastAmount
		,	spfCyP3.ForecastAmount * convert(float, .6)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 3)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 3), 0)
		) else 0 end
	,	ServiceDemandCyP5 = case when @cYear + 5 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP5.ForecastAmount
		,	spfCyP4.ForecastAmount * convert(float, .6)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 4)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 4), 0)
		) else 0 end
	,	ServiceDemandCyP6 = case when @cYear + 6 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP6.ForecastAmount
		,	spfCyP5.ForecastAmount * convert(float, .6)
		,	spfCyP4.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 4)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 5)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 5), 0)
		) else 0 end
	,	ServiceDemandCyP7 = case when @cYear + 7 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP7.ForecastAmount
		,	spfCyP6.ForecastAmount * convert(float, .6)
		,	spfCyP5.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP4.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 4)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 5)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 6)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 6), 0)
		) else 0 end
	,	ServiceDemandCyP8 = case when @cYear + 8 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP8.ForecastAmount
		,	spfCyP7.ForecastAmount * convert(float, .6)
		,	spfCyP6.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP5.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP4.ForecastAmount * power(convert(float, .6), 4)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 5)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 6)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 7)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 7), 0)
		) else 0 end
	,	ServiceDemandCyP9 = case when @cYear + 9 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP9.ForecastAmount
		,	spfCyP8.ForecastAmount * convert(float, .6)
		,	spfCyP7.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP6.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP5.ForecastAmount * power(convert(float, .6), 4)
		,	spfCyP4.ForecastAmount * power(convert(float, .6), 5)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 6)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 7)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 8)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 8), 0)
		) else 0 end
	,	ServiceDemandCyP10 = case when @cYear + 10 <= coalesce(sp.EndOfServiceYear, 2099) then coalesce
		(	spfCyP10.ForecastAmount
		,	spfCyP9.ForecastAmount * convert(float, .6)
		,	spfCyP8.ForecastAmount * power(convert(float, .6), 2)
		,	spfCyP7.ForecastAmount * power(convert(float, .6), 3)
		,	spfCyP6.ForecastAmount * power(convert(float, .6), 4)
		,	spfCyP5.ForecastAmount * power(convert(float, .6), 5)
		,	spfCyP4.ForecastAmount * power(convert(float, .6), 6)
		,	spfCyP3.ForecastAmount * power(convert(float, .6), 7)
		,	spfCyP2.ForecastAmount * power(convert(float, .6), 8)
		,	spfCyP1.ForecastAmount * power(convert(float, .6), 9)
		,	round((coalesce(sp.Active2011Demand, 0) + coalesce(sp.Shipped2011Demand, 0)) * .7 * power(convert(float, .6), 9), 0)
		) else 0 end
	from
		EEIACCT.ServiceParts sp
		left join EEIACCT.ServicePartForecast spfCyP1
			on spfCyP1.BasePart = sp.BasePart
			   and spfCyP1.ForecastYear = @cYear + 1
		left join EEIACCT.ServicePartForecast spfCyP2
			on spfCyP2.BasePart = sp.BasePart
			   and spfCyP2.ForecastYear = @cYear + 2
		left join EEIACCT.ServicePartForecast spfCyP3
			on spfCyP3.BasePart = sp.BasePart
			   and spfCyP3.ForecastYear = @cYear + 3
		left join EEIACCT.ServicePartForecast spfCyP4
			on spfCyP4.BasePart = sp.BasePart
			   and spfCyP4.ForecastYear = @cYear + 4
		left join EEIACCT.ServicePartForecast spfCyP5
			on spfCyP5.BasePart = sp.BasePart
			   and spfCyP5.ForecastYear = @cYear + 5
		left join EEIACCT.ServicePartForecast spfCyP6
			on spfCyP6.BasePart = sp.BasePart
			   and spfCyP6.ForecastYear = @cYear + 6
		left join EEIACCT.ServicePartForecast spfCyP7
			on spfCyP7.BasePart = sp.BasePart
			   and spfCyP7.ForecastYear = @cYear + 7
		left join EEIACCT.ServicePartForecast spfCyP8
			on spfCyP8.BasePart = sp.BasePart
			   and spfCyP8.ForecastYear = @cYear + 8
		left join EEIACCT.ServicePartForecast spfCyP9
			on spfCyP9.BasePart = sp.BasePart
			   and spfCyP9.ForecastYear = @cYear + 9
		left join EEIACCT.ServicePartForecast spfCyP10
			on spfCyP10.BasePart = sp.BasePart
			   and spfCyP10.ForecastYear = @cYear + 10

--- </Body>

---	<Return>
	return
end
GO
