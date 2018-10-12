SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[shipper_detail_eei] as
select	*
from	EEH.[dbo].[shipper_detail_eei] with (READUNCOMMITTED)
GO
