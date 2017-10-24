SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_budget_annual_insert] 
	(
	@budget_id varchar(50),
	@ledger_account varchar(50),
	@fiscal_year varchar(4),	
	@budget_line varchar(50),	
--  @cashflow varchar(10),	
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
	@budget_description varchar(255))
as
begin

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				1,
				@budget1
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				2,
				@budget2
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				3,
				@budget3
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				4,
				@budget4
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				5,
				@budget5
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				6,
				@budget6
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				7,
				@budget7
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				8,
				@budget8
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				9,
				@budget9
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				10,
				@budget10
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				11,
				@budget11
				)

insert into		eeiuser.acctg_budget
values			(
				@budget_id,
				@ledger_account,
				@budget_line,
				'YES',
				@budget_description,
				@fiscal_year,
				12,
				@budget12
				)

end
























--declare			@period int
--set				@period = 1
--
-- declare		@period_amount
-- set			if @period = 1 then @period_amount = @budget1 else @period_amount = @budget2 else @period_amount = @budget3...
--
--while			(@Period <= 12) 
--	begin
--
--		insert into		eeiuser.acctg_budget
--		values			(
--						@budget_id,
--						@ledger_account,
--						@budget_line,
--						@cashflow,
--						@budget_description,
--						@fiscal_year,
--						@period,
--						0
--						)
--
--		set				@Period = @Period + 1

--	end
GO
