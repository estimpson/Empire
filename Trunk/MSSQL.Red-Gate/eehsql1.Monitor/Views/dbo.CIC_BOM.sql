SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CIC_BOM] as
select	*
from	EEH.[dbo].[CIC_BOM] with (READUNCOMMITTED)
GO
