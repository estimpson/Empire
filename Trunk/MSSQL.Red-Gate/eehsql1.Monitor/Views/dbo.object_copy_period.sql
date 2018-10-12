SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_period] as
select	*
from	EEH.[dbo].[object_copy_period] with (READUNCOMMITTED)
GO
