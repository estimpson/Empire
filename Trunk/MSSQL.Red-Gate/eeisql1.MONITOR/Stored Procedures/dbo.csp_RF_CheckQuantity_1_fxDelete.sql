SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[csp_RF_CheckQuantity_1_fxDelete](@PONumber integer,@PartNumber varchar(25),@Quantity decimal(20,6),@Objects integer,@NextDueAmount decimal(20,6) output,@NextDueDate varchar(20) output,@Result integer output)
/*
Arguments:
@PONumber	The po number to check the accum against.
@PartNumber	The partnumber to use in the check.
@Quantity	The quantity to check.
@Objects	The number of objects.
@NextDueAmount	The next amount due when the accum is already met.
@NextDueDate	The date for above amount.
@Result		Output result.

Result set:
None

Return values:
0	Quantity is valid.
-1	Quantity trying to be received is greater than the balance on the po
-2	The quantity being received exceeds the po and authorized accum.

Description:

Example:

Author:
Chris Rogers
Copyright c 2005 Fore-Thought, LLC

Process:
*/
as /*	I.	Declarations*/
declare @Balance decimal(20,6),
@AuthAccum decimal(20,6),
@CurrentAccum decimal(20,6),
@ReceiptPeriodID integer,
@PeriodEndDT datetime
/*	II.	Initializations*/
select @Result=0,
  @Quantity=IsNull(@Quantity,0),
  @Objects=IsNull(@Objects,1)
/*	III.	Check if quantity is > the balance left for the week*/
/* Added one week so check is for requirement this week or next week Andre S. Boulanger 7/21/2005*/
if @Quantity*@Objects
  >IsNull((select Sum(IsNull(balance,0))
    from po_detail
    where po_number=@PONumber
    and part_number=@PartNumber
    and date_due between dateadd(dd,-7,(getdate()-datepart(dw,getdate())+1)) and dateadd(dd,7,(getdate()+(7-datepart(dw,getdate()))))),0)
  begin
    /*		A.	Execute the Record receipts procedure to make sure we*/
    /*			are working with an accurate accum.*/
    execute FT.csp_RecordReceipts @ReceiptPeriodID,@PeriodEndDT,0
    /*		B.	Check receipt against the authorized accum for the week.*/
    if @Quantity
      +IsNull((select StdQty
        from FT.POReceiptTotals
        where PONumber=@PONumber
        and Part=@PartNumber),0)
      >IsNull((select max(PostAccum)
        from ft.releaseplanraw as rpr left outer join
        FT.DTGlobals as dtg on dtg.name='BaseWeek' join
        po_header as poh on poh.po_number=@PONumber join
        part_vendor as pv on pv.part=rpr.part
        and pv.vendor=poh.vendor_code
        where rpr.ponumber=@PONumber
        and rpr.Part=@PartNumber
        and rpr.DueDT between dateadd(dd,-7,(getdate()-datepart(dw,getdate())+1))-(convert(integer,(pv.ReceiptAuthDays/7))) and dateadd(dd,7,(getdate()+(7-datepart(dw,getdate()))))
        and rpr.releaseplanid
        =any(select id
          from ft.releaseplans as rp
          where generatedweekno between datediff(wk,convert(datetime,Value),getdate())-(convert(integer,(pv.ReceiptAuthDays/7))) and datediff(wk,convert(datetime,Value),getdate()))),0)
      /*----		Commented by Andre S. Boulanger  Needs to Check Higest Accum Generated for Current Week inside Vendor Lead Time*/
      /*IsNull ( (	select	max(AuthorizedAccum)       Changed to select highest authorizedaccum from fabauthorizations for current week Andre S. Boulanger
      from	FT.FabAuthorizations
      where	PONumber = @PONumber and
      Part = @PartNumber and
      WeekNo <= 
      (	SELECT	datediff(wk,convert(datetime,Value),getdate()) 
      FROM	FT.DTGlobals
      where	name = 'BaseWeek' ) ), 0 )*/
      begin
        select @Result=-2
      end
    else
      begin
        /*			i.	Get the next due date and amount for return.*/
        select @NextDueAmount=po_detail.balance,
          @NextDueDate=po_detail.date_due
          from po_detail
          where po_number=@PONumber
          and part_number=@PartNumber
          and date_due
          =(select min(date_due)
            from po_detail
            where po_number=@PONumber
            and part_number=@PartNumber)
        select @NextDueAmount=IsNull(@NextDueAmount,0),
          @NextDueDate=IsNull(@NextDueDate,'')
        select @Result=-1
      end
  end
return @Result

GO
