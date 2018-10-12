SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[machine] as
select	*
from	EEH.[dbo].[machine] with (READUNCOMMITTED)
GO
