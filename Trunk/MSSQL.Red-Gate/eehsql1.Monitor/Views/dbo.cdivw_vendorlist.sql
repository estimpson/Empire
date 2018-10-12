SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_vendorlist] as
select	*
from	EEH.[dbo].[cdivw_vendorlist] with (READUNCOMMITTED)
GO
