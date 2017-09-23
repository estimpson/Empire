SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[OBS_acctg_inventory_reconciliation]
(	@BegDate datetime,
	@EndDate datetime,
	@Account varchar (10),
	@PartType char(1))
as
/*
execute	[EEIUser].[acctg_inventory_reconciliation]
	@BegDate = '2009-03-11',
	@EndDate = '2009-03-11',
	@Account = '151012',
	@PartType = 'R'

*/
set nocount on
declare	@Ledger varchar(10),
		@AdjBeginDT datetime,
		@AdjEndDT datetime,
		@ATBeginDate datetime,
		@ATEndDate datetime		

set		@Ledger = 'HONDURAS'

--	Get the adjusted beginning date and ending date from snapshots in part historical daily.

set	@ATBeginDate =
	(	select	dateadd(dd,1,ft.fn_truncdate('dd',max (time_stamp)))
		from		part_historical_daily
		where	time_stamp <= @BegDate)

set	@ATEndDate =
	(	select	dateadd(dd,1,ft.fn_truncdate('dd',max (time_stamp)))
		from		part_historical_daily
		where	time_stamp < dateadd(dd,1,@EndDate))

set	@AdjBeginDT =
	(	select	max (time_stamp)
		from		part_historical_daily
		where	time_stamp <= @BegDate)

set	@AdjEndDT =
	(	select	max (time_stamp)
		from		part_historical_daily
		where	time_stamp <= dateadd (ms, -2, @EndDate + 1))

Create table	#PartSetupBegin
(	Part varchar (25),
	Type char (1) null,
	ProductLine varchar (25) null,
	CostMaterial numeric (20,6) null, primary key (part))

Create table #PartSetupEnd
(	Part varchar (25) ,
	Type char (1) null,
	ProductLine varchar (25) null,
	CostMaterial numeric (20,6) null, primary key (part))

Create  table #PartSetupDaily
(	Part varchar (25),
	FromDT datetime,
	ToDT datetime,
	Type char (1) null,
	ProductLine varchar (25) null,
	CostMaterial numeric (20,6) null,
	primary key (Part, FromDT, ToDT))

--	Populate the tables with begin and end material cost.
--Print  getdate()
insert	#PartSetupBegin
(	Part,
	Type,
	ProductLine,
	CostMaterial)
select	Part = PriorMonthPart.Part,
		Type = PriorMonthPart.Type,
		ProductLine = PriorMonthPart.ProductLine,
		CostMaterial = PriorMonthCost.CostMaterial

from	(	select	Part = PriorMonthCost.part,
				CostMaterial = PriorMonthCost.material_cum
		from		part_standard_historical_daily PriorMonthCost
		where	PriorMonthCost.time_stamp = @AdjBeginDT) PriorMonthCost
	join
	(	select	Part = PriorMonthPart.part,
				Type = PriorMonthPart.Type,
				ProductLine = PriorMonthPart.product_line
		from		part_historical_daily PriorMonthPart
		where	PriorMonthPart.time_stamp = @AdjBeginDT and
				PriorMonthPart.type = @PartType) PriorMonthPart on PriorMonthCost.Part = PriorMonthPart.Part

insert	#PartSetupEnd
(	Part,
	Type,
	ProductLine,
	CostMaterial)
select	Part = CurrentMonthPart.Part,
		Type = CurrentMonthPart.Type,
		ProductLine = CurrentMonthPart.ProductLine,
		CostMaterial = CurrentMonthCost.CostMaterial
from	(	select	Part = CurrentMonthCost.part,
				CostMaterial = CurrentMonthCost.material_cum
		from		part_standard_historical_daily CurrentMonthCost
		where	CurrentMonthCost.time_stamp = @AdjEndDT) CurrentMonthCost
	join
	(	select	Part = CurrentMonthPart.part,
				Type = CurrentMonthPart.Type,
				ProductLine = CurrentMonthPart.product_line
		from		part_historical_daily CurrentMonthPart
		where	CurrentMonthPart.time_stamp = @AdjEndDT and
				CurrentMonthPart.type = @PartType) CurrentMonthPart on CurrentMonthCost.Part = CurrentMonthPart.Part

