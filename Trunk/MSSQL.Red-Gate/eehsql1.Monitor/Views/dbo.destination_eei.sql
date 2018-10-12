SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination_eei] as
select	*
from	EEH.[dbo].[destination_eei] with (READUNCOMMITTED)
GO
