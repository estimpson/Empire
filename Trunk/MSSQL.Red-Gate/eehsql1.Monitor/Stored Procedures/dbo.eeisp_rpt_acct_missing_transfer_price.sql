SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	procedure [dbo].[eeisp_rpt_acct_missing_transfer_price] (@DateStamp datetime, @DateStamp2 datetime)
as
begin
--	 eeisp_rpt_acct_missing_transfer_price '2008-10-01', '2008-10-31'
Select	ar_headers.document,
		ar_headers.document_date,
		Item, 
		item_price, 
		ar_items.ledger_account_code,
		ar_items.quantity,
		ar_headers.changed_date
from		ar_headers 
join		ar_items  on ar_headers.document = ar_items.document 
where	item_price !> 0 and ar_headers.changed_date >= @DateStamp and ar_headers.changed_date< dateadd(dd,1,  @DateStamp2)
End
GO
