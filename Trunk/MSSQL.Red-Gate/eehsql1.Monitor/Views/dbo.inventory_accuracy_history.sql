SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[inventory_accuracy_history] as
select	*
from	EEH.[dbo].[inventory_accuracy_history] with (READUNCOMMITTED)
GO
