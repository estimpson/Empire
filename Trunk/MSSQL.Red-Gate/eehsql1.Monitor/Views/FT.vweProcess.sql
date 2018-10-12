SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweProcess] as
select	*
from	EEH.[FT].[vweProcess] with (READUNCOMMITTED)
GO
