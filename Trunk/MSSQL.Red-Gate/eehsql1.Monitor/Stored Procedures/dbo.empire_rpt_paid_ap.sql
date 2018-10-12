SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[empire_rpt_paid_ap]
(@buy_vendor varchar(25))

as
begin
select	--a.company,
		--a.vendor_class,
		b.buy_vendor, 
		b.buy_vendor_name,
		--a.purchase_order,
		b.ap_document, 
		b.document_date, 
		b.due_date, 
		--a.discount_date,
		b.document_amount,
		--a.currency,
		--a.applied_document_amount as paid_amount,
		b.ap_check_selection,
		b.bank_account,
		b.bank_account_name,
		b.check_number,
		b.pay_amount
from Monitor.dbo.vr_ap_check_proof b 
where b.document_id1 = @buy_vendor
and isnull(b.check_number,'') <> ''
order by b.due_date desc, b.document_id2 asc

end



GO
