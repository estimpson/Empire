SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [FT].[vwInventory]
AS
SELECT	Serial = object.serial,
	PartECN = object.part,
	Status = ISNULL (object.status, 'X'),
	Location = object.location,
	Plant = ISNULL (location.plant,
		CASE	WHEN object.location LIKE 'TRAN%' THEN 'INTRANSIT'
			WHEN object.location LIKE '%LOST%' THEN 'LOST'
			ELSE 'EEI'
		END),
	StdQty = object.std_quantity,
	Shipper = isNULL(object.shipper,0)
FROM	object
	LEFT JOIN location ON object.location = location.code
	JOIN part ON object.part = part.part
WHERE	object.part != 'PALLET'
GO
