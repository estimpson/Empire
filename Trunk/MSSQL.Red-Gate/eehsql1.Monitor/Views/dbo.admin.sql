SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[admin] as
select	*
from	EEH.[dbo].[admin] with (READUNCOMMITTED)
GO
