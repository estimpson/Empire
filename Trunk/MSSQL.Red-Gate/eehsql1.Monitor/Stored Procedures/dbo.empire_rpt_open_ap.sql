SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[empire_rpt_open_ap]
(@buy_vendor varchar(25))

as
begin
select	a.company,
		a.vendor_class,
		a.buy_vendor, 
		a.buy_vendor_name,
		a.purchase_order,
		a.document_id2 as ap_document, 
		a.document_date, 
		a.due_date, 
		a.discount_date,
		a.document_amount,
		a.currency,
		a.applied_document_amount as paid_amount,
		b.ap_check_selection,
		b.bank_account,
		b.bank_account_name,
		b.check_number,
		b.pay_amount
from EEH_EMPOWER..getapaging (getdate()) a 
left outer join Monitor.dbo.vr_ap_check_proof b on a.document_id1 = b.document_id1 and a.document_id2 = b.document_id2 and a.document_id3 = b.document_id3 
where a.document_id1 = @buy_vendor
order by a.due_date, a.document_id2

end
GO
