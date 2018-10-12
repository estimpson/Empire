SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[terminals] as
select	*
from	EEH.[dbo].[terminals] with (READUNCOMMITTED)
GO