insert	#PartSetupDaily
(	Part,
	Type,
	FromDT,
	ToDT,
	ProductLine,
	CostMaterial)
select	Part = DailyPart.Part,
		Type = DailyPart.Type,
		FromDT =
		(select	max (time_stamp)
		from		part_standard_historical_daily
		where	reason = 'DAILY' and
				time_stamp < DailyCost.DateStamp),
		ToDT = DailyCost.DateStamp,
		ProductLine = DailyPart.ProductLine,
		CostMaterial = DailyCost.CostMaterial
from	(	select	Part = part,
				CostMaterial = material_cum,
				DateStamp = time_stamp
		from		part_standard_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
			reason = 'DAILY') DailyCost
	join
	(	select	Part = part,
				Type = type,
				ProductLine = product_line,
				DateStamp = time_stamp
		from		part_historical_daily
		where	time_stamp between @AdjBeginDT and @AdjEndDT and
				reason = 'DAILY' and
				part_historical_daily.type = @PartType)	DailyPart on DailyCost.Part = DailyPart.Part and
								DailyCost.DateStamp = DailyPart.DateStamp

--	Create the table to store prior month inventory.
create table #PriorMonthInv
(	Part varchar(50) ,
	PriorType char(1),
	PriorProductLine varchar(50),
	PriorQuantity decimal(30,6),
	PriorCost decimal(30,6),
	PriorExtCost decimal(30,6) primary key nonclustered (part) )

--	Populate the table.
--Print  getdate()
insert	#PriorMonthInv
select 	ohd1.part,
		PartSetupBegin.Type,
		PartSetupBegin.ProductLine,
		sum (ohd1.std_quantity),
		min (PartSetupBegin.CostMaterial),
		sum (ohd1.std_quantity*PartSetupBegin.CostMaterial) 
from 	object_historical_daily ohd1
join		#PartSetupBegin PartSetupBegin on ohd1.part = PartSetupBegin.Part
where	ohd1.time_stamp = @AdjBeginDT
		and ohd1.reason = 'Daily'
		and isNULL(ohd1.user_defined_status, 'XXX') !=  'PRESTOCK'
group by
		ohd1.part,
		PartSetupBegin.Type,
		PartSetupBegin.ProductLine

--	Create the table to store current month inventory.
create table #CurrentMonthInv
(	Part varchar(50) ,
	CurrentType char(1),
	CurrentProductLine varchar(50),
	CurrentQuantity decimal(30,6),
	CurrentCost decimal(30,6),
	CurrentExtCost decimal(30,6), primary key nonclustered (part))

--	Populate the table.
insert	#CurrentMonthInv
select 	ohd2.part,
		PartSetupEnd.Type,
		PartSetupEnd.ProductLine,
		sum (ohd2.std_quantity),
		min (PartSetupEnd.CostMaterial),
		sum (ohd2.std_quantity*PartSetupEnd.CostMaterial) 
from 	object_historical_daily ohd2
join		#PartSetupEnd PartSetupEnd on ohd2.part = PartSetupEnd.Part
where	ohd2.time_stamp = @AdjEndDT
		and ohd2.reason = 'Daily'
		and isNULL(ohd2.user_defined_status, 'XXX') !=  'PRESTOCK'
group by
		ohd2.part,
		PartSetupEnd.Type,
		PartSetupEnd.ProductLine

create table #CurrentTransactions
(	CTPart varchar(50) ,
	CTProductLine varchar(50),
	CTType char(1),
	CTQuantity decimal(30,6), primary key nonclustered (CTpart))

--	Populate the table.
insert	#CurrentTransactions
Select	distinct at9.part,
		part.product_line,
		part.type,
		1 as ATQty
 from	audit_trail at9
(index = idx_audit_trail_date_type_part_std_quantity)
join	part on at9.part = part.part
where	at9.date_stamp >= @ATBeginDate and
		at9.date_stamp < @ATEndDate and
		part.type = @partType


create table #Acctg_InvChange
(	Part varchar (50) not null primary key,
	PriorType char (1) null,
	PriorProductLine varchar (50) null,
	PriorQuantity decimal (30, 6) null,
	PriorCost decimal (30, 6) null,
	PriorExtCost decimal (30, 6) null,
	CurrentType char (1) null,
	CurrentProductLine varchar (50) null,
	CurrentQuantity decimal (30, 6) null,
	CurrentCost decimal (30, 6) null,
	CurrentExtCost decimal (30, 6) null,
	PeriodChange decimal (30, 6) null)

