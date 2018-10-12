SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure
[dbo].[eeisp_rpt_purchasedPartByCommodity](@commodity varchar(25))
/*
Arguments:
None

Result set:
Purchased Part Data

Description:

Author:
Andre S. Boulanger
Copyright c Empire Electronics, Inc.


Andre S. Boulanger January 25, 2004

Process:

*/
as
begin
  create table #parts_received(
    part varchar(25) not null,
    primary key(part),
    )
  insert into #parts_received
    select distinct part
      from audit_trail
      where type='R'
      and date_stamp>dateadd(yy,-1,getdate())
  select Part.commodity,
    Part.Part,
    Part.name,
    part_online.default_vendor,
    part_inventory.standard_unit,
    (select max(ap_items.price)
      from ap_items
      ,ap_headers
      where ap_items.item=part.part
      and ap_items.invoice_cm=ap_headers.invoice_cm
      and ap_items.vendor=ap_headers.vendor
      and ap_items.inv_cm_flag=ap_headers.inv_cm_flag
      and ap_items.inv_cm_flag='I'
      and ap_headers.inv_cm_date=(select max(ap_headers.inv_cm_date)
        from ap_items
        ,ap_headers
        where ap_items.item=part.part
        and ap_items.invoice_cm=ap_headers.invoice_cm
        and ap_items.vendor=ap_headers.vendor
        and ap_items.inv_cm_flag=ap_headers.inv_cm_flag
        and ap_items.inv_cm_flag='I'
        and ap_headers.inv_cm_date>dateadd(yy,-1,getdate()) and ap_headers.purchase_order is not null and ap_headers.purchase_order not like 'EEH%'))
    from #parts_received join
    part on #parts_received.part=part.part join
    part_online on part.part=part_online.part join
    part_inventory on part.part=part_inventory.part
    where part.class='P'
    and part.commodity=@commodity
end
GO
