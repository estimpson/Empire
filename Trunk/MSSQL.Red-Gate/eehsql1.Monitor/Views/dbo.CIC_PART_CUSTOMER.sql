SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CIC_PART_CUSTOMER] as
select	*
from	EEH.[dbo].[CIC_PART_CUSTOMER] with (READUNCOMMITTED)
GO