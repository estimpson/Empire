SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [FT].[fn_WP_SalesForecastSummaries_QuoteLogByCustomer]
(
	@Customer varchar(250) 
)
returns @QuoteData table
(
	QuoteNumber varchar(50)
,	Customer varchar(100)
,	Program varchar(100)
,	EEIPartNumber varchar(100)
,	Nameplate varchar(100)
,	SOP varchar(20)
,	EOP varchar(20)
,	QuoteStatus varchar(50)
,	Awarded varchar(50)
,	SalesPerMonth_2016 decimal(20,6) null
,	SalesPerMonth_2017 decimal(20,6) null
,	SalesPerMonth_2018 decimal(20,6) null
,	SalesPerMonth_2019 decimal(20,6) null
,	SalesPerMonth_2020 decimal(20,6) null
,	SalesPerMonth_2021 decimal(20,6) null
,	SalesPerMonth_2022 decimal(20,6) null
,	Processed int
)
as
begin

--- <Body>
insert into @QuoteData
(
	QuoteNumber
,	Customer
,	Program
,	EEIPartNumber
,	Nameplate
,	SOP
,	EOP
,	QuoteStatus
,	Awarded
,	SalesPerMonth_2016
,	SalesPerMonth_2017
,	SalesPerMonth_2018
,	SalesPerMonth_2019
,	SalesPerMonth_2020
,	SalesPerMonth_2021
,	SalesPerMonth_2022
,	Processed
)
select
	ql.QuoteNumber
,	ql.Customer
,	ql.Program
,	ql.EEIPartNumber
,	ql.Nameplate
,	convert(varchar, convert(date, ql.SOP)) as SOP
,	convert(varchar, convert(date, ql.EOP)) as EOP
,	ql.QuoteStatus
,	ql.Awarded
,	null
,	null
,	null
,	null
,	null
,	null
,	null
,	0
from
	eeiuser.QT_QuoteLog ql
where
	Customer = @Customer
	--Customer like '%' + @FilterValue + '%'
	and year(SOP) > 2015
	and year(EOP) > 2016
	and coalesce(TotalQuotedSales, 0) > 0


