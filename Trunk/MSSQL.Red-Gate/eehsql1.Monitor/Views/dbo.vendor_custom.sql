SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vendor_custom] as
select	*
from	EEH.[dbo].[vendor_custom] with (READUNCOMMITTED)
GO
