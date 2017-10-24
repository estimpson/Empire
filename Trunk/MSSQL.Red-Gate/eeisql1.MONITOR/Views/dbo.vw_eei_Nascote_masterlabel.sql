SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[vw_eei_Nascote_masterlabel]

AS


SELECT	DISTINCT ( SELECT MAX(shipper_detail.customer_part) FROM shipper_detail WHERE shipper_detail.part_original = obj.part AND shipper_detail.shipper = Obj.shipper ) AS Customerpart,
		( SELECT MAX(shipper_detail.customer_po) FROM shipper_detail WHERE shipper_detail.part_original = obj.part AND shipper_detail.shipper = Obj.shipper )  AS CustomerPO,
		( SELECT MAX(supplier_code) FROM edi_setups, shipper WHERE edi_setups.destination = shipper.destination AND shipper.id = Obj.shipper )  AS SupplierCode,
		(SELECT SUM(quantity) FROM object WHERE object.parent_serial = obj.parent_serial) AS PalletQuantity,
		parent_serial,
		(SELECT MAX(COALESCE(lot,CONVERT(varchar(50),serial))) FROM object WHERE object.parent_serial = obj.parent_serial) AS Lot,
		(SELECT COUNT(DISTINCT shipper_detail.customer_part) FROM shipper_detail WHERE shipper_detail.part_original = obj.part AND shipper_detail.shipper = Obj.shipper ) AS PartCount,
		(Select MAX(part.name) FROM part WHERE part.part = obj.part) AS PartName


FROM	object obj





GO