--	Populate the table.				
--	Add prior month inventory and current month inventory.
--Print  getdate()
insert	#Acctg_InvChange
select	coalesce (BEPart, PartTransactions.CTpart),
		coalesce (nullif(BEType,''),PartTransactions.CTType ),
		coalesce (nullif(BEproductLine,''), PartTransactions.CTProductLine),
		coalesce (BEInv,0),
		coalesce (BECost,0),
		coalesce (BEExtended,0),
		coalesce (Nullif(Endtype,''),PartTransactions.CTType),
		coalesce (nullif(EndProductLine,''), PartTransactions.CTProductLine),
		coalesce (EndInv,0),
		coalesce (EndCost,0),
		coalesce (EndExtended,0),
		coalesce (BeginEndExtendedDiff,0)
from		(Select coalesce (PriorMonthInv.Part, CurrentMonthInv.Part) BEpart,
		coalesce (PriorMonthInv.PriorType,CurrentMonthInv.CurrentType ) BEType,
		coalesce (PriorMonthInv.PriorProductLine,CurrentMonthInv.CurrentProductLine) BEProductLine,
		coalesce (PriorMonthInv.PriorQuantity,0) BEInv,
		coalesce (PriorMonthInv.PriorCost,0) BECost,
		coalesce (PriorMonthInv.PriorExtCost,0) BEExtended,
		coalesce (CurrentMonthInv.CurrentType,PriorMonthInv.PriorType) EndType,
		coalesce (CurrentMonthInv.CurrentProductLine,PriorMonthInv.PriorProductLine) EndProductLine,
		coalesce (CurrentMonthInv.CurrentQuantity,0) EndInv,
		coalesce (CurrentMonthInv.CurrentCost,0) EndCost,
		coalesce (CurrentMonthInv.CurrentExtCost,0) EndExtended,
		coalesce (isNull(CurrentMonthInv.CurrentExtCost,0) - isNull(PriorMonthInv.PriorExtCost,0),0) as BeginEndExtendedDiff
		from			#PriorMonthInv PriorMonthInv
		full join		#CurrentMonthInv CurrentMonthInv on PriorMonthInv.Part = CurrentMonthInv.part)  BeginEndInventory
		full join		#CurrentTransactions PartTransactions on BeginEndInventory.BEpart = PartTransactions.CTPart
		where (isnull(CTQuantity,0)+ isnull(BEInv,0) +isNull(EndInv,0)) > 0


--	Update table for instances of current month activity but no current month or prior month ending inventory.
--Print  getdate()
insert	#Acctg_InvChange
select distinct
	document_reference1,
	'',
	'',
	0,
	0,
	0,
	'',
	'',
	0,
	0,
	0,
	0
from	gl_cost_transactions
(index = glcosttrans_transaction_date)
where	ledger = @Ledger
		and ledger_account = @Account
		and fiscal_year between convert (varchar, datepart (yyyy, @AdjBeginDT)) and convert (varchar, datepart (yyyy, @AdjEndDT))		
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) >= @AdjBeginDT
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) < @AdjEndDT
		and update_balances = 'Y'
		and document_reference1 not in (select Part from #Acctg_InvChange)

--	Add product_line, Calculate period change.
/*---------------------------------------------------------------------------------------------Ask Dan why this following statement 2009-02-19 Andre S. Boulanger---------------------------------------------------------------*/
/*update	#Acctg_InvChange
set	CurrentType = PartSetupEnd.Type,
	CurrentProductLine = PartSetupEnd.ProductLine,
	PeriodChange = CurrentExtCost - PriorExtCost
from	#Acctg_InvChange Acctg_InvChange 
	left outer join #PartSetupEnd PartSetupEnd on Acctg_InvChange.Part = PartSetupEnd.Part*/

		

--	Create the table to store Empower activity for the selected month.
create table #SelectedEmpowerTransactions
(	EmpowerSerial varchar (50) not null,
	EmpowerPart varchar (50) null,
	EmpowerGLAccount varchar(50) not null,
	EmpowerTransactionDate datetime not null,
	EmpowerTransactionType varchar (25) not null,
	EmpowerExtCost decimal (18, 6) null,
	EmpowerDescription varchar(200) null,
	primary key nonclustered (EmpowerTransactionDate, EmpowerSerial, EmpowerTransactionType))

--	Populate the table with Empower activity for the selected month.
--Print  getdate()
insert	#SelectedEmpowerTransactions
(	EmpowerSerial, EmpowerPart, EmpowerGLAccount , EmpowerTransactionDate, EmpowerTransactionType, EmpowerExtCost, EmpowerDescription)
--added case statement to align columns for serial number depending on different transaction type
select	EmpowerSerial = (case when document_type = 'MON INV' then document_id1 else document_reference2 end),
		EmpowerPart = document_reference1,
		EmpowerGLAccount = ledger_account,
		EmpowerTransactionDate =
		case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
			then		convert (datetime, document_id2)
			else		transaction_date
		end,
		EmpowerTransactionType = document_id3,
		EmpowerExtCost = amount,
		EmpowerDescription = document_remarks
from		gl_cost_transactions
(index = glcosttrans_transaction_date)
where	ledger = @Ledger
		and ledger_account = @Account
		and fiscal_year between convert(varchar,datepart(yyyy,@AdjBeginDT)) and convert(varchar,datepart(yyyy,@AdjEndDT))		
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) >= @AdjBeginDT
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) < @AdjEndDT
		and update_balances = 'Y' and
		isNULL(document_type,'X')!='Journal Entry'
