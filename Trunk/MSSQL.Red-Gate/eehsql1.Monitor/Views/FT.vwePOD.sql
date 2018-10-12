SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePOD] as
select	*
from	EEH.[FT].[vwePOD] with (READUNCOMMITTED)
GO
