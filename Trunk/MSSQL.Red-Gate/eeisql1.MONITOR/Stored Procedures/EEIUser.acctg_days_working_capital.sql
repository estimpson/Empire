SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_days_working_capital] @fiscal_year varchar(4)

-- exec eeiuser.acctg_days_working_capital '2003'


as


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @ar_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @ar_temp
select	fiscal_year
		,period
		,'12051,12101,12111,12121' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('12051','12101','12111','12121') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

declare @ar_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @ar_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @ar_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

declare @ar_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @ar_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @ar_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@ar_temp2 a
order by date_stamp

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @inv_rm_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @Inv_rm_temp
select	fiscal_year
		,period
		,'15101,15151,15171' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('15101','15151','15171') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

declare @inv_rm_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @inv_rm_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @inv_rm_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

declare @inv_rm_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @inv_rm_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @inv_rm_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@inv_rm_temp2 a
order by date_stamp

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @inv_wip_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @Inv_wip_temp
select	fiscal_year
		,period
		,'15211,15221,15231,15251' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('15211','15221','15231','15251') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

declare @inv_wip_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @inv_wip_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @inv_wip_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

declare @inv_wip_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @inv_wip_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @inv_wip_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@inv_wip_temp2 a
order by date_stamp
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @inv_fg_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @Inv_fg_temp
select	fiscal_year
		,period
		,'15311,15321,15331,15361,15371,15401,15451,15461' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('15311','15321','15331','15361','15371','15401','15451','15461') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

declare @inv_fg_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @inv_fg_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @inv_fg_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

declare @inv_fg_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @inv_fg_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @inv_fg_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@inv_fg_temp2 a
order by date_stamp
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @inv_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @Inv_temp
select	fiscal_year
		,period
		,'15101,15151,15171,15211,15221,15231,15251,15311,15321,15331,15361,15371,15401,15451,15461' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('15101','15151','15171','15211','15221','15231','15251','15311','15321','15331','15361','15371','15401','15451','15461') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

declare @inv_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @inv_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @inv_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

