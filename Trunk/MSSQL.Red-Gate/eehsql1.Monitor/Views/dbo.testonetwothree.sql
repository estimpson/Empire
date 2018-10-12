SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[testonetwothree] as
select	*
from	EEH.[dbo].[testonetwothree] with (READUNCOMMITTED)
GO
