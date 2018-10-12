SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwProcessResults] as
select	*
from	EEH.[FT].[vwProcessResults] with (READUNCOMMITTED)
GO
