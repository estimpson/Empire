SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer_service_status] as
select	*
from	EEH.[dbo].[customer_service_status] with (READUNCOMMITTED)
GO
