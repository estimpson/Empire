SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_EDI_Exception_NALCurrentRev]
AS

SELECT DISTINCT Parts.BasePart from	
(SELECT BasePart FROM  
(Select	left(part.part,7) Basepart,
		(select part from part p2 where p2.part = part.part) Part,
		(Select	part from part_eecustom where isNull(nullif(CurrentRevLevel,''), 'N') = 'Y' and part_eecustom.part = part.part) CurrentRev,
		(Select max(order_no) from order_header where blanket_part =  part.part) OrderNo
From	part
Where	part like 'NAL%') AllParts WHERE CurrentRev IS NULL or OrderNo IS NULL) Parts WHERE Parts.BasePart NOT IN(

SELECT BasePart from	
(SELECT BasePart FROM  
(Select	left(part.part,7) Basepart,
		(select part from part p2 where p2.part = part.part) Part,
		(Select	part from part_eecustom where isNull(nullif(CurrentRevLevel,''), 'N') = 'Y' and part_eecustom.part = part.part) CurrentRev,
		(Select max(order_no) from order_header where blanket_part =  part.part) OrderNo
From	part
Where	part like 'NAL%') AllParts WHERE CurrentRev IS NOT NULL AND OrderNo IS NOT NULL) GoodParts)
GO
