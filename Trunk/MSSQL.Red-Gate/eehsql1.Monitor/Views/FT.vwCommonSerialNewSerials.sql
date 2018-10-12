SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwCommonSerialNewSerials] as
select	*
from	EEH.[FT].[vwCommonSerialNewSerials] with (READUNCOMMITTED)
GO
