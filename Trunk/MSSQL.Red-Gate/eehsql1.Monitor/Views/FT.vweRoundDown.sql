SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweRoundDown] as
select	*
from	EEH.[FT].[vweRoundDown] with (READUNCOMMITTED)
GO
