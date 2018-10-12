SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- exec eeiuser.acctg_inv_sp_reconciliation_daily_chooseable '2018-01-31','2018-02-28','152112','WIRE HARN-EEH','W','HONDURAS'

-- DW 2018-03-07:  Updated query to allow multiple product_lines for WIP because 152112 contains both WIRE HARN-EEH and ES3 COMPONENTS 

CREATE procedure [eeiuser].[acctg_inv_sp_reconciliation_daily_chooseable]
	@begdate datetime
,	@enddate datetime
,	@account varchar(10)
,	@productline varchar(25)
,	@parttype char(1)
,	@ledger varchar(10)
as
begin

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare  @rundate datetime
		,@adjbegdate datetime
		,@adjenddate datetime  
	
		
--		,@PartType char(1)
--		,@begdate datetime
--		,@enddate datetime 
--		,@account varchar(10)
--		,@productline varchar(20) 
--		,@ledger VARCHAR(25)

--select  @PartType = 'W';
--select @begdate = '2018-01-31 00:00:00';
--select @enddate = '2018-02-28 00:00:00';
--select @account = '152112';
--select @productline = 'WIRE HARN-EEH';
--SELECT @ledger = 'HONDURAS'


select  @rundate = getdate();
select  @adjbegdate = (select max(time_stamp) from HistoricalData.dbo.part_historical_daily where convert(varchar,time_stamp,101) = convert(varchar,@begdate,101));
select  @adjenddate = (select max(time_stamp) from HistoricalData.dbo.part_historical_daily where convert(varchar,time_stamp,101) = convert(varchar,@enddate,101));

 
DECLARE @product_line_table TABLE (product_line VARCHAR(25))
IF	(@parttype = 'W' AND @productline <> 'PCB')
	INSERT INTO @product_line_table
		VALUES ('WIRE HARN-EEH'),('ES3 COMPONENTS');
ELSE 
	INSERT INTO @product_line_table
		VALUES (@productline)

--SELECT * FROM @product_line_table


-- Clear the rows from the permanent table to allow repopulation
-- Delete from Acctg_invChange

If OBJECT_ID('tempdb..#Acctg_invChange') IS NOT NULL
BEGIN
	DROP TABLE #Acctg_InvChange
END

create table #Acctg_InvChange (
 Part varchar(50) not null
,PriorType char(1) null
,PriorProductLine varchar(50) null
,PriorQuantity decimal(30,6) null
,PriorCost decimal(30,6) null
,PriorExtCost decimal(30,6) null
,CurrentType char(1) null
,CurrentProductLine varchar(50) null
,CurrentQuantity decimal(30,6) null
,CurrentCost decimal(30,6) null
,CurrentExtCost decimal(30,6) null
,PeriodChange decimal(30,6) null
)
 
-- Create the table variable to store prior month inventory 
If OBJECT_ID('tempdb..#PriorMonthInv') IS NOT NULL
BEGIN
	DROP TABLE #PriorMonthInv
END

create table #PriorMonthInv
 ( 
  Part varchar(50) not null,
  PriorType char(1) null,
  PriorProductLine varchar(50) null,
  PriorQuantity decimal(30,6) null,
  PriorCost decimal(30,6) null,
  PriorExtCost decimal(30,6) null
 )
 
-- Populate the table variable for prior month inventory
insert	#PriorMonthInv
select  ohd1.part,
		phd1.type,
		phd1.product_line,
		sum(ohd1.quantity),
		pshd1.material_cum,
		sum(ohd1.quantity*pshd1.material_cum) 
from	HistoricalData.dbo.object_historical_daily ohd1
 left outer join HistoricalData.dbo.part_historical_daily phd1 on ohd1.part = phd1.part and phd1.time_stamp = @adjbegdate
 left outer join HistoricalData.dbo.part_standard_historical_daily pshd1 on ohd1.part = pshd1.part and pshd1.time_stamp = @adjbegdate
where	ohd1.time_stamp = @adjbegdate
	and phd1.type = @PartType 
	and phd1.product_line IN (SELECT * FROM @product_line_table)
	and ohd1.location <> 'PREOBJECT'
group by
		ohd1.part,
		phd1.type,
		phd1.product_line,
		pshd1.material_cum
 

-- Create the table variable to store current month inventory
If OBJECT_ID('tempdb..#CurrentMonthInv') IS NOT NULL
BEGIN
	DROP TABLE #CurrentMonthInv
END


create table #CurrentMonthInv
 (  
  Part varchar(50) not null,
  CurrentType char(1) null,
  CurrentProductLine varchar(50) null,
  CurrentQuantity decimal(30,6) null,
  CurrentCost decimal(30,6) null,
  CurrentExtCost decimal(30,6) null
 )
 
