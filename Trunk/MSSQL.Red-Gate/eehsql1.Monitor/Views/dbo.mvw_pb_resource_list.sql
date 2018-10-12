SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_pb_resource_list] as
select	*
from	EEH.[dbo].[mvw_pb_resource_list] with (READUNCOMMITTED)
GO
