SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[shipper] as
select	*
from	EEH.[dbo].[shipper] with (READUNCOMMITTED)
GO
