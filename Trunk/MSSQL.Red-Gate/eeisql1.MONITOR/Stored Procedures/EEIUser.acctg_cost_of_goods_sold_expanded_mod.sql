SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_cost_of_goods_sold_expanded_mod @period=6, @fiscal_year='2019'

CREATE PROC [EEIUser].[acctg_cost_of_goods_sold_expanded_mod] (@fiscal_year VARCHAR(4), @period VARCHAR(2) )

AS
BEGIN

-- declare @period varchar(2);
 --declare @fiscal_year varchar(4);
 --declare @beg_date datetime;
 --declare @end_date datetime;
 --select @period = 8;
 --select @fiscal_year = '2014';
 --select @beg_date = '2014-08-01'
 --select @end_date = '2014-08-31'


 declare @beg_date datetime;
 declare @end_date datetime;
 select @beg_date = @fiscal_year+'-'+@period+'-01'
 select @end_date = dateadd(m,1,@beg_date)

 --select @beg_date

--1. Get EEH Material Costs

declare @eeh_costs table (
part varchar(25),
material_cum decimal(20,6)
)
insert into @eeh_costs
 SELECT		eeh_new_part_standard.part,
			eeh_new_part_standard.material_cum 
 FROM		EEHSQL1.HistoricalData.dbo.part_standard_historical_daily eeh_new_part_standard
 WHERE		eeh_new_part_standard.period = @period 
		AND eeh_new_part_standard.fiscal_year = @fiscal_year 
		AND eeh_new_part_standard.reason='MONTH END'


--2. Get SPI Material Costs

declare @spi_costs table (
part varchar(25),
price decimal(20,6),
material_cum decimal(20,6),
labor_cum decimal(20,6),
burden_cum decimal(20,6),
cost_cum decimal(20,6),
interco_profit decimal(20,6)
)
insert into @spi_costs
 SELECT		spi_costs.part,
			spi_costs.price_cum,
			spi_costs.material_cum,
			spi_costs.labor_cum,
			spi_costs.burden_cum,
			spi_costs.cost_cum,
			isnull(spi_costs.price_cum,0) - isnull(spi_costs.cost_cum,0) as interco_profit
 FROM		[EEHREPORT1].monitor.dbo.part_standard_spi spi_costs


--3. Get EEC Material Costs

declare @eec_costs table (
part varchar(25),
price decimal(20,6),
material_cum decimal(20,6),
labor_cum decimal(20,6),
burden_cum decimal(20,6),
cost_cum decimal(20,6),
interco_profit decimal(20,6)
)
insert into @eec_costs
 SELECT		eec_costs.part,
			eec_costs.price_cum,
			eec_costs.material_cum,
			eec_costs.labor_cum,
			eec_costs.burden_cum,
			eec_costs.cost_cum,
			isnull(eec_costs.price_cum,0) - isnull(eec_costs.cost_cum,0) as interco_profit
 FROM		[EEHREPORT1].monitor.dbo.part_standard_eec eec_costs

 
 -- 4. Get EEH Labor Costs

--declare @eeh_labor table (
--part varchar(25),
--std_hours numeric(20,6)
--)

----insert into @eeh_labor
---- select part
----		  ,round(std_hours,6)
----		  ,round(quoted_bom_cost,6) 
----from	  eehsql1.monitor.dbo.part_eecustom

--insert into @eeh_labor
-- select		Part
--			,Std_Hrs = TiempoEstandar 
-- from		eehsql1.monitor.dbo.part_times

 
-- 5. Get EEI Labor Costs

declare @eei_labor table (
part varchar(25),
std_hours numeric(20,6),
quoted_bom_cost numeric(20,6)
)
insert into @eei_labor
select part, round(std_hours,6), round(quoted_bom_cost,6) from part_eecustom


--6. GET EEI Quote Detail

declare @quote_log table (
		 WO_EngineerID int
	    ,WO_Part varchar(25)
	    ,WO_QuoteNumber varchar(50)
		,QL_QuoteNumber varchar(50)
		,QL_CustomerQuoteDate datetime
		,QL_EEIPartNumber varchar(50)
		,QL_ProductionPrice decimal(20,4)
		,QL_PrototypePrice decimal(20,4)
		,QL_TransferPrice decimal(20,4)
		,QL_eau decimal(20,0)
		,QL_functionname varchar(50)
		,QL_notes varchar(max)
		,QL_straightmaterialcost decimal(20,6)
		,QL_awarded char(3)
		,QL_stdhours decimal(20,4)
)

