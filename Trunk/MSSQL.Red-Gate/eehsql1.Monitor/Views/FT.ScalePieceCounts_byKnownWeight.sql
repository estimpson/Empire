SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create	view [FT].[ScalePieceCounts_byKnownWeight] as
select	*
from	EEH.FT.ScalePieceCounts_byKnownWeight with (readuncommitted)
GO
