SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_rpt_inventory_snapshot](@begindatetime datetime,@enddatetime datetime)
as
begin
  create table #PostTransactions(
    Part varchar(25) null,
    type char(2) null,
    remarks varchar(50) null,
    user_defined_status varchar(50) null,
    Quantity decimal(20,6) null,
    cost decimal(20,6) null,
    currentcost decimal(20,6) null,
    )
  create index idxPostTransactions on #PostTransactions(Part asc)
  create table #PartInv(
    Part varchar(25) null,
    Quantity decimal(20,6) null,
    cost decimal(20,6) null,
    currentcost decimal(20,6) null,
    )
  create index idxPartInv on #PartInv(Part asc)
  insert into #PostTransactions
    select audit_trail.part,
      audit_trail.type,
      remarks,
      user_defined_status,
      qty=sum((case when type in('A','J','R','U') then((audit_trail.std_quantity)*-1) else audit_trail.std_quantity end)),
      cost_then=sum((case when type in('A','J','R','U') then(((audit_trail.std_quantity)*-1)*audit_trail.cost) else(audit_trail.std_quantity*audit_trail.cost) end)),
      cost_now=sum((case when type in('A','J','R','U') then(((audit_trail.std_quantity)*-1)*part_standard.cost_cum) else(audit_trail.std_quantity*part_standard.cost_cum) end))
      from audit_trail join
      part_standard on audit_trail.part=part_standard.part
      where audit_trail.date_stamp>=@begindatetime
      and audit_trail.date_stamp<@enddatetime
      and audit_trail.part<>'PALLET'
      and quantity>0
      and type not in('T','B','C')
      group by audit_trail.part,
      type,
      remarks,
      user_defined_status order by
      1 asc,2 asc
  delete from #PostTransactions
    where type='Q' and user_defined_status<>'Scrapped'
  insert into #PartInv
    select object_copy_20060131.part,
      qty=sum(object_copy_20060131.std_quantity),
      cost_then=sum(object_copy_20060131.std_quantity*object_copy_20060131.cost),
      cost_now=sum(object_copy_20060131.std_quantity*part_standard.cost_cum)
      from object_copy_20060131 join
      part_standard on object_copy_20060131.part=part_standard.part
      where object_copy_20060131.part<>'PALLET'
      group by object_copy_20060131.part,
      part_standard.part
  select #PartInv.part,
    ending_inventory=isNULL(#PartInv.quantity,0),
    ei_CostThen=isNULL(#PartInv.cost,0),
    ei_CostNow=isNULL(#PartInv.currentCost,0),
    #PostTransactions.part,
    isNULL(#PostTransactions.quantity,0),
    tr_CostThen=isNULL(#PostTransactions.cost,0),
    tr_CostNow=isNULL(#PostTransactions.currentcost,0),
    #PostTransactions.remarks,
    #PostTransactions.user_defined_status
    from #PartInv left outer join
    #PostTransactions on #PartInv.part=#PostTransactions.part union all
  select #PartInv.part,
    ending_inventory=isNULL(#PartInv.quantity,0),
    CostThen=isNULL(#PartInv.cost,0),
    CostNow=isNULL(#PartInv.currentCost,0),
    #PostTransactions.part,
    isNULL(#PostTransactions.quantity,0),
    tr_CostThen=isNULL(#PostTransactions.cost,0),
    tr_CostNow=isNULL(#PostTransactions.currentcost,0),
    #PostTransactions.remarks,
    #PostTransactions.user_defined_status
    from #PostTransactions left outer join
    #PartInv on #PostTransactions.part=#PartInv.part
end
GO
