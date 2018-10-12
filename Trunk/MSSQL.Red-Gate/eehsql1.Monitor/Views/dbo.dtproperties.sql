SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dtproperties] as
select	*
from	EEH.[dbo].[dtproperties] with (READUNCOMMITTED)
GO
