SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_RawQtyPerFinPart]

as
select	TopPart, ChildPart, Sum(XQty)as Quantity
		from FT.XRT
		JOIN	part on FT.XRT.TopPart = Part.part
		JOIN	part P2 on FT.XRT.ChildPart =P2.part
Where	part.type = 'F' and P2.Type = 'R'
GROUP	BY TopPart, ChildPart


GO
