SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[bkupWODH] as
select	*
from	EEH.[FT].[bkupWODH] with (READUNCOMMITTED)
GO
