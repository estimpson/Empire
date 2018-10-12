SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_gl_account] as
select	*
from	EEH.[dbo].[part_gl_account] with (READUNCOMMITTED)
GO
