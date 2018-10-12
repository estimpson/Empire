SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPLOH] as
select	*
from	EEH.[FT].[vwPLOH] with (READUNCOMMITTED)
GO
