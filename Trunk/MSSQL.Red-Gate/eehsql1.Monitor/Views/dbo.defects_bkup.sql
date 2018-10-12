SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[defects_bkup] as
select	*
from	EEH.[dbo].[defects_bkup] with (READUNCOMMITTED)
GO
