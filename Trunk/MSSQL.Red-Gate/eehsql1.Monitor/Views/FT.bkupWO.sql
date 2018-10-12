SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[bkupWO] as
select	*
from	EEH.[FT].[bkupWO] with (READUNCOMMITTED)
GO
