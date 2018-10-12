SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwCommonSerialPOD] as
select	*
from	EEH.[FT].[vwCommonSerialPOD] with (READUNCOMMITTED)
GO
