SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[bkupWOD] as
select	*
from	EEH.[FT].[bkupWOD] with (READUNCOMMITTED)
GO
