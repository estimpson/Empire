SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_20070131] as
select	*
from	EEH.[dbo].[object_copy_20070131] with (READUNCOMMITTED)
GO
