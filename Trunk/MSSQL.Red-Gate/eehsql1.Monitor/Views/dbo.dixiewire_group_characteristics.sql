SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixiewire_group_characteristics] as
select	*
from	EEH.[dbo].[dixiewire_group_characteristics] with (READUNCOMMITTED)
GO
