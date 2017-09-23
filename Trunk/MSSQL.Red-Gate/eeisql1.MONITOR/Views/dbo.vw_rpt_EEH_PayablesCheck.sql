SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE view [dbo].[vw_rpt_EEH_PayablesCheck] as

SELECT	vr_ap_check_proof.ap_check_selection, vr_ap_check_proof.buy_vendor,vr_ap_check_proof.document_type , vr_ap_check_proof.ap_document, 
		vr_ap_check_proof.document_amount, 
		vr_ap_check_proof.direct_deposit, 
		vr_ap_check_proof.bank_account,vr_ap_check_proof.bank_account_name, 
		document_approval_items.action_taken_by, 
		document_approval_items.approver,
		document_approval_items.action_taken_date,
		--document_approval_items.approver_comments, 
		approver_comments=case when document_approval_items.approval_sequence is NULL then 'No Variance to approve' else document_approval_items.approver_comments end,
		vr_ap_check_proof.buy_vendor_name, vr_ap_check_proof.check_number, 
		vr_ap_check_proof.company, vr_ap_check_proof.company_name,
		vr_ap_check_proof.document_date,vr_ap_check_proof.due_date, vr_ap_check_proof.begin_discount_date,vr_ap_check_proof.end_discount_date, vr_ap_check_proof.end_due_date, vr_ap_check_proof.discount_date,
		vr_ap_check_proof.group_number,is_distributed=isnull(vr_ap_check_proof.is_distributed,0) ,
		vr_ap_check_proof.multiplier, 
		approval_sequence=isnull(document_approval_items.approval_sequence,1),
		open_amount=case when isnull(document_approval_items.approval_sequence,1)=1 then vr_ap_check_proof.open_amount else 0 end,
		pay_amount=case when isnull(document_approval_items.approval_sequence,1)=1 then vr_ap_check_proof.pay_amount else 0 end,
		discount_amount=case when isnull(document_approval_items.approval_sequence,1)=1 then vr_ap_check_proof.discount_amount else 0 end,
		vr_ap_check_proof.pay_vendor, 	vr_ap_check_proof.pay_vendor_name, 
		vr_ap_check_proof.sort_order, vr_ap_check_proof.stub_number
		,VendorComments=vendors.comments,vendors.note_date,vr_ap_check_proof.currency
FROM	EEHSQL1.EEH_Empower.dbo.vr_ap_check_proof vr_ap_check_proof 
left join	 EEHSQL1.EEH_Empower.dbo.document_approval_items document_approval_items on document_approval_items.document_id1 = vr_ap_check_proof.document_id1 
		AND document_approval_items.document_id2 = vr_ap_check_proof.document_id2 
		AND document_approval_items.document_id3 = vr_ap_check_proof.document_id3 
		AND document_approval_items.document_type = vr_ap_check_proof.document_type 
left join (	select vendor,comments,note_date
			from   EEHSQL1.EEH_Empower.dbo.vendor_notes
			where  vendor_note in (
									select Max(Vendor_note)
									from   EEHSQL1.EEH_Empower.dbo.vendor_notes
									group by vendor )) vendors on vendors.vendor =vr_ap_check_proof.pay_vendor





GO
