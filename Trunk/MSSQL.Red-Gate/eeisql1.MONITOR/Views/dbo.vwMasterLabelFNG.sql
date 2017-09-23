SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vwMasterLabelFNG]
as 

--Select	max(sd.customer_part) as CustomerPart,
--		sum(ob.Quantity) as PalletSerialQty,
--		max(es.supplier_code) as SupplierCode,
--		max(coalesce(ob.Lot,ob.serial)) as LotNumber,
--		max(sd.customer_po) as CustomerPO,
--		ob.parent_serial as PalletSerial
--From
--	shipper_detail sd
--join
--	shipper s on s.id = sd.shipper
--join
--	edi_setups es on es.destination = s.destination
--join
--	object ob on ob.shipper =  sd.shipper
--where
--	parent_serial is Not Null and
--	ob.part != 'PALLET'
--group by
--	ob.parent_serial

--	union

	Select	max(sd.customer_part) as CustomerPart,
		sum(ob.Quantity) as PalletSerialQty,
		max(es.supplier_code) as SupplierCode,
		max(coalesce(ob.Lot,ob.serial)) as LotNumber,
		max(sd.customer_po) as CustomerPO,
		obpallet.serial as PalletSerial
From
	shipper_detail sd
join
	shipper s on s.id = sd.shipper
join
	edi_setups es on es.destination = s.destination
join
	object obpallet on obpallet.shipper =  sd.shipper
join
		object ob on ob.parent_serial = obpallet.serial and
		sd.part_original = ob.part
where
	ob.parent_serial is Not Null and
	obpallet.part = 'PALLET'
group by
	obpallet.serial


GO
