SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[shipper_container] as
select	*
from	EEH.[dbo].[shipper_container] with (READUNCOMMITTED)
GO
