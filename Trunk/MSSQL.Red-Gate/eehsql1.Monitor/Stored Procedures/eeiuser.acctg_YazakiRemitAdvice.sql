SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [eeiuser].[acctg_YazakiRemitAdvice] (@check_number int)
as

select item,  quantity, ap_items.price, left(bill_of_lading,len(bill_of_lading)-7) as bill_of_lading, invoice_cm, extended_amount  
from ap_items where vendor = 'YAZAKI' and invoice_cm in (select invoice_cm from ap_applications where pay_vendor = 'YAZAKI' and check_number = @check_number)
GO
