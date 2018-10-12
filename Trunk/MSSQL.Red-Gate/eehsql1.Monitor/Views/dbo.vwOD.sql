SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwOD] as
select	*
from	EEH.[dbo].[vwOD] with (READUNCOMMITTED)
GO
