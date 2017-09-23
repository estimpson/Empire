SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_sales_forecast_summary_by_parentcustomer]
as
set nocount on
set ansi_warnings on


select 
	parent_customer, 
	sum(Cal_16_Sales) as Sales_2016,
	sum(Cal_17_Sales) as Sales_2017,
	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017,
	sum(Cal_18_Sales) as Sales_2018,
	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018,
	sum(Cal_19_Sales) as Sales_2019,
	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019,
	sum(Cal_20_Sales) as Sales_2020,
	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	sf.parent_customer in 
(
	'ADAC Automotive'
,	'Autoliv'
,	'Automotive Lighting'
,	'Flex N Gate'
,	'Hella'
,	'II Stanley'
,	'Key Safety Inc'
,	'Magna International'
,	'North American Lighting'
,	'SL Lighting Corp'
,	'Stanley Electric US'
,	'TRW'
,	'Valeo Sylvania'
,	'Varroc Lighting Systems'
)
group by 
	sf.parent_customer
order by
	sf.parent_customer
GO
