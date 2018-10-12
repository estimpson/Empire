SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwPartRouter] as
select	*
from	EEH.[FT].[ftvwPartRouter] with (READUNCOMMITTED)
GO
