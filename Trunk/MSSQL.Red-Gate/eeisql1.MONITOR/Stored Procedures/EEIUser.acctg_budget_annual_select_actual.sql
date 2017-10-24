SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure	[EEIUser].[acctg_budget_annual_select_actual] 
						(
							@fiscal_year varchar(4)
							,@period numeric(2,0)
							,@ledger_account varchar(10)						)
as
begin
select	ledger_account 
		,contract_account_id 
		,document_id2 
		,document_id1 
		,transaction_date 
		,amount 
		,document_remarks
		,document_type
		,document_line
from	gl_cost_transactions 
where	fiscal_year = @fiscal_year
		and period = @period
		and ledger_account = @ledger_account
		and update_balances = 'Y' 
order by	contract_account_id
			,document_id2
			,document_id1
end





GO