order by
	2,4,3,1

--	Create the table to store Monitor activity for the selected month.
create  table	#SelectedMonitorTransactions
(	MonitorSerial varchar(50),
	MonitorPart varchar(50),
	MonitorTransactionDate datetime,
	MonitorTransactionType char(1) ,
	MonitorQuantity decimal(30,6) null,
	MonitorCost decimal(30,6)null,
	MonitorExtCost decimal(30,6) null,
	MonitorUserDefined varchar(50) null,
	MonitorRemarks varchar(10) NOT null,
	primary key nonclustered (MonitorTransactionDate, MonitorSerial, MonitorTransactionType, MonitorRemarks))

--	Populate the table with Monitor activity for the selected month.
--Print  getdate()
insert	#SelectedMonitorTransactions(
	MonitorSerial ,
	MonitorPart ,
	MonitorTransactionDate ,
	MonitorTransactionType ,
	MonitorQuantity ,
	MonitorCost ,
	MonitorExtCost ,
	MonitorUserDefined ,
	MonitorRemarks 
)
select	distinct at4.serial,
		at4.part,
		at4.date_stamp,
		at4.type,
		at4.quantity,
		PartSetupDaily.CostMaterial,
		round((at4.quantity*COALESCE(PartSetupDaily.CostMaterial, part_standard.cost_cum)),2),
		at4.user_defined_status,
		COALESCE(at4.remarks,'NoRemarks')
from		audit_trail at4
(index = idx_audit_trail_date_type_part_std_quantity)
left join	#PartSetupDaily PartSetupDaily on at4.part = PartSetupDaily.Part and at4.date_stamp >= PartSetupDaily.FromDT and at4.date_stamp < PartSetupDaily.ToDT 
join		part_standard on at4.part = Part_Standard.Part
Where	at4.date_stamp >= @AdjBeginDT and
		at4.date_stamp < @AdjEndDT 	and
	(
		(at4.type not in ('B','C','T','Z','G','H','P'))
		and
		(at4.type != 'Q' or at4.to_loc = 'S')
		and 
		(at4.type != 'D' or at4.remarks not like 'Scrap%')
	)
order by
	2,4,3,1

--	Create table to store activity comparison for the selected month.
create	 table	#Acctg_ActivityComparison
(	Part varchar (50),
	ProductLine varchar(50) null,
	GLAccount varchar (50) null,
	GLSerial varchar (50) null,
	GLTransactionDate datetime null,
	GLTransactionType varchar (25) null,
	GLQuantity decimal (18,6) null,
	GLCost decimal (18,6) null,
	GLExtCost decimal (18,6) null,
	GLDescription varchar(200) null,
	AuditSerial varchar (50),
	AuditTransactionDate datetime,
	AuditTransactionType char (1) null,
	AuditQuantity numeric (20,6) null,
	AuditCost numeric (20,6) null,
	AuditExtCost numeric (20,6) null, Primary Key (AuditSerial, AuditTransactionDate))

