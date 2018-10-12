SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOD] as
select	*
from	EEH.[FT].[vwPOD] with (READUNCOMMITTED)
GO
