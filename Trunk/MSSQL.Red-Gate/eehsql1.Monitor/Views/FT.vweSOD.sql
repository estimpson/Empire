SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweSOD] as
select	*
from	EEH.[FT].[vweSOD] with (READUNCOMMITTED)
GO
