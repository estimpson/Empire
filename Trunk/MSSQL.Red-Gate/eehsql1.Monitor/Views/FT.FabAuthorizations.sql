SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[FabAuthorizations] as
select	*
from	EEH.[FT].[FabAuthorizations] with (READUNCOMMITTED)
GO
