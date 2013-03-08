USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_GetBOMModificationQuoteNumber]    Script Date: 03/04/2013 11:18:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [EEIUser].[usp_QT_GetBOMModificationQuoteNumber]
	@QuoteNumber varchar(50)
,	@NewQuoteNumber varchar(50) out
as

declare
	@BOM varchar(1)
	
select
	@BOM = MAX(QuoteBOM)
from
	EEIUser.QT_QuoteNumberDissection
where
	QuoteNumber = @QuoteNumber


if (@BOM is not null) begin
	select
		@NewQuoteNumber = 
			QuoteNum +
			char(ascii(
			(	select
					MAX(QuoteBOM)
				from
					EEIUser.QT_QuoteNumberDissection
				where
					QuoteNum = qnd.QuoteNum
					and QuoteYear = qnd.QuoteYear
			)) + 1) + '-' + qnd.QuoteYear
	from
		EEIUser.QT_QuoteNumberDissection qnd
	where
		QuoteNumber = @QuoteNumber
end
else begin
	select
		@NewQuoteNumber = qnd.QuoteNum + 'A' + '-' + qnd.QuoteYear
	from
		EEIUser.QT_QuoteNumberDissection qnd
	where
		QuoteNumber = @QuoteNumber
end
	

-- Replaced with above
/*
select
	@NewQuoteNumber = 
			QuoteNum +
			char(ascii( coalesce
				(	(	select
							MAX(QuoteBOM)
						from
							EEIUser.QT_QuoteNumberDissection
						where
							QuoteNum = qnd.QuoteNum
							and QuoteYear = qnd.QuoteYear
					)
					,	'A'
				)
		) + 1) + '-' + qnd.QuoteYear
from
	EEIUser.QT_QuoteNumberDissection qnd
where
	QuoteNumber = @QuoteNumber
*/
GO

