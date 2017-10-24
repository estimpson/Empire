SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[temp_eeisp_recalc_POReceiptTotals] (@PeriodID Int)
as
Begin

Create table	#ReceiptTotal(
				RTPONumber	int,
				RTPart		varchar(25),
				RTQty		numeric(20,6))

Insert #ReceiptTotal
select	PONumber,
		Part,
		sum(STdQty) 
from	FT.POReceiptPeriods 
where	PeriodID > @PeriodID
Group by	PONumber,
			Part

Update	FT.POReceiptTotals
Set		FT.POReceiptTotals.StdQty = (FT.POReceiptTotals.StdQty-RTQty)
From	FT.POReceiptTotals,
		#ReceiptTotal
where	FT.POReceiptTotals.POnumber = RTPONumber and
		FT.POReceiptTotals.Part = RTPart

Delete	FT.POreceiptPeriods
where	PeriodID > @PeriodID

Delete	FT.ReceiptPeriods
where	ID > @periodID

DECLARE @RC int
DECLARE @ReceiptPeriodID int
DECLARE @PeriodEndDT datetime
DECLARE @Debug int

-- TODO: Set parameter values here.

EXECUTE @RC = [Monitor].[FT].[csp_RecordReceipts] 
   @ReceiptPeriodID OUTPUT
  ,@PeriodEndDT OUTPUT
  ,@Debug

end
GO
