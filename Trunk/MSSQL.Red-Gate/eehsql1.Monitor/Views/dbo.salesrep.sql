SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[salesrep] as
select	*
from	EEH.[dbo].[salesrep] with (READUNCOMMITTED)
GO
