SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [EDI_XML_VISTEON_LEGACY_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	TradingPartnerID = es.trading_partner_code
,	ShipTo = es.material_issuer
,	IConnectID = es.IConnectID
,	ASNDate = getdate()
,	ASNTime = getdate()
,	GrossWeightLbs= convert(int, s.gross_weight)
,	NetWeightLbs = convert(int, s.net_weight)
,	SCAC = coalesce(bol.scac_transfer, s.ship_via) 
,	SCACPickUp = bol.scac_pickup
,	TransMode = s.trans_mode
,	TruckNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25), s.id))
,	SLINumber = s.seal_number
,	SupplierCode = es.supplier_code
,	EquipmentInitial = bol.equipment_initial
,	ProNumber = s.pro_number
,	FordCosignee = es.id_code_type
,	BOLNumber =
		case
			when es.parent_destination = 'milkrun' then substring(es.material_issuer, datepart(dw, s.date_shipped)*2-1, 2) + right('0'+convert(varchar, datepart(month, s.date_shipped)),2) + right('0'+convert(varchar, datepart(day, s.date_shipped)),2)
			else convert(varchar, coalesce(s.bill_of_lading_number, s.id))
		end

,	PoolCode = 
		case 
			when s.trans_mode in ('AE', 'A') then CONVERT(VARCHAR(15), SUBSTRING(tm.description, PATINDEX('%~%', tm.description)+1, 3))
			when s.trans_mode = 'E' then ''
			else es.pool_code 
		end 
,	LocationQualifier = 
		case 
			when s.trans_mode = 'E' then ''
			when s.trans_mode in ('A', 'AE') then 'OR'
			when s.trans_mode not in ('AE', 'A', 'E') and isNULL(nullif(es.pool_code,''),'') != '' then 'PP'
			else '' 
		end
,	FreightBillQual = 
		case 
			when s.trans_mode not in ('A', 'AE') and  s.pro_number > '' then 'FR'
			else '' 
		end
,	FreightBill = 
		case 
			when s.trans_mode not in ('A', 'AE') and  s.pro_number > '' then  s.pro_number
			else '' 
		end
,	AirBillQual = 
		case
			when s.trans_mode in ( 'A', 'AE') and  s.pro_number > '' then  'AW'
			else ''
		end
,	AirBill = 
		case 
			when s.trans_mode in ( 'A', 'AE') and  s.pro_number > '' then s.pro_number
			else ''
		end
,	FordMotorCosignee = 
		case 
			when s.destination = 'F201C' then es.parent_destination 
			else coalesce(s.shipping_dock, es.parent_destination) 
		end
--,	LooseCtns = isnull((select	count(serial) 
--			from	audit_trail at,
--				package_materials pm
--			where	at.shipper = convert(varchar(10), s.id) AND
--				at.type = 'S' AND
--				at.part <> 'PALLET' AND 
--				at.parent_serial IS NULL AND
--				at.package_type = pm.code AND
--				pm.type = 'B' ),0) 
--,	LooseBins = isnull((select	count(at.serial) 
--			from	audit_trail at,
--				package_materials pm
--			where	at.shipper =  convert(varchar(10), s.id) AND
--				at.type = 'S' AND 
--				at.parent_serial IS NULL AND
--				at.package_type = pm.code AND
--				pm.type = 'O' ),0) 
--,	Pallets = 	isnull((select count(distinct at.Parent_serial) 
--			from	audit_trail at
--			where	at.shipper = CONVERT(VARCHAR(10), s.id) AND
--				at.type = 'S' AND 
--				isnull(at.parent_serial,0) >0 ),0) 
,	PackageType =
		COALESCE((case
			when (isnull((select count(distinct at.Parent_serial) from audit_trail at where	at.shipper = convert(varchar(10), s.id) and at.type = 'S' and isnull(at.parent_serial,0) >0 ),0)) > 0 then 'PLT90'
			else 'CTN90'
		end), '')
,	LadingQty =
		Coalesce(case
			when (isnull((select count(distinct at.Parent_serial) from audit_trail at where	at.shipper = convert(varchar(10), s.id) and at.type = 'S' and isnull(at.parent_serial,0) >0 ),0)) > 0 then (isnull((select count(distinct at.Parent_serial) from audit_trail at where	at.shipper = convert(varchar(10), s.id) and at.type = 'S' and isnull(at.parent_serial,0) >0 ),0))
			when (isnull((select count(at.serial) from audit_trail at, package_materials pm where at.shipper = convert(varchar(10), s.id) AND at.type = 'S' AND at.parent_serial IS NULL AND at.package_type = pm.code AND pm.type = 'O' ),0)) > 0 then (isnull((select count(at.serial) from audit_trail at, package_materials pm where at.shipper = convert(varchar(10), s.id) AND at.type = 'S' AND at.parent_serial IS NULL AND at.package_type = pm.code AND pm.type = 'O' ),0))
			when (isnull((select count(at.serial) from audit_trail at, package_materials pm where at.shipper = convert(varchar(10), s.id) AND at.type = 'S' AND at.part <> 'PALLET' AND at.parent_serial IS NULL AND at.package_type = pm.code AND	pm.type = 'B' ),0)) > 0 then (isnull((select count(at.serial) from audit_trail at, package_materials pm where at.shipper = convert(varchar(10), s.id) AND at.type = 'S' AND at.part <> 'PALLET' AND at.parent_serial IS NULL AND at.package_type = pm.code AND	pm.type = 'B' ),0))
		end, s.staged_objs)
--,	CTN90_qual = case
				--	when LooseCtns >0 then 'CTN90'
				--	else ''
				--end 
--,	BIN90_qual = case
				--	when LooseBins >0 then 'CTN90'
				--	else ''
				--end 
--,	PLT90_qual = case
				--	when Pallets >0 then 'PLT90'
				--	else ''
				--end 
from
	dbo.shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination	and s.date_shipped > getdate() - 60
	left join dbo.bill_of_lading bol
		on s.bill_of_lading_number = bol.bol_number
	left join dbo.trans_mode tm 
		on tm.code = s.trans_mode





GO
