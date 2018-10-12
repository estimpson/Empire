SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[Users] as
select	*
from	EEH.[FT].[Users] with (READUNCOMMITTED)
GO
