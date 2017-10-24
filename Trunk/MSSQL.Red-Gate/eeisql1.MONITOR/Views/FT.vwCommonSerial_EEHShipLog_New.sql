SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[vwCommonSerial_EEHShipLog_New]
as
select	*
from	OpenQuery ([EEHSQL1], 'select * from Monitor.FT.CommonSerialShipLog where RowStatus is null')

GO
