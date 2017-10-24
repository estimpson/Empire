SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_fix_POReceiptPeriods]
as
begin
  delete from FT.POReceiptTotals
  delete from FT.POReceiptPeriods
  delete from FT.ReceiptPeriods
  /* Watcom only
  create table Audit_trail modify
  dbDate default getdate()
  */
  update Audit_trail set
    dbdate=date_stamp
    where audit_trail.type='R'
  declare @ReceiptPeriodID integer,
  @PeriodEndDT datetime
  execute FT.csp_RecordReceipts @ReceiptPeriodID=
  @ReceiptPeriodID,@PeriodEndDT=
  @PeriodEndDT
end
GO
