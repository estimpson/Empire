SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_cost_of_goods_sold_expanded_mod @period=6, @fiscal_year='2016', @beg_date = '2016-06-01', @end_date = '2016-06-30'

CREATE proc [EEIUser].[acctg_cost_of_goods_sold_expanded_mod] (@period varchar(2), @fiscal_year varchar(4))

as
begin

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
 FROM		EEHSQL1.HistoricalData.dbo.part_standard_historical eeh_new_part_standard
 WHERE		eeh_new_part_standard.period=@period 
		AND eeh_new_part_standard.fiscal_year=@fiscal_year 
		AND eeh_new_part_standard.reason='MONTH END'


-- 2. Get EEH Labor Costs

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

 
-- 3. Get EEI Labor Costs

declare @eei_labor table (
part varchar(25),
std_hours numeric(20,6),
quoted_bom_cost numeric(20,6)
)
insert into @eei_labor
select part, round(std_hours,6), round(quoted_bom_cost,6) from part_eecustom


--4. GET EEI Quote Detail

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


--5.  Get COGS info for month

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
 
 
 --6.  Get total table

select 

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
			
			,eeips.material_cum as transfer_price
			,isnull(shipments.qty_packed,0)*isnull(eeips.material_cum,0) as ext_transfer_price
			
			,eeips.frozen_material_cum as absorbed_material_cum
			,isnull(shipments.qty_packed,0)*isnull(eeips.frozen_material_cum,0) as ext_absorbed_material_cum
			
			,(case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then eeips.material_cum else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum else eehps.material_cum end)end) as eeh_material_cum
			,(case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then isnull(shipments.qty_packed,0)*isnull(eeips.material_cum,0) else(case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then isnull(shipments.qty_packed,0)*isnull(eeips.frozen_material_cum,0) else isnull(shipments.qty_packed,0)*isnull(eehps.material_cum,0) end) end) as ext_eeh_material_cum
			,(case when isnull(shipments.price,0)=0 then 0 else (case when eeip.product_line in ('OUTSOURCED ES3 COPMONENTS') then eeips.material_cum/shipments.price else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum/shipments.price else eehps.material_cum/shipments.price end) end)end) as current_material_cost_percentage
			
			,(case when isnull(eeilc.std_hours,0)=0 then 'Standard Hours not input into Monitor' else 'Monitor contains Standard Hour Information' end) as std_hour_error
			,eeilc.std_hours			
			,2.07 as std_labor_rate
			,isnull(eeilc.std_hours,0)*2.07 as std_labor_cost
			,isnull(shipments.qty_packed,0)*isnull(eeilc.std_hours,0)*2.07 as ext_std_labor_cost
			,(case when isnull(shipments.price,0)=0 then 0 else ((isnull(shipments.qty_packed,0)*isnull(eeilc.std_hours,0)*2.07))/shipments.ext_price end) as std_labor_cost_percentage

			,shipments.price-((case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then eeips.material_cum else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum else eehps.material_cum end)end)+isnull(eeilc.std_hours,0)*2.07) as CAML
			,shipments.ext_price-((case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then isnull(shipments.qty_packed,0)*isnull(eeips.material_cum,0) else(case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then isnull(shipments.qty_packed,0)*isnull(eeips.frozen_material_cum,0) else isnull(shipments.qty_packed,0)*isnull(eehps.material_cum,0) end) end)*isnull(eeilc.std_hours,0)*2.07) as Ext_CAML
						
		,'------'
		,'------'
		,(case when isnull(WO_EngineerID,'')='' then 'NJB/ECN not input into Monitor' else 'Monitor contains NJB/ECN Information' end) as nbj_ecn_error
		,WO_EngineerID
		,(Case when isnull(WO_QuoteNumber,'')='' then 'Quote Number not input into NJB/ECN' else 'NJB/ECN contains Quote Number' end) as njb_ecn_quotenumber_error	    
		,WO_QuoteNumber
		,(Case when isnull(QL_QuoteNumber,'')='' then 'Quote Number input into NJB/ECN does not exist in QuoteLog' else 'QuoteLog contains Quote Number' end) as quote_log_error
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
		,(case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then eeips.material_cum else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum else eehps.material_cum end)end) as eeh_material_cost	
		,(case when isnull(shipments.price,0)=0 then 0 else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum/shipments.price else eehps.material_cum/shipments.price end) end) as current_material_cost_percentage		
		,'------'
		,QL_ProductionPrice	
		,QL_straightmaterialcost
		,(case when isnull(QL_productionprice,0)=0 then 0 else QL_straightMaterialcost/QL_ProductionPrice end) as quote_material_cost_percentage
		,'------'
		,-(case when isnull(QL_productionprice,0)=0 then 0 else QL_straightMaterialcost/QL_ProductionPrice end)+(case when isnull(shipments.price,0)=0 then 0 else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum/shipments.price else eehps.material_cum/shipments.price end) end) as material_cost_percentage_variance
		,'------'				
		,isnull(shipments.qty_packed,0)*QL_ProductionPrice as Ext_QL_Production_price		
		,isnull(shipments.qty_packed,0)*QL_StraightMaterialCost as EXT_QL_StraightMaterialCost
		,isnull(shipments.qty_packed,0)*QL_stdhours*1.00 as EXT_QL_StandardLaborCost
		,'------'
		,QL_straightmaterialcost
		,(case when eeip.product_line in ('OUTSOURCED ES3 COMPONENTS') then eeips.material_cum else (case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum else eehps.material_cum end)end) as eeh_material_cost
		,-QL_straightmaterialcost+(case when eeip.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eeips.frozen_material_cum else eehps.material_cum end) as quoted_vs_actual_material_cost_variance
		,'------'
		,QL_stdhours as QL_std_hours
		,eeilc.std_hours as EEI_std_hours
		,-QL_stdhours+eeilc.std_hours as quoted_vs_eeh_std_labor_hours_variance

 FROM       @shipments shipments
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_historical eeip ON shipments.part_original = eeip.part and eeip.fiscal_year = @fiscal_year and eeip.period = @period and eeip.reason = 'MONTH END'
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_standard_historical eeips ON shipments.part_original=eeips.part and eeips.fiscal_year = @fiscal_year and eeips.period = @period and eeips.reason = 'MONTH END'
	LEFT OUTER JOIN @eeh_costs eehps on shipments.part_original = eehps.part
--	LEFT OUTER JOIN @eeh_labor lc on shipments.part_original = lc.part
	LEFT OUTER JOIN @eei_labor eeilc on shipments.part_original = eeilc.part
	LEFT OUTER JOIN flatCSM CSM on LEFT(shipments.part_original,7) = CSM.basepart
	left outer join @quote_log ql on shipments.part_original = ql.WO_Part
	LEFT OUTER JOIN eeiuser.acctg_csm_base_part_attributes bpa on LEFT(shipments.part_original,7) = bpa.base_part and bpa.release_id = (select max(release_id) from eeiuser.acctg_csm_base_part_attributes)

order by eeip.product_line, shipments.part_original

end

GO
