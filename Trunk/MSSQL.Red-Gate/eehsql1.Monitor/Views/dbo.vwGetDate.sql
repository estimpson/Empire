SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwGetDate] as
select	*
from	EEH.[dbo].[vwGetDate] with (READUNCOMMITTED)
GO
