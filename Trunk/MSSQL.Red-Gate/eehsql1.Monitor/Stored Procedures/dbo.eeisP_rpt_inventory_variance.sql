SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisP_rpt_inventory_variance] (@TRANTYPE1 char(1), @part varchar(25), @evaluationdate datetime, @glAccount varchar(25))

as

begin


select	glcostship.document_reference1,
			glcostship.quantity,
			glcostjc.quantity,		
			glcostship.document_id1,
			glcostjc.document_id1,			
			glcostship.ledger_account,
			glcostjc.ledger_account,
			glcostship.document_type,
			glcostjc.document_type,
			glcostship.document_id3,
			glcostjc.document_id3,
			glcostship.transaction_date,
			glcostjc.transaction_date,
			glcostship.amount,
			glcostjc.amount
					
			
from		gl_cost_transactions as glcostship,
			gl_cost_transactions as glcostjc
where	glcostSHIP.document_type = 'MON INV' and
			glcostSHIP.ledger_account = @glAccount and
			glcostship.ledger_account *= glcostjc.ledger_account and
			glcostship.document_id1 *= glcostjc.document_id1 and
			glcostship.document_reference1 *= glcostjc.document_reference1 AND
			glcostship.document_id3 = @TRANTYPE1  and
			glcostJC.document_id3 <> @TRANTYPE1  and
			glcostship.document_reference1 = @PART AND
			glcostship.TRANSACTION_DATE>= @evaluationdate AND
			(abs(isNULL(glcostship.amount,0))-abs(isNULL(glcostjc.amount,0))) <> 0

end
GO
