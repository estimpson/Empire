SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_eei_getdate]
AS
Select	FT.fn_TruncDate('wk',GETDATE() ) as CurrentSunday, 
		FT.fn_TruncDate('m',GETDATE() ) as FirstDOM,  
		FT.fn_TruncDate('dd',GETDATE() ) as CurrentDate,
		Dateadd(dd,1,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkMonday,
		Dateadd(dd,2,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkTuesday,
		Dateadd(dd,3,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkWednesday,
		Dateadd(dd,4,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkThursday,
		Dateadd(dd,5,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkFriday,
		Dateadd(dd,6,FT.fn_TruncDate('wk',GETDATE() )) as CurrentWkSaturday
		
GO
