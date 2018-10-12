SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwPart] as
select	*
from	EEH.[FT].[ftvwPart] with (READUNCOMMITTED)
GO
