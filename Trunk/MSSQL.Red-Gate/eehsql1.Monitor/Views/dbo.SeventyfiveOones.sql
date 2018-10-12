SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SeventyfiveOones] as
select	*
from	EEH.[dbo].[SeventyfiveOones] with (READUNCOMMITTED)
GO