insert @quote_log
SELECT	 WO.WOEngineerID
	    ,WO.Part
	    ,WO.QuoteNumber
		,q.QuoteNumber
		,q.CustomerQuoteDate
		,q.EEIPartNumber
		,round(q.quoteprice,4) as QL_ProductionPrice
		,round(q.prototypeprice,4) as QL_PrototypePrice
		,round(Q.QuotePrice*.83,2) as QL_TransferPrice
		,q.eau
		,q.functionname
		,q.notes
		,q.straightmaterialcost
		,q.awarded
		,q.stdhours

FROM eehsql1.eeh.dbo.ENG_WOEngineer WO 
	LEFT JOIN eeiuser.qt_quotelog Q on	WO.QuoteNumber = Q.QuoteNumber 

where wo.woengineerid in (select max(woengineerid) from eehsql1.eeh.dbo.eng_woengineer group by part)


--7.  Get COGS info for month

declare @shipments table
(
customer varchar(25)
,part_original varchar(25)
,qty_packed decimal(18,6)
,price decimal(18,6)
,ext_price decimal(18,6)
)

insert into @shipments
 SELECT		s.customer
			,sd.part_original
			,sum(isnull(sd.qty_packed,0)) as qty_packed
			,avg(isnull(sd.price,0)) as price
			,sum(isnull(sd.qty_packed,0)*isnull(sd.price,0)) as ext_price
 from shipper s 
	join shipper_detail sd on s.id = sd.shipper

  WHERE	s.destination <> 'EMPHOND' 
		AND (s.date_shipped>=@beg_date AND s.date_shipped<@end_date)
		AND isnull(sd.qty_packed,0) <> 0
 
 group by s.customer, sd.part_original
 
 
 --8.  Get total table

