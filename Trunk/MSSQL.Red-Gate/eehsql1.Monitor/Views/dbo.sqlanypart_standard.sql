SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanypart_standard] as
select	*
from	EEH.[dbo].[sqlanypart_standard] with (READUNCOMMITTED)
GO
