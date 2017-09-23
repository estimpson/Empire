SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[eeisp_rpt_object_historical_by_location] (@fiscalYear int, @period int, @reason varchar(15), @partType char(1))
as

--exec eeisp_rpt_object_historical_by_location '2013', '11', 'MONTH END', 'R'

 SELECT ph.type, 
		ph.product_line, 
		oh.plant,
		oh.location, 
		isnull(l.secured_location,'No') as secured_location,
		l.group_no,		 
		oh.serial, 
		oh.part, 
		oh.quantity, 
		psh.material_cum,
		oh.quantity*psh.material_cum as ext_material_cum, 
		oh.user_defined_status, 
		oh.last_date 
 FROM	 HistoricalData.dbo.object_historical oh
 LEFT JOIN HistoricalData.dbo.part_standard_historical psh ON oh.part = psh.part and oh.time_stamp = psh.time_stamp
 LEFT JOIN HistoricalData.dbo.part_historical ph ON oh.part = ph.part and oh.time_stamp = ph.time_stamp
 LEFT JOIN location l ON oh.location = l.code
 WHERE  oh.fiscal_year = @FiscalYear
		and oh.period = @Period   
		and oh.reason = @Reason 
		and isNULL(ph.type, 'X') = @PartType 
		and oh.location <> 'PREOBJECT' 
		and isNULL(oh.user_defined_status, 'XXX') !=  'PRESTOCK' 
		AND oh.part <>'PALLET'
		AND oh.quantity > 0
 ORDER BY ph.product_line,
		  oh.plant,
		  oh.location,
		  isnull(l.secured_location,'No'),
		  oh.part,
		  oh.serial








GO
