SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[REbajado] as
select	*
from	EEH.[dbo].[REbajado] with (READUNCOMMITTED)
GO