SELECT 

			 @fiscal_year 
			,@period		
			,shipments.customer
			,bpa.parent_customer
			,shipments.part_original 
			
			,eeip.product_line			
			,bpa.empire_market_segment
			,bpa.empire_market_subsegment			
			
			,CSM.oem
			,CSM.program
			,CSM.vehicle			
						 			
			,shipments.qty_packed 
			
			,shipments.price
			,shipments.ext_price
			
			,eeips.material_cum AS transfer_price
			,ISNULL(shipments.qty_packed,0)*ISNULL(eeips.material_cum,0) AS ext_transfer_price
			
			,eeips.frozen_material_cum AS absorbed_material_cum
			,ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0) AS ext_absorbed_material_cum
			
			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN eeips.material_cum ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum ELSE eehps.material_cum END)END) AS eeh_material_cum
			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.material_cum,0) ELSE(CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0) ELSE ISNULL(shipments.qty_packed,0)*ISNULL(eehps.material_cum,0) END) END) AS ext_eeh_material_cum
			,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COPMONENTS') THEN eeips.material_cum/shipments.price ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE eehps.material_cum/shipments.price END) END)END) AS current_material_cost_percentage

			,isnull(spips.interco_profit,0) as spi_interco_profit

			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN eeips.material_cum											ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum											ELSE								(isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)) END) END) AS consolidated_material_cum
			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.material_cum,0) ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0)	ELSE ISNULL(shipments.qty_packed,0)*(ISNULL(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)) END) END) AS ext_consolidated_material_cum
			,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COPMONENTS') THEN isnull(eeips.material_cum,0)/shipments.price ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE (isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0))/shipments.price END) END)END) AS consolidated_material_cost_percentage
	
			,isnull(eecps.interco_profit,0) as eec_interco_profit

				-- DW 7/23/2019  changed the definition of consolidated material_cost to exclude SPI labor and SPI burden because Ken wants to see these separately broken out.	
			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN eeips.material_cum											ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum											ELSE								(isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END) AS total_co_material_cum
			,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.material_cum,0) ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0)	ELSE ISNULL(shipments.qty_packed,0)*(ISNULL(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END) AS ext_total_co_material_cum
			,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COPMONENTS') THEN isnull(eeips.material_cum,0)/shipments.price ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE (isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0))/shipments.price END) END)END) AS total_co_material_cost_percentage
			
			,(CASE WHEN ISNULL(eeilc.std_hours,0)=0 THEN 'Standard Hours not input into Monitor' ELSE 'Monitor contains Standard Hour Information' END) AS std_hour_error
			,eeilc.std_hours			
			,2.07 AS std_labor_rate
			-- DW 7/24/19: using the quoted std hours instead of Monitor due to gross errors in Monitor
			--,ISNULL(eeilc.std_hours,0)*2.07 AS std_labor_cost
			,ISNULL(QL_stdhours,0)*2.07 as std_labor_cost

			--,ISNULL(shipments.qty_packed,0)*ISNULL(eeilc.std_hours,0)*2.07 AS ext_std_labor_cost
			,ISNULL(shipments.qty_packed,0)*ISNULL(QL_stdhours,0)*2.07 AS ext_std_labor_cost
			--,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE ((ISNULL(shipments.qty_packed,0)*ISNULL(eeilc.std_hours,0)*2.07))/shipments.ext_price END) AS std_labor_cost_percentage

			,((shipments.price)
				-(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(eeips.material_cum,0) ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(eeips.frozen_material_cum,0)	ELSE (ISNULL(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END)
				-(ISNULL(QL_stdhours,0)*2.07)) AS CAML


			,((shipments.ext_price)
				-(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.material_cum,0) ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0)	ELSE ISNULL(shipments.qty_packed,0)*(ISNULL(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END)
				-(ISNULL(shipments.qty_packed,0)*ISNULL(QL_stdhours,0)*2.07)) AS ext_CAML
			
		,'------'
		,'------'
		,(CASE WHEN ISNULL(WO_EngineerID,'')='' THEN 'NJB/ECN not input into Monitor' ELSE 'Monitor contains NJB/ECN Information' END) AS nbj_ecn_error
		,WO_EngineerID
		,(CASE WHEN ISNULL(WO_QuoteNumber,'')='' THEN 'Quote Number not input into NJB/ECN' ELSE 'NJB/ECN contains Quote Number' END) AS njb_ecn_quotenumber_error	    
		,WO_QuoteNumber
		,(CASE WHEN ISNULL(QL_QuoteNumber,'')='' THEN 'Quote Number input into NJB/ECN does not exist in QuoteLog' ELSE 'QuoteLog contains Quote Number' END) AS quote_log_error
		,QL_QuoteNumber
		,QL_CustomerQuoteDate 
		,QL_awarded 
		,QL_ProductionPrice	
		,QL_PrototypePrice 
		,QL_eau 
		,QL_functionname 
		,QL_notes
		,'------'
		,'------'
		,shipments.price	
		,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN eeips.material_cum ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum ELSE eehps.material_cum END)END) AS eeh_material_cost	
		--,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE eehps.material_cum/shipments.price END) END) AS current_material_cost_percentage		
		,'------'
		,QL_ProductionPrice	
		,QL_straightmaterialcost
		--,(CASE WHEN ISNULL(QL_productionprice,0)=0 THEN 0 ELSE QL_straightMaterialcost/QL_ProductionPrice END) AS quote_material_cost_percentage
		,'------'
		--,-(CASE WHEN ISNULL(QL_productionprice,0)=0 THEN 0 ELSE QL_straightMaterialcost/QL_ProductionPrice END)+(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE eehps.material_cum/shipments.price END) END) AS material_cost_percentage_variance
		,'------'				
		,ISNULL(shipments.qty_packed,0)*QL_ProductionPrice AS Ext_QL_Production_price		
		,ISNULL(shipments.qty_packed,0)*QL_StraightMaterialCost AS EXT_QL_StraightMaterialCost
		,ISNULL(shipments.qty_packed,0)*QL_stdhours*1.00 AS EXT_QL_StandardLaborCost
		,'------'
		,QL_straightmaterialcost
		,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN eeips.material_cum ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum ELSE eehps.material_cum END)END) AS eeh_material_cost
		,-QL_straightmaterialcost+(CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum ELSE eehps.material_cum END) AS quoted_vs_actual_material_cost_variance
		,'------'
		,QL_stdhours AS QL_std_hours
		,eeilc.std_hours AS EEI_std_hours
		,-QL_stdhours+eeilc.std_hours AS quoted_vs_eeh_std_labor_hours_variance

		,spips.price as spi_price
		,spips.material_cum as spi_material_cum
		,spips.labor_cum as spi_labor_cum
		,spips.burden_cum as spi_burden_cum
		,spips.cost_cum as spi_cost_cum
		,spips.interco_profit as spi_interco_profit

		,ISNULL(shipments.qty_packed,0)*SPIps.price as SPI_ext_price
		,ISNULL(shipments.qty_packed,0)*SPIps.material_cum as SPI_ext_material_cum
		,ISNULL(shipments.qty_packed,0)*SPIps.labor_cum as SPI_ext_labor_cum
		,ISNULL(shipments.qty_packed,0)*SPIps.burden_cum as SPI_ext_burden_cum
		,ISNULL(shipments.qty_packed,0)*SPIps.cost_cum as SPI_ext_cost_cum
		,isnull(shipments.qty_packed,0)*SPIps.interco_profit as SPI_ext_interco_profit

		,eecps.price as eec_price
		,eecps.material_cum as eec_material_cum
		,eecps.labor_cum as eec_labor_cum
		,eecps.burden_cum as eec_burden_cum
		,eecps.cost_cum as eec_cost_cum
		,eecps.interco_profit as eec_interco_profit

		,ISNULL(shipments.qty_packed,0)*eecps.price as eec_ext_price
		,ISNULL(shipments.qty_packed,0)*eecps.material_cum as eec_ext_material_cum
		,ISNULL(shipments.qty_packed,0)*eecps.labor_cum as eec_ext_labor_cum
		,ISNULL(shipments.qty_packed,0)*eecps.burden_cum as eec_ext_burden_cum
		,ISNULL(shipments.qty_packed,0)*eecps.cost_cum as eec_ext_cost_cum
		,isnull(shipments.qty_packed,0)*eecps.interco_profit as eec_ext_interco_profit

		,(ISNULL(QL_stdhours,0)*2.07)+spips.labor_cum+eecps.labor_cum as total_co_labor_cum
		,(ISNULL(shipments.qty_packed,0)*((ISNULL(QL_stdhours,0)*2.07)+spips.labor_cum+eecps.labor_cum)) as total_co_ext_labor_cum

