SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_empire_gl_cost_transactions] AS
SELECT
	gl_cost_documents.document_id1,
	gl_cost_documents.document_id2,
	gl_cost_documents.document_id3,
	gl_cost_documents.application,
	gl_cost_documents.approved,
	gl_cost_documents.balance_name,
	gl_cost_documents.currency,
	gl_cost_documents.document_date,
	gl_cost_documents.document_exchange_rate,
	gl_cost_documents.document_source,
	gl_cost_documents.fiscal_year,
	gl_cost_documents.gl_date,
	gl_cost_documents.journal_entry,
	gl_cost_documents.ledger,
	gl_cost_documents.ledger_exchange_rate,
	gl_cost_documents.period,
	gl_cost_documents.uncommitment,
	gl_cost_documents.update_ledger_balances,
	gl_cost_documents.is_debit,
	gl_cost_documents.is_draft,
	gl_cost_documents.document_id,
	gl_cost_transactions.document_line,
	gl_cost_transactions.posting_account,
	gl_cost_transactions.cost_account,
	gl_cost_transactions.document_amount,
	gl_cost_transactions.ledger_amount,
	gl_cost_transactions.document_reference1,
	gl_cost_transactions.document_reference2,
	gl_cost_transactions.document_remarks,
	gl_cost_transactions.gl_line_type,
	gl_cost_transactions.profit_loss_posting_account,
	gl_cost_transactions.debit_credit_multiplier,
	gl_cost_transactions.document_transaction_id
FROM
	EMPOWER..gl_cost_documents INNER JOIN
	EMPOWER..gl_cost_transactions ON
		gl_cost_documents.document_type = gl_cost_transactions.document_type AND
		gl_cost_documents.document_id1 = gl_cost_transactions.document_id1 AND
		gl_cost_documents.document_id2 = gl_cost_transactions.document_id2 AND
		gl_cost_documents.document_id3 = gl_cost_transactions.document_id3 
GO
