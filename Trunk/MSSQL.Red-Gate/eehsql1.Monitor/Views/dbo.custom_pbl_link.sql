SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[custom_pbl_link] as
select	*
from	EEH.[dbo].[custom_pbl_link] with (READUNCOMMITTED)
GO
