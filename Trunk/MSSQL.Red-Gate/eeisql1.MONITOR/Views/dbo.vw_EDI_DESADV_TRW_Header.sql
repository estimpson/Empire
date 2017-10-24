SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	VIEW	[dbo].[vw_EDI_DESADV_TRW_Header]

AS

SELECT	shipper.id AS ShipperIDInt,
		CONVERT(varchar(25), shipper.id) AS ShipperID,
		(CASE WHEN bill_of_lading_number is NULL THEN CONVERT(varchar(25), shipper.id) ELSE CONVERT(varchar(25), shipper.bill_of_lading_number)END) as BOL,
		(CASE WHEN Shipper.status = 'Z' THEN '5' ELSE '9' END) as DESADVSTATUS,
		(CONVERT(varchar(4), DATEPART(yy,shipper.date_shipped))+
		CONVERT(varchar(2), DATEPART(mm,shipper.date_shipped))+
		CONVERT(varchar(2), DATEPART(dd,shipper.date_shipped)))AS DocumentDate,
		(CONVERT(varchar(4), DATEPART(yy,getdate()))+
		CONVERT(varchar(2), DATEPART(mm,getdate()))+
		CONVERT(varchar(2), DATEPART(dd,getdate())))AS DesadvDate,
		ISNULL(edi_setups.parent_destination,edi_setups.destination) AS DestinationCode,
		CONVERT(varchar(20), shipper.gross_weight) as GrossWeight,
		CONVERT(varchar(20), shipper.tare_weight) as TareWeight,
		CONVERT(varchar(15),(Select	sum(qty_packed) from shipper_detail where shipper_detail.shipper = shipper.id)) as PieceCount,
		edi_setups.supplier_code AS SupplierCode,
		'' AS Partial_Complete,
		trading_partner_code AS TradingPartner,
		Shipper.ship_via as SCAC,
		(CASE WHEN shipper.trans_mode like '%A%' THEN '40' ELSE '30' END) as TransMode,
		shipper.truck_number AS TruckNumber
		
		
FROM	shipper
JOIN	edi_setups ON shipper.destination = edi_setups.destination

GO
