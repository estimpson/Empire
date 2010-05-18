$PBExportHeader$w_empire_nascote.srw
forward
global type w_empire_nascote from Window
end type
end forward

global type w_empire_nascote from Window
int X=672
int Y=264
int Width=1582
int Height=992
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_empire_nascote w_empire_nascote

type variables
St_generic_structure Stparm
end variables

event open;//  Label for Job Completion

//  Declaration
//
Stparm = Message.PowerObjectParm
Long 			ll_Label		  // 32-bit Open Handle
Long   		lSerial
Long			lParentSerial
Long   		lposition
Long			lshipper
Long			dserial

Int 			f_length
Int 			s_length
Int 			iPQAIndicator

Integer 		i_order
Integer 		i_TwoDlength

String 		cesc         
String 		szLoc        
String 		szLot        
String 		szUnit       
String 		szOperator
String 		szPart
String 		szPartName
String 		szdestination, szDAdd1, szDAdd2, szDAdd3, szDName
String 		szSupplier,szDescription
String 		szCompany
String 		szTemp
String 		szName 
String 		szName2
String 		szName1
String 		szCustomer, szCName,szCAdd1, szCAdd2, szCAdd3
String 		szNumberofLabels
String 		szcustomerpart
String 		szCrossRef
String 		szfirst
String 		szsecond
String 		szFmglpn
String 		szEng
String 		szDock
String		szJuliandate
String		szCentocoDate
String		szshipper
String		szline11
String		szline12
String		szline13
String		szline14
String		szline15
String		szline16
String		szline17
String		szlinefeed
String		szcustomerPO
String		szLicensePlate
String		szMasterLicensePlate
String		szPCoName
String		szPAdd1
String		szPAdd2
String		szPAdd3
String		szPOLine
String		szZonecode
String		sz2DData
String		szSerialFiller
String 		szdate
String 		szMfgDate
String 		szShipDate
String		szKanban
String		szALCdate
String		szFNGdate
String		FedMogulCrossRef
String		szMitsuMfgDate
String		szTAKDate
String		szTAKdayofyear
String		szTAKYear
String		szTAKShift
String		szTAKLot
String		szTRWJulianDate



Dec {0} 		dQuantity, nPo, dweight, dtweight

Time 			tTime

date  			dDate

datetime		dtdatetime

CONSTANT CHAR		ESC = '~h1B'
CONSTANT STRING	DMEM = '3F'
CONSTANT CHAR		RS = '~h1E'
CONSTANT CHAR     GS = '~h1D'
CONSTANT CHAR     EOT = '~h04'
cesc = "~h1B"
/////////////////////////////////////////////////
//  Initialization
//

//lSerial = Message.DoubleParm
lSerial = Long(Stparm.Value1)


