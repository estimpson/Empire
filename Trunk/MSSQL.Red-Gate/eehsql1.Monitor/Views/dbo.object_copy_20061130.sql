SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_20061130] as
select	*
from	EEH.[dbo].[object_copy_20061130] with (READUNCOMMITTED)
GO
