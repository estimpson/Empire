SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweRoundDownDetail] as
select	*
from	EEH.[FT].[vweRoundDownDetail] with (READUNCOMMITTED)
GO