--		,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(eeilc.std_hours,0)*4									ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum											ELSE								(isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END) AS total_co_material_cum
--		,(CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COMPONENTS') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeilc.std_hours,0)*4  ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN ISNULL(shipments.qty_packed,0)*ISNULL(eeips.frozen_material_cum,0)	ELSE ISNULL(shipments.qty_packed,0)*(ISNULL(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0)) END) END) AS ext_total_co_material_cum
--		,(CASE WHEN ISNULL(shipments.price,0)=0 THEN 0 ELSE (CASE WHEN eeip.product_line IN ('OUTSOURCED ES3 COPMONENTS') THEN isnull(eeips.material_cum,0)/shipments.price ELSE (CASE WHEN eeip.product_line IN ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') THEN eeips.frozen_material_cum/shipments.price ELSE (isnull(eehps.material_cum,0)-isnull(spips.interco_profit,0)-isnull(spips.burden_cum,0)-isnull(spips.labor_cum,0)-isnull(eecps.interco_profit,0))/shipments.price END) END)END) AS total_co_material_cost_percentage
			


 FROM       @shipments shipments
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_historical eeip ON shipments.part_original = eeip.part AND eeip.fiscal_year = @fiscal_year AND eeip.period = @period AND eeip.reason = 'MONTH END'
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_standard_historical eeips ON shipments.part_original=eeips.part AND eeips.fiscal_year = @fiscal_year AND eeips.period = @period AND eeips.reason = 'MONTH END'
	LEFT OUTER JOIN @eeh_costs eehps ON shipments.part_original = eehps.part
--	LEFT OUTER JOIN @eeh_labor lc on shipments.part_original = lc.part
	LEFT OUTER JOIN @eei_labor eeilc ON shipments.part_original = eeilc.part
	LEFT OUTER JOIN flatCSM CSM ON LEFT(shipments.part_original,7) = CSM.basepart
	LEFT OUTER JOIN @quote_log ql ON shipments.part_original = ql.WO_Part
	LEFT OUTER JOIN eeiuser.acctg_csm_base_part_attributes bpa ON LEFT(shipments.part_original,7) = bpa.base_part AND bpa.release_id = (SELECT MAX(release_id) FROM eeiuser.acctg_csm_base_part_attributes)
	LEFT OUTER JOIN @spi_costs spips ON shipments.part_original = spips.part
	LEFT OUTER JOIN @eec_costs eecps ON shipments.part_original = eecps.part


ORDER BY eeip.product_line, shipments.part_original

END


GO
