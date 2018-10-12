SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[AutoQCApprovedSerials] as
select	*
from	EEH.[dbo].[AutoQCApprovedSerials] with (READUNCOMMITTED)
GO
