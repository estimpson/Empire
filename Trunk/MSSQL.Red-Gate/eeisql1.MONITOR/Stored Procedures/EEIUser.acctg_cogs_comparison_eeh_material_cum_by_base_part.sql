SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_cogs_comparison_eeh_material_cum_by_base_part '2017-02-01', '2017-02-28', '2018-02-01', '2018-02-28'


CREATE procedure [EEIUser].[acctg_cogs_comparison_eeh_material_cum_by_base_part]	
										(
											@BEG_DATE_1 DATE,					
											@END_DATE_1 DATE,
											@BEG_DATE_2 DATE,
											@END_DATE_2 DATE
										)
AS

----------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID(N'tempdb..#COGS_1') IS NOT NULL
BEGIN
	DROP TABLE #COGS_1
END

CREATE TABLE #COGS_1
	(
		 product_line VARCHAR(25)
		,shipper int
		,type VARCHAR(1)
		,customer VARCHAR(25)
		,destination VARCHAR(20)
		,date_shipped datetime
		,part_original VARCHAR(25)
		,part_type VARCHAR(1)
		,qty_packed NUMERIC(20,6)
		,boxes_staged int
		,price NUMERIC(20,6)
		,ext_price NUMERIC(20,6)
		,eei_material_cum DECIMAL(18,6)
		,ext_transfer_price decimal(18,6)
		,frozen_material_cum DECIMAL(18,6)
		,ext_frozen_material_cum DECIMAL(18,6)
		,eeh_material_cum DECIMAL(18,6)
		,ext_eeh_material_cum DECIMAL(18,6)
		,mc_Jan_18 DECIMAL(18,6)
		,ext_csm_material_cum decimal(18,6)
		,TopPart VARCHAR(25)
		,ChildPart VARCHAR(25)
		,BulbedPrice DECIMAL(18,6)
		,ext_Bulbed_Price DECIMAL(18,6)
		,UnbulbedPrice DECIMAL(18,6)
		,ext_Unbulbed_Price DECIMAL(18,6)
		,incremental_price DECIMAL(18,6)
		,ext_incremental_price DECIMAL(18,6)
		,bulbedmaterialcost DECIMAL(18,6)
		,ext_bulbed_material_cost DECIMAL(18,6)
		,unbulbedmaterialcost DECIMAL(18,6)
		,ext_unbulbed_material_cost DECIMAL(18,6) 
		,incrementalmaterialcost DECIMAL(18,6)
		,ext_incremental_material_cost DECIMAL(18,6)
	)

--------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID(N'tempdb..#COGS_2') IS NOT NULL
BEGIN
	DROP TABLE #COGS_2
END

CREATE TABLE #COGS_2
	(
		 product_line VARCHAR(25)
		,shipper int
		,type VARCHAR(1)
		,customer VARCHAR(25)
		,destination VARCHAR(20)
		,date_shipped datetime
		,part_original VARCHAR(25)
		,part_type VARCHAR(1)
		,qty_packed NUMERIC(20,6)
		,boxes_staged int
		,price NUMERIC(20,6)
		,ext_price NUMERIC(20,6)
		,eei_material_cum DECIMAL(18,6)
		,ext_transfer_price decimal(18,6)
		,frozen_material_cum DECIMAL(18,6)
		,ext_frozen_material_cum DECIMAL(18,6)
		,eeh_material_cum DECIMAL(18,6)
		,ext_eeh_material_cum DECIMAL(18,6)
		,mc_Jan_18 DECIMAL(18,6)
		,ext_csm_material_cum decimal(18,6)
		,TopPart VARCHAR(25)
		,ChildPart VARCHAR(25)
		,BulbedPrice DECIMAL(18,6)
		,ext_Bulbed_Price DECIMAL(18,6)
		,UnbulbedPrice DECIMAL(18,6)
		,ext_Unbulbed_Price DECIMAL(18,6)
		,incremental_price DECIMAL(18,6)
		,ext_incremental_price DECIMAL(18,6)
		,bulbedmaterialcost DECIMAL(18,6)
		,ext_bulbed_material_cost DECIMAL(18,6)
		,unbulbedmaterialcost DECIMAL(18,6)
		,ext_unbulbed_material_cost DECIMAL(18,6) 
		,incrementalmaterialcost DECIMAL(18,6)
		,ext_incremental_material_cost DECIMAL(18,6)
	)

----------------------------------------------------------------------------------------------------------------------


INSERT INTO #COGS_1
	EXEC EEIUSER.ACCTG_COST_OF_GOODS_SOLD @BEG_DATE_1, @END_DATE_1

INSERT INTO #COGS_2
	EXEC EEIUSER.ACCTG_COST_OF_GOODS_SOLD @BEG_DATE_2, @END_DATE_2

