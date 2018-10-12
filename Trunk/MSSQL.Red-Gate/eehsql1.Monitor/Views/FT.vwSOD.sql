SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwSOD] as
select	*
from	EEH.[FT].[vwSOD] with (READUNCOMMITTED)
GO
