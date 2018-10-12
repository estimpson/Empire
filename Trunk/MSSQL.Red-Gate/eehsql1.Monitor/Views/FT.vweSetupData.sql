SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweSetupData] as
select	*
from	EEH.[FT].[vweSetupData] with (READUNCOMMITTED)
GO
