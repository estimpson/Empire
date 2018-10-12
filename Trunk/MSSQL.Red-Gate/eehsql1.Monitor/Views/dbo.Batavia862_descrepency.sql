SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia862_descrepency] as
select	*
from	EEH.[dbo].[Batavia862_descrepency] with (READUNCOMMITTED)
GO
