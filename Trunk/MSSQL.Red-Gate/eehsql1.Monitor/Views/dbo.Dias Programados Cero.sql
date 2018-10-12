SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Dias Programados Cero] as
select	*
from	EEH.[dbo].[Dias Programados Cero] with (READUNCOMMITTED)
GO
