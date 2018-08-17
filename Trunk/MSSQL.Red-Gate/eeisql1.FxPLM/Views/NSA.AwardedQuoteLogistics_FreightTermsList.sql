SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuoteLogistics_FreightTermsList]
as
select distinct
	aql.FreightTerms
from
	NSA.AwardedQuoteLogistics aql
GO
