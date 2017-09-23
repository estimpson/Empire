SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEA].[FinalAuditPutAwayLocations]
as
select
	Location = code
from
	dbo.location l
where
	--code in ('ALA-CERTIF', 'ALA-WRHQUE')
	code in ('AL-CERTI', 'AL-WRHQUE')
GO
