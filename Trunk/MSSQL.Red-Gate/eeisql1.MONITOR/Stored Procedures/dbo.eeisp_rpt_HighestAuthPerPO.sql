SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure
[dbo].[eeisp_rpt_HighestAuthPerPO] (@PONumber integer)
as
begin

declare	@ReceiptPeriodID integer,
				@PeriodEndDT datetime
  

if exists
    (    select    1
        from    audit_trail
        where    type = 'R'  and
            po_number = @PONumber and
            date_stamp > 
            (    select    max(PeriodEndDT)
                from    FT.ReceiptPeriods ) )

        exec FT.csp_RecordReceipts @ReceiptPeriodID output,@PeriodEndDT output, 0
  
  Select	FT.FABAuthorizations.PONumber,
				FT.FABAuthorizations.Part,
				FT.FABAuthorizations.WeekNo,
				dateadd(wk, FT.FABAuthorizations.WeekNo, '1999-01-03'),
				max(FT.FABAuthorizations.AuthorizedAccum),
				FT.HighFABAuthorizations.AuthorizedAccum,
				FT.HighFABAuthorizations.ReleasePlanID,
				FT.POreceiptTotals.STDqTY+isNULL(FT.POReceiptTotals.AccumAdjust,0)			
from			FT.FABAuthorizations,
				FT.HighFABAuthorizations,
				FT.POReceiptTotals
			 
where		FT.FABAuthorizations.PONumber = @PONumber and
				FT.FABAuthorizations.PONumber =  FT.HighFABAuthorizations.PONumber and
				FT.FABAuthorizations.Part =  FT.HighFABAuthorizations.Part and
				FT.POReceiptTotals.POnumber = FT.HighFABAuthorizations.PONumber and
				FT.POReceiptTotals.Part = FT.HighFABAuthorizations.Part 

Group By	FT.FABAuthorizations.PONumber,
				FT.FABAuthorizations.Part,
				FT.FABAuthorizations.WeekNo,
				dateadd(wk, FT.FABAuthorizations.WeekNo, '1999-01-03'),
				FT.HighFABAuthorizations.AuthorizedAccum,
				FT.HighFABAuthorizations.ReleasePlanID,
				FT.POreceiptTotals.STDqTY,
				FT.POReceiptTotals.AccumAdjust	
				

  
   
end
GO
