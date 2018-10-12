SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweRoundDownFP] as
select	*
from	EEH.[FT].[vweRoundDownFP] with (READUNCOMMITTED)
GO
