SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_copy_20060930_post] as
select	*
from	EEH.[dbo].[object_copy_20060930_post] with (READUNCOMMITTED)
GO
