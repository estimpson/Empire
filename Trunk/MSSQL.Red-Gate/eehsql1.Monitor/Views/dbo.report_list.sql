SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[report_list] as
select	*
from	EEH.[dbo].[report_list] with (READUNCOMMITTED)
GO
