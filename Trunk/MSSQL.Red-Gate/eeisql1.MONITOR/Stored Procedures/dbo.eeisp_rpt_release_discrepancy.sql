SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:	cad
-- Create date: 3/31/2010
-- Description:	Calculate percent increase or decrease of current release qty
-- =============================================
CREATE PROCEDURE [dbo].[eeisp_rpt_release_discrepancy]
	
AS
BEGIN

-- Create temp table to hold order_detail and m_in_release_plan data
DECLARE @tempReleaseQty TABLE (customerPart varchar(35), onOrderQty dec(20,6), onEDIQty dec(20,6), week int)  
DECLARE @week int

SET @week = 1
WHILE (@week <17)
BEGIN
	INSERT	@tempReleaseQty (customerPart, onEDIQty, onOrderQty, week)
	SELECT	mirp.customer_part, mirp.quantity, od.std_qty, @week
	FROM	dbo.m_in_release_plan_copy mirp
		left join dbo.edi_setups es on mirp.shipto_id = es.destination
		join dbo.order_header oh on
			mirp.shipto_id = oh.destination and
			(mirp.customer_part = oh.customer_part or
			 mirp.customer_part = oh.new_customer_part) and
			(	coalesce (es.check_model_year, 'N') != 'Y' or
				mirp.model_year = oh.model_year) and
			(	coalesce (es.check_po, 'N') != 'Y' or
				mirp.customer_po = oh.customer_po)
		join dbo.order_detail od on
			od.order_no = oh.order_no 
	WHERE	mirp.release_dt >= getdate() and 
		mirp.release_dt <= dateadd(wk,@week,getdate()) 

	SET @week = @week + 1
END


-- Create a temp table for data output, grouping rows by part, and creating week column groups
DECLARE @tempSummary TABLE (customerPart varchar(35), 
	Week1Order dec(20,6), Week1EDI dec(20,6), Week1Disc dec(20,6),
	Week2Order dec(20,6), Week2EDI dec(20,6), Week2Disc dec(20,6),
	Week3Order dec(20,6), Week3EDI dec(20,6), Week3Disc dec(20,6),
	Week4Order dec(20,6), Week4EDI dec(20,6), Week4Disc dec(20,6),
	Week5Order dec(20,6), Week5EDI dec(20,6), Week5Disc dec(20,6),
	Week6Order dec(20,6), Week6EDI dec(20,6), Week6Disc dec(20,6),
	Week7Order dec(20,6), Week7EDI dec(20,6), Week7Disc dec(20,6),
	Week8Order dec(20,6), Week8EDI dec(20,6), Week8Disc dec(20,6),
	Week9Order dec(20,6), Week9EDI dec(20,6), Week9Disc dec(20,6),
	Week10Order dec(20,6), Week10EDI dec(20,6), Week10Disc dec(20,6),
	Week11Order dec(20,6), Week11EDI dec(20,6), Week11Disc dec(20,6),
	Week12Order dec(20,6), Week12EDI dec(20,6), Week12Disc dec(20,6),
	Week13Order dec(20,6), Week13EDI dec(20,6), Week13Disc dec(20,6),
	Week14Order dec(20,6), Week14EDI dec(20,6), Week14Disc dec(20,6),
	Week15Order dec(20,6), Week15EDI dec(20,6), Week15Disc dec(20,6),
	Week16Order dec(20,6), Week16EDI dec(20,6), Week16Disc dec(20,6))

INSERT	@tempSummary (customerPart, 
	Week1Order, Week1EDI, Week2Order, Week2EDI,
	Week3Order, Week3EDI, Week4Order, Week4EDI,
	Week5Order, Week5EDI, Week6Order, Week6EDI,
	Week7Order, Week7EDI, Week8Order, Week8EDI,
	Week9Order, Week9EDI, Week10Order, Week10EDI,
	Week11Order, Week11EDI, Week12Order, Week12EDI,
	Week13Order, Week13EDI, Week14Order, Week14EDI,
	Week15Order, Week15EDI, Week16Order, Week16EDI)
