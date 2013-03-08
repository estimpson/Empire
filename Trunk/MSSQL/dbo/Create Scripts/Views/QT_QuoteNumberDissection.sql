USE [MONITOR]
GO

/****** Object:  View [EEIUser].[QT_QuoteNumberDissection]    Script Date: 03/04/2013 11:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [EEIUser].[QT_QuoteNumberDissection]
as
select
	QuoteNumber
--,	QuoteNum = convert(int, left(QuoteNumber, patindex('%[^0-9]%', QuoteNumber) - 1))
,	QuoteNum = left(QuoteNumber, patindex('%[^0-9]%', QuoteNumber) - 1)
,	QuoteBOM =
		case when QuoteNumber like '%[A-Z]%' then
			Substring(QuoteNumber, patindex('%[A-Z]%', QuoteNumber), 1)
			else null
		end
,	QuoteYear =
		case when QuoteNumber like '%-%-%' then
			SUBSTRING(QuoteNumber, patindex('%-%', QuoteNumber) + 1, patindex('%-%', QuoteNumber) + patindex('%-%', SUBSTRING(QuoteNumber, patindex('%-%', QuoteNumber) + 1, LEN(QuoteNumber))) - patindex('%-%', QuoteNumber) - 1)
			else right(QuoteNumber, 2)
		end
,	QuotePriceSuffix =
		case when QuoteNumber like '%-%-%' then
			convert(int, right(QuoteNumber, patindex('%-%', reverse(QuoteNumber)) - 1))
			else null
		end
from
	EEIUser.QT_QuoteLog
where
	QuoteNumber not like '%-[A-Z]%'



GO

