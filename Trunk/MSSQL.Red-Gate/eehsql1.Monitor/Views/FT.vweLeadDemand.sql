SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweLeadDemand] as
select	*
from	EEH.[FT].[vweLeadDemand] with (READUNCOMMITTED)
GO
