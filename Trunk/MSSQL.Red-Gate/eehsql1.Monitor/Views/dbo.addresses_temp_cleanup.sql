SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[addresses_temp_cleanup] as
select	*
from	EEH.[dbo].[addresses_temp_cleanup] with (READUNCOMMITTED)
GO
