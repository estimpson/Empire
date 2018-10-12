SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_KB_Exceso_Issue] as
select	*
from	EEH.[dbo].[EEH_KB_Exceso_Issue] with (READUNCOMMITTED)
GO
