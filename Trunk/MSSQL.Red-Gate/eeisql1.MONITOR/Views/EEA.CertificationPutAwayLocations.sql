SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EEA].[CertificationPutAwayLocations]
as
select
	Location = code
from
	dbo.location l
where
	--code in ('ALA-FINAUD', 'ALA-WRHQUE')
	code in ('AL-FINAUD', 'AL-WRHQUE')
GO
