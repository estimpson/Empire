SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[process] as
select	*
from	EEH.[dbo].[process] with (READUNCOMMITTED)
GO
