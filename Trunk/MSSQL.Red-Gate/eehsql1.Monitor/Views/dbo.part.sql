SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[part] as
select	*
from	EEH.[dbo].[part] with (READUNCOMMITTED)


GO