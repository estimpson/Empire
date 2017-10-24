SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EEIUser].[fn_QT_GetDaysLateForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	int
as
begin
	declare
		@DaysLateOutput int
		
	select
	--,	convert(varchar(20), qql.RequestedDueDate, 100) as RequiestedDueDate
	--,	convert(varchar(20), qql.EEIPromisedDueDate, 100) as EEIPromisedDueDate
	--,	convert(varchar(20), qql.CustomerQuoteDate, 100) as CustomerQuoteDate
	@DaysLateOutput =
	/*
		case 
			when qql.CustomerQuoteDate is not null 
				and datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.CustomerQuoteDate) > -1
				then datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.CustomerQuoteDate)
			when qql.CustomerQuoteDate is not null 
				and datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.CustomerQuoteDate) < 0
				then 0
			when datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), getdate()) > -1
				then datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), getdate())
			else 0 
		end	
	*/
		case 
			when qql.EngineeringMaterialsDate is not null 
				and datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.EngineeringMaterialsDate) > -1
				then datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.EngineeringMaterialsDate)
			when qql.EngineeringMaterialsDate is not null 
				and datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), qql.EngineeringMaterialsDate) < 0
				then 0
			when datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), getdate()) > -1
				then datediff(day, coalesce(qql.RequestedDueDate, qql.EEIPromisedDueDate), getdate())
			else 0 
		end
	from
		EEIUser.QT_QuoteLog qql
	where
		qql.QuoteNumber = @QuoteNumber

	return	@DaysLateOutput
end


--QL - Days late pulling from customer quote date, needs to be engineering materials date.
GO
