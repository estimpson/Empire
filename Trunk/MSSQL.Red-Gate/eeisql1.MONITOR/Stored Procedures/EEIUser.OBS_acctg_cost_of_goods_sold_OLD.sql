SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- exec eeiuser.acctg_cost_of_goods_sold @period=10, @fiscal_year='2014', @beg_date = '2014-10-01', @end_date = '2014-10-31'

CREATE proc [EEIUser].[OBS_acctg_cost_of_goods_sold_OLD] (@period int, @fiscal_year varchar(4), @beg_date datetime, @end_date datetime)

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


declare @eeh_costs table (
part varchar(25),
material_cum decimal(18,6)
)
insert into @eeh_costs
 SELECT		eeh_new_part_standard.part,
			eeh_new_part_standard.material_cum 
 FROM		EEHSQL1.HistoricalData.dbo.part_standard_historical eeh_new_part_standard
 WHERE		eeh_new_part_standard.period=@period 
		AND eeh_new_part_standard.fiscal_year=@fiscal_year 
		AND eeh_new_part_standard.reason='MONTH END'


 SELECT		eei_part.product_line, 
			shipper_detail.shipper,			
			shipper.type,			
			shipper.destination,			
			shipper.date_shipped, 
			shipper_detail.part_original, 
			eei_part.type as part_type,			
			shipper_detail.qty_packed, 
			shipper_detail.price, 
			isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0) as ext_price,
			eei_new_part_standard.fiscal_year, 
			eei_new_part_standard.period,			
			eei_new_part_standard.part,			
			eei_new_part_standard.material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_new_part_standard.material_cum,0) as ext_transfer_price, 
			eei_new_part_standard.cost_cum, 
			eei_new_part_standard.frozen_material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eei_new_part_standard.frozen_material_cum,0) as ext_frozen_material_cum,
			eeh_new_part_standard.material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(eeh_new_part_standard.material_cum,0) as ext_eeh_material_cum,
			ic.TopPart, 
			ic.ChildPart, 
			ic.BulbedPrice,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.bulbedPrice,0) as ext_Bulbed_Price, 
			ic.UnbulbedPrice, 
			isnull(shipper_detail.qty_packed,0)*isnull(ic.UnbulbedPrice,0) as ext_Unbulbed_Price,
			isnull(shipper_detail.price,0)-isnull(ic.UnbulbedPrice,0) as incremental_price,
			(isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0))-(isnull(shipper_detail.qty_packed,0)*isnull(ic.unbulbedPrice,0)) as ext_incremental_price, 
			ic.BulbedMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.BulbedMaterialCost,0) as ext_Bulbed_material_cost,
			ic.UnbulbedMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.UnbulbedMaterialCost,0) as ext_unBulbed_material_cost,
			ic.IncrementalMaterialCost,
			isnull(shipper_detail.qty_packed,0)*isnull(ic.incrementalMaterialCost,0) as ext_incremental_material_cost
 FROM       MONITOR.dbo.shipper_detail shipper_detail 
	LEFT OUTER JOIN MONITOR.dbo.shipper shipper ON shipper_detail.shipper=shipper.id
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_historical eei_part ON shipper_detail.part_original=eei_part.part and eei_part.fiscal_year = @fiscal_year and eei_part.period = @period
	LEFT OUTER JOIN HISTORICALDATA.dbo.part_standard_historical eei_new_part_standard ON shipper_detail.part_original=eei_new_part_standard.part and eei_new_part_standard.fiscal_year = @fiscal_year and eei_new_part_standard.period = @period
	LEFT OUTER JOIN @eeh_costs eeh_new_part_standard on shipper_detail.part_original = eeh_new_part_standard.part
	LEFT OUTER JOIN FT.Ftsp_BOMPerPart_incremental IC on ic.toppart = shipper_detail.part_original
 WHERE	shipper.destination <> 'EMPHOND' 
		AND (shipper.date_shipped>=@beg_date AND shipper.date_shipped<dateadd(d,1,@end_date))
order by product_line, part


end




GO
