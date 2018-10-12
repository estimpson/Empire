SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_effectivechangenotice] as
select	*
from	EEH.[dbo].[mvw_effectivechangenotice] with (READUNCOMMITTED)
GO
