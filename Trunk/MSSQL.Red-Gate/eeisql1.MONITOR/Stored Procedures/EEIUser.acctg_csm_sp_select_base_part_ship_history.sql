SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_csm_sp_select_base_part_ship_history] (@base_part varchar(25))
as

-- exec eeiuser.acctg_csm_sp_select_base_part_ship_history @base_part = 'AUT0290'

select  bill_customer, 
		bill_customer_name, 
		a.ar_document, 
		a.document_type, 
		approved, 
		document_date, 
		a.payment_term, 
		due_date, 
		b.customer_po,  
		quantity, 
		unit_cost, 
		quantity*unit_cost*Multiplier as [extended_amount], 
		item, 
		item_description, 
		b.posting_account
from empower..ar_documents a join empower..ar_document_items b
on a.ar_document = b.ar_document and a.document_type = b.document_type 
where item like '%'+@Base_part+'%' 
or item_description like '%'+@Base_part+'%'
order by a.document_date

GO
