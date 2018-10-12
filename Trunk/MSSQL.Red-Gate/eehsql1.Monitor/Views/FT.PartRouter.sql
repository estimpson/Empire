SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[PartRouter] as
select	*
from	EEH.[FT].[PartRouter] with (READUNCOMMITTED)
GO
