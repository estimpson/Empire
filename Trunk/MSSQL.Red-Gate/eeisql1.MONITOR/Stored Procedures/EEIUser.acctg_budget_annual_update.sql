SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_budget_annual_update] 
(
@budget_id varchar(50),
@ledger_account varchar(50), 
@fiscal_year varchar(5),
@budget_line varchar(50), 
@budget1 decimal(18,2), 
@budget2 decimal(18,2), 
@budget3 decimal(18,2), 
@budget4 decimal(18,2), 
@budget5 decimal(18,2), 
@budget6 decimal(18,2), 
@budget7 decimal(18,2), 
@budget8 decimal(18,2), 
@budget9 decimal(18,2), 
@budget10 decimal(18,2), 
@budget11 decimal(18,2), 
@budget12 decimal(18,2), 
@total_budget decimal(18,2),
@budget_description varchar(500)
)

as
begin

update eeiuser.acctg_budget set period_amount = @budget1, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 1 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget2, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 2 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget3, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 3 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget4, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 4 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget5, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 5 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget6, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 6 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget7, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 7 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget8, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 8 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget9, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 9 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget10, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 10 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget11, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 11 and budget_line = @budget_line
update eeiuser.acctg_budget set period_amount = @budget12, budget_description = @budget_description where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year and period = 12 and budget_line = @budget_line

end
GO