SELECT	customerPart, 
	Week1Order = sum(case when week = 1 then onOrderQty end), Week1EDI = sum(case when week = 1 then onEDIQty end),	
	Week2Order = sum(case when week = 2 then onOrderQty end), Week2EDI = sum(case when week = 2 then onEDIQty end),
	Week3Order = sum(case when week = 3 then onOrderQty end), Week3EDI = sum(case when week = 3 then onEDIQty end),
	Week4Order = sum(case when week = 4 then onOrderQty end), Week4EDI = sum(case when week = 4 then onEDIQty end),
	Week5Order = sum(case when week = 5 then onOrderQty end), Week5EDI = sum(case when week = 5 then onEDIQty end),
	Week6Order = sum(case when week = 6 then onOrderQty end), Week6EDI = sum(case when week = 6 then onEDIQty end),
	Week7Order = sum(case when week = 7 then onOrderQty end), Week7EDI = sum(case when week = 7 then onEDIQty end),
	Week8Order = sum(case when week = 8 then onOrderQty end), Week8EDI = sum(case when week = 8 then onEDIQty end),
	Week9Order = sum(case when week = 9 then onOrderQty end), Week9EDI = sum(case when week = 9 then onEDIQty end),
	Week10Order = sum(case when week = 10 then onOrderQty end), Week10EDI = sum(case when week = 10 then onEDIQty end),
	Week11Order = sum(case when week = 11 then onOrderQty end), Week11EDI = sum(case when week = 11 then onEDIQty end),
	Week12Order = sum(case when week = 12 then onOrderQty end), Week12EDI = sum(case when week = 12 then onEDIQty end),
	Week13Order = sum(case when week = 13 then onOrderQty end), Week13EDI = sum(case when week = 13 then onEDIQty end),
	Week14Order = sum(case when week = 14 then onOrderQty end), Week14EDI = sum(case when week = 14 then onEDIQty end),
	Week15Order = sum(case when week = 15 then onOrderQty end), Week15EDI = sum(case when week = 15 then onEDIQty end),
	Week16Order = sum(case when week = 16 then onOrderQty end), Week16EDI = sum(case when week = 16 then onEDIQty end)
FROM	@tempReleaseQty
GROUP BY customerPart

	
-- Update the temp table with a discrepancy calculation
UPDATE @tempSummary 
SET	Week1Disc = (case when Week1Order > 0 then ((Week1EDI - Week1Order)/Week1Order) else null end),
	Week2Disc = (case when Week2Order > 0 then ((Week2EDI - Week2Order)/Week2Order) else null end),
	Week3Disc = (case when Week3Order > 0 then ((Week3EDI - Week3Order)/Week3Order) else null end),
	Week4Disc = (case when Week4Order > 0 then ((Week4EDI - Week4Order)/Week4Order) else null end),
	Week5Disc = (case when Week5Order > 0 then ((Week5EDI - Week5Order)/Week5Order) else null end),
	Week6Disc = (case when Week6Order > 0 then ((Week6EDI - Week6Order)/Week6Order) else null end),
	Week7Disc = (case when Week7Order > 0 then ((Week7EDI - Week7Order)/Week7Order) else null end),
	Week8Disc = (case when Week8Order > 0 then ((Week8EDI - Week8Order)/Week8Order) else null end),
	Week9Disc = (case when Week9Order > 0 then ((Week9EDI - Week9Order)/Week9Order) else null end),
	Week10Disc = (case when Week10Order > 0 then ((Week10EDI - Week10Order)/Week10Order) else null end),
	Week11Disc = (case when Week11Order > 0 then ((Week11EDI - Week11Order)/Week11Order) else null end),
	Week12Disc = (case when Week12Order > 0 then ((Week12EDI - Week12Order)/Week12Order) else null end),
	Week13Disc = (case when Week13Order > 0 then ((Week13EDI - Week13Order)/Week13Order) else null end),
	Week14Disc = (case when Week14Order > 0 then ((Week14EDI - Week14Order)/Week14Order) else null end),
	Week15Disc = (case when Week15Order > 0 then ((Week15EDI - Week15Order)/Week15Order) else null end),
	Week16Disc = (case when Week16Order > 0 then ((Week16EDI - Week16Order)/Week16Order) else null end)



SELECT * FROM @tempSummary


		
END
GO
