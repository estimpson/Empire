SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [RTV].[HondurasLocations]
as
select
	LocationCode = l.code
,	IsStorage = case when l.type = 'ST' then 1 else 0 end
,	IsSecure = case when l.secured_location = 'Y' then 1 else 0 end
from
	EEHSQL1.EEH.dbo.location l
GO
