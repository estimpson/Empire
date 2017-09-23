SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[web_ar_aggregation]

as
begin



-- Insert a total row and compile the customer accounts receivable metrics (for all open invoices)

declare @dt datetime
select @dt = getdate()

insert into 
eeiuser.ar_4

select
@dt, 
'ALL',
isnull(sum(case when days_past_doc < 31 then amount-applied_amount end),0) as [0-30],
isnull(sum(case when days_past_doc BETWEEN 31 and 60 then amount-applied_amount end),0) as [30-60],
isnull(sum(case when days_past_doc BETWEEN 61 and 90 then amount-applied_amount end),0) as [60-90],
isnull(sum(case when days_past_doc > 90 then amount-applied_amount end),0) as [Over 90],
isnull(sum(amount-applied_amount),0) as total_due,
(case when (sum(amount-applied_amount)=0) then 0 else (sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount)) end) as total_days_past_doc,
sum((case when days_past_due > 0 then (case when (amount-applied_amount)<=0 then 0 else amount-applied_amount end) else 0 end)) as past_due,
(case when (sum(amount-applied_amount)<=0) then 0 else ((sum((case when days_past_due > 0 then amount-applied_amount else 0 end))/sum(amount-applied_amount))) end) as percent_past_due,
NULL,
NULL,
NULL
from 
dbo.ar_customer_aging
where 
amount <> applied_amount 



-- Insert a row for each customer and compile the customer accounts receivable metrics (for all open invoices grouped by customer)

insert into 

eeiuser.ar_4

select 

@dt, 
customer,
isnull(sum(case when days_past_doc < 31 then amount-applied_amount end),0) as [0-30],
isnull(sum(case when days_past_doc BETWEEN 31 and 60 then amount-applied_amount end),0) as [30-60],
isnull(sum(case when days_past_doc BETWEEN 61 and 90 then amount-applied_amount end),0) as [60-90],
isnull(sum(case when days_past_doc > 90 then amount-applied_amount end),0) as [Over 90],
isnull(sum(amount-applied_amount),0) as total_due,
(case when (sum(amount-applied_amount)=0) then 0 else (sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount)) end) as total_days_past_doc,
sum((case when days_past_due > 0 then (case when (amount-applied_amount)<=0 then 0 else amount-applied_amount end) else 0 end)) as past_due,
(case when (sum(amount-applied_amount)<=0) then 0 else ((sum((case when days_past_due > 0 then amount-applied_amount else 0 end))/sum(amount-applied_amount))) end) as percent_past_due,
NULL,
NULL,
NULL

from 

dbo.ar_customer_aging

where 

amount <> applied_amount 

group by 

customer


-- For the total row,
-- Calculate the weighted average days past due and weighted average days past doc (for past due invoices only)
-- and calculate a ranking of past due customers based on a combination of open_amount, days_past_due, and days_past_doc (for past due invoices only)

Create table #t1	(
									Customer			varchar(50),
									wavg_days_past_due	decimal(18,6),
									wavg_days_past_doc	decimal(18,6),
									past_due_rank		decimal(18,6)
					)
insert into #t1

select 
'ALL', 
isnull(sum(days_past_due*(amount-applied_amount))/sum(amount-applied_amount),0) as days_past_due,
isnull(sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount),0) as days_past_doc,
isnull((sum(amount-applied_amount)*.4)*((sum(days_past_due*(amount-applied_amount))/sum(amount-applied_amount))*.4)*((sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount))*.2),0)
from 
ar_customer_aging 
where 
days_past_due > 0 
and amount<>applied_amount



-- Copy the calculated values from the temp table to the permanent table

update 
ar_4
set 
ar_4.wavg_days_past_due = #t1.wavg_days_past_due,
ar_4.wavg_days_past_doc = #t1.wavg_days_past_doc,
ar_4.past_due_rank = #t1.past_due_rank
from 
ar_4, #t1
where 
ar_4.customer = #t1.customer
and ar_4.time_stamp = (select max(ar_4.time_stamp) from ar_4)


-- For each customer, 
-- Calculate the weighted average days past due and weighted average days past doc (for past due invoices only)
-- and calculate a ranking of past due customers based on a combination of open_amount, days_past_due, and days_past_doc (for past due invoices only)

Create table #t2	(
									Customer			varchar(50),
									wavg_days_past_due	decimal(18,6),
									wavg_days_past_doc	decimal(18,6),
									past_due_rank		decimal(18,6)
					)
insert into #t2


select 
customer, 
isnull(sum(days_past_due*(amount-applied_amount))/sum(amount-applied_amount),0) as days_past_due,
isnull(sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount),0) as days_past_doc,
isnull((sum(amount-applied_amount)*.4)*((sum(days_past_due*(amount-applied_amount))/sum(amount-applied_amount))*.4)*((sum(days_past_doc*(amount-applied_amount))/sum(amount-applied_amount))*.2),0)
from 
ar_customer_aging 
where 
days_past_due > 0 
and amount<>applied_amount
group by
customer



-- Copy the calculated values from the temp table to the permanent table

update 
ar_4
set 
ar_4.wavg_days_past_due = #t2.wavg_days_past_due,
ar_4.wavg_days_past_doc = #t2.wavg_days_past_doc,
ar_4.past_due_rank = #t2.past_due_rank
from 
ar_4, #t2
where 
ar_4.customer = #t2.customer
and ar_4.time_stamp = (select max(ar_4.time_stamp) from ar_4)



-- Close the stored procedure

end

GO
