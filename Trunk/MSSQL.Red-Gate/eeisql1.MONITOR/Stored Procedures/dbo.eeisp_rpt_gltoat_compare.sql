SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_gltoat_compare] (@fromdate datetime, @throughDate datetime, @fiscalYear int, @Period int)
as
Begin
Select	Serial,
		document_id1,
		audittrail.part,
		document_reference1,
		date_stamp,
		document_id2,
		dbDate,
		AuditTrail.quantity,
		ext_cost,
		GLCostTransactions.Quantity,
		ext_amount,
		auditTrail.type,
		document_id3
from

(select	serial, 
		audit_trail.part, 
		date_stamp, 
		quantity, 
		quantity*part_standard.material_cum as ext_cost,
		dbdate, 
		type 
from	audit_trail, part_standard 
where	audit_trail.part = part_standard.part and
		date_stamp>= @fromDate and 
		date_stamp<= dateadd(dd,1, @throughDate) and
		type = 'S' and 
		audit_trail.part<>'PALLET') AuditTrail
full Join

( select	document_id1, 
		document_id2, 
		document_id3, 
		ledger_account, 
		fiscal_year, 
		period, 
		quantity,
        amount as ext_amount,  
		document_reference1 
from	gl_cost_transactions 
where	fiscal_year = @fiscalYear and 
		period = @period and 
		document_type = 'MON INV' and 
		document_reference1<>'PALLET' and 
		document_id3 = 'S' and document_line = 1) GLCostTransactions

on		AuditTrail.serial = GLCostTransactions.document_id1 and
		auditTrail.type = GLCostTransactions.document_id3 and
		convert(datetime,AuditTrail.date_stamp, 121) =  convert(datetime,GLCostTransactions.document_id2,121)

where	(isNULL(AuditTrail.quantity, 0)-isNULL(GLCostTransactions.Quantity,0))<>0

order by 2,3 ASC

end
GO
