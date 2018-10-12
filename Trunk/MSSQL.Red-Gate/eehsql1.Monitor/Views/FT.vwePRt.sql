SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePRt] as
select	*
from	EEH.[FT].[vwePRt] with (READUNCOMMITTED)
GO
