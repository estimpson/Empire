SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[company_info] as
select	*
from	EEH.[dbo].[company_info] with (READUNCOMMITTED)
GO
