SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[CommonSerialShipLog] as
select	*
from	EEH.[FT].[CommonSerialShipLog] with (READUNCOMMITTED)
GO
