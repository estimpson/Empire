SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[down_pointer] as
select	*
from	EEH.[dbo].[down_pointer] with (READUNCOMMITTED)
GO
