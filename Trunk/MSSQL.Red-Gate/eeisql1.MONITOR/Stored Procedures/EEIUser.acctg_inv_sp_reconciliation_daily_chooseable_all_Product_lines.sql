SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
Create procedure [EEIUser].[acctg_inv_sp_reconciliation_daily_chooseable_all_Product_lines]
( @BegDate datetime,
 @EndDate datetime,
 @Account varchar (10),
 @PartType char(1))
as
/*
execute EEIUser.acctg_inv_sp_reconciliation_daily_chooseable_all_Product_lines
 @BegDate = '2008-07-01',
 @EndDate = '2008-07-03',
 @Account = '153111',
 @PartType = 'F'
 
*/
set nocount on
declare @Ledger varchar(10)
 ,@AdjBeginDT datetime
 ,@AdjEndDT datetime  
 
set @Ledger = 'HONDURAS'
 
-- Get the adjusted beginning date and ending date from snapshots in part historical daily.
set @AdjBeginDT =
 ( select max (time_stamp)
  from part_historical_daily
  where time_stamp <= @BegDate)
 
set @AdjEndDT =
 ( select max (time_stamp)
  from part_historical_daily
  where time_stamp <= dateadd (ms, -2, @EndDate + 1))
 
--print convert(varchar(30), @AdjBeginDT)
--print convert(varchar(30), @AdjEndDT)
 

--select @AdjBeginDT = (select max(time_stamp) from part_historical_daily where convert(varchar,time_stamp,101) = convert(varchar,@BegDate,101))
--select @AdjEndDT = (select max(time_stamp) from part_historical_daily where convert(varchar,time_stamp,101) = convert(varchar,@EndDate,101))
 
-- Clear the rows from the permanent table to allow repopulation
--delete eeiuser.Acctg_InvDates
 
-- Populate the table with the selected date range
 
--insert eeiuser.acctg_invdates
--( beg_date,
-- end_date)
--select @AdjBeginDT,
-- @AdjEndDT
 
-- Clear the rows from the permanent table to allow repopulation
--delete Acctg_InvChange
 
-- Create tables to store begin and end material cost.
declare @PartSetupBegin table
( Part varchar (25) primary key,
 Type char (1) null,
 ProductLine varchar (25) null,
 CostMaterial numeric (20,6) null)
 
declare @PartSetupEnd table
( Part varchar (25) primary key,
 Type char (1) null,
 ProductLine varchar (25) null,
 CostMaterial numeric (20,6) null)
 
declare @PartSetupDaily table
( Part varchar (25),
 FromDT datetime,
 ToDT datetime,
 Type char (1) null,
 ProductLine varchar (25) null,
 CostMaterial numeric (20,6) null,
 primary key (Part, FromDT, ToDT))
 
-- Populate the tables with begin and end material cost.
insert @PartSetupBegin
( Part,
 Type,
 ProductLine,
 CostMaterial)
select Part = PriorMonthPart.Part,
 Type = PriorMonthPart.Type,
 ProductLine = PriorMonthPart.ProductLine,
 CostMaterial = PriorMonthCost.CostMaterial
from ( select Part = PriorMonthCost.part,
   CostMaterial = PriorMonthCost.material_cum
  from part_standard_historical_daily PriorMonthCost
  where PriorMonthCost.time_stamp = @AdjBeginDT) PriorMonthCost
 join
 ( select Part = PriorMonthPart.part,
   Type = PriorMonthPart.Type,
   ProductLine = PriorMonthPart.product_line
  from part_historical_daily PriorMonthPart
  where PriorMonthPart.time_stamp = @AdjBeginDT) PriorMonthPart on PriorMonthCost.Part = PriorMonthPart.Part
 
insert @PartSetupEnd
( Part,
 Type,
 ProductLine,
 CostMaterial)
select Part = CurrentMonthPart.Part,
 Type = CurrentMonthPart.Type,
 ProductLine = CurrentMonthPart.ProductLine,
 CostMaterial = CurrentMonthCost.CostMaterial
from ( select Part = CurrentMonthCost.part,
   CostMaterial = CurrentMonthCost.material_cum
  from part_standard_historical_daily CurrentMonthCost
  where CurrentMonthCost.time_stamp = @AdjEndDT) CurrentMonthCost
 join
 ( select Part = CurrentMonthPart.part,
   Type = CurrentMonthPart.Type,
   ProductLine = CurrentMonthPart.product_line
  from part_historical_daily CurrentMonthPart
  where CurrentMonthPart.time_stamp = @AdjEndDT) CurrentMonthPart on CurrentMonthCost.Part = CurrentMonthPart.Part
 
