SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_so_inquiry] as
select	*
from	EEH.[dbo].[cdivw_so_inquiry] with (READUNCOMMITTED)
GO
