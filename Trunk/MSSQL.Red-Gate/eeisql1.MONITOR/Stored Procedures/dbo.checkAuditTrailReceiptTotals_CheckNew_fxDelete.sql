SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[checkAuditTrailReceiptTotals_CheckNew_fxDelete]
as
begin
  delete from eeiat_ftcumqtydifference
  insert into eeiat_ftcumqtydifference
    select ATQty=sum(std_quantity),FTQty=(select sum(POReceiptPEriodsTemp.STDQty)
        from FT.POReceiptPEriodsTemp
        where POReceiptPEriodsTemp.PONumber=Audit_trail.po_number
        and POReceiptPEriodsTemp.part=Audit_trail.part),
      po_number,audit_trail.part
      from audit_trail
      where type='R'
      and audit_trail.date_stamp<'2005/08/18 08:47:33'
      group by po_number,audit_trail.part
      having FTQty<>ATQty
  select eeiat_ftcumqtydifference.atqty,
    eeiat_ftcumqtydifference.ftqty,
    0,
    eeiat_ftcumqtydifference.ponumber,
    eeiat_ftcumqtydifference.part,
    po_header.vendor_code
    from eeiat_ftcumqtydifference join po_header on eeiat_ftcumqtydifference.poNUmber=po_header.po_number
end
GO
