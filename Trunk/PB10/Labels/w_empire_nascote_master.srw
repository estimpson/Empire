$PBExportHeader$w_empire_nascote_master.srw
forward
global type w_empire_nascote_master from Window
end type
end forward

global type w_empire_nascote_master from Window
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
global w_empire_nascote_master w_empire_nascote_master

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
Int 			iPartCount

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


Select		Customerpart,
				CustomerPO,
				SupplierCode,
				PalletQuantity,
				parent_serial,
				Lot,
				PartCount,
				PartName
				
 INTO 		:szCustomerpart,
				:szcustomerPO,
				:szSupplier,
				:dQuantity,
				:lParentSerial,				
				:szLot,
				:iPartCount,
				:szPartName
				
								
	FROM		vw_eei_Nascote_masterlabel
  WHERE 		vw_eei_Nascote_masterlabel.parent_serial = :lSerial;
  
  
  
	lposition = Pos ( sztemp, " " ,10 )
	f_length  = len ( sztemp )

		IF iPartCount <> 1 THEN
			szCustomerpart = "Not a Master Pallet"
			messagebox ("Please Check Part Count on Pallet"+string(iPartCount), "Not a Master Pallet, please create Master Pallet and relabel")
   	ELSE
			szCustomerpart = szCustomerpart
		END IF
		
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
PrintSend ( ll_Label, cesc+"V485"+cesc+"H440"+cesc+"WB1"+szSupplier )
PrintSend ( ll_Label, cesc+"V528"+cesc+"H246"+cesc+"B103095"+"*"+"V"+szSupplier + "*")

PrintSend ( ll_Label, cesc+"V638"+cesc+"H266"+cesc+"M"+"Lot Number " )
PrintSend ( ll_Label, cesc+"WB1"+String ( szLot ) )
PrintSend ( ll_Label, cesc+"V661"+cesc+"H266"+cesc+"M"+"(1T)" )
PrintSend ( ll_Label, cesc+"V680"+cesc+"H246"+cesc+"B103095"+"*"+"1T"+String( szLot ) + "*" )

PrintSend ( ll_Label, cesc+"V298"+cesc+"H770"+cesc+"M"+"P. O. NO." )
PrintSend ( ll_Label, cesc+"V318"+cesc+"H770"+cesc+"M"+"(K)" )
PrintSend ( ll_Label, cesc+"V298"+cesc+"H950"+cesc+"WL1"+szCustomerPO )
PrintSend ( ll_Label, cesc+"V358"+cesc+"H790"+cesc+"B103095"+"*"+"K"+szCustomerPO + "*" )

PrintSend ( ll_Label, cesc+"V485"+cesc+"H770"+cesc+"M"+"Serial" )
PrintSend ( ll_Label, cesc+"V504"+cesc+"H770"+cesc+"M"+"(M)" )
PrintSend ( ll_Label, cesc+"V485"+cesc+"H950"+cesc+"WB1"+String(lParentSerial) )
PrintSend ( ll_Label, cesc+"V528"+cesc+"H790"+cesc+"B103095"+"*"+"M"+String(lParentSerial) + "*")

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
on w_empire_nascote_master.create
end on

on w_empire_nascote_master.destroy
end on

