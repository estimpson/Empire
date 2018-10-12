SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_vendorlist] as
select	*
from	EEH.[dbo].[mvw_vendorlist] with (READUNCOMMITTED)
GO
