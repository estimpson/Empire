SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CIC_INV_20070118] as
select	*
from	EEH.[dbo].[CIC_INV_20070118] with (READUNCOMMITTED)
GO