SELECT 		objectserial,
				UPPER(CustomerPart),
				UPPER(CustomerPO),
				Quantity,
				UPPER(Lot),
				UPPER(SupplierCode),
				UPPER(PartName),
				UPPER(Cross_Ref),
				UPPER(EngineeringLevel),
				UPPER(substring(convert(varchar(10),datepart(dd, MfgDate)),1,4)+convert(varchar(25),datepart(mm, MfgDate))+convert(varchar(25),datepart(yyyy, MfgDate))),
				UPPER(substring(convert(varchar(10),datepart(dd, shipdate)),1,4)+convert(varchar(25),datepart(mm, shipdate))+convert(varchar(25),datepart(yyyy, shipdate))),
				UPPER(Substring((convert(varchar(10), MfgDate, 112)),5,2) + '-'+ Substring((convert(varchar(25), MfgDate, 112)),7,2)+'-'+Substring((convert(varchar(25), MfgDate, 112)),1,4)),
				UPPER(Substring((convert(varchar(25), MfgDate, 112)),5,2) + '/'+ Substring((convert(varchar(25), MfgDate, 112)),7,2)+'/'+Substring((convert(varchar(25), MfgDate, 112)),3,2)),
				UPPER(substring(convert(varchar(4),datepart(year,MfgDate)),3,2)+convert(varchar(4),(datepart(dy, MfgDate)))),
				UPPER(Substring((convert(varchar(25), MfgDate, 112)),5,2) + '/'+ Substring((convert(varchar(25), Mfgdate, 112)),7,2)+'/'+Substring((convert(varchar(25), MfgDate, 112)),1,4)),
				getdate(),
				UPPER(CompanyName),
				UPPER(CompanyAdd1),
				UPPER(CompanyAdd2),
				UPPER(CompanyAdd3),
				UPPER(Destination),
				SUBSTRING(UPPER(destinationname),1,25),
				UPPER(DestinationAdd1),
				UPPER(DestinationAdd2),
				UPPER(DestinationAdd3),
				UPPER(LineFeed),
				UPPER(Line11),
				UPPER(Line12),
				UPPER(Line13),
				UPPER(Line14),
				UPPER(Line15),
				UPPER(Line16),
				UPPER(Line17),
				UPPER(ZoneCode),
				isNULL(convert(varchar(15),objectshipper),'RELABEL'),
				ParentSerial,
				UPPER(KanBanNo),
				UPPER(DockCode),
				UPPER(customer),
				UPPER(customername),
				UPPER(CustomerAdd1),
				UPPER(CustomerAdd2),
				UPPER(CustomerAdd3),
				UPPER(ObjectPart),
				UPPER(suppliercode+ (CASE WHEN objectserial > 999999 THEN '0' + Convert(varchar(10),objectserial) ELSE '00' +convert(varchar(10),objectserial) END )),
				UPPER(suppliercode+ (CASE WHEN parentserial > 999999 THEN '0' + Convert(varchar(10),isNULL(parentserial,0)) ELSE '00' +Convert(varchar(10),isNULL(parentserial,0)) END )),
				objectweight,
				objecttareweight,
				UPPER(FedMogulCrossRef),
				UPPER(Substring((convert(varchar(25), isNULL(mfgdate, getdate()), 112)),5,2) + '/'+ Substring((convert(varchar(25), isNULL(mfgdate, getdate()), 112)),7,2)+'/'+Substring((convert(varchar(25), isNULL(mfgdate, getdate()), 112)),3,2)),
				UPPER(convert(varchar(25),datepart(dy,isNULL(mfgdate, getdate())))),
				UPPER(substring(convert(varchar(25),datepart(yy,isNULL(mfgdate, getdate()))),3,2)),
				UPPER(convert(varchar(25),(CASE when datepart(hh,isNULL(mfgdate, getdate())) BETWEEN 7 and 15 THEN 1 WHEN datepart(hh,isNULL(mfgdate, getdate())) BETWEEN 16 and 24 THEN 2 ELSE 3 END))),
				UPPER( substring(convert( varchar(10),datepart(year, mfgdate)),3,2)+convert( varchar(25),datepart (dy, mfgdate))), 
				(CASE WHEN UPPER(isNULL(ordernotes,'X')) like '%NO PQA%' THEN 1 ELSE 0 END)
 
 INTO 		:dserial,
	 			:szCustomerpart,
				:szcustomerPO,
				:dQuantity,
				:szLot,
				:szSupplier,
				:szPartName,
				:szCrossRef,
				:szeng,
				:szMfgDate,
				:szShipDate,
				:szALCDate,
				:szCentocoDate,
				:szFNGDate,
				:szMitsuMfgDate,
				:dtdatetime,
				:szPCoName,
				:szPAdd1,
				:szPAdd2,
				:szPAdd3,
				:szdestination,
				:szDName,
				:szDAdd1,
				:szDAdd2,
				:szDAdd3,
				:szLineFeed,
				:szline11,
				:szline12,
				:szline13,
				:szline14,
				:szline15,
				:szline16,
				:szline17,
				:szZonecode,
				:szshipper,
				:lParentSerial,
				:szKanban,
				:szDock,
				:szCustomer,
				:szCName,
				:szCAdd1,
				:szCAdd2,
				:szCAdd3,
				:szPart,
				:szLicensePlate,
				:szMasterLicensePlate,
				:dweight, 
				:dtweight,
				:FedMogulCrossRef,
				:szTAKDate,
				:szTAKdayofyear,
				:szTAKYear,
				:szTAKShift,
				:szTRWJulianDate,
				:iPQAIndicator
				

								
	FROM	vw_eei_customerlabel
  WHERE 		vw_eei_customerlabel.objectserial = :lSerial;
  sztemp = szPartName
	lposition = Pos ( sztemp, " " ,10 )
	f_length  = len ( sztemp )

		IF f_length < 15 THEN
			szFirst = sztemp
   			szSecond = ""
		ELSE
			szFirst   = Left ( sztemp, lposition )
			s_length  = len ( szFirst )
			szSecond  = Mid ( sztemp, lposition + 1, f_length - s_length )
		END IF
	szName1 = Mid ( SZFIRST,1, 18 )
	szName2 = Mid ( szSECOND, 19, 36 )
	
	If Stparm.value11 = "" Then
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If
/////////////////////////////////////////////////
//  Main Routine
//

ll_Label = PrintOpen ( )

//  Start Printing
PrintSend ( ll_Label, cesc+"A"+cesc+"R" )
PrintSend ( ll_Label, cesc+"CS2" )

