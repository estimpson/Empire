SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwft_ActiveParts]
as

SELECT *
FROM	eeiuser.acctg_csm_excluded_base_parts CSMBaseParts
LEFT	JOIN ( SELECT	order_no AS ActiveOrderNo,
						LEFT(blanket_part,7) ActiveRevOrderBasePart,
						blanket_Part AS ActiveRevOrderPart
				FROM	dbo.order_header
				WHERE	status = 'A') ActiveOrders ON CSMBaseParts.base_part = ActiveOrders.ActiveRevOrderBasePart
LEFT	JOIN ( SELECT	LEFT(part,7) ActiveRevBasePart,
						part AS ActiveRevPart
				FROM	dbo.part_eecustom
				WHERE	CurrentRevLevel = 'Y') CurrentEECustomRev ON CSMBaseParts.base_part = CurrentEECustomRev.ActiveRevBasePart
WHERE	release_id = dbo.fn_ReturnLatestCSMRelease('CSM') AND
		include_in_Forecast = 1
GO
