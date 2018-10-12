SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[pbcatfmt] as
select	*
from	EEH.[dbo].[pbcatfmt] with (READUNCOMMITTED)
GO
