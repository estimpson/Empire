SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuoteToolingPO_BudgetCapexList]
as
select distinct
	aqtpo.BudgetCapex
from
	NSA.AwardedQuoteToolingPOs aqtpo
GO
