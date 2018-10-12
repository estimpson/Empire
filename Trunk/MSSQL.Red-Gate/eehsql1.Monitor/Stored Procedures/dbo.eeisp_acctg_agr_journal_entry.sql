SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_acctg_agr_journal_entry]  (@date date, @variance_account varchar(4))
as
BEGIN

--0. TESTING

-- exec eeisp_acctg_agr_journal_entry @date = '2017-01-31', @variance_account = '5020'

-- declare @date date = '2017-01-31'
-- declare @variance_account varchar(4) = '5020'


--1. Get the pre (old costs) and post (new costs) snapshots for the specified global rollup

declare @old_date datetime = (select min(time_stamp) from historicaldata.dbo.part_standard_historical where time_stamp >= @date and time_stamp < dateadd(d,1,@date) and reason = 'Global Rollup');
declare @new_date datetime = (select max(time_stamp) from historicaldata.dbo.part_standard_historical where time_stamp >= @date and time_stamp < dateadd(d,1,@date) and reason = 'Global Rollup')


--2. Create a temp table for the relevant posting_accounts for each product_line and part_type.

IF object_id(N'tempdb..#gr_accounts') IS NOT NULL
	DROP TABLE #gr_accounts

create table #gr_accounts
(product_line varchar(50),
 part_type varchar(1),
 material_debit varchar(4),
 labor_debit varchar(4),
 burden_debit varchar(4),
 gl_segment varchar(2)
 )


--3. Get the relevant posting_accounts for each product_line and part_type.  
--   We'll use audit_trail_type = 'A' because we don't have a transaction type for the global rollup and the 'A' contains the same posting_accounts that we need for the global rollup journal entry
--   **CAUTION** DEPENDENCY: If the audit_trail_type 'A' changes or the logic for the posting_accounts assigned to the 'A' transaction changes, this procedure will need to be modified

insert into #gr_accounts 
select monitor_product_line, monitor_part_type, replace(material_posting_account_dr,'?',''), replace(labor_posting_account_dr,'?',''), replace(burden_posting_account_dr,'?',''), pl.gl_segment
from eeh_empower..monitor_inventory_posting_accounts mia
 join product_line pl on mia.monitor_product_line = pl.id 
 where mia.fiscal_year = '2018'
 --datepart(yyyy,@date) 
 and mia.ledger = 'HONDURAS' 
 and mia.monitor_transaction_type = 'A'

 
--4. Testpoint
 -- select * from #gr_accounts 

--5. Create a temp table to capture the costs that have changed from one snapshot to the next.  This will be our main working table.

IF object_id(N'tempdb..#gr_costs') IS NOT NULL
	DROP TABLE #gr_costs

create table #gr_costs 
	   (part varchar(25),
	    part_type varchar(1),
		product_line varchar(50),
		quantity decimal(18,6),
		old_material_cum decimal(18,6),
		new_material_cum decimal(18,6),
		old_labor_cum decimal(18,6),
		new_labor_cum decimal(18,6),
		old_burden_cum decimal(18,6),
		new_burden_cum decimal(18,6),
		old_cost_cum decimal(18,6),
		new_cost_cum decimal(18,6),
		material_cum_change decimal(18,6),
		labor_cum_change decimal(18,6),
		burden_cum_change decimal(18,6),
		cost_cum_change decimal(18,6)
		)


--6. Populate the table with the costs that have changed from one snapshot to the next.

insert into #gr_costs
select  coalesce(a.part,b.part) as part,
        '' as part_type,
		'' as product_line,
		0 as quantity,
		isnull(a.material_cum,0) as old_material_cum, 
		isnull(b.material_cum,0) as new_material_cum, 
		isnull(a.labor_cum,0) as old_labor_cum, 
		isnull(b.labor_cum,0) as new_labor_cum,
		isnull(a.burden_cum,0) as old_material_cum, 
		isnull(b.burden_cum,0) as new_burden_cum, 
		isnull(a.cost_cum,0) as old_cost_cum, 
		isnull(b.cost_cum,0) as new_cost_cum, 
		isnull(b.material_cum,0) - isnull(a.material_cum,0) as material_cum_change, 
		isnull(b.labor_cum,0) - isnull(a.labor_cum,0) as labor_cum_change,
		isnull(b.burden_cum,0) - isnull(a.burden_cum,0) as burden_cum_change,
		(isnull(b.material_cum,0)+isnull(b.labor_cum,0)+isnull(b.burden_cum,0))- (isnull(a.material_cum,0)+isnull(a.labor_cum,0)+isnull(a.burden_cum,0)) as cost_cum_change
from 
 (select part, material_cum, labor_cum, burden_cum, cost_cum, planned_material_cum, planned_labor_cum, planned_burden_cum, planned_cost_cum from historicaldata.dbo.part_standard_historical where time_stamp = @old_date ) a
 left join
 (select part, material_cum, labor_cum, burden_cum, cost_cum, planned_material_cum, planned_labor_cum, planned_burden_cum, planned_cost_cum from historicaldata.dbo.part_standard_historical where time_stamp = @new_date ) b
 on a.part = b.part 
