SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







Create procedure [dbo].[OBS_acctg_eehsp_rpt_1510inventoryreconciliationreport_200608_fxDelete]

as 

begin


-- clear the rows from the permanent table to allow repopulation

TRUNCATE TABLE		Acctg_ActivityComparison
TRUNCATE TABLE		SelectedEmpowerTransactions



-- Create the table to store Empower GL transactions for the selected month
	
--	Create table		SelectedEmpowerTransactions	(
--									EmpowerSerial		varchar(50),
--									EmpowerPart		varchar(50),
--									EmpowerTransactionDate	varchar(50),
--									EmpowerTransactionType	varchar(25),
--									EmpowerQuantity		decimal(18,6),
--									EmpowerCost		decimal(18,6),
--									EmpowerExtCost		decimal(18,6)
--								)
--
--	Create index		idxSelectedEmpowerTransactions on SelectedEmpowerTransactions(EmpowerPart)


-- Populate the table

	Insert			SelectedEmpowerTransactions (EmpowerSerial, EmpowerPart, EmpowerTransactionDate, EmpowerTransactionType, EmpowerExtCost)

		select		gl_cost_transactions.document_id1,
				gl_cost_transactions.document_reference1,
				gl_cost_transactions.document_id2,
				gl_cost_transactions.document_id3,
				gl_cost_transactions.amount

		from		gl_cost_transactions

		where		ledger = 'HONDURAS' and
				fiscal_year = 2006 and
				period = 8 and
				ledger_account = '151012' and
				update_balances = 'Y'

		order by 	2,4,3,1



-- Create the table to store Monitor activity for the selected month


	Create table		#SelectedMonitorTransactions	(
									MonitorSerial		varchar(50),
									MonitorPart		varchar(50),
									MonitorTransactionDate	datetime,
									MonitorTransactionType	char(2),
									MonitorQuantity		decimal(30,6),
									MonitorCost		decimal(30,6),
									MonitorExtCost		decimal(30,6),
									MonitorUserDefined	varchar(50)
								)

	create index		#idxSelectedMonitorTransactions on #SelectedMonitorTransactions(MonitorPart)


-- Populate the table
	
	Insert			#SelectedMonitorTransactions

		select		audit_trail.serial,
				audit_trail.part,
				audit_trail.date_stamp,
				audit_trail.type,
				audit_trail.quantity,
				part_standard_copy_20060831.material_cum,
				(audit_trail.quantity*part_standard_copy_20060831.material_cum),
				audit_trail.user_defined_status

		from		audit_trail

		left outer join	part_copy_20060831 on audit_trail.part = part_copy_20060831.part
		left outer join	part_standard_copy_20060831 on audit_trail.part = part_standard_copy_20060831.part

		where		audit_trail.date_stamp >= '2006-08-01 00:00:00' and
				audit_trail.date_stamp < '2006-09-01 00:00:00' and
				((audit_trail.type not in ('B','C','T','Z')) or
				(audit_trail.type = 'Q' and audit_trail.user_defined_status = 'Scrapped') or
				(audit_trail.type = 'D' and audit_trail.user_defined_status <> 'Scrapped')) and
				part_copy_20060831.type not in ('F','W','','O')

		order by 	2,4,3,1


-- Get rid of unwanted rows

	Delete from		#SelectedMonitorTransactions

			where	MonitorTransactionType = 'Q' and MonitorUserDefined <> 'Scrapped'

	Delete from		#SelectedMonitorTransactions

			where	MonitorTransactionType = 'D' and MonitorUserDefined = 'Scrapped'


-- The following permanent table was created to compare Empower and Monitor activity for the selected month

