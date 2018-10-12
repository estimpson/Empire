SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[exclude_serial] as
select	*
from	EEH.[dbo].[exclude_serial] with (READUNCOMMITTED)
GO
