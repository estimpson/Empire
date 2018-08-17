SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuoteToolingPO_PaymentTriggerList]
as
select distinct
	aqtpo.PaymentTrigger
from
	NSA.AwardedQuoteToolingPOs aqtpo
GO
