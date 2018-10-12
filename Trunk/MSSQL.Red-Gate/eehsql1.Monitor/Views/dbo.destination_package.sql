SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination_package] as
select	*
from	EEH.[dbo].[destination_package] with (READUNCOMMITTED)
GO
