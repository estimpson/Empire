SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_tapereceipthistory](@startdate datetime,@enddate datetime)
as
begin
  create table #tapereceipts(
    part varchar(25) null,
    description varchar(100) null,
    quantity decimal(20,6) null,
    UM char(2) null,
    cost decimal(20,6) null,
    std_cost decimal(20,6) null,
    )
  insert into #tapereceipts
    select Audit_trail.part,
      part.name,
      sum(std_quantity),
      part_inventory.standard_unit,
      sum(audit_trail.cost*std_quantity),
      sum(audit_trail.std_cost*std_quantity)
      from audit_trail join
      part on audit_trail.part=part.part join
      part_inventory on part.part=part_inventory.part join
      tapeparts on part.part=tapeparts.part
      where audit_trail.type='R'
      and audit_trail.date_stamp>=@startdate
      and audit_trail.date_stamp<dateadd(dd,1,@enddate)
      and not audit_trail.serial=any(select serial from audit_trail where type='D' and date_stamp>=@startdate)
      group by audit_trail.part,
      part.name,
      part_inventory.standard_unit
  select #tapereceipts.part,#tapereceipts.description,
    #tapereceipts.quantity,#tapereceipts.UM,#tapereceipts.cost,
    #tapereceipts.std_cost
    from #tapereceipts
end
  
GO
