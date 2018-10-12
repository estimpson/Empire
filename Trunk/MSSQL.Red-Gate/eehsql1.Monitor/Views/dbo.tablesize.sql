SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[tablesize] as
select	*
from	EEH.[dbo].[tablesize] with (READUNCOMMITTED)
GO
