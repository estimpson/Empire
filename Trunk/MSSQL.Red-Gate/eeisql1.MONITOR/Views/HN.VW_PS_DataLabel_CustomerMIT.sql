SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [HN].[VW_PS_DataLabel_CustomerMIT]
as

SELECT	Serial=objectserial,
		SetSerial=convert(varchar,convert(int,objectserial)), 
		SetPlantCode=UPPER(PlantCode), 
		SetCustomerpart=UPPER(CustomerPart), 
		SetcustomerPO=UPPER(CustomerPO), 
		SetQuantity=convert(varchar,convert(int,Quantity)), 
		SetLot=UPPER(Lot), 
		SetSupplier=UPPER(ISNULL(SupplierCode, 'EMPIRE')), 
		SetPartName=UPPER(PartName), 
		SetCrossRef=UPPER(Cross_Ref), 
		SetEngLevel=UPPER(EngineeringLevel), 
		SetMfgDate=UPPER(SUBSTRING(CONVERT(varchar(10), DATEPART(dd, MfgDate)), 1, 4) + CONVERT(varchar(25), 
                         DATEPART(mm, MfgDate)) + CONVERT(varchar(25), DATEPART(yyyy, MfgDate))), 
		SetShipDate=UPPER(SUBSTRING(CONVERT(varchar(10), DATEPART(dd, ShipDate)), 1, 4) + CONVERT(varchar(25), DATEPART(mm, ShipDate)) + CONVERT(varchar(25), DATEPART(yyyy, ShipDate))), 
		SetALCDate = UPPER(SUBSTRING(CONVERT(varchar(10), MfgDate, 112), 5, 2) + '-' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 7, 2) 
                         + '-' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 1, 4)), 
		SetCentocoDate=UPPER(SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 5, 2) 
                         + '/' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 7, 2) + '/' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 3, 2)), 
		SetFNGDate=UPPER(SUBSTRING(CONVERT(varchar(4), DATEPART(year, MfgDate)), 3, 2) + CONVERT(varchar(4), DATEPART(dy, MfgDate))), 
		SetMitsuMfgDate=UPPER(SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 5, 2) + '/' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 7, 2) 
                         + '/' + SUBSTRING(CONVERT(varchar(25), MfgDate, 112), 1, 4)), 
		Setdatetime=convert(varchar,GETDATE(),101), 
		SetCompanyName=UPPER(CompanyName), 
		SetCompanyAddress1 =UPPER(CompanyAdd1), 
		SetCompanyAddress2=UPPER(CompanyAdd2), 
		SetCompanyAddress3=UPPER(CompanyAdd3), 
		SetName=UPPER(LEFT(CustomerPart, 25)), 
		SetDestination=UPPER(Destination), 
		SetDestinationName=SUBSTRING(UPPER(destinationname), 1, 25) , 
		SetDestinationAddress1=UPPER(DestinationAdd1), 
		SetDestinationAddress2=UPPER(DestinationAdd2), 
		SetDestinationAddress3=UPPER(DestinationAdd3), 
		SetLineFeed=UPPER(LineFeed), 
		SetLine11=UPPER(Line11), 
		SetLine12=UPPER(Line12), 
		SetLine13=UPPER(Line13), 
		SetLine14=UPPER(Line14), 
		SetLine15=UPPER(Line15), 
		SetLine16=UPPER(Line16), 
		SetLine17=UPPER(Line17), 
		SetZonecode=UPPER(ZoneCode), 
		SetShipper=ISNULL(CONVERT(varchar(15), objectshipper), 'RELABEL'), 
		SetParentSerial=ParentSerial, 
		SetKanban=UPPER(KanBanNo), 
		SetDock=UPPER(DockCode), 
		SetCustomer=UPPER(customer), 
		SetCustomerName=UPPER(customername), 
		SetCustomerAddress1=UPPER(CustomerAdd1), 
		SetCustomerAddress2=UPPER(CustomerAdd2), 
		SetCustomerAddress3=UPPER(CustomerAdd3), 
		SetPart=UPPER(ObjectPart), 
		SetLicensePlate=UPPER(SupplierCode + (CASE WHEN objectserial > 999999 THEN '0' + CONVERT(varchar(10), 
                         objectserial) ELSE '00' + CONVERT(varchar(10), objectserial) END)), 
        SetMasterLicensePlate=UPPER(SupplierCode + (CASE WHEN parentserial > 999999 THEN '0' + CONVERT(varchar(10), isNULL(parentserial, 0)) ELSE '00' + CONVERT(varchar(10), 
						 ISNULL(parentserial, 0)) END)), 
		SetWeight=convert(varchar,convert(numeric(9,2),Objectweight)), 
		SetTareWeight=convert(varchar,convert(numeric(9,2),Objecttareweight)),
		SetGrossWeight=case when Objecttareweight >0 then  convert(varchar,convert(numeric(9,2),Objecttareweight+ Objectweight)) else convert(varchar,convert(numeric(9,2),Objectweight)) end,
		SetFedMogulCrossRef=UPPER(FedMogulCrossRef), 
		SetTAKDate=UPPER(SUBSTRING(CONVERT(varchar(25), ISNULL(MfgDate, GETDATE()), 112), 5, 2) + '/' + SUBSTRING(CONVERT(varchar(25), ISNULL(MfgDate, GETDATE()), 112), 7, 
                         2) + '/' + SUBSTRING(CONVERT(varchar(25), ISNULL(MfgDate, GETDATE()), 112), 3, 2)), 
		SetTAKdayofyear=UPPER(CONVERT(varchar(25), DATEPART(dy, ISNULL(MfgDate, GETDATE())))), 
		SetTAKYear=UPPER(SUBSTRING(CONVERT(varchar(25), DATEPART(yy, ISNULL(MfgDate, GETDATE()))), 3, 2)), 
		SetTAKShift=UPPER(CONVERT(varchar(25), (CASE WHEN datepart(hh, isNULL(mfgdate, getdate())) BETWEEN 7 AND 15 THEN 1 WHEN datepart(hh, isNULL(mfgdate, getdate())) 
                         BETWEEN 16 AND 24 THEN 2 ELSE 3 END))), 
		SetTRWJulianDate=UPPER(SUBSTRING(CONVERT(varchar(10), DATEPART(year, MfgDate)), 3, 2) + CONVERT(varchar(25), 
                         DATEPART(dy, MfgDate))), 
		--SetPQAIndicator=(CASE WHEN UPPER(isNULL(ordernotes, 'X')) LIKE '%NO PQA%' THEN 1 ELSE 0 END), 
		SetFirst=LEFT(PartName, 20), 
		SetSecond=SUBSTRING(PartName, 21, 20)
FROM            vw_eei_LabelBoxMitsubishi 


GO
GRANT SELECT ON  [HN].[VW_PS_DataLabel_CustomerMIT] TO [APPUser]
GO
