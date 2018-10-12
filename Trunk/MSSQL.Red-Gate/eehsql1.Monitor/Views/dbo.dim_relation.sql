SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dim_relation] as
select	*
from	EEH.[dbo].[dim_relation] with (READUNCOMMITTED)
GO
