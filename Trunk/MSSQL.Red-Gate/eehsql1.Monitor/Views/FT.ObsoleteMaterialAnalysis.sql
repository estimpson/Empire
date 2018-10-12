SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ObsoleteMaterialAnalysis] as
select	*
from	EEH.[FT].[ObsoleteMaterialAnalysis] with (READUNCOMMITTED)
GO
