SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--exec sys.sp_rename 'dbo.eeisp_rpt_materials_CSM_RawPart_Demand', 'dbo.eeisp_rpt_materials_CSM_RawPart_Demand(Andre)'
--go

CREATE procedure [dbo].[eeisp_rpt_materials_CSM_RawPart_Demand_testing]
as
set nocount on
--dbo.eeisp_rpt_materials_CSM_RawPart_Demand
--Get part List to obtain best possible BOM Structure

--print 'insert #Active Part'

declare
	@ActiveParts table
(	BasePart char(7) primary key
,	ActiveOrderPart varchar(25)
,	CurrentRevLevel varchar(25)
,	LastShippedPart varchar(25)
,	LastHN varchar(25)
,	LastPT varchar(25)
,	ActiveOrderPart1 varchar(25)
,	CurrentRevLevel1 varchar(25)
,	LastShippedPart1 varchar(25)
)

insert
	@ActiveParts
(	BasePart
,	ActiveOrderPart
,	CurrentRevLevel
,	LastShippedPart
,	LastHN
,	LastPT
,	ActiveOrderPart1
,	CurrentRevLevel1
,	LastShippedPart1
)
select 
	fcafp.BasePart
,	fcafp.ActiveOrderPart
,	fcafp.CurrentRevLevel
,	fcafp.LastShippedPart
,	fcafp.LastHN
,	fcafp.LastPT
,	fcafp.ActiveOrderPart1
,	fcafp.CurrentRevLevel1
,	fcafp.LastShippedPart1
from
	FT.fn_CSM_ActiveFinishedPart() fcafp

declare
	@BOM table
(	BasePart varchar(25)
,	TopPart varchar(25)
,	RawPart varchar(25)
,	QtyPer numeric(20, 6) primary key (BasePart, RawPart)
)

insert
	@BOM
(	BasePart
,	TopPart
,	RawPart
,	QtyPer
)
select
	ap.BasePart
,	BOM.TopPart
,	BOM.ChildPart
,	BOM.Quantity
from
	dbo.vw_RawQtyPerFinPart BOM
	join @ActiveParts ap
		on BOM.TopPart = coalesce(ap.ActiveOrderPart, ap.CurrentRevLevel, ap.LastShippedPart, ap.LastHN, ap.LastPT)
		
Declare @Countries table 
(CountryCode varchar(15) NOT NULL PRIMARY KEY,
	CountryName varchar(255) NULL)

Insert @Countries

Select * from countries

Declare @HTSCode table 
(	HTSCode varchar(50) NOT NULL PRIMARY KEY,
	HTSDescription varchar(255) NULL,
	Country varchar(50) NULL,
	[type] varchar(50) NULL)



Insert @HTSCode

Select * from HTSCode

Select * Into 
#CSMDemand
from
	(	select
			*
		from
			openquery
			(	EEISQL1
			,	'
select
	*
from
	MONITOR.EEIUser.acctg_csm_vw_select_sales_forecast as CSMDemand
'
			)
	) CSMDemand



select
	CSMDemand.base_part
