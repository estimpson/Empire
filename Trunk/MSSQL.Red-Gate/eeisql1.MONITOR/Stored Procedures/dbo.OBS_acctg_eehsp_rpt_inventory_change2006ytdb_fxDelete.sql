SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[OBS_acctg_eehsp_rpt_inventory_change2006ytdb_fxDelete]

as

begin

-- clear the rows from the permanent table to allow repopulation


TRUNCATE TABLE		Acctg_ActivityComparison_2006ytd


SET ANSI_WARNINGS OFF

-- Create the table to store Empower GL transactions for the selected month

	
	Create table		#SelectedEmpowerTransactions	(
									EmpowerSerial		varchar(50),
									EmpowerPart		varchar(50),
									EmpowerTransactionDate	varchar(50),
									EmpowerTransactionType	char(2),
									EmpowerQuantity		decimal(30,6),
									EmpowerCost		decimal(30,6),
									EmpowerExtCost		decimal(30,6)
								)

	Create index		#idxSelectedEmpowerTransactions on #SelectedEmpowerTransactions(EmpowerPart)


-- Populate the table


	Insert			#SelectedEmpowerTransactions (EmpowerSerial, EmpowerPart, EmpowerTransactionDate, EmpowerTransactionType, EmpowerExtCost)

		select		gl_cost_transactions.document_id1,
					gl_cost_transactions.document_reference1,
					gl_cost_transactions.document_id2,
					gl_cost_transactions.document_id3,
					gl_cost_transactions.amount

		from		gl_cost_transactions

		where		ledger = 'HONDURAS' and
					fiscal_year = 2006 and
					period in ('1', '2', '3', '4', '5') and
					ledger_account = '153112' and
					update_balances = 'Y'

		order by 	2,4,3,1



-- Create the table to store Monitor activity for the selected month


	Create table		#SelectedMonitorTransactions	(
									MonitorSerial			varchar(50),
									MonitorPart			varchar(50),
									MonitorTransactionDate		datetime,
									MonitorTransactionType		char(2),
									MonitorQuantity			decimal(30,6),
									MonitorCost			decimal(30,6),
									MonitorExtCost			decimal(30,6),
									MonitorUserDefined		varchar(50)
								)

	create index		#idxSelectedMonitorTransactions on #SelectedMonitorTransactions(MonitorPart)


-- Populate the table
	
	Insert			#SelectedMonitorTransactions

		select		audit_trail.serial,
					audit_trail.part,
					audit_trail.date_stamp,
					audit_trail.type,
					audit_trail.quantity,
					part_standard_copy_20060531.material_cum,
					(audit_trail.quantity*part_standard_copy_20060531.material_cum),
					audit_trail.user_defined_status

		from		audit_trail

		left outer join	part_copy_20060531 on audit_trail.part = part_copy_20060531.part
		left outer join	part_standard_copy_20060531 on audit_trail.part = part_standard_copy_20060531.part

		where		audit_trail.date_stamp >= '2006-01-01 00:00:00' and
					audit_trail.date_stamp < '2006-06-01 00:00:00' and
					((audit_trail.type not in ('B','T','Z')) or
					(audit_trail.type = 'Q' and audit_trail.user_defined_status = 'Scrapped') or
					(audit_trail.type = 'D' and audit_trail.user_defined_status <> 'Scrapped')) and
					part_copy_20060531.type not in ('R','W','')

		order by 	2,4,3,1


-- Get rid of unwanted rows

	Delete from		#SelectedMonitorTransactions

			where	MonitorTransactionType = 'Q' and MonitorUserDefined <> 'Scrapped'

	Delete from		#SelectedMonitorTransactions

			where	MonitorTransactionType = 'D' and MonitorUserDefined = 'Scrapped'


-- The following permanent table was created to compare Empower and Monitor activity for the selected month

