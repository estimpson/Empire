SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[description_short] as
select	*
from	EEH.[dbo].[description_short] with (READUNCOMMITTED)
GO
