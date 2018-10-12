SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mdata] as
select	*
from	EEH.[dbo].[mdata] with (READUNCOMMITTED)
GO
