SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_20061031_copy] as
select	*
from	EEH.[dbo].[object_copy_20061031_copy] with (READUNCOMMITTED)
GO
