SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure
[dbo].[eeisp_QCSortPriority]
as
begin

  create table #onhold(
    MinSerial integer null,
    Part varchar(25) null,
    note varchar(255) null,
    QtyOnHold numeric(20,6) null,
    QtyApproved numeric(20,6) null,
    FIFOApproved numeric(20,6) null,
    StdPack numeric(20,6) null,
    team varchar(10) null,
    HourstoApprove numeric(20,6) null,
    scheduler varchar(10) null,
    )
  create index idx_#onhold_1 on #onhold(Part asc)
 
  insert into #onhold(MinSerial,
    Part,
    note,
    QtyOnHold,
    QtyApproved,
    FIFOApproved,
    StdPack,
    team,
    HourstoApprove,
    scheduler)
    select MinSerialonhold=min(serial),
      object.part,
      part.description_long,
      qty_onhold=sum(std_quantity),
      approved_qty=isNULL((select sum(std_quantity)
        from object as o2
        where part.part=o2.part
        and status='A'),0),
      FIFO_approved_qty=isNULL((select sum(std_quantity)
        from object as o2
        where part.part=o2.part
        and status='A'
        and o2.serial=any(select o3.serial
          from object as o3
          where part.part=o3.part
          and status='A' and o3.serial<(Select min(serial) from Object join
      part_inventory on object.part=part_inventory.part join
      part on part_inventory.part=part.part join
      location on object.location=location.code join
      part_eecustom on part.part=part_eecustom.part
      where object.status<>'A'
      and part.type='F'
      and(location.plant like 'EEI%' or location.plant like 'INTRANS%')))),0),
      part_inventory.standard_pack,
      part_eecustom.team_no,
      hourstoapprove=isNULL(part_eecustom.MinutestoApproveBox,0)/60,
      scheduler=isNULL((select max(scheduler)
        from destination
        ,part_customer
        where part_customer.part=part.part
        and part_customer.customer not in('EEH','EEI')
        and part_customer.customer=destination.customer),'XX')
      from Object join
      part_inventory on object.part=part_inventory.part join
      part on part_inventory.part=part.part join
      location on object.location=location.code join
      part_eecustom on part.part=part_eecustom.part
      where object.status<>'A'
      and part.type='F'
      and(location.plant like 'EEI%' or location.plant like 'INTRANS%')
      group by part.part,
      object.part,
      part_eecustom.team_no,
      MinutestoApproveBox,
      part.description_long,
      part_inventory.standard_pack
  select #onhold.Part,
    QtyOnHold,
    QtyApproved,
    FIFOApproved,
    StdPack,
    start_date=convert(datetime,convert(varchar(10),getdate(),101)),
    qty_past_due=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and (order_detail.due_date)<convert(varchar(10),getdate(),101)),0),
    qty_day0=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=convert(varchar(10),getdate(),101)),0),
    qty_day1=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,1,convert(varchar(10),getdate(),101))),0),
    qty_day2=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,2,convert(varchar(10),getdate(),101))),0),
    qty_day3=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,3,convert(varchar(10),getdate(),101))),0),
    qty_day4=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,4,convert(varchar(10),getdate(),101))),0),
    qty_day5=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,5,convert(varchar(10),getdate(),101))),0),
    qty_day6=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,6,convert(varchar(10),getdate(),101))),0),
    qty_day7=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,7,convert(varchar(10),getdate(),101))),0),
    qty_day8=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,8,convert(varchar(10),getdate(),101))),0),
    qty_day9=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,9,convert(varchar(10),getdate(),101))),0),
    qty_day10=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,10,convert(varchar(10),getdate(),101))),0),
    qty_day11=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,11,convert(varchar(10),getdate(),101))),0),
    qty_day12=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,12,convert(varchar(10),getdate(),101))),0),
    qty_day13=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,13,convert(varchar(10),getdate(),101))),0),
    qty_day14=isNULL((select sum(order_detail.quantity)
      from order_detail where order_detail.part_number=#onhold.part and order_detail.due_date=dateadd(dd,14,convert(varchar(10),getdate(),101))),0),
    note,
    team,
    HourstoApprove,
    scheduler,
	minserial
    from #onhold order by
    1 asc,5 asc
end



GO
