SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_getreleaseno] as
select	*
from	EEH.[dbo].[cdivw_getreleaseno] with (READUNCOMMITTED)
GO
