SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_Chrysler_ASN].[ASNLines]
(	@shipperID int
)
returns @ASNLines table
(	PackingSlip varchar(25)
,	CustomerPart varchar(35)
,	ECL varchar(25)
,	BoxType varchar(25)
,	BoxCount int
,	PalletType varchar(25)
,	PalletCount int
,	QtyPacked int
,	AccumShipped int
,	PONumber varchar(20)
,	DockCode varchar(10)
,	ShipTo varchar(20)
,	ACIndicator char(1)
,	ACHandler char(2)
,	ACClause char(3)
,	ACCharge numeric(20,6)
)
as
begin
--- <Body>
	insert
		@ASNLines


		---asb 09/11/2017; We need to group by customerpart for Empire due to multiple internal ecn per customer part per shipper
		select
		PackingSlip = si.PackingSlip
	,	CustomrPart = bo.CustomerPart
	,	ECL = right(rtrim(bo.CustomerPart), 2)
	,	BoxType = si.PackageType
	,	BoxCount = sum(si.Boxes)
	,	PalletType = coalesce(si.PalletPackageType,'')
	,	PalletCount = sum(si.Pallets)
	,	QtyPacked = sum(convert(int, si.QtyPacked))
	,	AccumShipped = max(convert(int, bo.AccumShipped))
	,	PONumber = max(bo.CustomerPO)
	,	DockCode = max(bo.DockCode)
	,	ShipTo = max(bo.EDIShipToCode)
	,	ACIndicator = max(case when bo.Returnable = 'Y'
				  and si.PackingSlip like '%E%'
				  and bo.Clause092UnitCost > 0 then 'C'
		end)
	,	ACHandler = max(case when bo.Returnable = 'Y'
				  and si.PackingSlip like '%E%'
				  and bo.Clause092UnitCost > 0 then '06'
		end)
	,	ACClause = max(case when bo.Returnable = 'Y'
				  and si.PackingSlip like '%E%'
				  and bo.Clause092UnitCost > 0 then '092'
		end)
	,	ACCharge = sum(case when bo.Returnable = 'Y'
					and si.PackingSlip like '%E%'
					and bo.Clause092UnitCost > 0 then bo.Clause092UnitCost
		end * si.QtyPacked)
	from
		ChryslerEDI.fn_ShipperInventory(@shipperID) si
		join dbo.shipper_detail sd
			on si.Part = sd.part_original
			   and sd.shipper = @shipperID
		join ChryslerEDI.BlanketOrders bo
			on sd.order_no = bo.BlanketOrderNo
		join shipper s
			on sd.shipper = s.id
		join edi_setups es
			on s.destination = es.destination

			group by
				si.PackingSlip,
				bo.CustomerPart,
				 si.PackageType,
				coalesce(si.PalletPackageType,'')





		------Ugrouped data Commented asb 09/11/2017; We need to group by customerpart for Empire due to multiple internal ecn per customer part per shipper
	--select
	--	PackingSlip = si.PackingSlip
	--,	CustomrPart = bo.CustomerPart
	--,	ECL = right(rtrim(bo.CustomerPart), 2)
	--,	BoxType = si.PackageType
	--,	BoxCount = si.Boxes
	--,	PalletType = si.PalletPackageType
	--,	PalletCount = si.Pallets
	--,	QtyPacked = convert(int, si.QtyPacked)
	--,	AccumShipped = convert(int, bo.AccumShipped)
	--,	PONumber = bo.CustomerPO
	--,	DockCode = bo.DockCode
	--,	ShipTo = bo.EDIShipToCode
	--,	ACIndicator = case when bo.Returnable = 'Y'
	--			  and si.PackingSlip like '%E%'
	--			  and bo.Clause092UnitCost > 0 then 'C'
	--	end
	--,	ACHandler = case when bo.Returnable = 'Y'
	--			  and si.PackingSlip like '%E%'
	--			  and bo.Clause092UnitCost > 0 then '06'
	--	end
	--,	ACClause = case when bo.Returnable = 'Y'
	--			  and si.PackingSlip like '%E%'
	--			  and bo.Clause092UnitCost > 0 then '092'
	--	end
	--,	ACCharge = case when bo.Returnable = 'Y'
	--				and si.PackingSlip like '%E%'
	--				and bo.Clause092UnitCost > 0 then bo.Clause092UnitCost
	--	end * si.QtyPacked
	--from
	--	ChryslerEDI.fn_ShipperInventory(@shipperID) si
	--	join dbo.shipper_detail sd
	--		on si.Part = sd.part_original
	--		   and sd.shipper = @shipperID
	--	join ChryslerEDI.BlanketOrders bo
	--		on sd.order_no = bo.BlanketOrderNo
	--	join shipper s
	--		on sd.shipper = s.id
	--	join edi_setups es
	--		on s.destination = es.destination
--- </Body>

---	<Return>
	return
end

GO
