SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwePartRouter] as
select	*
from	EEH.[FT].[ftvwePartRouter] with (READUNCOMMITTED)
GO
