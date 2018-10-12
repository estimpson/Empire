SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eei_weekly_accumreceipts] as
select	*
from	EEH.[dbo].[eei_weekly_accumreceipts] with (READUNCOMMITTED)
GO
