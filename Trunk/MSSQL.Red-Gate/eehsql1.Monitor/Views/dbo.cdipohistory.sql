SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdipohistory] as
select	*
from	EEH.[dbo].[cdipohistory] with (READUNCOMMITTED)
GO
