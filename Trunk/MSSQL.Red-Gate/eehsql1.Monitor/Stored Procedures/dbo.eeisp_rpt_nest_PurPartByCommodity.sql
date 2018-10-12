SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure
[dbo].[eeisp_rpt_nest_PurPartByCommodity](@part varchar(25))
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
  select part_vendor.part,
    part_vendor.vendor,
    part_vendor_price_matrix.break_qty,
    part_vendor_price_matrix.alternate_price
    from part_vendor
    ,part_vendor_price_matrix
    where part_vendor.vendor=part_vendor_price_matrix.vendor
    and part_vendor.part=part_vendor_price_matrix.part
    and part_vendor.part=@part
end
GO
