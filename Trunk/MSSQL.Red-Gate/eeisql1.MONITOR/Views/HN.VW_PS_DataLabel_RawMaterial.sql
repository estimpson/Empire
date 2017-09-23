SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE view [HN].[VW_PS_DataLabel_RawMaterial]
as

SELECT	Serial=object.serial,
		SetSerial=convert(varchar,object.serial),
		SetPart=isnull(object.part,''), 
		SetLot=isnull(object.lot,''), 
		Setdatetime=isnull(convert(varchar,object.last_date,101),''), 
		SetOperator=isnull(object.operator,''),
		SetQuantity=isnull(convert(varchar,convert(integer,object.quantity)),''), 
		SetStatus=	(CASE WHEN status = 'A' THEN 'Approved' ELSE 'Not Approved' END), 
		SetLine11=isnull(object.custom3,''),-- AS s_tag, 
		SetLine12=isnull(object.custom4,''),-- AS s_coil, 
		SetLine13=isnull(object.custom5,''),-- AS s_heat, 
        SetcustomerPO=isnull(object.po_number,''),-- AS l_po_number, 
		SetLine14=	isnull(part_eecustom.critical_part,''),--  AS ls_critical, 
		SetLine15=	isnull(part_eecustom.Expedite,''),--  AS ls_rush, 
		SetLine16=	isnull(part.quality_alert,''),--  AS ls_qualityAlert, 
		SetLine17=	ISNULL(object.field1, ''),--  AS s_field1, 
		SetPartName=	isnull(part.name,''),--  AS s_partDesc, 
		SetUnitM=	isnull(object.unit_measure,''),-- AS szunit, 
		SetVendorSerialLot=isnull(object.lot,''),-- AS s_vendor_serial, 
		SetPartDescription=SUBSTRING(isnull(part.name,''), 1, 26),-- AS s_Description1, 
		SetCriticalMessage=	isnull(part_eecustom.criticalpartnotes,''),-- AS ls_CriticalMessage, 
		SetVendorCode=	isnull(VendorInformation.vendor_code,''), 
		SetVendorPart=	isnull(VendorInformation.vendor_part,''),
		SetCritical= case when isnull(critical_part,'N') = 'Y' then 'CRITICAL' else '' end,
		SetRush= case when isnull(expedite,'N') = 'Y' then '1st CONTAINER' else '' end,
		SETCURRENTDATE = convert(varchar, MONTH(getdate())) + '/' + convert(varchar, Day(getdate())) + '/' + convert(varchar, year(getdate())) ,
		SETCURRENTTIME = convert(varchar, case when datepart(hour, getdate()) = 0 then 12 when datepart(hour, getdate()) > 12 then datepart(hour, getdate()) - 12 else datepart(hour, getdate()) end) + ':' + convert(varchar, datepart(minute, getdate()))  + ' ' + case when datepart(hour, getdate()) > 12 then 'PM' else 'AM' end,
		SETIDFGPart = IDLabels.Part
FROM    object INNER JOIN
        FT.ObjectLot ON object.serial = FT.ObjectLot.Serial 
        INNER JOIN	part ON object.part = part.part 
        INNER JOIN	part_eecustom ON part.part = part_eecustom.part 
		LEFT OUTER JOIN HN.BF_IdLabel_WOSerials AS IDLabels ON IDLabels.Serial = dbo.object.serial
        LEFT OUTER JOIN	(SELECT	po_header.vendor_code, part_vendor.vendor_part, po_header.po_number, part_vendor.part
						 FROM	po_header INNER JOIN	part_vendor ON po_header.vendor_code = part_vendor.vendor) AS VendorInformation
		ON VendorInformation.part= object.part and VendorInformation.po_number = object.po_number








GO
GRANT SELECT ON  [HN].[VW_PS_DataLabel_RawMaterial] TO [APPUser]
GO
