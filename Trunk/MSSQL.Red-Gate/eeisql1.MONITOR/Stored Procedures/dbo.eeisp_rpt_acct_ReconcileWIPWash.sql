SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[eeisp_rpt_acct_ReconcileWIPWash] (@Startdate Datetime)

-- eeisp_rpt_acct_ReconcileWIPWash '2016-01-01'
as
Begin

Create table #bill_of_material (	Parent_part varchar(25),
									Part varchar(25),
									quantity numeric(20,6) null, Primary Key (Parent_part, Part))

Insert	 #bill_of_material 
Select	parent_part,
		part,
		quantity
from		bill_of_material
where	parent_part in (Select	part  
from		audit_trail
where	date_stamp >= '2016-01-01' and
		type = 'J')
Union

Select	parent_part,
		part,
		quantity
from		bill_of_material
where	part in (Select	part  
from		audit_trail
where	date_stamp >= '2016-01-01' and
		type = 'M')

Create table #pshd (	ThatDayDateStamp datetime,
					FollowingDayDateStamp datetime,
					Part varchar(25),
					Cost_cum numeric(20,6) null,
					material_cum numeric(20,6) null, Primary Key (ThatDayDateStamp, Part))

Insert	 #pshd 

Select	distinct ft.fn_truncdate('dd', Time_stamp),
		dateadd(dd,1,ft.fn_truncdate('dd', Time_stamp)) FollowingDay,
		part,
		cost_cum,
		material_cum
from		historicaldata.dbo.part_standard_historical_daily
where	time_stamp >=@Startdate and
		part in (select part from audit_trail where type = 'J' and date_stamp>= @Startdate
				union 
				select part from audit_trail where type = 'M' and date_stamp>= @Startdate)

Create table	#Ins (	DateStamp Datetime,
					Inpart varchar(25),
					type char(1),
					QtyIn numeric(20,6)	, 
					QtyType  int, primary key (DateStamp, Inpart))		

Insert #Ins
select 
	ft.fn_truncdate ('dd', date_stamp) as DateStamp,
	part,
	Type,
	sum(Quantity),
	Posting =
 (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end)
from		audit_trail
where	date_stamp>= @Startdate
and		audit_trail.type in ('J')
group by	ft.fn_truncdate ('dd', date_stamp),
	part,
	Type,
	 (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end),
	audit_trail.status
having (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end) = 1


Create table	#Outs (	DateStamp Datetime,
					Outpart varchar(25),
					type char(1),
					QtyOut numeric(20,6)	, 
					QtyType  int, primary key (DateStamp, Outpart))	

Insert #Outs
select 
	ft.fn_truncdate ('dd', date_stamp) as DateStamp,
	part,
	Type,
	sum(Quantity),
	Posting =
 (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end)
from		audit_trail
where	date_stamp>= @Startdate
and		audit_trail.type in ('M')
group by	ft.fn_truncdate ('dd', date_stamp),
	part,
	Type,
	 (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end),
	audit_trail.status
having (case
  when Type in ('B', 'T', 'C', 'H') then 0
  when Type in ('R', 'A', 'J') then 1
  when Type in ('E', 'M', 'D') then -1
  when Type = 'Q' and Status = 'S' then -1
  when Type = 'Q' and Status != 'S' then 0
 end) = -1
Create	table #TheoreticalConsumption
(	DateStamp datetime,
	InPart varchar(25),
	QtyIn numeric(20,6) null,
	Parentpart varchar(25) null,
	Part varchar(25),
	BOMQty numeric(20,6) null,
	TheoreticalConsumption numeric(20,6) , primary key (DateStamp, InPart, Part))
--Insert	#TheoreticalConsumption
Select	DateStamp,
		InPart,
		isNull(QtyIn,0)as Ins,
		isNull(QtyIn,0)*psh1.material_CUM as ExtendedMaterialIn,
		Parent_part,
		bill_of_material.part,
		quantity,		
		isNULL(((QtyIn*Quantity)*-1),0) as StandardOuts,
		isNULL(((QtyIn*Quantity)*-1),0)*psh2.material_CUM as StandardExtendedOuts,
		-1*(Select sum(QtyOut) from #Outs where OutPart = bill_of_material.Part and #Outs.DateStamp = Ins.DateStamp)as ActualOuts,
		-1*(Select sum(QtyOut) from #Outs where OutPart = bill_of_material.Part and #Outs.DateStamp = Ins.DateStamp)*psh2.material_CUM as ActualOutsExtended
		

from		#bill_of_material bill_of_material
left join   #ins ins on bill_of_material.parent_part = ins.inpart
left join		 #pshd psh1 on bill_of_material.Parent_part = psh1.part and DateStamp = psh1.ThatDayDateStamp
left join		 #pshd psh2 on bill_of_material.part = psh2.part and DateStamp = psh2.ThatDayDateStamp 

/*Select	COALESCE(TheoreticalConsumption.DateStamp, Outs.DateStamp),* 
from	#TheoreticalConsumption TheoreticalConsumption
full join	#outs outs on TheoreticalConsumption.DateStamp = outs.DateStamp and TheoreticalConsumption.Part = Outs.Outpart
left join	#pshd pshd1 on TheoreticalConsumption.Inpart = pshd1.part and COALESCE(TheoreticalConsumption.DateStamp, Outs.DateStamp) = pshd1.ThatDayDateStamp
left join	#pshd pshd2 on TheoreticalConsumption.part = pshd2.part and COALESCE(TheoreticalConsumption.DateStamp, Outs.DateStamp) = pshd2.ThatDayDateStamp
order by 1*/

End



GO
