SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure	[EEIUser].[acctg_budget_annual_update_actual] 
						(
							@fiscal_year varchar(4)
							,@period numeric(2,0)
							,@ledger_account varchar(10)							
							,@contract_account_id varchar(20)
							,@document_id2 varchar(25)							
							,@document_id1 varchar(25)
							,@transaction_date datetime
							,@amount decimal(12,2)
							,@document_remarks varchar(250)
							,@document_line varchar(3)
							,@document_type varchar(25)						)
as
begin
update	gl_cost_transactions 
set		contract_account_id = @contract_account_id
from	gl_cost_transactions 
where	ledger_account = @ledger_account
		and fiscal_year = @fiscal_year
		and period = @period
		and document_type = @document_type
		and document_id1 = @document_id1
		and document_id2 = @document_id2
		and document_line = @document_line
		and update_balances = 'Y' 
end

GO
