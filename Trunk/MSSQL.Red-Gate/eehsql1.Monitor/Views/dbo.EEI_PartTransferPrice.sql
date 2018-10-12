SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEI_PartTransferPrice] as
select	*
from	EEH.[dbo].[EEI_PartTransferPrice] with (READUNCOMMITTED)
GO
