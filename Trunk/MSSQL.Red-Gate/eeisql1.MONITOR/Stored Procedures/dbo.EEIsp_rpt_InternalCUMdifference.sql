SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[EEIsp_rpt_InternalCUMdifference]
as
begin
  declare @GeneratedDT datetime,
  @ReceiptPeriodID integer,
  @ProcResult integer,
  @Error integer,
  @SQLCode integer
  execute
  @ProcResult=FT.csp_RecordReceipts @ReceiptPeriodID=
  @ReceiptPeriodID,@PeriodEndDT=
  @GeneratedDT
  begin transaction
  delete from eeiat_ftcumqtydifference
  insert into eeiat_ftcumqtydifference
    select ATQty=sum(std_quantity),FTQty=(POReceiptTotals.STDQty),po_number,audit_trail.part
      from audit_trail join
      FT.POReceiptTotals POReceiptTotals on Audit_trail.PO_Number=POReceiptTotals.PONumber and audit_trail.part=POReceiptTotals.part
      where type='R'
      group by po_number,audit_trail.part,
      POReceiptTotals.STDQty,
      AccumAdjust
      having (POReceiptTotals.STDQty)<>sum(std_quantity)
  commit transaction
  select eeiat_ftcumqtydifference.atqty,
    eeiat_ftcumqtydifference.ftqty,
    POReceiptTotals.AccumAdjust,
    eeiat_ftcumqtydifference.ponumber,
    eeiat_ftcumqtydifference.part,
    po_header.vendor_code
    from eeiat_ftcumqtydifference join
    FT.POReceiptTotals POReceiptTotals on eeiat_ftcumqtydifference.ponumber=POReceiptTotals.PONUmber
    and eeiat_ftcumqtydifference.part=POReceiptTotals.part join
    po_header on POReceiptTotals.poNUmber=po_header.po_number
end
GO
