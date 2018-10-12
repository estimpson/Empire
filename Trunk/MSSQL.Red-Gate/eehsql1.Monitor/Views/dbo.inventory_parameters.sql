SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[inventory_parameters] as
select	*
from	EEH.[dbo].[inventory_parameters] with (READUNCOMMITTED)
GO