--	Populate the table with activity comparison for the selected month.
--Print  getdate()
insert	#Acctg_ActivityComparison
(	Part,
	GLAccount,
	GLSerial,
	GLTransactionDate,
	GLTransactionType,
	GLExtCost,
	GLQuantity,
	GLCost,
	GLDescription,
	AuditSerial,
	AuditTransactionDate,
	AuditTransactionType,
	AuditQuantity,
	AuditCost,
	AuditExtCost,
	ProductLine)
select	Part = coalesce (SelectedEmpowerTransactions.EmpowerPart, SelectedMonitorTransactions.MonitorPart),
	GLAccount = SelectedEmpowerTransactions.EmpowerGLAccount,
	GLSerial = coalesce ( SelectedEmpowerTransactions.EmpowerSerial,SelectedMonitorTransactions.MonitorSerial),
	GLTransactionDate = coalesce (SelectedEmpowerTransactions.EmpowerTransactionDate, SelectedMonitorTransactions.MonitorTransactionDate ),
	GLTransactionType = coalesce (SelectedEmpowerTransactions.EmpowerTransactionType, SelectedMonitorTransactions.MonitorTransactionType),
	GLExtCost = SelectedEmpowerTransactions.EmpowerExtCost,
	GLQuantity = SelectedMonitorTransactions.MonitorQuantity,
	GLCost = SelectedEmpowerTransactions.EmpowerExtCost / nullif (SelectedMonitorTransactions.MonitorQuantity,0),
	GLDescription = SelectedEmpowerTransactions.EmpowerDescription,
	AuditSerial = coalesce (SelectedMonitorTransactions.MonitorSerial, SelectedEmpowerTransactions.EmpowerSerial),
	AuditTransactionDate = coalesce (SelectedMonitorTransactions.MonitorTransactionDate, SelectedEmpowerTransactions.EmpowerTransactionDate),
	AuditTransactionType = coalesce (SelectedMonitorTransactions.MonitorTransactionType, SelectedEmpowerTransactions.EmpowerTransactionType),
	AuditQuantity = SelectedMonitorTransactions.MonitorQuantity,
	AuditCost = SelectedMonitorTransactions.MonitorCost,
	AuditExtCost = SelectedMonitorTransactions.MonitorExtCost,
	ProductLine = PartSetupEnd.ProductLine
from	#SelectedEmpowerTransactions SelectedEmpowerTransactions
	full join #SelectedMonitorTransactions SelectedMonitorTransactions on SelectedEmpowerTransactions.EmpowerSerial = SelectedMonitorTransactions.MonitorSerial
		and SelectedEmpowerTransactions.EmpowerTransactionType = SelectedMonitorTransactions.MonitorTransactionType
		and SelectedEmpowerTransactions.EmpowerTransactionDate = SelectedMonitorTransactions.MonitorTransactionDate
	join #PartSetupEnd PartSetupEnd on coalesce (SelectedEmpowerTransactions.EmpowerPart, SelectedMonitorTransactions.MonitorPart) = PartSetupEnd.Part

--	Fix Empower and Monitor quantity and Monitor extended cost.
--Print  getdate()
update	#Acctg_ActivityComparison
set	AuditQuantity = -1 * AuditQuantity,
	AuditExtCost = -1 * AuditExtCost,
	GLQuantity = -1 * GLQuantity,
	GLCost = GLExtCost / nullif ((-1 * GLQuantity),0)
where	AuditTransactionType in ('D','M','Q','S','V','E')



 --Get Journal Entries for Account
create	 table	#Acctg_JournalEntries
(	id int identity,
	Part varchar (50),
	ProductLine varchar (50),
	GLSerial varchar (50),
	GLTransactionDate datetime,
	GLTransactionType varchar (25),
	GLQuantity decimal (18,6),
	GLCost decimal (18,6),
	GLExtCost decimal (18,6),
	GLDescription varchar(200),
	AuditSerial varchar (50),
	AuditTransactionDate datetime,
	AuditTransactionType char (1),
	AuditQuantity numeric (20,6),
	AuditCost numeric (20,6),
	AuditExtCost numeric (20,6) primary key (id))

