SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_20061231] as
select	*
from	EEH.[dbo].[object_copy_20061231] with (READUNCOMMITTED)
GO
