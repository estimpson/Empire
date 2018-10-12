SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Proc_PurchasingReportData_beta] 
	@Ledger_Account VARCHAR(50),
	@PurchasingReport varchar(1) = 'Y'
as
exec	EEH.dbo.Proc_PurchasingReportData_beta
			@Ledger_Account = @Ledger_Account,
			@PurchasingReport = @PurchasingReport
GO
