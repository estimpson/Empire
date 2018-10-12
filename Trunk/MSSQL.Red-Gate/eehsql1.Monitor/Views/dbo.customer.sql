SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer] as
select	*
from	EEH.[dbo].[customer] with (READUNCOMMITTED)
GO
