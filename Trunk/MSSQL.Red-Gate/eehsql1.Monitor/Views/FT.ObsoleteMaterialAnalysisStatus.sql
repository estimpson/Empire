SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ObsoleteMaterialAnalysisStatus] as
select	*
from	EEH.[FT].[ObsoleteMaterialAnalysisStatus] with (READUNCOMMITTED)
GO
