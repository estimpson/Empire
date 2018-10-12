SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOH] as
select	*
from	EEH.[FT].[vwPOH] with (READUNCOMMITTED)
GO