insert @PartSetupDaily
( Part,
 Type,
 FromDT,
 ToDT,
 ProductLine,
 CostMaterial)
select Part = DailyPart.Part,
 Type = DailyPart.Type,
 FromDT = DailyCost.DateStamp,
 ToDT =
 ( select min (time_stamp)
  from part_standard_historical_daily
  where reason = 'DAILY' and
   time_stamp >= DailyCost.DateStamp),
 ProductLine = DailyPart.ProductLine,
 CostMaterial = DailyCost.CostMaterial
from ( select Part = part,
   CostMaterial = material_cum,
   DateStamp = time_stamp
  from part_standard_historical_daily
  where time_stamp between @AdjBeginDT and @AdjEndDT and
   reason = 'DAILY') DailyCost
 join
 ( select Part = part,
   Type = type,
   ProductLine = product_line,
   DateStamp = time_stamp
  from part_historical_daily
  where time_stamp between @AdjBeginDT and @AdjEndDT and
   reason = 'DAILY') DailyPart on DailyCost.Part = DailyPart.Part and
  DailyCost.DateStamp = DailyPart.DateStamp
 
-- Create the table to store prior month inventory.
declare @PriorMonthInv table
( Part varchar(50) primary key nonclustered,
 PriorType char(1),
 PriorProductLine varchar(50),
 PriorQuantity decimal(30,6),
 PriorCost decimal(30,6),
 PriorExtCost decimal(30,6))
 
-- Populate the table.
insert @PriorMonthInv
select  ohd1.part,
 PartSetupBegin.Type,
 PartSetupBegin.ProductLine,
 sum (ohd1.std_quantity),
 min (PartSetupBegin.CostMaterial),
 sum (ohd1.std_quantity*PartSetupBegin.CostMaterial) 
from  object_historical_daily ohd1
 join @PartSetupBegin PartSetupBegin on ohd1.part = PartSetupBegin.Part and
  PartSetupBegin.Type = @PartType 
where ohd1.time_stamp = @AdjBeginDT
  and ohd1.reason = 'Daily'
  and isNULL(ohd1.user_defined_status, 'XXX') !=  'PRESTOCK'
group by
 ohd1.part,
 PartSetupBegin.Type,
 PartSetupBegin.ProductLine
 
-- Create the table to store current month inventory.
declare @CurrentMonthInv table
( Part varchar(50) primary key nonclustered,
 CurrentType char(1),
 CurrentProductLine varchar(50),
 CurrentQuantity decimal(30,6),
 CurrentCost decimal(30,6),
 CurrentExtCost decimal(30,6))
 
-- Populate the table.
insert @CurrentMonthInv
select  ohd2.part,
 PartSetupEnd.Type,
 PartSetupEnd.ProductLine,
 sum (ohd2.std_quantity),
 min (PartSetupEnd.CostMaterial),
 sum (ohd2.std_quantity*PartSetupEnd.CostMaterial) 
from  object_historical_daily ohd2
 join @PartSetupEnd PartSetupEnd on ohd2.part = PartSetupEnd.Part and
  PartSetupEnd.Type = @PartType 
where ohd2.time_stamp = @AdjEndDT
  and ohd2.reason = 'Daily'
  and isNULL(ohd2.user_defined_status, 'XXX') !=  'PRESTOCK'
group by
 ohd2.part,
 PartSetupEnd.Type,
 PartSetupEnd.ProductLine
 
declare @Acctg_InvChange table
( Part varchar (50) not null primary key,
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
 
-- Populate the table.    
-- Add prior month inventory and current month inventory.
insert @Acctg_InvChange
select coalesce (PriorMonthInv.Part, CurrentMonthInv.Part),
 coalesce (PriorMonthInv.PriorType,''),
 coalesce (PriorMonthInv.PriorProductLine,''),
 coalesce (PriorMonthInv.PriorQuantity,0),
 coalesce (PriorMonthInv.PriorCost,0),
 coalesce (PriorMonthInv.PriorExtCost,0),
 coalesce (CurrentMonthInv.CurrentType,''),
 coalesce (CurrentMonthInv.CurrentProductLine,''),
 coalesce (CurrentMonthInv.CurrentQuantity,0),
 coalesce (CurrentMonthInv.CurrentCost,0),
 coalesce (CurrentMonthInv.CurrentExtCost,0),
 0
from @PriorMonthInv PriorMonthInv
 full join @CurrentMonthInv CurrentMonthInv on PriorMonthInv.part = CurrentMonthInv.part
 
-- Update table for instances of current month activity but no current month or prior month ending inventory.
insert @Acctg_InvChange
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
from gl_cost_transactions
where ledger = @Ledger
  and ledger_account = @Account
  and fiscal_year between convert (varchar, datepart (yyyy, @AdjBeginDT)) and convert (varchar, datepart (yyyy, @AdjEndDT))  
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) >= @AdjBeginDT
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) < @AdjEndDT
  and update_balances = 'Y'
  and document_reference1 not in (select Part from @Acctg_InvChange)
 
