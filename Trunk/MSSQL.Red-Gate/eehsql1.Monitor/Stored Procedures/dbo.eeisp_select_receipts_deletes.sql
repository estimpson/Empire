SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	procedure [dbo].[eeisp_select_receipts_deletes] (@po_number varchar(25))
as
Begin
SELECT	audit_trail.date_stamp, 
		audit_trail.po_number, 
		audit_trail.vendor, 
		(CASE WHEN type = 'D' THEN (audit_trail.quantity*-1) ELSE audit_trail.quantity END) quantity, 
		audit_trail.cost, 
		audit_trail.operator, 
		audit_trail.part, 
		audit_trail.remarks, 
		audit_trail.serial, 
		audit_trail.shipper, 
		audit_trail.to_loc
FROM	dbo.audit_trail audit_trail
WHERE	((audit_trail.type='r') OR (audit_trail.type='d')) AND (audit_trail.po_number=@po_number) 
End
GO
