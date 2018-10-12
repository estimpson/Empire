SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[tet] as
select	*
from	EEH.[dbo].[tet] with (READUNCOMMITTED)
GO
