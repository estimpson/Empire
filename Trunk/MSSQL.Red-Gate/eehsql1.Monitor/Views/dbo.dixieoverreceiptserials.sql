SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixieoverreceiptserials] as
select	*
from	EEH.[dbo].[dixieoverreceiptserials] with (READUNCOMMITTED)
GO
