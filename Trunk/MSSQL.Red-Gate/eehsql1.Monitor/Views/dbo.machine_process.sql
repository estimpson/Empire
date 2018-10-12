SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[machine_process] as
select	*
from	EEH.[dbo].[machine_process] with (READUNCOMMITTED)
GO
