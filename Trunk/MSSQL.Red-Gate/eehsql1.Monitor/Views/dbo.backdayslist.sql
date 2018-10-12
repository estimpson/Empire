SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[backdayslist] as
select	*
from	EEH.[dbo].[backdayslist] with (READUNCOMMITTED)
GO
