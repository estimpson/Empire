SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[user_definable_module_labels] as
select	*
from	EEH.[dbo].[user_definable_module_labels] with (READUNCOMMITTED)
GO
