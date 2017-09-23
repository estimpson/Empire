SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure
[dbo].[eeIsp_asn_detail](@shipper integer)
as
begin
  select edi_setups.prev_cum_in_asn,
    shipper_detail.customer_part,
    shipper_detail.alternative_qty,
    shipper_detail.alternative_unit,
    shipper_detail.net_weight,
    shipper_detail.gross_weight,
    shipper_detail.accum_shipped,
    shipper_detail.shipper,
    shipper_detail.customer_po,
    accum2=(select isNULL(max(sd2.accum_shipped),0)
      from shipper_detail as sd2
      where sd2.order_no=shipper_detail.order_no
      and (sd2.date_shipped)<=(select max(sd3.date_shipped)
        from shipper_detail as sd3
        where sd3.order_no=shipper_detail.order_no
        and sd3.date_shipped<shipper_detail.date_shipped)),
    order_header.engineering_level,
	shipper_detail.alternate_price
    from edi_setups
    ,shipper_detail
    ,shipper
    ,order_header
    where(shipper.destination=edi_setups.destination)
    and(order_header.order_no=shipper_detail.order_no)
    and(shipper_detail.part_original not like 'Copper%')
    and(shipper.id=@shipper)
    and((shipper_detail.shipper=@shipper)) order by
    2 asc
end
GO
