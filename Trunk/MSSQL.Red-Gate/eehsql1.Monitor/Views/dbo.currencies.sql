SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[currencies] as select * from EEH_Empower.dbo.currencies
UNION ALL SELECT 'YEN','YEN',0,0,'2017-05-02 16:09:41.000','MON','¥','en-US'


GO
