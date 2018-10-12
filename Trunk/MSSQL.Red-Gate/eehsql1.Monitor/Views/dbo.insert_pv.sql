SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[insert_pv] as
select	*
from	EEH.[dbo].[insert_pv] with (READUNCOMMITTED)
GO
