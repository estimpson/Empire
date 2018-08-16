SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuoteProductionPO_AlternativeCustomerCommitmentList]
as
select distinct
	aqppo.AlternativeCustomerCommitment
from
	NSA.AwardedQuoteProductionPOs aqppo
GO
