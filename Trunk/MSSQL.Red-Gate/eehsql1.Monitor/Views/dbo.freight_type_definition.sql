SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[freight_type_definition] as
select	*
from	EEH.[dbo].[freight_type_definition] with (READUNCOMMITTED)
GO
