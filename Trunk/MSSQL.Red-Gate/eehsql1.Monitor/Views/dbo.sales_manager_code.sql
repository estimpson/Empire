SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sales_manager_code] as
select	*
from	EEH.[dbo].[sales_manager_code] with (READUNCOMMITTED)
GO
