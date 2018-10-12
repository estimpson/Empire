SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[pbcatcol] as
select	*
from	EEH.[dbo].[pbcatcol] with (READUNCOMMITTED)
GO
