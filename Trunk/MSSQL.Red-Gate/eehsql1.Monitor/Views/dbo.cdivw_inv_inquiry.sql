SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_inv_inquiry] as
select	*
from	EEH.[dbo].[cdivw_inv_inquiry] with (READUNCOMMITTED)
GO
