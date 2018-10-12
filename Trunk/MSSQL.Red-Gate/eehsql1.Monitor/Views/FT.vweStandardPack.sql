SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweStandardPack] as
select	*
from	EEH.[FT].[vweStandardPack] with (READUNCOMMITTED)
GO
