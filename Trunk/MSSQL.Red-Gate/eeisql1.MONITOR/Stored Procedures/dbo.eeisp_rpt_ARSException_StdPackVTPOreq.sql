SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_rpt_ARSException_StdPackVTPOreq]
as
begin
  create table #ReleaseRequirements(
    PONumber smallint null,
    Part varchar(50) null,
    RawMonthlyReq decimal(20,6) null,
    RawTotalReq decimal(20,6) null,
    POMonthlyReq decimal(20,6) null,
    POTotalReq decimal(20,6) null,
    weeksCovered smallint null,
    firstorderweek smallint null,
    totalweekshorizon smallint null,
    weekssupplyaft smallint null,
    )
  insert into #ReleaseRequirements
    select po_header.po_number,
      po_header.blanket_part,
      isNULL((select max(postdemandAccum) from FT.WkNMPS where weekNo<=4 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      isNULL((select postdemandAccum from FT.WkNMPS where weekNo=(select max(weekNo) from FT.WkNMPS as MPS2 where MPS2.PONumber=FT.WkNMPS.PONumber and MPS2.part=FT.WkNMPS.part) and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      isNULL((select max(POBalance+PriorPOAccum) from FT.WkNMPS where weekNo<=4 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      isNULL((select POBalance+PriorPOAccum from FT.WkNMPS where weekNo=(select max(weekNo) from FT.WkNMPS as MPS2 where MPS2.PONumber=FT.WkNMPS.PONumber and MPS2.part=FT.WkNMPS.part) and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      isNULL((select max(weekNo) from FT.WkNMPS where postdemandAccum<=StandardPack and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      firstorderweek=isNULL((select min(weekNo) from FT.WkNMPS where POBalance>0 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      totalweekshorizon=isNULL((select max(weekNo) from FT.WkNMPS where FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0),
      isNULL(((select min(weekNo) from FT.WkNMPS where weekno>isNULL((select min(weekNo) from FT.WkNMPS where POBalance>0 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0) and FT.WkNMPS.POBalance>0 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part)-isNULL((select min(weekNo) from FT.WkNMPS where POBalance>0 and FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0))-1,isNULL((select max(weekNo) from FT.WkNMPS where FT.WkNMPS.ponumber=po_header.po_Number and FT.WkNMPS.part=po_header.blanket_part),0))
      from po_header join
      part_online on po_header.blanket_Part=part_online.part and po_header.po_number=part_online.default_po_number join
      part_eecustom on part_online.part=part_eecustom.part
      where part_eecustom.auto_releases='Y'
  select #ReleaseRequirements.PONumber,
    #ReleaseRequirements.Part,
    RawMonthlyReq,
    POMonthlyReq,
    RawTotalReq,
    POTotalReq,
    weeksCovered,
    std_pack=isNull(part_vendor.vendor_standard_pack,part_inventory.standard_pack),
    vendor.code,
    vendor.contact,
    part_vendor.vendor_part,
    firmweeks=isNull((FabauthDays/7),0),
    firstorderweek,
    totalweekshorizon,
    weekssupplyaft,
    cost
    from #ReleaseRequirements join
    po_header on #ReleaseRequirements.PONumber=po_header.po_number and #ReleaseRequirements.part=po_header.blanket_part join
    vendor on po_header.vendor_code=vendor.code join
    part_vendor on po_header.vendor_code=part_vendor.vendor and po_header.blanket_part=part_vendor.part join
    part_standard on po_header.blanket_part=part_standard.part join
    part_inventory on po_header.blanket_part=part_inventory.part
    where POTotalReq>0
    and isNull(part_vendor.vendor_standard_pack,part_inventory.standard_pack)>RawTotalReq
end
GO
