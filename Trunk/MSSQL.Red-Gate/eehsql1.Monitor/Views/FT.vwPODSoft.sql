SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPODSoft] as
select	*
from	EEH.[FT].[vwPODSoft] with (READUNCOMMITTED)
GO
