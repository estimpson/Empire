SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_empower_QH_ApprovalFlow]
as
SELECT        requisitions.document_type, requisitions.requisition, requisitions.requester, requisitions.requested_by, requisitions.buy_unit, requisitions.document_date, requisitions.gl_date, 
                         gl_cost_documents.created_date AS requisition_created_date_time, requisitions.requisition_reason, requisitions.document_amount, document_approvals.approved, document_approvals.canceled, 
                         document_approval_items.approval_sequence, document_approval_items.approver, document_approval_items.action_taken_by, document_approval_items.action_taken_date, 
                         document_approval_items.changed_date AS action_taken_date_time, document_approval_items.approved AS approver_approved, document_approval_items.canceled AS approver_canceled, 
                         document_approval_items.approver_comments, CASE WHEN (requester_names.first_name IS NULL OR
                         requester_names.first_name = '') THEN requester_names.last_name ELSE requester_names.first_name + ' ' + requester_names.last_name END AS requester_name, CASE WHEN (user_names.first_name IS NULL OR
                         user_names.first_name = '') THEN user_names.last_name ELSE user_names.first_name + ' ' + user_names.last_name END AS approver_name, CASE WHEN (action_taken_by.first_name IS NULL OR
                         action_taken_by.first_name = '') THEN action_taken_by.last_name ELSE action_taken_by.first_name + ' ' + action_taken_by.last_name END AS action_taken_by_name, document_types.document_type_description, 
                         requisitions.currency, currencies.currency_symbol, currencies.currency_culture
FROM            requisitions INNER JOIN
                         document_types ON requisitions.document_type = document_types.document_type INNER JOIN
                         currencies ON requisitions.currency = currencies.currency INNER JOIN
                         document_approvals ON requisitions.document_type = document_approvals.document_type AND requisitions.document_id1 = document_approvals.document_id1 AND 
                         requisitions.document_id2 = document_approvals.document_id2 AND requisitions.document_id3 = document_approvals.document_id3 INNER JOIN
                         document_approval_items ON document_approvals.document_type = document_approval_items.document_type AND document_approvals.document_id1 = document_approval_items.document_id1 AND 
                         document_approvals.document_id2 = document_approval_items.document_id2 AND document_approvals.document_id3 = document_approval_items.document_id3 INNER JOIN
                         gl_cost_documents ON requisitions.document_type = gl_cost_documents.document_type AND requisitions.document_id1 = gl_cost_documents.document_id1 AND 
                         requisitions.document_id2 = gl_cost_documents.document_id2 AND requisitions.document_id3 = gl_cost_documents.document_id3 INNER JOIN
                         user_names AS requester_names ON requester_names.user_name = requisitions.requester LEFT OUTER JOIN
                         user_names ON document_approval_items.approver = user_names.user_name LEFT OUTER JOIN
                         user_names AS action_taken_by ON action_taken_by.user_name = document_approval_items.action_taken_by
WHERE        (gl_cost_documents.created_date >= '2018-01-01')



GO
