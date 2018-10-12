SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Material_Issue_To_Floor] as
select	*
from	EEH.[dbo].[Material_Issue_To_Floor] with (READUNCOMMITTED)
GO
