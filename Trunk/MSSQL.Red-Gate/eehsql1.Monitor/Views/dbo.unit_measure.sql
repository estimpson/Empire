SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[unit_measure] as
select	*
from	EEH.[dbo].[unit_measure] with (READUNCOMMITTED)
GO
