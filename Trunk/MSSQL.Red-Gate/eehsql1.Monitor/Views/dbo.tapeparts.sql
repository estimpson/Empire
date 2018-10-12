SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[tapeparts] as
select	*
from	EEH.[dbo].[tapeparts] with (READUNCOMMITTED)
GO
