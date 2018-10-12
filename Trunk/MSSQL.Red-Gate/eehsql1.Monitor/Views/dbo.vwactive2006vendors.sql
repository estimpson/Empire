SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwactive2006vendors] as
select	*
from	EEH.[dbo].[vwactive2006vendors] with (READUNCOMMITTED)
GO
