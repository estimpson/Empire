SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[shipper_eei] as
select	*
from	EEH.[dbo].[shipper_eei] with (READUNCOMMITTED)
GO
