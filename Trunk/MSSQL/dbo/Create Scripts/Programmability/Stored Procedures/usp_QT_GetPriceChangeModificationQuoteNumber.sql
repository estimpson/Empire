USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_GetPriceChangeModificationQuoteNumber]    Script Date: 03/04/2013 11:19:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_GetPriceChangeModificationQuoteNumber]
	@QuoteNumber varchar(50)
,	@NewQuoteNumber varchar(50) out
as
select
	@NewQuoteNumber =
		case
			when exists
				(	select
						*
					from
						EEIUser.QT_QuoteNumberDissection
					where
						QuoteNum = qnd.QuoteNum
						and QuoteYear = qnd.QuoteYear
						and coalesce(QuoteBOM, 'N/A') = coalesce(qnd.QuoteBOM, 'N/A')
						and QuotePriceSuffix > coalesce(qnd.QuotePriceSuffix, 0)
				) then 'There''s a more current price for that rev: ' + CONVERT(varchar, qnd.QuoteNum) + coalesce(qnd.QuoteBOM, '')
		else
			qnd.QuoteNum + coalesce(qnd.QuoteBOM, '') + '-' + qnd.QuoteYear + '-' + convert(varchar, coalesce(qnd.QuotePriceSuffix, 0) + 1)
		end
from
	EEIUser.QT_QuoteNumberDissection qnd
where
	QuoteNumber = @QuoteNumber

--if	@NewQuoteNumber like 'There%' begin
--	RAISERROR (@QuoteNumber, 16, 1)
--	return
--end
GO

