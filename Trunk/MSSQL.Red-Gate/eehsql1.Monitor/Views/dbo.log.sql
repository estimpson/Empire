SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[log] as
select	*
from	EEH.[dbo].[log] with (READUNCOMMITTED)
GO
