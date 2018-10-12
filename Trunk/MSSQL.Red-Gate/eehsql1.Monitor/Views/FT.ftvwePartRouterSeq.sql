SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwePartRouterSeq] as
select	*
from	EEH.[FT].[ftvwePartRouterSeq] with (READUNCOMMITTED)
GO