--	Create table		Acctg_ActivityComparison		(
--									Part			varchar(50),
--									ProductLine		archar(50),
--									GLSerial		varchar(50),
--									GLTransactionDate	varchar(50),
--									GLTransactionType	char(2),
--									GLQuantity		decimal(30,6),
--									GLCost			decimal(30,6),
--									GlExtCost		decimal(30,6),
--									AuditSerial		varchar(50),
--									AuditTransactionDate	datetime,
--									AuditTransactionType	char(2),
--									AuditQuantity		decimal(30,6),
--									AuditCost		decimal(30,6),
--									AuditExtCost		decimal(30,6)
--								)
--
--	Create index		idxAcctg_ActivityComparison on Acctg_ActivityComparison(Part)


-- Populate the table

-- Insert Empower activity for the selected month



	Insert			Acctg_ActivityComparison (Part, GLSerial, GLTransactionDate, GLTransactionType, GLExtCost)

		select		SelectedEmpowerTransactions.EmpowerPart,
				SelectedEmpowerTransactions.EmpowerSerial,
				SelectedEmpowerTransactions.EmpowerTransactionDate,
				SelectedEmpowerTransactions.EmpowerTransactionType,
				SelectedEmpowerTransactions.EmpowerExtCost

		from		SelectedEmpowerTransactions


-- Add Monitor activity to the Empower activity for the selected month


	Update			Acctg_ActivityComparison

		set		GLQuantity = #SelectedMonitorTransactions.MonitorQuantity,
				AuditSerial = #SelectedMonitorTransactions.MonitorSerial,
				AuditTransactionDate = #SelectedMonitorTransactions.MonitorTransactionDate,
				AuditTransactionType = #SelectedMonitorTransactions.MonitorTransactionType,
				AuditQuantity = #SelectedMonitorTransactions.MonitorQuantity,
				AuditCost = #SelectedMonitorTransactions.MonitorCost,
				AuditExtCost = #SelectedMonitorTransactions.MonitorExtCost

		from		#SelectedMonitorTransactions, Acctg_ActivityComparison
	
		where		Acctg_ActivityComparison.GLSerial = #SelectedMonitorTransactions.MOnitorSerial and
				Acctg_ActivityComparison.GLTransactionType = #SelectedMonitorTransactions.MonitorTransactionType



-- Insert Monitor activity for the selected month where no Empower activity for the selected month


	Insert			Acctg_ActivityComparison (Part, AuditSerial, AuditTransactionDate, AuditTransactionType, AuditQuantity, AuditCost, AuditExtCost)

		select		#SelectedMonitorTransactions.MonitorPart,
				#SelectedMonitorTransactions.MonitorSerial,
				#SelectedMonitorTransactions.MOnitorTransactionDate,
				#SelectedMonitorTransactions.MonitorTransactionType,
				#SelectedMonitorTransactions.MonitorQuantity,
				#SelectedMonitorTransactions.MonitorCost,
				#SelectedMonitorTransactions.MonitorExtCost

		from		#SelectedMonitorTransactions

		where		#SelectedMonitorTransactions.MonitorSerial+#SelectedMonitorTransactions.MonitorTransactionType not in (Select Acctg_ActivityComparison.GLSerial+Acctg_ActivityComparison.GLTransactionType from Acctg_ActivityComparison)



-- Fix Empower and Monitor quantity and Monitor extended cost

	Update			Acctg_ActivityComparison

		set		Acctg_ActivityComparison.AuditQuantity = -1*Acctg_ActivityComparison.AuditQuantity,
				Acctg_ActivityComparison.AuditExtCost = -1*Acctg_ActivityComparison.AuditExtCost,
				Acctg_ActivityComparison.GLQuantity = -1*Acctg_ActivityComparison.GLQuantity,
				Acctg_ActivityComparison.GLCost = Acctg_ActivityComparison.GLExtCost/(-1*Acctg_ActivityComparison.GLQuantity)

		from		Acctg_ActivityComparison

		where		Acctg_ActivityComparison.AuditTransactionType in ('D','M','Q','S','V')



-- Add product_line


	Update			Acctg_ActivityComparison

		set		ProductLine = part_copy_20060831.product_line
			
		from		part_copy_20060831, Acctg_ActivityComparison

		where		Acctg_ActivityComparison.part = part_copy_20060831.part


End


GO
