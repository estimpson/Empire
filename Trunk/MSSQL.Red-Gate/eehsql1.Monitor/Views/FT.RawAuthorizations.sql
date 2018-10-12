SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[RawAuthorizations] as
select	*
from	EEH.[FT].[RawAuthorizations] with (READUNCOMMITTED)
GO
