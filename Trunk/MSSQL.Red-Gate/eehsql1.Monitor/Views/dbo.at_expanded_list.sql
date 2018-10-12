SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[at_expanded_list] as
select	*
from	EEH.[dbo].[at_expanded_list] with (READUNCOMMITTED)
GO
