SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[bom_report] as
select	*
from	EEH.[dbo].[bom_report] with (READUNCOMMITTED)
GO