if exists (
		select 
			1 
		from 
			@QuoteData ) begin

	declare @salesPerMonthPerYear table
	(
		SalesYear varchar(50)
	,	SalesPerMonth decimal(20,6) null )

	declare @salesPerMonthPerYearPivot table
	(
		SalesPerMonth_2016 decimal(20,6) null
	,	SalesPerMonth_2017 decimal(20,6) null
	,	SalesPerMonth_2018 decimal(20,6) null
	,	SalesPerMonth_2019 decimal(20,6) null
	,	SalesPerMonth_2020 decimal(20,6) null
	,	SalesPerMonth_2021 decimal(20,6) null
	,	SalesPerMonth_2022 decimal(20,6) null
	)
	
	declare @salesPerMonthPerYearPivotFlat table
	(
		QuoteNumber varchar(50)
	,	SalesPerMonth_2016 decimal(20,6) null
	,	SalesPerMonth_2017 decimal(20,6) null
	,	SalesPerMonth_2018 decimal(20,6) null
	,	SalesPerMonth_2019 decimal(20,6) null
	,	SalesPerMonth_2020 decimal(20,6) null
	,	SalesPerMonth_2021 decimal(20,6) null
	,	SalesPerMonth_2022 decimal(20,6) null
	)

	declare
		@quoteNumber varchar(50)
	,	@startMonth int
	,	@endMonth int
	,	@totalMonths int
	,	@startYear int
	,	@currentYear int
	,	@lastYear int	
	,	@totalYears int
	,	@salesPerMonth decimal(20, 6)


	declare
		@currentQuoteNumber varchar(50)

	while ((select count(1) from @quoteData where Processed = 0) > 0) begin

		select
			@currentQuoteNumber = min(QuoteNumber)
		from
			@QuoteData
		where
			Processed = 0
			

		select
			@quoteNumber = QuoteNumber
		,	@startMonth = month(SOP)
		,	@endMonth = month(EOP)
		,	@totalMonths = datediff(month, SOP, EOP)
		,	@startYear = year(SOP)
		,	@currentYear = year(SOP)
		,	@lastYear = year(EOP)
		,	@totalYears = datediff(year, SOP, EOP)
		,	@salesPerMonth = (TotalQuotedSales / datediff(month, SOP, EOP))
		from
			eeiuser.QT_QuoteLog ql
		where
			ql.QuoteNumber = @currentQuoteNumber



		declare
			@totalMonthsCurrentYear int
		,	@salesPerMonthCurrentYear decimal(20, 6)

	
	
		delete from
			@salesPerMonthPerYear

		while (@currentYear <= @lastYear) begin
			
			if (@currentYear = @startYear) begin
				set @totalMonthsCurrentYear = (13 - @startMonth)
				set @salesPerMonthCurrentYear = (@totalMonthsCurrentYear * @salesPerMonth)
			end
			else if (@currentYear = @lastYear) begin
				set @salesPerMonthCurrentYear = (@endMonth * @salesPerMonth)
			end
			else begin
				set @salesPerMonthCurrentYear = (12 * @salesPerMonth)
			end

			insert into
				@salesPerMonthPerYear
			(
				SalesYear
			,	SalesPerMonth
			)
			select
				@currentYear
			,	@salesPerMonthCurrentYear

			set @currentYear = @currentYear + 1

		end



		delete from
			@salesPerMonthPerYearPivot

		insert into
			@salesPerMonthPerYearPivot
		(
			SalesPerMonth_2016
		,	SalesPerMonth_2017
		,	SalesPerMonth_2018
		,	SalesPerMonth_2019
		,	SalesPerMonth_2020
		,	SalesPerMonth_2021
		,	SalesPerMonth_2022
		)
		select
			case when (spm.SalesYear = 2016) then spm.SalesPerMonth end
		,	case when (spm.SalesYear = 2017) then spm.SalesPerMonth end
		,	case when (spm.SalesYear = 2018) then spm.SalesPerMonth end 	
		,	case when (spm.SalesYear = 2019) then spm.SalesPerMonth end
		,	case when (spm.SalesYear = 2020) then spm.SalesPerMonth end
		,	case when (spm.SalesYear = 2021) then spm.SalesPerMonth end
		,	case when (spm.SalesYear = 2022) then spm.SalesPerMonth end
		from
			@salesPerMonthPerYear spm


	
		delete from
			@salesPerMonthPerYearPivotFlat

		insert into @salesPerMonthPerYearPivotFlat
		(
			QuoteNumber
		,	SalesPerMonth_2016
		,	SalesPerMonth_2017
		,	SalesPerMonth_2018
		,	SalesPerMonth_2019
		,	SalesPerMonth_2020
		,	SalesPerMonth_2021
		,	SalesPerMonth_2022
		)
		select
			@quoteNumber as QuoteNumber
		,	min(SalesPerMonth_2016) as SalesPerMonth_2016
		,	min(SalesPerMonth_2017) as SalesPerMonth_2017 
		,	min(SalesPerMonth_2018) as SalesPerMonth_2018
		,	min(SalesPerMonth_2019) as SalesPerMonth_2019
		,	min(SalesPerMonth_2020) as SalesPerMonth_2020
		,	min(SalesPerMonth_2021) as SalesPerMonth_2021
		,	min(SalesPerMonth_2022) as SalesPerMonth_2022
		from 
			@salesPerMonthPerYearPivot

			
		
		update
			qd
		set
			SalesPerMonth_2016 = spm.SalesPerMonth_2016
		,	SalesPerMonth_2017 = spm.SalesPerMonth_2017
		,	SalesPerMonth_2018 = spm.SalesPerMonth_2018
		,	SalesPerMonth_2019 = spm.SalesPerMonth_2019
		,	SalesPerMonth_2020 = spm.SalesPerMonth_2020
		,	SalesPerMonth_2021 = spm.SalesPerMonth_2021
		,	SalesPerMonth_2022 = spm.SalesPerMonth_2022
		from
			@QuoteData qd
			join @salesPerMonthPerYearPivotFlat spm
				on spm.QuoteNumber = qd.QuoteNumber
		
		
		update
			@QuoteData
		set
			Processed = 1
		where
			QuoteNumber = @currentQuoteNumber
		
	end

end
--- </Body>

---	<Return>
return
end

























GO
