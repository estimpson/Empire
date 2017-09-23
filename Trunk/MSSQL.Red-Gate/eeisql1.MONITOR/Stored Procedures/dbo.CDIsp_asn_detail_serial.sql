SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure
[dbo].[CDIsp_asn_detail_serial] (@SHIPPER integer)
AS
--[dbo].[CDIsp_asn_detail_serial] 42063 
begin
  create table #atr_package_type(
    part varchar(25) null,
    package_type varchar(25) null,
    pack_qty decimal(20,6) null,
    package_count integer null,
    )
  create table #atr_objects(
    serial integer null,
    part varchar(25) null,
    package_quantity varchar(25) null,
    package_type varchar(25) null,
    )
  insert into #atr_package_type
    select audit_trail.part,
     isNULL(audit_trail.package_type,'CTN90'),
      audit_trail.quantity,
      count(SERIAL)
      from audit_trail
      where audit_trail.type='S'
      and audit_trail.part<>'PALLET'
      and audit_trail.shipper=convert(varchar(25),@shipper)
      group by audit_trail.part,
       isNULL(audit_trail.package_type,'CTN90'),
      audit_trail.quantity
  insert into #atr_objects
    select audit_trail.serial,
      audit_trail.part,
      audit_trail.quantity,
      isNULL(audit_trail.package_type,'CTN90')
      from audit_trail
      where audit_trail.type='S'
      and audit_trail.part<>'PALLET'
      and audit_trail.shipper=convert(varchar(25),@shipper)
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
    #atr_package_type.package_type,
    #atr_package_type.package_count,
    #atr_package_type.pack_qty,
    #atr_objects.serial,
    order_header.engineering_level,
    (SELECT COUNT(1) FROM shipper_detail sd2 WHERE sd2.shipper = @SHIPPER AND sd2.part_original <= shipper_detail.part_original) AS LineItem,
    CONVERT(varchar(3),(SELECT COUNT(1) FROM shipper_detail sd2 WHERE sd2.shipper = @SHIPPER AND sd2.part_original <= shipper_detail.part_original))+dbo.shipper_detail.customer_part AS GCustomerPart,
    part_original
    from edi_setups
    ,shipper_detail
    ,shipper
    ,order_header
    ,#atr_package_type
    ,#atr_objects
    where(shipper.destination=edi_setups.destination)
    and(order_header.order_no=shipper_detail.order_no)
    and(shipper.id=@shipper)
    and(#atr_package_type.part=shipper_detail.part_original)
    and(#atr_objects.part=shipper_detail.part_original)
    and(#atr_objects.part=#atr_package_type.part)
    and(#atr_objects.package_quantity=#atr_package_type.pack_qty)
    and(#atr_objects.package_type=#atr_package_type.package_type)
    and((shipper_detail.shipper=@shipper)) order by
    part_original asc,
    11 asc,
    12 asc,
    13 asc,
    14 asc
end


GO
