SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_eng_level] as
select	*
from	EEH.[dbo].[mvw_eng_level] with (READUNCOMMITTED)
GO
