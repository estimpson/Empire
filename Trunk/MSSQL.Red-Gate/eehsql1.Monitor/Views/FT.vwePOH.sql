SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePOH] as
select	*
from	EEH.[FT].[vwePOH] with (READUNCOMMITTED)
GO
