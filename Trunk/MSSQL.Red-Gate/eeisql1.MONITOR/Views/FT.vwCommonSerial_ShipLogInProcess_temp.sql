SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [FT].[vwCommonSerial_ShipLogInProcess_temp]
as
select	ShipLog.RowStatus,
	ShipLog.Shipper,
	ShipLog.Serial,
	ShipLog.Part,
	ShipLog.Quantity,
	ShipLog.Unit,
	ShipLog.PackageType,
	ShipLog.Status,
	ShipLog.UserStatus,
	ShipLog.PalletSerial,
	ShipLog.Price,
	ShipLog.Cost,
	ShipLog.Weight,
	ShipLog.TareWeight,
	ShipLog.ShipDT,
	ShipLog.Origin,
	ShipLog.Destination,
	PONumber = po_header.po_number,
	RcvdUnit = part_inventory.standard_unit,
	RcvdPrice = part_standard.price,
	RcvdCost = part_standard.cost,
	RcvdWeight = part_inventory.unit_weight * ShipLog.Quantity,
	RcvdTareWeight = package_materials.weight,
	RcvdPlant = po_header.plant
from	FT.CommonSerialShipLog ShipLog
	left outer join part_online on ShipLog.Part = part_online.part
	left outer join po_header on part_online.default_po_number = po_header.po_number
	left outer join part_inventory on ShipLog.Part = part_inventory.part
	left outer join part_standard on ShipLog.Part = part_standard.part
	left outer join package_materials on ShipLog.PackageType = package_materials.code
where	ShipLog.Part != 'PALLET' and
	shipper = 14265 and
	ShipLog.Serial in (Select serial From audit_trail where type ='V' and serial in 
	(Select serial From eehsql1.eeh.dbo.audit_trail where TYPE= 'S' AND shipper = '14265' AND part = 'TOG0050-HB00'))

GO
