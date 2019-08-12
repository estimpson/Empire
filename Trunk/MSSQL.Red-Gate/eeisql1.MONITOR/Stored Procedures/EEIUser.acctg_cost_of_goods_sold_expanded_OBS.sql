SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_cost_of_goods_sold_expanded @period=6, @fiscal_year='2016', @beg_date = '2016-06-01', @end_date = '2016-06-30'

CREATE proc [EEIUser].[acctg_cost_of_goods_sold_expanded_OBS] (@period int, @fiscal_year varchar(4), @beg_date datetime, @end_date datetime)

as
begin

 --declare @period int;
 --declare @fiscal_year varchar(4);
 --declare @beg_date datetime;
 --declare @end_date datetime;
 --select @period = 8;
 --select @fiscal_year = '2014';
 --select @beg_date = '2014-08-01'
 --select @end_date = '2014-08-31'

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

declare @eeh_labor table (
part varchar(25),
std_hours numeric(20,6)
)

--insert into @eeh_labor
-- select part
--		  ,round(std_hours,6)
--		  ,round(quoted_bom_cost,6) 
--from	  eehsql1.monitor.dbo.part_eecustom

insert into @eeh_labor
 select		Part
			,Std_Hrs = TiempoEstandar 
 from		eehsql1.monitor.dbo.part_times

 
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




 SELECT		eei_part.product_line, 
			eei_new_part_standard.fiscal_year, 
			eei_new_part_standard.period, 			
			shipper.customer,
			shipper.destination, 			
			shipper_detail.shipper,			
			shipper.type,			
			shipper.date_shipped, 
			shipper_detail.part_original, 
			eei_part.type as part_type, 			
			shipper_detail.qty_packed, 
			shipper_detail.price, 
			isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0) as ext_price,
			eei_new_part_standard.material_cum as transfer_price,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_new_part_standard.material_cum,0) as ext_transfer_price, 
			eei_new_part_standard.frozen_material_cum as absorbed_material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_new_part_standard.frozen_material_cum,0) as ext_absorbed_material_cum,
			(case when eei_part.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eei_new_part_standard.frozen_material_cum else eeh_new_part_standard.material_cum end) as eeh_material_cum,
			(case when eei_part.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then isnull(shipper_detail.qty_packed,0)*isnull(eei_new_part_standard.frozen_material_cum,0) else isnull(shipper_detail.qty_packed,0)*isnull(eeh_new_part_standard.material_cum,0) end) as ext_eeh_material_cum,
			(case when isnull(eeilc.std_hours,0)=0 then 'Standard Hours not input into Monitor' else 'Monitor contains Standard Hour Information' end) as std_hour_error,
			eeilc.std_hours,			
			2.07 as std_rate,
			isnull(shipper_detail.qty_packed,0)*isnull(eeilc.std_hours,0)*2.07 as ext_std_labor_cost,
			CSM.oem,
			CSM.program,
			CSM.vehicle
		,(case when isnull(WO_EngineerID,'')='' then 'NJB/ECN not input into Monitor' else 'Monitor contains NJB/ECN Information' end) as nbj_ecn_error
		,WO_EngineerID
		,(Case when isnull(WO_QuoteNumber,'')='' then 'Quote Number not input into NJB/ECN' else 'NJB/ECN contains Quote Number' end) as njb_ecn_quotenumber_error	    
		,WO_QuoteNumber
		,(Case when isnull(QL_QuoteNumber,'')='' then 'Quote Number input into NJB/ECN does not exist in QuoteLog' else 'QuoteLog contains Quote Number' end) as quote_log_error
		,QL_QuoteNumber
		,QL_CustomerQuoteDate 
		,QL_awarded  		
		,QL_PrototypePrice 
		,QL_eau 
		,QL_functionname 
		,QL_notes
		,'------'
		,shipper_detail.price	
		,(case when eei_part.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eei_new_part_standard.frozen_material_cum else eeh_new_part_standard.material_cum end) as eeh_material_cum	
		,(case when isnull(shipper_detail.price,0)=0 then 0 else (case when eei_part.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eei_new_part_standard.frozen_material_cum/shipper_detail.price else eeh_new_part_standard.material_cum/shipper_detail.price end) end) as current_material_cost_percentage		
		,'------'
		,QL_ProductionPrice 		
		,QL_straightmaterialcost
		,(case when isnull(QL_productionprice,0)=0 then 0 else QL_straightMaterialcost/QL_ProductionPrice end) as quote_material_cost_percentage
		,'------'
		,-(case when isnull(QL_productionprice,0)=0 then 0 else QL_straightMaterialcost/QL_ProductionPrice end)+(case when isnull(shipper_detail.price,0)=0 then 0 else (case when eei_part.product_line in ('BULBED ES3 COMPONENTS','WIRE HARN - EEI','BULBED WIRE HARN - EEH') then eei_new_part_standard.frozen_material_cum/shipper_detail.price else eeh_new_part_standard.material_cum/shipper_detail.price end) end) as material_cost_percentage_variance
		,'------'
		,QL_straightmaterialcost
		,eeh_new_part_standard.material_cum as eeh_material_cum
		,-QL_straightmaterialcost+eeh_new_part_standard.material_cum as quoted_vs_actual_material_cost_variance
		,'------'
		,QL_stdhours as QL_std_hours
		,eeilc.std_hours as EEI_std_hours
		,-QL_stdhours+eeilc.std_hours as quoted_vs_eeh_std_labor_hours_variance

 FROM       MONITOR.dbo.shipper_detail shipper_detail 
	LEFT OUTER JOIN MONITOR.dbo.shipper shipper ON shipper_detail.shipper=shipper.id
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_historical eei_part ON shipper_detail.part_original=eei_part.part and eei_part.fiscal_year = @fiscal_year and eei_part.period = @period
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_standard_historical eei_new_part_standard ON shipper_detail.part_original=eei_new_part_standard.part and eei_new_part_standard.fiscal_year = @fiscal_year and eei_new_part_standard.period = @period
	LEFT OUTER JOIN @eeh_costs eeh_new_part_standard on shipper_detail.part_original = eeh_new_part_standard.part
	LEFT OUTER JOIN @eeh_labor lc on shipper_detail.part_original = lc.part
	LEFT OUTER JOIN @eei_labor eeilc on shipper_detail.part_original = eeilc.part
	LEFT OUTER JOIN flatCSM CSM on LEFT(shipper_detail.part_original,7) = CSM.basepart
	left outer join @quote_log ql on shipper_detail.part_original = ql.WO_Part
 WHERE	shipper.destination <> 'EMPHOND' 
		AND (shipper.date_shipped>=@beg_date AND shipper.date_shipped<dateadd(d,1,@end_date))
		AND isnull(shipper_detail.qty_packed,0) <> 0
order by eei_part.product_line, shipper_detail.part_original

end

GO
