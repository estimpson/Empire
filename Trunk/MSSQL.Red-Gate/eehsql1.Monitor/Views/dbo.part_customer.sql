SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_customer] as
select	*
from	EEH.[dbo].[part_customer] with (READUNCOMMITTED)
GO
