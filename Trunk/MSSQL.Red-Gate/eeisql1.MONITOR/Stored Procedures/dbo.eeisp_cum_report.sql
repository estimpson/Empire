SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_cum_report] as
begin
  create table #accums(
    PONumber integer null,
    vendor varchar(15) null,
    part varchar(25) null,
    StdQty decimal(20,6) null,
    AccumAdjust decimal(20,6) null,
    ReceivedDT datetime null,
    accumPrior decimal(20,6) null,
    )
  create index idx_#accums_1 on #accums(vendor asc,PONumber asc)
  begin transaction
  begin
    declare @ReceiptPeriodID integer,
    @PeriodEndDT datetime
    execute FT.csp_RecordReceipts @ReceiptPeriodID=
    @ReceiptPeriodID,@PeriodEndDT=
    @PeriodEndDT
  end
  commit transaction
  insert into #accums(PONumber,
    vendor,
    part,
    StdQty,
    AccumAdjust,
    ReceivedDT,
    accumPrior)
    select ponumber,
      vendor.code,
      POReceiptTotals.part,
      TotalACCUM=stdqty,
      accumadjust,
      lastreceivedDT,
      accumprior2004=isNULL((select sum(quantity)
        from audit_trail
        where type='R'
        and part=POReceiptTotals.part
        and audit_trail.po_number=convert(varchar(25),PONumber)
        and date_stamp<'2004/01/01'),0)
      from FT.POReceiptTotals join
      po_header on POReceiptTotals.PONumber=po_header.po_number join
      vendor on po_header.vendor_code=vendor.code join
      part_online on po_header.po_number=part_online.default_po_number
      where po_header.type='B'
  select #accums.PONumber,#accums.vendor,#accums.part,
    #accums.StdQty,#accums.AccumAdjust,#accums.ReceivedDT,
    #accums.accumPrior
    from #accums order by
    vendor asc,PONumber asc
end

GO