-- Add product_line, Calculate period change.
update @Acctg_InvChange
set CurrentType = PartSetupEnd.Type,
 CurrentProductLine = PartSetupEnd.ProductLine,
 PeriodChange = CurrentExtCost - PriorExtCost
from @Acctg_InvChange Acctg_InvChange 
 left outer join @PartSetupEnd PartSetupEnd on Acctg_InvChange.Part = PartSetupEnd.Part
 
-- Create the table to store Empower activity for the selected month.
declare @SelectedEmpowerTransactions table
( EmpowerSerial varchar (50) not null,
 EmpowerPart varchar (50) null,
 EmpowerTransactionDate datetime not null,
 EmpowerTransactionType varchar (25) not null,
 EmpowerExtCost decimal (18, 6) null,
 EmpowerDescription varchar(200) null,
 primary key nonclustered (EmpowerTransactionDate, EmpowerSerial, EmpowerTransactionType))
 
-- Populate the table with Empower activity for the selected month.
insert @SelectedEmpowerTransactions
( EmpowerSerial, EmpowerPart, EmpowerTransactionDate, EmpowerTransactionType, EmpowerExtCost, EmpowerDescription)
--added case statement to align columns for serial number depending on different transaction type
select EmpowerSerial = (case when document_type = 'MON INV' then document_id1 else document_reference2 end),
 EmpowerPart = document_reference1,
 EmpowerTransactionDate =
  case when document_type = 'MON INV' and
    IsDate (document_id2) = 1
   then convert (datetime, document_id2)
   else transaction_date
  end,
 EmpowerTransactionType = document_id3,
 EmpowerExtCost = amount,
 EmpowerDescription = document_remarks
from gl_cost_transactions
where ledger = @Ledger
  and ledger_account = @Account
  and fiscal_year between convert(varchar,datepart(yyyy,@AdjBeginDT)) and convert(varchar,datepart(yyyy,@AdjEndDT))  
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) >= @AdjBeginDT
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) < @AdjEndDT
  and update_balances = 'Y' and
  isNULL(document_type,'X')!='Journal Entry'
order by
 2,4,3,1
 
-- Create the table to store Monitor activity for the selected month.
declare @SelectedMonitorTransactions table
( MonitorSerial varchar(50),
 MonitorPart varchar(50),
 MonitorTransactionDate datetime,
 MonitorTransactionType char(1),
 MonitorQuantity decimal(30,6),
 MonitorCost decimal(30,6),
 MonitorExtCost decimal(30,6),
 MonitorUserDefined varchar(50),
 MonitorRemarks varchar(10),
 primary key nonclustered (MonitorTransactionDate, MonitorSerial, MonitorTransactionType))
 
-- Populate the table with Monitor activity for the selected month.
insert @SelectedMonitorTransactions
select at4.serial,
 at4.part,
 at4.date_stamp,
 at4.type,
 at4.quantity,
 PartSetupDaily.CostMaterial,
 (at4.quantity*PartSetupDaily.CostMaterial),
 at4.user_defined_status,
 at4.remarks
from audit_trail at4
 join @PartSetupDaily PartSetupDaily on at4.part = PartSetupDaily.Part
  and at4.date_stamp >= PartSetupDaily.FromDT and at4.date_stamp < PartSetupDaily.ToDT
  and PartSetupDaily.Type = @PartType
  
where at4.part in
 ( select Part
  from @PartSetupDaily
  where Type = @PartType ) and
 at4.date_stamp >= @AdjBeginDT and
 at4.date_stamp < @AdjEndDT
  and
 (
  (at4.type not in ('B','C','T','Z','G','H','P'))
  and
  (at4.type != 'Q' or at4.to_loc = 'S')
  and 
  (at4.type != 'D' or at4.remarks not like 'Scrap%')
 )
order by
 2,4,3,1
 
-- Create table to store activity comparison for the selected month.
declare @Acctg_ActivityComparison table
( Part varchar (50),
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
 AuditExtCost numeric (20,6))
 
