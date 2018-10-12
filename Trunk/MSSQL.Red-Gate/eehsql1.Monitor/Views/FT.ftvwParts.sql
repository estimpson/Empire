SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwParts] as
select	*
from	EEH.[FT].[ftvwParts] with (READUNCOMMITTED)
GO
