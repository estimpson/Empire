SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EDIMap] as
select	*
from	EEH.[dbo].[EDIMap] with (READUNCOMMITTED)
GO
