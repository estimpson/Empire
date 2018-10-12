SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vendor_service_status] as
select	*
from	EEH.[dbo].[vendor_service_status] with (READUNCOMMITTED)
GO