-- Populate the table variable for current month inventory
insert	#CurrentMonthInv
select  ohd2.part,
		phd2.type,
		 phd2.product_line,
		sum(ohd2.quantity),
		pshd2.material_cum,
		sum(ohd2.quantity*pshd2.material_cum)
from	HistoricalData.dbo.object_historical_daily ohd2
 left outer join HistoricalData.dbo.part_historical_daily phd2 on ohd2.part = phd2.part and phd2.time_stamp = @adjenddate
 left outer join HistoricalData.dbo.part_standard_historical_daily pshd2 on ohd2.part = pshd2.part and pshd2.time_stamp = @adjenddate
where	ohd2.time_stamp = @adjenddate 
	and phd2.type = @PartType 
	and phd2.product_line IN (SELECT * FROM @product_line_table)
	and ohd2.location <> 'PREOBJECT'
group by
		ohd2.part,
		phd2.type,
		phd2.product_line,
		pshd2.material_cum          
 

-- Populate the permanent table     
-- Add prior month inventory and current month inventory from the table variables
insert	#Acctg_InvChange
select	PriorMonthInv.part,
		isNULL(PriorMonthInv.PriorType,''),
		isNULL(PriorMonthInv.PriorProductLine,''),
		isNULL(PriorMonthInv.PriorQuantity,0),
		isNULL(PriorMonthInv.PriorCost,0),
		isNULL(PriorMonthInv.PriorExtCost,0),
		isNULL(CurrentMonthInv.CurrentType,''),
		isNULL(CurrentMonthInv.CurrentProductLine,''),
		isNULL(CurrentMonthInv.CurrentQuantity,0),
		isNULL(CurrentMonthInv.CurrentCost,0),
		isNULL(CurrentMonthInv.CurrentExtCost,0),
		0
from	#PriorMonthInv PriorMonthInv
 left outer join #CurrentMonthInv CurrentMonthInv on PriorMonthInv.part = CurrentMonthInv.part
 

-- Populate the permanent table with current month inventory where no prior month inventory
insert	#Acctg_InvChange
select	CurrentMonthInv.part,
		isNULL(PriorMonthInv.PriorType,''),
		isNULL(PriorMonthInv.PriorProductLine,''),
		isNULL(PriorMonthInv.PriorQuantity,0),
		isNULL(PriorMonthInv.PriorCost,0),
		isNULL(PriorMonthInv.PriorExtCost,0),
		isNULL(CurrentMonthInv.CurrentType,''),
		isNULL(CurrentMonthInv.CurrentProductLine,''),
		isNULL(CurrentMonthInv.CurrentQuantity,0),
		isNULL(CurrentMonthInv.CurrentCost,0),
		isNULL(CurrentMonthInv.CurrentExtCost,0),
		0
