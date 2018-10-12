SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [dbo].[HTSCode] as
select	*
from	EEH.[dbo].[HTSCode] with (READUNCOMMITTED)
GO
