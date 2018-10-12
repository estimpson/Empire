SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[xreport_datasource] as
select	*
from	EEH.[dbo].[xreport_datasource] with (READUNCOMMITTED)
GO
