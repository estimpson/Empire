SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixieedipos1112] as
select	*
from	EEH.[dbo].[dixieedipos1112] with (READUNCOMMITTED)
GO
