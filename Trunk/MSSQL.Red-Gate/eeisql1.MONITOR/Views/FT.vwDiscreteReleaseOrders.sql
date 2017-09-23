SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [FT].[vwDiscreteReleaseOrders]
as

Select order_no
From
	order_header
Where
	(customer_po like '%SPOT%' or
	blanket_part like 'ADC%') and
	blanket_part not like 'ALI%' and
	blanket_part not like 'NAL%'
GO
