SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[eeisp_clear_zero_balance_EEH_pos] (@poNumber int)

as 

Declare @rowstodelete int
select	@rowstodelete = count(1)from po_detail where po_number = @poNumber and balance<=0
Delete	po_detail
where	po_number = @poNumber and balance <= 0

Select 'Deleted ' +convert(varchar(25), @rowstodelete) + ' zero balance PO line items for PO Number ' + convert(varchar(25), convert(int,@poNumber)) 
GO
