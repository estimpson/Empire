SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[bkupWOH] as
select	*
from	EEH.[FT].[bkupWOH] with (READUNCOMMITTED)
GO
