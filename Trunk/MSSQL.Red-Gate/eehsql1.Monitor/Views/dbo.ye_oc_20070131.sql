SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ye_oc_20070131] as
select	*
from	EEH.[dbo].[ye_oc_20070131] with (READUNCOMMITTED)
GO
