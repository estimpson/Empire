SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixie_essex] as
select	*
from	EEH.[dbo].[dixie_essex] with (READUNCOMMITTED)
GO