-- Populate the table with activity comparison for the selected month.
insert @Acctg_ActivityComparison
( Part,
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
select Part = coalesce (SelectedEmpowerTransactions.EmpowerPart, SelectedMonitorTransactions.MonitorPart),
 GLSerial = SelectedEmpowerTransactions.EmpowerSerial,
 GLTransactionDate = SelectedEmpowerTransactions.EmpowerTransactionDate,
 GLTransactionType = SelectedEmpowerTransactions.EmpowerTransactionType,
 GLExtCost = SelectedEmpowerTransactions.EmpowerExtCost,
 GLQuantity = SelectedMonitorTransactions.MonitorQuantity,
 GLCost = SelectedEmpowerTransactions.EmpowerExtCost / nullif (SelectedMonitorTransactions.MonitorQuantity,0),
 GLDescription = SelectedEmpowerTransactions.EmpowerDescription,
 AuditSerial = SelectedMonitorTransactions.MonitorSerial,
 AuditTransactionDate = SelectedMonitorTransactions.MonitorTransactionDate,
 AuditTransactionType = SelectedMonitorTransactions.MonitorTransactionType,
 AuditQuantity = SelectedMonitorTransactions.MonitorQuantity,
 AuditCost = SelectedMonitorTransactions.MonitorCost,
 AuditExtCost = SelectedMonitorTransactions.MonitorExtCost,
 ProductLine = PartSetupEnd.ProductLine
from @SelectedEmpowerTransactions SelectedEmpowerTransactions
 full join @SelectedMonitorTransactions SelectedMonitorTransactions on SelectedEmpowerTransactions.EmpowerSerial = SelectedMonitorTransactions.MonitorSerial
  and SelectedEmpowerTransactions.EmpowerTransactionType = SelectedMonitorTransactions.MonitorTransactionType
  and SelectedEmpowerTransactions.EmpowerTransactionDate = SelectedMonitorTransactions.MonitorTransactionDate
 join @PartSetupEnd PartSetupEnd on coalesce (SelectedEmpowerTransactions.EmpowerPart, SelectedMonitorTransactions.MonitorPart) = PartSetupEnd.Part
 
-- Fix Empower and Monitor quantity and Monitor extended cost.
update @Acctg_ActivityComparison
set AuditQuantity = -1 * AuditQuantity,
 AuditExtCost = -1 * AuditExtCost,
 GLQuantity = -1 * GLQuantity,
 GLCost = GLExtCost / nullif ((-1 * GLQuantity),0)
where AuditTransactionType in ('D','M','Q','S','V','E')
 
 
 
 --Get Journal Entries for Account
declare @Acctg_JournalEntries table
( Part varchar (50),
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
 AuditExtCost numeric (20,6))
 
Insert @Acctg_JournalEntries
select document_reference1,
  '',  
  document_reference2,
  transaction_date,
  'W',
  quantity,
  document_amount,
  document_amount,
  document_remarks,  
  '0',
  transaction_date,
  'W',
  quantity,
  document_amount,
  document_amount
from  gl_cost_transactions
where ledger = @Ledger
  and ledger_account = @Account
  and fiscal_year between convert(varchar,datepart(yyyy,@AdjBeginDT)) and convert(varchar,datepart(yyyy,@AdjEndDT))  
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) >= @AdjBeginDT
  and ( case when document_type = 'MON INV' and
     IsDate (document_id2) = 1
    then convert (datetime, document_id2)
    else transaction_date
   end) < @AdjEndDT
  and update_balances = 'Y' and
   isNULL(document_type,'X') = 'Journal Entry'
 
insert @Acctg_ActivityComparison
( Part,
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
 
Select Part ,
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
  ProductLine
From @Acctg_JournalEntries
 

--update @Acctg_ActivityComparison
--set AuditQuantity = (CASE WHEN AuditQuantity>= 0 THEN -1 ELSE 1 END) * AuditQuantity,
-- AuditExtCost = (CASE WHEN AuditQuantity>= 0 THEN -1 ELSE 1 END) * AuditExtCost,
-- GLQuantity = (CASE WHEN AuditQuantity>= 0 THEN -1 ELSE 1 END) * GLQuantity,
-- GLCost = GLExtCost / nullif ((-1 * GLQuantity),0)
--where AuditTransactionType ='E'
 
-- Return results.
select AdjBeginDT = @AdjBeginDT,
 AdjEndDT = @AdjEndDT,
 ProductLine = coalesce (Acctg_InvChange.CurrentProductLine, Acctg_ActivityComparison.ProductLine),
 Part = coalesce (Acctg_ActivityComparison.Part, Acctg_InvChange.Part),
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
from @Acctg_InvChange Acctg_InvChange
 full join @Acctg_ActivityComparison Acctg_ActivityComparison on Acctg_InvChange.Part = Acctg_ActivityComparison.Part
order by
 1, 2

 
 
GO
