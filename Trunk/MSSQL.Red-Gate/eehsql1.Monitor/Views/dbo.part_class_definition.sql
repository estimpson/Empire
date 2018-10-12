SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_class_definition] as
select	*
from	EEH.[dbo].[part_class_definition] with (READUNCOMMITTED)
GO
