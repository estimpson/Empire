SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[activity_costs] as
select	*
from	EEH.[dbo].[activity_costs] with (READUNCOMMITTED)
GO