Insert	#Acctg_JournalEntries
	(Part,
	ProductLine,
	GLSerial ,
	GLTransactionDate ,
	GLTransactionType ,
	GLQuantity ,
	GLCost ,
	GLExtCost ,
	GLDescription ,
	AuditSerial,
	AuditTransactionDate ,
	AuditTransactionType ,
	AuditQuantity ,
	AuditCost ,
	AuditExtCost )
select	document_reference1,
		'',		
		document_reference2,
		transaction_date,
		'W',
		quantity,
		document_amount,
		document_amount,
		document_remarks,
		0,	
		transaction_date,
		'W',
		quantity,
		document_amount,
		document_amount
from		gl_cost_transactions
where	ledger = @Ledger
		and ledger_account = @Account
		and fiscal_year between convert(varchar,datepart(yyyy,@AdjBeginDT)) and convert(varchar,datepart(yyyy,@AdjEndDT))		
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) >= @AdjBeginDT
		and (	case	when	document_type = 'MON INV' and
					IsDate (document_id2) = 1
				then	convert (datetime, document_id2)
				else	transaction_date
			end) < @AdjEndDT
		and	update_balances = 'Y' and
			isNULL(document_type,'X') = 'Journal Entry'

insert	#Acctg_ActivityComparison
(	Part,
	GLSerial,
	GLTransactionDate,
	GLTransactionType,
	GLExtCost,
	GLQuantity,
	GLCost,
	GLDescription,
	AuditSerial,
	AuditTransactionDate,
	AuditTransactionType,
	AuditQuantity,
	AuditCost,
	AuditExtCost,
	ProductLine)

Select	AJE.Part ,
		GLSerial,
		GLTransactionDate,
		GLTransactionType,
		GLExtCost,
		GLQuantity,
		GLCost,
		GLDescription,
		id,
		AuditTransactionDate,
		AuditTransactionType,
		AuditQuantity,
		AuditCost,
		AuditExtCost,
		COALESCE(part.product_line,ProductLine,'')
From	#Acctg_JournalEntries AJE
left join	part on AJE.part = part.part
update	#Acctg_ActivityComparison
set		 GLSerial = AuditSerial
where	GLTransactionType = 'w'

--	Return results.
--Print  getdate()
select	AdjBeginDT = @ATBeginDate,
	AdjEndDT = @ATEndDate,
	ProductLine = coalesce (nullif(Acctg_InvChange.CurrentProductLine,''), Acctg_ActivityComparison.ProductLine),
	Part = coalesce (nullif(Acctg_ActivityComparison.Part,''), Acctg_InvChange.Part),
	Acctg_ActivityComparison.GLSerial,
	Acctg_ActivityComparison.GLTransactionDate,
	Acctg_ActivityComparison.GLTransactionType,
	Acctg_ActivityComparison.GLQuantity,
	Acctg_ActivityComparison.GLExtCost,
	Acctg_ActivityComparison.GLDescription,
	Acctg_ActivityComparison.AuditSerial,
	Acctg_ActivityComparison.AuditTransactionDate,
	Acctg_ActivityComparison.AuditTransactionType,
	Acctg_ActivityComparison.AuditQuantity,
	Acctg_ActivityComparison.AuditCost,
	Acctg_ActivityComparison.AuditExtCost,
	Acctg_InvChange.PriorType,
	Acctg_InvChange.PriorProductLine,
	Acctg_InvChange.PriorQuantity,
	Acctg_InvChange.PriorCost,
	Acctg_InvChange.PriorExtCost,
	Acctg_InvChange.CurrentType,
	Acctg_InvChange.CurrentProductLine,
	Acctg_InvChange.CurrentQuantity,
	Acctg_InvChange.CurrentCost,
	Acctg_InvChange.CurrentExtCost,
	Acctg_InvChange.PeriodChange
from	#Acctg_InvChange Acctg_InvChange
	full join #Acctg_ActivityComparison Acctg_ActivityComparison on Acctg_InvChange.Part = Acctg_ActivityComparison.Part
order by
	1, 2

GO
