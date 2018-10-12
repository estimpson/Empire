SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[eeisp_rpt_materials_CSM_RawPart_Demand(Andre)] 
AS
BEGIN

--[dbo].[eeisp_rpt_materials_CSM_RawPart_Demand]

--Get part List to obtain best possible BOM Structure

--print 'insert #Active Part'

CREATE TABLE #ActiveTopPart (Part VARCHAR(25), PRIMARY KEY (part))
INSERT	#ActiveTopPart


SELECT	MAX(blanket_part)
FROM	 [EEISQL1].[Monitor].[dbo].order_header order_header
WHERE	status = 'A'
GROUP	BY LEFT(blanket_part,7)
UNION
SELECT	MAX(part.part)
FROM	[EEISQL1].[Monitor].[dbo].part_eecustom part_eecustom
JOIN	[EEISQL1].[Monitor].[dbo].part part ON part_eecustom.part = part.part
WHERE	ISNULL(part_eecustom.CurrentRevLevel, 'N') = 'Y' AND LEFT(part.part,7) NOT IN (SELECT	DISTINCT LEFT(blanket_part,7)
														FROM	 [EEISQL1].[Monitor].[dbo].order_header order_header
														WHERE	status = 'A')
GROUP BY LEFT(part.part,7)

--select * from #ActiveTopPart
--Get BOM for Active parts

CREATE TABLE #BOM (	BasePart VARCHAR(25),
					TopPart VARCHAR(25),
					RawPart	VARCHAR(25),
					QtyPer NUMERIC(20,6) PRIMARY KEY (TopPart, RawPart))

INSERT	#BOM
SELECT	LEFT(TopPart,7),
			TopPart,
			ChildPart,
			Quantity
FROM		[dbo].[vw_RawQtyPerFinPart] BOM
JOIN		#ActiveTopPart ATP ON BOM.TopPart = ATP.Part

--SELECT* FROM #BOM
--WHERE	BasePart = 'AUT0119'




SELECT		base_part,
			part.name,
			--FlatCSM.Program FlatProgram,
			CSMDemand.program,
			Manufacturer,
			--FlatCSM.oem,
			Badge,
			--FlatCSM.vehicle,
			Status,
			CSM_eop_display,
			Total_2014_Totaldemand AS FGDemand2014,
			Total_2015_Totaldemand AS FGDemand2015,
			Total_2016_Totaldemand AS FGDemand2016,
			Total_2017_Totaldemand AS FGDemand2017,
			Cal18_Totaldemand AS FGDemand2018,
			Cal19_Totaldemand AS FGDemand2019,
			Cal20_Totaldemand AS FGDemand2020,
			Cal21_Totaldemand AS FGDemand2021,
			RawPart,
			COALESCE(p2.Commodity, 'NoCommdityDefined') AS Commodity,
			QtyPer,
			QtyPer*Total_2014_Totaldemand RawPartDemand2014,
			QtyPer*Total_2015_Totaldemand RawPartDemand2015,
			QtyPer*Total_2016_Totaldemand RawPartDemand2016,
			QtyPer*Total_2017_Totaldemand RawPartDemand2017,
			QtyPer*Cal18_Totaldemand RawPartDemand2018,
			QtyPer*Cal19_Totaldemand RawPartDemand2019,
			QtyPer*Cal20_Totaldemand RawPartDemand2020,
			QtyPer*Cal21_Totaldemand RawPartDemand2021,
			
			material_cum*QtyPer*Total_2014_Totaldemand RawPartSpend2014,
			material_cum*QtyPer*Total_2015_Totaldemand RawPartSpend2015,
			material_cum*QtyPer*Total_2016_Totaldemand RawPartSpend2016,
			material_cum*QtyPer*Total_2017_Totaldemand RawPartSpend2017,
			material_cum*QtyPer*Cal18_Totaldemand RawPartSpend2018,
			material_cum*QtyPer*Cal19_Totaldemand RawPartSpend2019,
			material_cum*QtyPer*Cal20_Totaldemand RawPartSpend2020,
			material_cum*QtyPer*Cal21_Totaldemand RawPartSpend2021,
			default_vendor,
			standard_pack,
			ISNULL((SELECT FabAuthDays/7 FROM part_vendor WHERE vendor = default_vendor AND part = part.part),0) AS LeadTime,
			material_cum AS StandardCost,
			(CASE WHEN ISNULL((SELECT FabAuthDays/7 FROM part_vendor WHERE vendor = default_vendor AND part=part.part),0) >= 8 THEN 'Excessive Lead Time' ELSE '' END) AS LeadTimeFlag
				
INTO		#results				
FROM		[EEISQL1].[MONITOR].[EEIUser].[acctg_csm_vw_select_sales_forecast] AS CSMDemand
LEFT JOIN	#BOM BOM ON CSMDemand.base_part = BOM.BasePart
LEFT JOIN	part p2 ON BOM.RawPArt = p2.part
--LEFT JOIN	[EEISQL1].MONITOR.dbo.flatCSM	FlatCSM ON CSMDemand.base_part = FlatCSM.BasePart 
JOIN	part_online ON BOM.RawPart = Part_Online.Part
JOIN	part ON part_online.part = part.part
JOIN	part_inventory ON part_online.part = part_inventory.part
JOIN	part_standard ON part_online.part = part_standard.part

TRUNCATE TABLE 
		 FT.CSM_VendorSpend
INSERT 
	FT.CSM_VendorSpend

SELECT	*,
		(SELECT MAX(CSM_eop_display) FROM #results R2 WHERE R2.Rawpart = Results.RawPart) AS MaxCSMEOPforRawPart,
		(SELECT SUM(std_quantity) FROM object WHERE object.part = Results.RawPart) AS AllRawPartInventory,
		( SELECT MAX(hdr_terms) FROM vendors WHERE vendor = results.default_vendor) AS VendorTerms
		--(CASE WHEN  Standard_pack-(SELECT SUM(RawpartDemand2010) FROM #Results R WHERE R.RawPart = Results.Rawpart)> 0 THEN  Standard_pack-(SELECT SUM(RawpartDemand2010) FROM #Results R WHERE R.RawPart = Results.Rawpart) ELSE 0 END) AS Standard_pack_exceeds_one_month,
		--(CASE WHEN  Standard_pack-(SELECT SUM(RawpartDemand2010) FROM #Results R WHERE R.RawPart = Results.Rawpart)> 0 THEN  Standard_pack-(SELECT SUM(RawpartDemand2010) FROM #Results R WHERE R.RawPart = Results.Rawpart) ELSE 0 END) AS Standard_pack_exceeds_three_months
		
	
FROM		#results Results
ORDER BY 1,2


END















GO
