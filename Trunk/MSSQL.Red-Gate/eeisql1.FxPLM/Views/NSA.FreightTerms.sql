SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create view [NSA].[FreightTerms]
as
select
	aql.FreightTerms
,	RowID = isnull(row_number() over (order by aql.FreightTerms), 0)
from
	NSA.AwardedQuoteLogistics aql


GO
