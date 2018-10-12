SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[downtime_codes] as
select	*
from	EEH.[dbo].[downtime_codes] with (READUNCOMMITTED)
GO
