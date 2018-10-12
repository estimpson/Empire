SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Manual_ADD_To_Floor] as
select	*
from	EEH.[dbo].[Manual_ADD_To_Floor] with (READUNCOMMITTED)
GO