--	Create table		Acctg_ActivityComparison_2006ytd		(
--									Part			varchar(50),
--									ProductLine		varchar(50),
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
--	Create index		idxAcctg_ActivityComparison_2006ytd on Acctg_ActivityComparison_2006ytd(Part)


-- Populate the table

-- Insert Empower activity for the selected month



	Insert			Acctg_ActivityComparison_2006ytd (Part, GLSerial, GLTransactionDate, GLTransactionType, GLExtCost)

		select		#SelectedEmpowerTransactions.EmpowerPart,
					#SelectedEmpowerTransactions.EmpowerSerial,
					#SelectedEmpowerTransactions.EmpowerTransactionDate,
					#SelectedEmpowerTransactions.EmpowerTransactionType,
					#SelectedEmpowerTransactions.EmpowerExtCost

		from		#SelectedEmpowerTransactions


-- Add Monitor activity to the Empower activity for the selected month


	Update			Acctg_ActivityComparison_2006ytd

		set			GLQuantity = #SelectedMonitorTransactions.MonitorQuantity,
					AuditSerial = #SelectedMonitorTransactions.MonitorSerial,
					AuditTransactionDate = #SelectedMonitorTransactions.MonitorTransactionDate,
					AuditTransactionType = #SelectedMonitorTransactions.MonitorTransactionType,
					AuditQuantity = #SelectedMonitorTransactions.MonitorQuantity,
					AuditCost = #SelectedMonitorTransactions.MonitorCost,
					AuditExtCost = #SelectedMonitorTransactions.MonitorExtCost

		from		#SelectedMonitorTransactions, Acctg_ActivityComparison_2006ytd
	
		where		Acctg_ActivityComparison_2006ytd.GLSerial = #SelectedMonitorTransactions.MOnitorSerial and
				    Acctg_ActivityComparison_2006ytd.GLTransactionType = #SelectedMonitorTransactions.MonitorTransactionType



-- Insert Monitor activity for the selected month where no Empower activity for the selected month


	Insert			Acctg_ActivityComparison_2006ytd (Part, AuditSerial, AuditTransactionDate, AuditTransactionType, AuditQuantity, AuditCost, AuditExtCost)

		select		#SelectedMonitorTransactions.MonitorPart,
					#SelectedMonitorTransactions.MonitorSerial,
					#SelectedMonitorTransactions.MOnitorTransactionDate,
					#SelectedMonitorTransactions.MonitorTransactionType,
					#SelectedMonitorTransactions.MonitorQuantity,
					#SelectedMonitorTransactions.MonitorCost,
					#SelectedMonitorTransactions.MonitorExtCost

		from		#SelectedMonitorTransactions

		where		#SelectedMonitorTransactions.MonitorSerial+#SelectedMonitorTransactions.MonitorTransactionType not in (Select Acctg_ActivityComparison_2006ytd.GLSerial+Acctg_ActivityComparison_2006ytd.GLTransactionType from Acctg_ActivityComparison_2006ytd)



-- Fix Empower and Monitor quantity and Monitor extended cost

	Update			Acctg_ActivityComparison_2006ytd

		set			Acctg_ActivityComparison_2006ytd.AuditQuantity = -1*Acctg_ActivityComparison_2006ytd.AuditQuantity,
					Acctg_ActivityComparison_2006ytd.AuditExtCost = -1*Acctg_ActivityComparison_2006ytd.AuditExtCost,
					Acctg_ActivityComparison_2006ytd.GLQuantity = -1*Acctg_ActivityComparison_2006ytd.GLQuantity,
					Acctg_ActivityComparison_2006ytd.GLCost = Acctg_ActivityComparison_2006ytd.GLExtCost/(-1*Acctg_ActivityComparison_2006ytd.GLQuantity)

		from		Acctg_ActivityComparison_2006ytd

		where		Acctg_ActivityComparison_2006ytd.AuditTransactionType in ('D','M','Q','S','V')



-- Add product_line


	Update			Acctg_ActivityComparison_2006ytd

		set			ProductLine = part_copy_20060531.product_line
			
		from		part_copy_20060531, Acctg_ActivityComparison_2006ytd

		where		Acctg_ActivityComparison_2006ytd.part = part_copy_20060531.part


End

-- OUTPUT DATA


-- Select *, GLExtCost-AuditExtCost as difference from ActivityComparison_2006ytd

-- Order by 1,5,4,3

GO
