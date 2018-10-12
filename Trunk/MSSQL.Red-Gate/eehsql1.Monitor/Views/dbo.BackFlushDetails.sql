SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BackFlushDetails] as
select	*
from	EEH.[dbo].[BackFlushDetails] with (READUNCOMMITTED)
GO
