SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[EndofProgramRawParts_TEMP] as
select	*
from	EEH.[FT].[EndofProgramRawParts_TEMP] with (READUNCOMMITTED)
GO