----------------------------------------------------------------------------------------------------------------------
SELECT 

	 ISNULL(a.product_line,b.product_line) AS product_line
	,a.product_line
	,b.product_line
	
	,ISNULL(a.base_part,b.base_part)
	--,ISNULL(a.customer,b.customer) AS customer

	,a.qty_packed AS prior_qty_packed
	,b.qty_packed AS current_qty_packed

	,ISNULL(a.selling_price,b.selling_price) AS prior_selling_price
	,b.selling_price AS current_selling_price	

	,a.ext_selling_price AS prior_ext_selling_price
	,b.ext_selling_price AS current_ext_selling_price	
	
	,ISNULL((CASE WHEN a.product_line IN ('BULBED ES3 COMPONENTS','BULBED WIRE HARN - EEH') THEN a.frozen_material_cum ELSE a.eeh_material_cum END),(CASE WHEN b.product_line IN ('BULBED ES3 COMPONENTS','BULBED WIRE HARN - EEH') THEN b.frozen_material_cum ELSE b.eeh_material_cum END)) AS prior_eeh_material_cum
	,(CASE WHEN b.product_line IN ('BULBED ES3 COMPONENTS','BULBED WIRE HARN - EEH') THEN b.frozen_material_cum ELSE b.eeh_material_cum END) AS current_eeh_material_cum	
	
	,(CASE WHEN a.product_line IN ('BULBED ES3 COMPONENTS','BULBED WIRE HARN - EEH') THEN a.ext_frozen_material_cum ELSE a.ext_eeh_material_cum END) AS prior_ext_eeh_material_cum
	,(CASE WHEN b.product_line IN ('BULBED ES3 COMPONENTS','BULBED WIRE HARN - EEH') THEN b.ext_frozen_material_cum ELSE b.ext_eeh_material_cum END) AS current_ext_eeh_material_cum
		
	,a.csm_material_cum AS prior_csm_material_cum
	,b.csm_material_cum AS current_csm_material_cum	

	,a.ext_csm_material_cum AS prior_ext_csm_material_cum
	,b.ext_csm_material_cum AS current_ext_csm_material_cum
	
FROM 
	(	SELECT 

				 product_line
				,LEFT(part_original,7) AS base_part
				,RIGHT(LEFT(part_original,PATINDEX ('%-%' , part_original)+1),1) as base_part_type
				--,customer
				,SUM(qty_packed) AS qty_packed
				,SUM(boxes_staged) AS boxes_staged
				,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_price)/SUM(qty_packed) END) AS selling_price
				,SUM(ext_price) AS ext_selling_price
				,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_transfer_price)/SUM(qty_packed) END) AS transfer_price
				,SUM(ext_transfer_price) AS ext_transfer_price
				,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_frozen_material_cum)/SUM(qty_packed) END) AS frozen_material_cum
				,SUM(ext_frozen_material_cum) AS ext_frozen_material_cum
				,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_eeh_material_cum)/SUM(qty_packed) END) AS eeh_material_cum
				,SUM(ext_eeh_material_cum) AS ext_eeh_material_cum
				,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_csm_material_cum)/SUM(qty_packed) END) AS csm_material_cum 
				,SUM(ext_csm_material_cum) AS ext_csm_material_cum

		FROM	#COGS_1
		GROUP BY product_line
				,LEFT(part_original,7)
				,RIGHT(LEFT(part_original,PATINDEX ('%-%' , part_original)+1),1) 
				--, customer 
	)a

FULL OUTER JOIN

	(	SELECT 

			 product_line
			,LEFT(part_original,7) AS base_part
			,RIGHT(LEFT(part_original,PATINDEX ('%-%' , part_original)+1),1) as base_part_type
			--,customer
			,SUM(qty_packed) AS qty_packed
			,SUM(boxes_staged) AS boxes_staged
			,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_price)/SUM(qty_packed) END) AS selling_price
			,SUM(ext_price) AS ext_selling_price
			,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_transfer_price)/SUM(qty_packed) END) AS transfer_price
			,SUM(ext_transfer_price) AS ext_transfer_price
			,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_frozen_material_cum)/SUM(qty_packed) END) AS frozen_material_cum
			,SUM(ext_frozen_material_cum) AS ext_frozen_material_cum
			,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_eeh_material_cum)/SUM(qty_packed) END) AS eeh_material_cum
			,SUM(ext_eeh_material_cum) AS ext_eeh_material_cum
			,(CASE WHEN ISNULL(SUM(qty_packed),0)=0 THEN 0 ELSE SUM(ext_csm_material_cum)/SUM(qty_packed) END) AS csm_material_cum 
			,SUM(ext_csm_material_cum) AS ext_csm_material_cum

		FROM	#COGS_2
		GROUP BY product_line
				,LEFT(part_original,7)
				,RIGHT(LEFT(part_original,PATINDEX ('%-%' , part_original)+1),1)
				--,customer 
	)b

ON a.base_part = b.base_part AND ISNULL(a.product_line,b.product_line)=ISNULL(b.product_line,a.product_line)

GO
