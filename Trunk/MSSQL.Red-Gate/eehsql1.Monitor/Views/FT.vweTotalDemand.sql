SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweTotalDemand] as
select	*
from	EEH.[FT].[vweTotalDemand] with (READUNCOMMITTED)
GO