from	#CurrentMonthInv CurrentMonthInv
left outer join #PriorMonthInv PriorMonthInv on CurrentMonthInv.part = PriorMonthInv.part
where	CurrentMonthInv.part not in (select #Acctg_InvChange.part from #Acctg_InvChange)
 
-- Populate the permanent table for instances of current month activity but no current month or prior month ending inventory
insert	#Acctg_InvChange
select  gct.monitor_part,
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
from	vw_empower_transactions_by_posting_account gct
where	gct.ledger = @ledger
	and gct.posting_account = @account
	and fiscal_year between convert(varchar,datepart(yyyy,@adjbegdate)) and convert(varchar,datepart(yyyy,@adjenddate))  
	and gct.monitor_transaction_date >= @adjbegdate
	and gct.monitor_transaction_date < @adjenddate
	and gct.period != 0 
	AND NOT EXISTS (SELECT 1 FROM #Acctg_InvChange WHERE #Acctg_InvChange.part = gct.monitor_part)
GROUP BY
	gct.monitor_part

-- Add product_line
-- DW 7/22/2015 - not sure why we are doing this for only current inventory and not also for prior inventory; 
--                this step is really only for the benefit of the parts added through the prior step above  we should just join above
update	#Acctg_InvChange
set		CurrentType = phd3.type,
		CurrentProductLine = phd3.Product_Line
from	#Acctg_InvChange 
 left outer join HistoricalData.dbo.part_historical_daily phd3 on #acctg_invchange.part = phd3.part and phd3.time_stamp = @adjenddate
 
-- Calculate period change
update #Acctg_InvChange
set  PeriodChange = CurrentExtCost-PriorExtCost

 
---- Get rid of unwanted rows
--delete #SelectedMonitorTransactions
--where MonitorTransactionType = 'Q' and MonitorUserDefined <> 'Scrapped'
 
--delete #SelectedMonitorTransactions
--where MonitorTransactionType = 'D' and MonitorUserDefined = 'Scrapped'
 
 
---- Fix Empower and Monitor quantity and Monitor extended cost
--update Acctg_ActivityComparison
--set Acctg_ActivityComparison.AuditQuantity = -1*Acctg_ActivityComparison.AuditQuantity,
-- Acctg_ActivityComparison.AuditExtCost = -1*Acctg_ActivityComparison.AuditExtCost,
-- Acctg_ActivityComparison.GLQuantity = -1*Acctg_ActivityComparison.GLQuantity,
-- Acctg_ActivityComparison.GLCost = Acctg_ActivityComparison.GLExtCost/(-1*Acctg_ActivityComparison.GLQuantity)
--from Acctg_ActivityComparison
--where Acctg_ActivityComparison.AuditTransactionType in ('D','M','Q','S','V')
 
---- Add product_line
--update Acctg_ActivityComparison
--set  ProductLine = phd5.product_line
--from Acctg_ActivityComparison
-- join HistoricalData.dbo.part_historical_daily phd5 on Acctg_ActivityComparison.part = phd5.part 
--  and phd5.time_stamp = @adjenddate
 
declare @ComparisonDetail table
 (  
  PostingAccount varchar(50) 
  ,Part varchar(50) 
  ,GLSerial int
  ,GLTransactionDate datetime
  ,GLTransactionType varchar(2)
  ,GLQuantity decimal(18,6)
  ,GLCost decimal(18,6)
  ,GLExtCost decimal(18,6)
  ,AuditSerial int
  ,AuditTransactionDate datetime
  ,AuditTransactonType varchar(2)
  ,AuditQuantity decimal(18,6)
  ,AuditCost decimal(18,6)
  ,AuditExtCost decimal(18,6)
  ,Variance decimal(18,6)
  )

insert into @comparisondetail

SELECT			left(a.posting_account,50)
				,left(isnull(a.monitor_part,b.part),50) as 'Part'
				,a.monitor_serial as 'GLSerial'
				,a.monitor_transaction_date as 'GLTransactionDate'
				,a.monitor_transaction_type as 'GLTransactionType'
				,case when a.monitor_transaction_type in ('R','U','A','J') then a.quantity else -1*a.quantity end as 'GLQuantity'
				,a.cost as 'GLCost'
				,a.amount as 'GLExtCost'
				,b.serial as 'AuditSerial'
				,b.date_stamp as 'AuditTransactionDate'
				,b.transaction_type as 'AuditTransactionType'
				,b.quantity as 'AuditQuantity'
				,b.material_cum as 'AuditCost'
				,b.amount as 'AuditExtCost'
				,isnull(a.amount,0)-isnull(b.amount,0) as variance 

FROM

	(select		* 
	from		vw_empower_transactions_by_posting_account gct
	where		gct.ledger = @ledger
			and gct.posting_account = @account
			and fiscal_year between convert(varchar,datepart(yyyy,@adjbegdate)) and convert(varchar,datepart(yyyy,@adjenddate))  
			and gct.monitor_transaction_date >= @adjbegdate
			and gct.monitor_transaction_date < @adjenddate
			and gct.period != 0 
	) a


FULL OUTER JOIN 
	
	(SELECT		p.product_line
				,p.type				
				,at.id
				,at.serial
				,at.date_stamp
				,at.dbdate 
				,at.part
				,at.type as 'transaction_type'
				,case when at.type in ('R','U','A','J') then at.quantity else -1*at.quantity end as 'quantity'
				,ps.material_cum
				,case when at.type in ('R','U','A','J') then round(at.quantity*ps.material_cum,2) else round(-1*at.quantity*ps.material_cum,2) end as 'amount'
				,at.operator
				,at.parent_serial
				,at.posted
	
	FROM		Monitor..audit_trail at 

	LEFT JOIN	Monitor..part p 
		   ON	at.part = p.part

	LEFT JOIN	HistoricalData.dbo.part_standard_historical_daily ps
		   ON	at.part = ps.part and ps.time_stamp = @adjenddate
	
	WHERE 		(at.type not in ('B','C','T','Z','G','H','P','I1','I2'))
			and (at.type != 'Q' or at.user_defined_status = 'Scrapped')
			and (at.type != 'D' or at.user_defined_status != 'Scrapped')
			and (at.date_stamp >= @adjbegdate and at.date_stamp < @adjenddate)
			and (p.product_line = @productline)
	) b  

ON				a.monitor_audit_trail_id = b.id




Select	* 		
		,@adjbegdate as adjbegdate
		,@adjenddate as adjenddate
		,isnull(PeriodChange,0)-isnull(GLChange,0) as Variance
from	#acctg_invchange 
		left outer join (select * from @ComparisonDetail) a on #acctg_invchange.part = a.part 
		left outer join (select monitor_part, sum(amount) as glchange from vw_empower_transactions_by_posting_account where monitor_transaction_date >= @adjbegdate and monitor_transaction_date <= @adjenddate and posting_account = @account group by monitor_part) b  on #acctg_invchange.part = b.Monitor_part
order by #acctg_invchange.currentproductline
		,#acctg_invchange.part
end






GO
