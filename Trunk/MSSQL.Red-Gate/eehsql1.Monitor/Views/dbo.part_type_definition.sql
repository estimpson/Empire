SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_type_definition] as
select	*
from	EEH.[dbo].[part_type_definition] with (READUNCOMMITTED)
GO
