SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	procedure [dbo].[ftsp_DeleteBadPODetail]
as
Begin
Begin Tran
Delete	po_detail
From	po_header
join	po_detail on po_header.po_number = po_detail.po_number
where	po_header.type = 'B' and po_header.blanket_part != po_detail.part_number
Commit tran
End
GO
