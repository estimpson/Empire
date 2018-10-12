SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwBOM] as
select	*
from	EEH.[FT].[vwBOM] with (READUNCOMMITTED)
GO
