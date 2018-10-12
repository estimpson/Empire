SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[HighRawAuthorizations] as
select	*
from	EEH.[FT].[HighRawAuthorizations] with (READUNCOMMITTED)
GO
