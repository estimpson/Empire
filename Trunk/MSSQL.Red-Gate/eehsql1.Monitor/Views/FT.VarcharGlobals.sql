SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[VarcharGlobals] as
select	*
from	EEH.[FT].[VarcharGlobals] with (READUNCOMMITTED)
GO
