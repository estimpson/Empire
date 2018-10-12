SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwePart] as
select	*
from	EEH.[FT].[ftvwePart] with (READUNCOMMITTED)
GO