where	a.material_cum <> b.material_cum 
	 or a.labor_cum <> b.labor_cum 
	 or a.burden_cum <> b.burden_cum 
	 or a.cost_cum <> b.cost_cum


--7. Testpoint

-- select * from #gr_costs


--8. Update the work table with the product_line and part_type associated to each part

update	a
set		a.product_line = b.product_line,
		a.part_type = b.type
from	#gr_costs a
	join historicaldata.dbo.part_historical b
	on a.part = b.part
where b.time_stamp = @old_date


--9. Testpoint

-- select * from #gr_costs order by part_type, product_line, part  


--10. Update the work table with the beginning quantity on hand (from the first snapshot)... 
--    Empower will use the costs from the last snapshot of that day when importing transactions from that entire day.  Therefore we want the BEGINNING on hand inventory.  (The current day's transactions will be imported at the NEW costs.)

update a 
set a.quantity = b.quantity
from #gr_costs a
join (select part, sum(quantity) as quantity from historicaldata.dbo.object_historical where time_stamp = @old_date and user_defined_status != 'PRESTOCK' and part != 'PALLET' group by part) b
on a.part = b.part


--11.  Return the result set ready for import into Empower.
--     **We need to work with Empower to automate this step.**

select	material_debit+gl_segment as posting_account, 
		quantity*material_cum_change as ext_amount, 
		'' as cost_account,
		convert(varchar,@date)+' Global Rollup' as Reference1,
		part as Reference2, 
		'To record change in material_cum for '+part+' from '+convert(varchar(100),old_material_cum)+' to '+convert(varchar(100),new_material_cum)+' for '+convert(varchar(100),quantity)+' on hand quantity' as Remarks
from	#gr_costs a
   join #gr_accounts b 
     on a.part_type = b.part_type and a.product_line = b.product_line 
where	a.quantity <> 0 and a.material_cum_change <> 0

union

select	labor_debit+gl_segment as posting_account, 
		quantity*labor_cum_change as ext_amount, 
		'' as cost_account,
		convert(varchar,@date)+' Global Rollup' as Reference1, 
		part as Reference2, 
		'To record change in labor_cum for '+part+' from '+convert(varchar(100),old_labor_cum)+' to '+convert(varchar(100),new_labor_cum)+' for '+convert(varchar(100),quantity)+' on hand quantity' as Remarks
from	#gr_costs a
   join #gr_accounts b 
     on a.part_type = b.part_type and a.product_line = b.product_line 
where	a.quantity <> 0 and a.labor_cum_change <> 0

union

select	burden_debit+gl_segment as posting_account, 
		quantity*burden_cum_change as ext_amount, 
		'' as cost_account,
		convert(varchar,@date)+' Global Rollup' as Reference1,
		part as Reference2, 
		'To record change in burden_cum for '+part+' from '+convert(varchar(100),old_burden_cum)+' to '+convert(varchar(100),new_burden_cum)+' for '+convert(varchar(100),quantity)+' on hand quantity' as Remarks
from	#gr_costs a
   join #gr_accounts b 
     on a.part_type = b.part_type and a.product_line = b.product_line 
where	a.quantity <> 0 and a.burden_cum_change <> 0

union

-- NOTE: need to reverse the sign for the extended amount here, because this is the offseting side of the journal entry (variance account)

select @variance_account+gl_segment as posting_account, 
		quantity*-cost_cum_change as ext_amount, 
		'' as cost_account, 
		convert(varchar,@date)+' Global Rollup' as Reference1, 
		part as Reference2, 
		'To record change in cost_cum for '+part+' from '+convert(varchar(100),old_burden_cum)+' to '+convert(varchar(100),new_burden_cum)+' for '+convert(varchar(100),quantity)+' on hand quantity' as Remarks
from	#gr_costs a
   join #gr_accounts b 
	 on a.part_type = b.part_type and a.product_line = b.product_line 
where	a.quantity <> 0 and a.cost_cum_change <> 0 

order by 1, 5
END



--To validate procedure results:
--select sum(quantity*material_cum) as ext_material_cum, sum(quantity*labor_cum) as ext_labor_cum, sum(quantity*burden_cum) as ext_burden_cum, sum(quantity*cost_cum) as ext_cost_cum
--from historicaldata.dbo.object_historical oh
--join historicaldata.dbo.part_standard_historical psh on oh.part = psh.part and oh.time_stamp = psh.time_stamp
--where oh.time_stamp = '2016-12-15 00:01:00.150' and oh.user_defined_status != 'PRESTOCK' and oh.part != 'PALLET'

--select sum(quantity*material_cum) as ext_material_cum, sum(quantity*labor_cum) as ext_labor_cum, sum(quantity*burden_cum) as ext_burden_cum, sum(quantity*cost_cum) as ext_cost_cum
--from historicaldata.dbo.object_historical oh
--join historicaldata.dbo.part_standard_historical psh on oh.part = psh.part 
--where oh.time_stamp = '2016-12-15 00:01:00.150'
--and psh.time_stamp = '2016-12-15 00:14:03.213'
-- and oh.user_defined_status != 'PRESTOCK'
-- and oh.part != 'PALLET'







GO
