SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[effective_change_notice] as
select	*
from	EEH.[dbo].[effective_change_notice] with (READUNCOMMITTED)
GO
