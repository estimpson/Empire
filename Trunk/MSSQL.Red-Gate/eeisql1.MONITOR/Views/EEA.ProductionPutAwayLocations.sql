SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EEA].[ProductionPutAwayLocations]
as
select
	Location = code
from
	dbo.location l
where
	code in ('AL-CERTI', 'AL-FINAUD')
GO
