SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[gl_tran_type] as
select	*
from	EEH.[dbo].[gl_tran_type] with (READUNCOMMITTED)
GO
