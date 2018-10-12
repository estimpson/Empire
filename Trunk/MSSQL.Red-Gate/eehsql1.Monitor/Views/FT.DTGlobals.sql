SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[DTGlobals] as
select	*
from	EEH.[FT].[DTGlobals] with (READUNCOMMITTED)
GO
