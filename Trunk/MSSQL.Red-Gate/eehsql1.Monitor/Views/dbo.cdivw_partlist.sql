SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_partlist] as
select	*
from	EEH.[dbo].[cdivw_partlist] with (READUNCOMMITTED)
GO
