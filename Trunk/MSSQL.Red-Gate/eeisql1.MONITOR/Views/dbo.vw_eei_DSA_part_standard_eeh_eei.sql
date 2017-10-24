SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[vw_eei_DSA_part_standard_eeh_eei]
as
Select time_stamp,fiscal_year, period, part Part, 'EEI' as Loc, price Price, material MAterial, cost_cum CostCum, material_cum MaterialCum from part_standard_historical_daily where part like '%DSA%'
union all
Select time_stamp,fiscal_year, period, part part, 'EEH' as Loc, price Price, material MAterial, cost_cum CostCum, material_cum MaterialCum  from [EEHSQL1].[EEH].[dbo].part_standard_historical_daily where part like '%DSA%'

GO
