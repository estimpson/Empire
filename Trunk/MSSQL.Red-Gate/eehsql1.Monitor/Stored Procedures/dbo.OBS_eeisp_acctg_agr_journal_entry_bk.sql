SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[OBS_eeisp_acctg_agr_journal_entry_bk]  (@newcosttimestampp datetime, @inventorysnapshoptimestampp datetime, @offsetaccount varchar(10))
as
Begin

declare	@RollUpDay	varchar(10),
		@newcosttimestamp datetime, 
		@inventorysnapshoptimestamp datetime,
		@identitynumber int,
		@mididentitynumber int

declare	@JournalEntries table (
		id int identity,
		ledger_account	varchar(15),
		extended_amount numeric (20,6),
		transaction_date varchar(15),
		AA varchar(15),
		BB varchar(15),
		change numeric (20,6),
		part varchar(25),
		serial int,
		remarks varchar(255))

Select	@newcosttimestamp = (select min(time_stamp) from part_standard_historical where time_stamp >=@newcosttimestampp and reason = 'Global Rollup')
Select	@inventorysnapshoptimestamp = (select min(time_stamp) from	object_historical where time_stamp >=@inventorysnapshoptimestampp and reason = 'Global Rollup')


Select	@rollUpDay = substring(convert(varchar(10), @newcosttimestamp,111),1,4) +'-'+ substring(convert(varchar(10), @newcosttimestamp,111),6,2)+'-'+ substring(convert(varchar(10), @newcosttimestamp,111),9,2)


insert	@JournalEntries ( ledger_account	,
		extended_amount ,
		transaction_date,
		AA ,
		BB,
		change,
		part ,
		serial ,
		remarks 	)
Select *  from (select	(case c.type when 'R' then '151012' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.material_cum - b.planned_material_cum),2) as ext_amount, 
								@rollUpDay as transaction_date,
								'' as AA, 
								'' as BB, 
								b.material_cum-b.planned_material_cum as change, 
								a.part, 
								a.serial, 
								'RAW MATERIAL GLOBAL ROLLUP   NEW: '+ convert(varchar(10),b.material_cum)+'  OLD: '+convert(varchar(10),b.planned_material_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and 
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'R' and
								b.material_cum - b.planned_material_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'W' then '152112' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.material_cum - b.planned_material_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.material_cum-b.planned_material_cum as change, 
								a.part, 
								a.serial, 
								'WIP MATERIAL GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.material_cum)+'  OLD: '+convert(varchar(10),b.planned_material_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'W' and
								b.material_cum - b.planned_material_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'W' then '152212' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.labor_cum - b.planned_labor_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.labor_cum-b.planned_labor_cum as change, 
								a.part, 
								a.serial, 
								'WIP LABOR GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.labor_cum)+'  OLD: '+convert(varchar(10),b.planned_labor_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'W'and
								b.labor_cum - b.planned_labor_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'W' then '152312' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.burden_cum - b.planned_burden_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.burden_cum-b.planned_burden_cum as change, 
								a.part, 
								a.serial, 
								'WIP BURDEN GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.burden_cum)+'  OLD: '+convert(varchar(10),b.planned_burden_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'W'and
								b.burden_cum - b.planned_burden_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'F' then '153112' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.material_cum - b.planned_material_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.material_cum-b.planned_material_cum as change, 
								a.part, 
								a.serial,  
								'FG MATERIAL GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.material_cum)+'  OLD: '+convert(varchar(10),b.planned_material_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'F'and
								b.material_cum - b.planned_material_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'F' then '153212' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.labor_cum - b.planned_labor_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.labor_cum-b.planned_labor_cum as change, 
								a.part, 
								a.serial, 
								'FG LABOR GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.labor_cum)+'  OLD: '+convert(varchar(10),b.planned_labor_cum) as document_remarks
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'F'and
								b.labor_cum - b.planned_labor_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						union all
						select (	case c.type when 'F' then '153312' else '' end) as ledger_account, 
								ROUND(a.quantity*(b.burden_cum - b.planned_burden_cum),2) as ext_amount, 
								@rollUpDay as transaction_date, 
								' ' as AA, 
								' ' as BB, 
								b.burden_cum-b.planned_burden_cum as change, 
								a.part, 
								a.serial,  
								'FG BURDEN GLOBAL ROLLUP   NEW: '+convert(varchar(10),b.burden_cum)+'  OLD: '+convert(varchar(10),b.planned_burden_cum) as document_remarks 
						from		object_historical a, 
								part_standard_historical b, 
								part c
						where	a.part = c.part and 
								a.part = b.part and  
								b.time_stamp = @newcosttimestamp and 
								a.time_stamp = @inventorysnapshoptimestamp and
								c.type = 'F' and
								b.burden_cum - b.planned_burden_cum != 0 and a.quantity>0 and
								a.user_defined_status !='PRESTOCK'
						) JEntries
set		@identitynumber = (Select max(id) from @journalentries)

--print		convert(varchar(25), @identitynumber)


if		(@identitynumber>= 20000) Begin
set		@mididentitynumber = round((@identitynumber/2),0)
	
select	id ,
		ledger_account,
		convert(varchar(30), extended_amount),
		transaction_date,
		AA ,
		BB ,
		convert(varchar(30),change),
		part ,
		serial,
		remarks
from		@JournalEntries
where	id < @mididentitynumber
union
select	0,
		@offsetaccount,
		convert(varchar (30), -1*sum(extended_amount)), 
		@RollUpDay,
		' ' ,
		' ',
		NULL,
		' ',
		NULL,
		'GLOBAL ROLLUP' 
from		@JournalEntries where change <> 0
and		id < @mididentitynumber
union
select	id ,
		ledger_account,
		convert(varchar(30), extended_amount),
		transaction_date,
		AA ,
		BB ,
		convert(varchar(30),change),
		part ,
		serial,
		remarks 
from		@JournalEntries
where	id >= @mididentitynumber
union
select	@mididentitynumber-1,
		@offsetaccount,
		convert(varchar (30), -1*sum(extended_amount)), 
		@RollUpDay,
		' ' ,
		' ',
		NULL,
		' ',
		NULL,
		'GLOBAL ROLLUP' 
from		@JournalEntries where change <> 0
and		id >= @mididentitynumber
end else
Begin
select	id ,
		ledger_account,
		convert(varchar(30), extended_amount),
		transaction_date,
		AA ,
		BB ,
		convert(varchar(30),change),
		part ,
		serial,
		remarks 
from		@JournalEntries
union
select	0,
		@offsetaccount,
		convert(varchar (30), -1*sum(extended_amount)), 
		@RollUpDay,
		' ' ,
		' ',
		NULL,
		' ',
		NULL,
		'GLOBAL ROLLUP' 
from		@JournalEntries where change <> 0

End
End
GO
