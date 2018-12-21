SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[SalesForecastUpdated]
as
select
	row_number() over(order by sf.base_part) as RowId
,	sf.status
,	sf.parent_customer
,	sf.program
,	sf.vehicle
,	sf.base_part
,	sf.empire_sop
,	sf.mid_model_year
,	sf.empire_eop
,	sf.empire_eop_note
,	sf.verified_eop
,	sf.verified_eop_date
,	sf.CSM_sop
,	sf.CSM_eop
,	sf.Cal_16_Sales
,	sf.Cal_17_Sales
,	sf.Cal_18_Sales
,	sf.Cal_19_Sales
,	sf.Cal_20_Sales
,	sf.Cal_21_Sales
,	sf.Cal_22_Sales
,	sf.Cal_23_Sales
,	sf.Cal_24_Sales
,	sf.Cal_25_Sales
,	a.SchedulerResponsible
,	a.RfMpsLink
,	a.SchedulingTeamComments
,	a.MaterialsComments
,	a.ShipToLocation
,	a.FgInventoryAfterBuildout
,	a.CostEach
,	a.ExcessFgAfterBuildout
,	a.ExcessRmAfterBuildout
,	a.ProgramExposure
,	a.DateToSendCoLetter
from
	eeiuser.acctg_csm_vw_select_sales_forecast sf
	outer apply 
		(	select
				*
			from
				eeiuser.BasePartCloseouts bpc
			where
				bpc.BasePart = sf.base_part ) a
GO
