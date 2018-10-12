SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[interface_utilities] as
select	*
from	EEH.[dbo].[interface_utilities] with (READUNCOMMITTED)
GO
