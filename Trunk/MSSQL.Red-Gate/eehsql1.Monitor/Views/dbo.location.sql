SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[location] as
select	*
from	EEH.[dbo].[location] with (READUNCOMMITTED)
GO
