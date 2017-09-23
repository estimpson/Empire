SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrADPOPM]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing where the default PO
--	doesn't mactch the part.
select	Part = part_eecustom.part,
	Description = 'Default PO specified for part ' + part_eecustom.part + ' has a part mismatch.  ' +
	IsNull ( po_header.blanket_part, '(undefined)' )
from	dbo.part_eecustom
	join dbo.part_online on part_eecustom.part = part_online.part
	join dbo.po_header on part_online.default_po_number = po_header.po_number
where	part_eecustom.auto_releases = 'Y' and
	part_eecustom.part != IsNull ( po_header.blanket_part, '!' )
GO
