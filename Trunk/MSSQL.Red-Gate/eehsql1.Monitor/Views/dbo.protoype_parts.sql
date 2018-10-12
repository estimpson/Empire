SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[protoype_parts] as
select	*
from	EEH.[dbo].[protoype_parts] with (READUNCOMMITTED)
GO