,	p.name
,	CSMDemand.program
,	CSMDemand.manufacturer
,	CSMDemand.badge
,	CSMDemand.status
,	CSMDemand.CSM_eop_display
,	CSMDemand.CSM_sop_display
,	FGDemand2016 = Cal_16_TOTALdemand
,	FGDemand2017 = Cal_17_TOTALdemand
,	FGDemand2018 = Cal_18_TOTALdemand
,	FGDemand2019 = Cal_19_TOTALdemand
,	FGDemand2020 = Cal_20_TOTALdemand
,	FGDemand2021 = Cal_21_TOTALdemand
,	FGDemand2022 = Cal_22_TOTALdemand
,	FGDemand2023 = Cal_23_TOTALDemand
,	FGDemand2024 = Cal_24_TOTALdemand
,	FGDemand2025 = Cal_25_TOTALdemand
,	BOM.RawPart
,	Commodity = coalesce(p2.commodity, 'NoCommdityDefined')
,	BOM.QtyPer
,	RawPartDemand2016 = QtyPer * Cal_16_TOTALdemand
,	RawPartDemand2017 = QtyPer * Cal_17_TOTALdemand
,	RawPartDemand2018 = QtyPer * Cal_18_TOTALdemand
,	RawPartDemand2019 = QtyPer * Cal_19_TOTALdemand
,	RawPartDemand2020 = QtyPer * Cal_20_TOTALdemand
,	RawPartDemand2021 = QtyPer * Cal_21_TOTALdemand
,	RawPartDemand2022 = QtyPer * Cal_22_TOTALdemand
,	RawPartDemand2023 = QtyPer * Cal_23_TOTALdemand
,	RawPartDemand2024 = QtyPer * Cal_24_TOTALdemand
,	RawPartDemand2025 = QtyPer * Cal_25_TOTALdemand
,	RawPartSpend2016 = material_cum * QtyPer * Cal_16_TOTALdemand
,	RawPartSpend2017 = material_cum * QtyPer * Cal_17_TOTALdemand
,	RawPartSpend2018 = material_cum * QtyPer * Cal_18_TOTALdemand
,	RawPartSpend2019 = material_cum * QtyPer * Cal_19_TOTALdemand
,	RawPartSpend2020 = material_cum * QtyPer * Cal_20_TOTALdemand
,	RawPartSpend2021 = material_cum * QtyPer * Cal_21_TOTALdemand
,	RawPartSpend2022 = material_cum * QtyPer * Cal_22_TOTALdemand
,	RawPartSpend2023 = material_cum * QtyPer * Cal_23_TOTALdemand
,	RawPartSpend2024 = material_cum * QtyPer * Cal_24_TOTALdemand
,	RawPartSpend2025 = material_cum * QtyPer * Cal_25_TOTALdemand
,	po.default_vendor
,	pInv.standard_pack
,	HTSCode.HTSCode as HTSCode
,	HTSCode.HTSDescription as HTSDescription
,	HTSCode.Country as HTSCountry
,	HTSCode.Type as HTSType
,	Countries.CountryName as PartInventoryCountryName
,	nullif(poh.ship_to_destination, '') as POShipTo
,	LeadTime = coalesce
		(	(	select
					pv.FABAuthDays / 7
				from
					dbo.part_vendor pv
				where
					pv.vendor = po.default_vendor
					and pv.part = po.part
			)
		,	0
		)
,	StandardCost = ps.material_cum
,	LeadTimeFlag = 
		case when coalesce
			(	(	select
						pv.FABAuthDays / 7
					from
						dbo.part_vendor pv
					where
						pv.vendor = po.default_vendor
						and pv.part = po.part
				)
			,	0
			) >= 8 then 'Excessive Lead Time'
			else ''
		end
into
	#results
from
	#CSMDemand CSMDemand
	left join @BOM BOM
		on CSMDemand.base_part = BOM.BasePart
	left join part p2
		on p2.part = BOM.RawPArt
	join dbo.part_online po
		on po.part = BOM.RawPart
	join dbo.part p
		on p.part = BOM.RawPart
	join dbo.part_inventory pInv
		on pInv.part = BOM.RawPArt
	join dbo.part_standard ps
		on ps.part = BOM.RawPart
	Left Join po_header poh
		on poh.po_number = po.default_po_number
	outer Apply (Select top 1 * from  @countries countries Where countries.CountryCode = pInv.CountryCode) Countries
    outer apply  (Select top 1 * from @HTSCode HTSCode where  HTSCode.HTSCode = p2.HTSCodeUSCustoms and HTSCode.Country = 'US') HTSCode

Truncate table
	FT.CSM_VendorSpend

insert
	FT.CSM_VendorSpend
select
	*
,	MaxCSMEOPforRawPart =
		(	select
				MAX(r2.CSM_eop_display)
			from
				#results r2
			where
				r2.RawPart = r.RawPart
		)
,	MinCSMSOPforRawPart =
		(	select
				MIN(r2.CSM_sop_display)
			from
				#results r2
			where
				r2.RawPart = r.RawPart
		)
,	AllRawPartInventory =
		(	select
				sum(o.std_quantity)
			from
				dbo.object o
			where
				o.part = r.RawPart
		)
,	VendorTerms =
		(	select
				max(v.terms)
			from
				dbo.vendor v
			where
				v.code = r.default_vendor
		)
		
	--Into FT.CSM_VendorSpend
from
	#results r
order by
	1
,	2




GO
