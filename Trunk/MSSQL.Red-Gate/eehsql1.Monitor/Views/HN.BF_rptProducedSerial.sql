SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[BF_rptProducedSerial] as
select	*
from	EEH.[HN].[BF_rptProducedSerial] with (READUNCOMMITTED)
GO
