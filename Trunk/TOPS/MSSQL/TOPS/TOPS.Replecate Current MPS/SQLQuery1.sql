select
	acvssf.base_part
,	acvssf.CSM_sop
,	acvssf.CSM_eop
,	acvssf.CSM_sop_display
,	acvssf.CSM_eop_display
,	acvssf.empire_sop
,	acvssf.empire_eop
,	acvssf.sop
,	acvssf.eop
,	acvssf.sop_display
,	acvssf.eop_display
,	acvssf.empire_duration_mo
,	acvssf.Jan_18_TOTALdemand
,	acvssf.Feb_18_TOTALdemand
,	acvssf.Mar_18_TOTALdemand
,	acvssf.Apr_18_TOTALdemand
,	acvssf.May_18_TOTALdemand
,	acvssf.Jun_18_TOTALdemand
,	acvssf.Jul_18_TOTALdemand
,	acvssf.Aug_18_TOTALdemand
,	acvssf.Sep_18_TOTALdemand
,	acvssf.Oct_18_TOTALdemand
,	acvssf.Nov_18_TOTALdemand
,	acvssf.Dec_18_TOTALdemand
,	acvssf.Jan_19_TOTALdemand
,	acvssf.Feb_19_TOTALdemand
,	acvssf.Mar_19_TOTALdemand
,	acvssf.Apr_19_TOTALdemand
,	acvssf.May_19_TOTALdemand
,	acvssf.Jun_19_TOTALdemand
,	acvssf.Jul_19_TOTALdemand
,	acvssf.Aug_19_TOTALdemand
,	acvssf.Sep_19_TOTALdemand
,	acvssf.Oct_19_TOTALdemand
,	acvssf.Nov_19_TOTALdemand
,	acvssf.Dec_19_TOTALdemand
,	acvssf.Jan_20_TOTALdemand
,	acvssf.Feb_20_TOTALdemand
,	acvssf.Mar_20_TOTALdemand
,	acvssf.Apr_20_TOTALdemand
,	acvssf.May_20_TOTALdemand
,	acvssf.Jun_20_TOTALdemand
,	acvssf.Jul_20_TOTALdemand
,	acvssf.Aug_20_TOTALdemand
,	acvssf.Sep_20_TOTALdemand
,	acvssf.Oct_20_TOTALdemand
,	acvssf.Nov_20_TOTALdemand
,	acvssf.Dec_20_TOTALdemand
,	acvssf.Cal_18_TOTALdemand
,	acvssf.Cal_19_TOTALdemand
,	acvssf.Cal_20_TOTALdemand
from
	EEIUser.acctg_csm_vw_select_sales_forecast acvssf
where
	acvssf.[Cal_18_TOTALdemand] > 0
	and acvssf.Cal_20_TOTALdemand > 0
	and acvssf.base_part = 'AUT0244'

select
	sum(case when datediff(month, '2018-01-01', od.due_date) = 1 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 2 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 3 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 4 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 5 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 6 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 7 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 8 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 9 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 10 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 11 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 12 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 13 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 14 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 15 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 16 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 17 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 18 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 19 then od.quantity else 0 end)
,	sum(case when datediff(month, '2018-01-01', od.due_date) = 20 then od.quantity else 0 end)
from
	dbo.order_detail od
where
	left(od.part_number, 7) = 'AUT0244'


select
	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 1  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 2  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 3  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 4  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 5  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 6  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 7  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 8  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 9  then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 10 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 11 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 12 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 13 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 14 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 15 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 16 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 17 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 18 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 19 then sd.qty_packed else 0 end)
,	sum(case when datediff(month, '2018-01-01', sd.date_shipped) = 20 then sd.qty_packed else 0 end)
from
	dbo.shipper_detail sd
where
	left(sd.part_original, 7) = 'AUT0244'
