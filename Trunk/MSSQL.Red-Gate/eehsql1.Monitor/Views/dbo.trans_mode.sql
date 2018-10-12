SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[trans_mode] as
select	*
from	EEH.[dbo].[trans_mode] with (READUNCOMMITTED)
GO