//  Part Info
PrintSend ( ll_Label, cesc+"V77"+cesc+"H266"+cesc+"M"+"PART NO" )
PrintSend ( ll_Label, cesc+"V97"+cesc+"H266"+cesc+"M"+"(P)" )
PrintSend ( ll_Label, cesc+"V162"+cesc+"H246"+cesc+"B103095"+"*"+"P"+szCustomerPart + "*" )

PrintSend ( ll_Label, cesc+"V298"+cesc+"H266"+cesc+"M"+"QUANTITY" )
PrintSend ( ll_Label, cesc+"V318"+cesc+"H266"+cesc+"M"+"(Q)" )
PrintSend ( ll_Label, cesc+"V378"+cesc+"H246"+cesc+"B103095"+"*" +"Q"+String ( dQuantity ) + "*" )

PrintSend ( ll_Label, cesc+"V485"+cesc+"H266"+cesc+"M"+"SUPPLIER" )
PrintSend ( ll_Label, cesc+"V504"+cesc+"H266"+cesc+"M"+"(V)" )
PrintSend ( ll_Label, cesc+"V485"+cesc+"H440"+cesc+"WB1"+"EES083" )
PrintSend ( ll_Label, cesc+"V528"+cesc+"H246"+cesc+"B103095"+"*"+"V"+"EES083" + "*")

PrintSend ( ll_Label, cesc+"V638"+cesc+"H266"+cesc+"M"+"Lot Number " )
PrintSend ( ll_Label, cesc+"WB1"+String ( szFNGDate ) )
PrintSend ( ll_Label, cesc+"V661"+cesc+"H266"+cesc+"M"+"(1T)" )
PrintSend ( ll_Label, cesc+"V680"+cesc+"H246"+cesc+"B103095"+"*"+"1T"+String( szFNGDate ) + "*" )

PrintSend ( ll_Label, cesc+"V298"+cesc+"H770"+cesc+"M"+"P. O. NO." )
PrintSend ( ll_Label, cesc+"V318"+cesc+"H770"+cesc+"M"+"(K)" )
PrintSend ( ll_Label, cesc+"V298"+cesc+"H950"+cesc+"WL1"+szCustomerPO )
PrintSend ( ll_Label, cesc+"V358"+cesc+"H790"+cesc+"B103095"+"*"+"K"+szCustomerPO + "*" )

PrintSend ( ll_Label, cesc+"V485"+cesc+"H770"+cesc+"M"+"Serial" )
PrintSend ( ll_Label, cesc+"V504"+cesc+"H770"+cesc+"M"+"(S)" )
PrintSend ( ll_Label, cesc+"V485"+cesc+"H950"+cesc+"WB1"+String(dSerial) )
PrintSend ( ll_Label, cesc+"V528"+cesc+"H790"+cesc+"B103095"+"*"+"S"+String(dSerial) + "*")

PrintSend ( ll_Label, cesc+"V77"+cesc+"H810"+cesc+"M"+"PART DESCRIPTION" )
PrintSend ( ll_Label, cesc+"V115"+cesc+"H810"+cesc+"M"+szPartName)

//PrintSend ( ll_Label, cesc+"V661"+cesc+"H835"+cesc+"M"+"MFG SHIP DATE" )
//PrintSend ( ll_Label, cesc+"V661"+cesc+"H1055"+cesc+"WL1"+szMfgDate )
//PrintSend ( ll_Label, cesc+"V741"+cesc+"H835"+cesc+"M"+"LOT NO." )
//PrintSend ( ll_Label, cesc+"WB1"+String ( lSerial ) )

PrintSend ( ll_Label, cesc+"L0102" )
PrintSend ( ll_Label, cesc+"V860"+cesc+"H366"+cesc+"S"+szPCoName+ "  "+szPAdd1 + " "+szPAdd2 + "  "+szPAdd3 )

PrintSend ( ll_Label, cesc+"L0203" )
PrintSend ( ll_Label, cesc+"V70"+cesc+"H400"+cesc+"WB1"+szCustomerPart)
PrintSend ( ll_Label, cesc+"V283"+cesc+"H440"+cesc+"WB1"+String ( dQuantity ) )

//  Draw Lines
PrintSend ( ll_Label, cesc+"V280"+cesc+"H250"+cesc+"FW02H1127" )
PrintSend ( ll_Label, cesc+"V475"+cesc+"H250"+cesc+"FW02H1127" )
PrintSend ( ll_Label, cesc+"V632"+cesc+"H250"+cesc+"FW02H1127" )
PrintSend ( ll_Label, cesc+"V280"+cesc+"H760"+cesc+"FW02V352" )

PrintSend ( ll_Label, cesc+"CS2" )

PrintSend ( ll_Label, cesc+szNumberofLabels )
PrintSend ( ll_Label, cesc+"Z" )
PrintClose ( ll_Label )
Close ( this )
end event
on w_empire_nascote.create
end on

on w_empire_nascote.destroy
end on

