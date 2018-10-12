SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[tdata] as
select	*
from	EEH.[dbo].[tdata] with (READUNCOMMITTED)
GO
