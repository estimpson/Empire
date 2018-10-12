SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_class_type_cross_ref] as
select	*
from	EEH.[dbo].[part_class_type_cross_ref] with (READUNCOMMITTED)
GO