declare @inv_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @inv_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @inv_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@inv_temp2 a
order by date_stamp
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @ap_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @ap_temp
select	fiscal_year
		,period
		,'21101,21111,21151,21161,21201,21211,21221' as ledger_accounts
		,ledger
		,balance_name
		,SUM(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('21101','21111','21151','21161','21201','21211','21221') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

--select * from @ap_temp

declare @ap_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @ap_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @ap_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

--select * from @ap_temp2

declare @ap_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @ap_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @ap_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@ap_temp2 a
order by date_stamp

--select * from @ap_temp3

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @sales_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @sales_temp
select	fiscal_year
		,period
		,'40101,40111,40171,40191,40201,40231' as ledger_accounts
		,ledger
		,balance_name
		,sum(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('40101','40111','40171','40191','40201','40231') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

--select * from @sales_temp

declare @sales_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @sales_temp2
select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @sales_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

--select * from @sales_temp2

declare @sales_temp3 table (date_stamp datetime, account_balance decimal(18,6))

insert into @sales_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @sales_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@sales_temp2 a
order by date_stamp

--select * from @sales_temp3

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
declare @cogs_temp table (fiscal_year varchar(4), period varchar(2), ledger_accounts varchar(100), ledger varchar(50), balance_name varchar(25), period_amount decimal(18,6))

insert into @cogs_temp
select	fiscal_year
		,period
		,'50101,50111,50131,50141,50151' as ledger_accounts
		,ledger
		,balance_name
		,sum(period_amount) as period_amount
from	ledger_balances 
where	fiscal_year >= @fiscal_year
	and ledger = 'EMPIRE' 
	and ledger_account in ('50101','50111','50131','50141','50151') 
	and balance_name = 'ACTUAL' 
group by	fiscal_year
			,period
			,ledger
			,balance_name	
having (case when (fiscal_year <> @fiscal_year And period = 0) then 0 else 1 end) = 1
order by 1,2

--select * from @_cogs_temp

declare @cogs_temp2 table (date_stamp datetime, period_amount decimal(18,6))

insert into @cogs_temp2

select	CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')
		,sum(period_amount) as period_amount
from @cogs_temp
group by CONVERT(datetime,fiscal_year+'-'+convert(varchar(2),(case when period = 0 then 1 else (case when period = 13 then 12 else period end)end))+'-01')

--select * from @cogs_temp2

declare @cogs_temp3 table (date_stamp datetime, account_balance decimal(18,6))
insert into @cogs_temp3
select	date_stamp,
		period_amount+coalesce((select sum(period_amount) from @cogs_temp2 b where b.date_stamp < a.date_stamp),0) as runningtotal
from	@cogs_temp2 a
order by date_stamp

--select * from @cogs_temp3

--==================================================================================================================================
select	ar.date_stamp
		,ar.category
		,ar.account_balance
		,ar.two_mo_moving_average
		,(-sales.two_mo_moving_average*6)/ar.two_mo_moving_average as ar_turns_based_on_two_mo_moving_average
		,360/((-sales.two_mo_moving_average*6)/ar.two_mo_moving_average) as days_ar_based_on_two_mo_moving_average
		,ar.three_mo_moving_average
		,(-sales.three_mo_moving_average*4)/ar.three_mo_moving_average as ar_turns_based_on_three_mo_moving_average
		,360/((-sales.three_mo_moving_average*4)/ar.three_mo_moving_average) as days_ar_based_on_three_mo_moving_average
		,rm.category
		,rm.account_balance
		,rm.two_mo_moving_average
		,(cogs.two_mo_moving_average*6)/rm.two_mo_moving_average as rm_inv_turns_based_on_two_mo_moving_average
		,360/((cogs.two_mo_moving_average*6)/rm.two_mo_moving_average) as days_rm_inv_based_on_two_mo_moving_average
		,rm.three_mo_moving_average
		,(cogs.three_mo_moving_average*4)/rm.three_mo_moving_average as rm_inv_turns_based_on_three_mo_moving_average
		,360/((cogs.three_mo_moving_average*4)/rm.three_mo_moving_average) as days_rm_inv_based_on_three_mo_moving_average		
		,wip.category
		,wip.account_balance
		,wip.two_mo_moving_average
		,(cogs.two_mo_moving_average*6)/wip.two_mo_moving_average as wip_inv_turns_based_on_two_mo_moving_average
		,360/((cogs.two_mo_moving_average*6)/wip.two_mo_moving_average) as days_wip_inv_based_on_two_mo_moving_average
		,wip.three_mo_moving_average
		,(cogs.three_mo_moving_average*4)/wip.three_mo_moving_average as wip_inv_turns_based_on_three_mo_moving_average
		,360/((cogs.three_mo_moving_average*4)/wip.three_mo_moving_average) as days_wip_inv_based_on_three_mo_moving_average
		,fg.category
		,fg.account_balance
		,fg.two_mo_moving_average
		,(cogs.two_mo_moving_average*6)/fg.two_mo_moving_average as fg_inv_turns_based_on_two_mo_moving_average
		,360/((cogs.two_mo_moving_average*6)/fg.two_mo_moving_average) as days_fg_inv_based_on_two_mo_moving_average
		,fg.three_mo_moving_average
		,(cogs.three_mo_moving_average*4)/fg.three_mo_moving_average as fg_inv_turns_based_on_three_mo_moving_average
		,360/((cogs.three_mo_moving_average*4)/fg.three_mo_moving_average) as days_fg_inv_based_on_three_mo_moving_average
		,inv.category
		,inv.account_balance
		,inv.two_mo_moving_average
		,(cogs.two_mo_moving_average*6)/inv.two_mo_moving_average as inv_turns_based_on_two_mo_moving_average
		,360/((cogs.two_mo_moving_average*6)/inv.two_mo_moving_average) as days_inv_based_on_two_mo_moving_average
		,inv.three_mo_moving_average
		,(cogs.three_mo_moving_average*4)/inv.three_mo_moving_average as inv_turns_based_on_three_mo_moving_average
		,360/((cogs.three_mo_moving_average*4)/inv.three_mo_moving_average) as days_inv_based_on_three_mo_moving_average
		,ap.category
		,-ap.account_balance
		,-ap.two_mo_moving_average
		,(cogs.two_mo_moving_average*6)/-ap.two_mo_moving_average as ap_turns_based_on_two_mo_moving_average
		,360/((cogs.two_mo_moving_average*6)/-ap.two_mo_moving_average) as days_ap_based_on_two_mo_moving_average
		,-ap.three_mo_moving_average
		,(cogs.three_mo_moving_average*4)/-ap.three_mo_moving_average as ap_turns_based_on_three_mo_moving_average
		,360/((cogs.three_mo_moving_average*4)/-ap.three_mo_moving_average) as days_ap_based_on_three_mo_moving_average,sales.category
		,-sales.period_amount
		,-sales.two_mo_moving_average
		,(-sales.two_mo_moving_average*6) as annualized_based_on_two_mo_moving_average
		,-sales.three_mo_moving_average
		,(-sales.three_mo_moving_average*4) as annualized_based_on_three_mo_moving_average
		,cogs.category
		,cogs.period_amount
		,cogs.two_mo_moving_average
		,(cogs.two_mo_moving_average*6) as annualized_based_on_two_mo_moving_average
		,cogs.three_mo_moving_average
		,(cogs.three_mo_moving_average*4) as annualized_based_on_three_mo_moving_average
from
(select 'a/r' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @ar_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @ar_temp3 x ,@ar_temp3 y 
WHERE x.date_stamp >= @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @ar_temp3 x ,@ar_temp3 y 
WHERE x.date_stamp >= @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) ar

left join

(select 'rm_inv' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @inv_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @inv_rm_temp3 x ,@inv_rm_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @inv_rm_temp3 x ,@inv_rm_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) rm

on ar.date_stamp = rm.date_stamp

left join

(select 'wip_inv' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @inv_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @inv_wip_temp3 x ,@inv_wip_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @inv_wip_temp3 x ,@inv_wip_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) wip

on ar.date_stamp = wip.date_stamp

left join

(select 'fg_inv' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @inv_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @inv_fg_temp3 x ,@inv_fg_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @inv_fg_temp3 x ,@inv_fg_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) fg

on ar.date_stamp = fg.date_stamp

left join

(select 'inv' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @inv_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @inv_temp3 x ,@inv_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @inv_temp3 x ,@inv_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) inv

on ar.date_stamp = inv.date_stamp

left join

(select 'a/p' as category, aa.date_stamp, aa.account_balance, bb.two_mo_moving_average, cc.three_mo_moving_average from @ap_temp3 aa
left join
(	
SELECT	x.date_stamp,
		AVG(y.account_balance) as two_mo_moving_average
FROM @ap_temp3 x ,@ap_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		AVG(y.account_balance) as three_mo_moving_average
FROM @ap_temp3 x ,@ap_temp3 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) ap 

on ar.date_stamp = ap.date_stamp

left join

(select 'sales' as category, aa.date_stamp, aa.period_amount, bb.two_mo_moving_average, cc.three_mo_moving_average from @sales_temp2 aa
left join
(	
SELECT	x.date_stamp,
		sum(y.period_amount) as two_mo_moving_average
FROM @sales_temp2 x ,@sales_temp2 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		sum(y.period_amount) as three_mo_moving_average
FROM @sales_temp2 x ,@sales_temp2 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) sales

on ar.date_stamp = sales.date_stamp

left join 

(select 'cogs' as category, aa.date_stamp, aa.period_amount, bb.two_mo_moving_average, cc.three_mo_moving_average from @cogs_temp2 aa
left join
(	
SELECT	x.date_stamp,
		sum(y.period_amount) as two_mo_moving_average
FROM @cogs_temp2 x ,@cogs_temp2 y 
WHERE x.date_stamp >=  @fiscal_year+'-02-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,1,y.date_stamp)
GROUP BY x.date_stamp
)bb on aa.date_stamp = bb.date_stamp
left join
(
SELECT	x.date_stamp,
		sum(y.period_amount) as three_mo_moving_average
FROM @cogs_temp2 x ,@cogs_temp2 y 
WHERE x.date_stamp >=  @fiscal_year+'-03-01' AND x.date_stamp BETWEEN y.date_stamp AND dateadd(m,2,y.date_stamp)
GROUP BY x.date_stamp
) cc on aa.date_stamp = cc.date_stamp) cogs

on ar.date_stamp = cogs.date_stamp



GO
