SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ars_vendor_initialize] as
select	*
from	EEH.[dbo].[ars_vendor_initialize] with (READUNCOMMITTED)
GO
