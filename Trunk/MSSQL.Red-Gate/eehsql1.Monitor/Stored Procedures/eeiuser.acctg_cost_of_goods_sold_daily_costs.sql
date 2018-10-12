SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- exec eeiuser.acctg_cost_of_goods_sold_daily_costs @beg_date = '2016-09-01', @end_date = '2016-09-30'

CREATE proc [eeiuser].[acctg_cost_of_goods_sold_daily_costs] (@beg_date datetime, @end_date datetime)

as
begin


 --declare @beg_date datetime;
 --declare @end_date datetime;
 --select @beg_date = '2014-08-01'
 --select @end_date = '2014-08-31'

 declare @part_list table
 (
	part varchar(25) NOT NULL
	primary key (part)
 )
 insert into @part_list 
 select distinct(part) from shipper s join shipper_detail sd on s.id = sd.shipper where s.date_shipped >= @beg_date and s.date_shipped < dateadd(d,1,@end_date)

--select count(*) from @part_list	



declare @eeh_phd table 
	(
	time_stamp date NOT NULL,
	part varchar(25) NOT NULL,
	product_line varchar(25),
	type varchar(1)
	primary key (part, time_stamp)
	)
insert into @eeh_phd
	SELECT	convert(date, time_stamp),
			part,
			product_line,
			type
	FROM	HistoricalData.dbo.part_historical_daily
	WHERE	time_stamp >= @beg_date
			and time_stamp < dateadd(d,1,@end_date)
			and reason in ('Daily','Month End')
			and part in (select part from @part_list)
			and product_line is not null

--select count(*) from @eeh_phd

declare @eeh_pshd table
	(
	time_stamp date NOT NULL,
	part varchar(25) NOT NULL,
	price decimal(18,6),
	material_cum decimal(18,6),
	labor_cum decimal(18,6),
	burden_cum decimal(18,6),
	cost_cum decimal(18,6)
	primary key (part, time_stamp)
	)
insert into @eeh_pshd
	SELECT  convert(date, time_stamp),
			part,
			price,
			material_cum,
			labor_cum,
			burden_cum,
			cost_cum
	FROM	HistoricalData.dbo.part_standard_historical_daily
	WHERE	Time_stamp >= @beg_date
			and time_stamp < dateadd(d,1,@end_date)
			and reason in ('Daily','Month End')
			and part in (select part from @part_list)

--select count(*) from @eeh_pshd

 SELECT		phd.product_line, 
			phd.type as part_type,			
			shipper_detail.shipper,			
			shipper.type,
			shipper.customer,			
			shipper.destination,			
			shipper.date_shipped, 
			shipper_detail.part_original, 
			shipper_detail.qty_packed,
			shipper_detail.boxes_staged,
			shipper_detail.price, 
			isnull(shipper_detail.qty_packed,0)*isnull(shipper_detail.price,0) as ext_price,			 
			pshd.price,
			isnull(shipper_detail.qty_packed,0)*isnull(pshd.material_cum,0) as ext_eeh_ps_price,
			pshd.material_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(pshd.material_cum,0) as ext_eeh_material_cum,
			pshd.labor_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(pshd.labor_cum,0) as ext_eeh_labor_cum,
			pshd.burden_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(pshd.burden_cum,0) as ext_eeh_burden_cum,
			pshd.cost_cum,
			isnull(shipper_detail.qty_packed,0)*isnull(pshd.cost_cum,0) as ext_eeh_cost_cum

FROM        MONITOR.dbo.shipper_detail shipper_detail 
	LEFT OUTER JOIN MONITOR.dbo.shipper shipper ON shipper_detail.shipper=shipper.id
	LEFT OUTER JOIN @eeh_phd phd  	ON shipper_detail.part_original=phd.part	and convert(date, shipper.date_shipped) = phd.time_stamp 
	LEFT OUTER JOIN @eeh_pshd pshd	ON shipper_detail.part_original=pshd.part	and convert(date, shipper.date_shipped) = pshd.time_stamp 

--	LEFT OUTER JOIN @eeh_costs eeh_new_part_standard on shipper_detail.part_original = eeh_new_part_standard.part

WHERE	shipper.destination <> 'EMPHOND' 
		AND (shipper.date_shipped>=@beg_date AND shipper.date_shipped<dateadd(d,1,@end_date))
		AND phd.type = 'F'

ORDER BY product_line, part_original


end








GO
