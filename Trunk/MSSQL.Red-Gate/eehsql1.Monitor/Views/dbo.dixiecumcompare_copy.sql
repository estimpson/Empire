SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixiecumcompare_copy] as
select	*
from	EEH.[dbo].[dixiecumcompare_copy] with (READUNCOMMITTED)
GO
