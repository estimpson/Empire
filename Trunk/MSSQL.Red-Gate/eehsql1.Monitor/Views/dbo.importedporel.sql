SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[importedporel] as
select	*
from	EEH.[dbo].[importedporel] with (READUNCOMMITTED)
GO
