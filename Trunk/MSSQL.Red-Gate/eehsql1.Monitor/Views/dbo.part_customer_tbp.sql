SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_customer_tbp] as
select	*
from	EEH.[dbo].[part_customer_tbp] with (READUNCOMMITTED)
GO
