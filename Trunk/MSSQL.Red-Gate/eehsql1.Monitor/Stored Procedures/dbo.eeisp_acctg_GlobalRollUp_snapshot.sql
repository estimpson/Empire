SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_acctg_GlobalRollUp_snapshot]  (@period int, @FiscalYear int)
as
begin
Select distinct time_stamp 
from		[HistoricalData].dbo.part_standard_historical 
where	period = @period and fiscal_year = @FiscalYear
End
GO
