HA$PBExportHeader$w_blanket_order.srw
$PBExportComments$mbo
forward
global type w_blanket_order from Window
end type
type dw_raw_fab_cum from datawindow within w_blanket_order
end type
type cb_6 from commandbutton within w_blanket_order
end type
type cb_5 from commandbutton within w_blanket_order
end type
type cb_2 from commandbutton within w_blanket_order
end type
type cb_note_save from commandbutton within w_blanket_order
end type
type cb_note_cancel from commandbutton within w_blanket_order
end type
type sle_cum from singlelineedit within w_blanket_order
end type
type cb_3 from commandbutton within w_blanket_order
end type
type st_message from statictext within w_blanket_order
end type
type lb_unit from listbox within w_blanket_order
end type
type st_program_name from statictext within w_blanket_order
end type
type st_mini_cop from statictext within w_blanket_order
end type
type st_cop from statictext within w_blanket_order
end type
type p_cop from picture within w_blanket_order
end type
type st_release from statictext within w_blanket_order
end type
type sle_mini_cop from singlelineedit within w_blanket_order
end type
type st_2 from statictext within w_blanket_order
end type
type mle_1 from multilineedit within w_blanket_order
end type
type cb_1 from commandbutton within w_blanket_order
end type
type dw_3 from datawindow within w_blanket_order
end type
type cb_note from commandbutton within w_blanket_order
end type
type mle_note from multilineedit within w_blanket_order
end type
type dw_stack from datawindow within w_blanket_order
end type
type dw_2 from datawindow within w_blanket_order
end type
type cb_4 from commandbutton within w_blanket_order
end type
type gb_edi from groupbox within w_blanket_order
end type
type gb_2 from groupbox within w_blanket_order
end type
type dw_1 from datawindow within w_blanket_order
end type
type dw_edi_setup from datawindow within w_blanket_order
end type
type p_note from picture within w_blanket_order
end type
type gb_1 from groupbox within w_blanket_order
end type
type dw_kanban_inv_for_orders from datawindow within w_blanket_order
end type
type st_history from statictext within w_blanket_order
end type
end forward

global type w_blanket_order from Window
int X=0
int Y=0
int Width=4425
int Height=2024
boolean TitleBar=true
string Title="Blanket Order Maintenance"
long BackColor=78682240
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event insert_release pbm_custom01
event delete_release pbm_custom02
event update_release pbm_custom03
event exit_window pbm_custom05
event edit_cum pbm_custom06
event show_history pbm_custom07
event fastcopy pbm_custom08
event edit_note pbm_custom09
event ue_scan pbm_custom10
event ue_close_uo_scan pbm_custom11
event ue_promise_date pbm_custom12
event ue_retrieve_detail pbm_custom13
event ue_set_dw pbm_custom14
event ue_edi_setup pbm_custom15
event ue_save ( )
event ue_kanban_inv_detail pbm_custom16
event ue_unapproved_message ( )
event ue_print ( )
dw_raw_fab_cum dw_raw_fab_cum
cb_6 cb_6
cb_5 cb_5
cb_2 cb_2
cb_note_save cb_note_save
cb_note_cancel cb_note_cancel
sle_cum sle_cum
cb_3 cb_3
st_message st_message
lb_unit lb_unit
st_program_name st_program_name
st_mini_cop st_mini_cop
st_cop st_cop
p_cop p_cop
st_release st_release
sle_mini_cop sle_mini_cop
st_2 st_2
mle_1 mle_1
cb_1 cb_1
dw_3 dw_3
cb_note cb_note
mle_note mle_note
dw_stack dw_stack
dw_2 dw_2
cb_4 cb_4
gb_edi gb_edi
gb_2 gb_2
dw_1 dw_1
dw_edi_setup dw_edi_setup
p_note p_note
gb_1 gb_1
dw_kanban_inv_for_orders dw_kanban_inv_for_orders
st_history st_history
end type
global w_blanket_order w_blanket_order

type variables
st_generic_structure stParm
str_super_cop_parms istr_super_cop_parms
st_order_chain  st_parm
st_dda_parmlist st_prmlst
m_machine_load m_load_menu

String    szMpsPart    	//To keep the parts in MPS
String    szOperator     	//To keep the operator
String    szPart            	//Blanket part number
String    szDest           	//Destination code
String    is_customer
String    szUM             	//Unit of Measurement
String    szPlant		//Plant code
String    szShipType	//Ship type
string	is_previous_currency
String 	is_ddarequired='N'	 

Decimal nQty              	//To keep the quantity

Date  dMpsDate          	//To keep the due date for MPS
Long  iOrder                	//To keep the sales order number
Long  iReleaseRow      	//To keep the row in release window
Long  iLastRow            	//To keep the last row number
Long  iDelArray[200]     	//To keep the list of release to be deleted
Long  iDelCount   = 0    	//Total items in Del Array
long	il_maxrowid	// store max row id
Int     iRow_Id             	//To keep the Id for Row

Boolean bDelete          	//Whether to delete
Boolean bUpdate         	//Whether to update
Boolean bNewOrder     	//Whether this is new order
Boolean bEditCum        	//Whether editing cum
Boolean bPartError  = FALSE
Boolean bDestError = FALSE
Boolean bHeaderSaved = TRUE
Boolean bHaveNote = FALSE
Boolean bUpdateFinished = TRUE //Whether the update is finished

DataWindowChild  dwcPack  //Packaging type drop down
DataWindowChild  dwcDest   //Destination drop down

u_scan	uo_password
string	is_artificialcum=''
end variables

forward prototypes
public function decimal get_value (decimal value)
public subroutine recalc_releases ()
public subroutine wf_write_shipping_history ()
public subroutine show_reason ()
public subroutine hide_reason ()
public subroutine wf_show_note (boolean bflag)
public subroutine wf_create_dropdown ()
public function integer wf_valid_data ()
public function boolean wf_need_to_explode ()
public subroutine wf_clear_mps ()
public function boolean wf_part_is_staged (string szpart, long iorder)
public function decimal wf_get_qty_for_pack (string szpart, string szpackage)
public subroutine wf_disable_screen ()
public subroutine wf_enable_screen ()
public subroutine wf_resetflag ()
public function long wf_create_order_from_quote (long a_l_quote)
public subroutine wf_get_packaging_types (string a_s_part)
public subroutine wf_change_cop_flag (long aiorder)
public subroutine wf_set_cop_normal_flag (long aiorder)
public function boolean wf_checkcenglevel ()
end prototypes

event insert_release;Int	iTotalRow
Date	dDate
string	ls_part,&
	ls_part_name
Int	li_Randno, &
	li_found
boolean	lb_findseq=true

If (Not bHeaderSaved) then
	MessageBox("Warning", "You must enter and save header information before you insert releases", StopSign!)
	Return
End If

iTotalRow = dw_2.RowCount()

ls_part = dw_1.GetItemString(1, "blanket_part")

dw_2.SelectRow(0, FALSE)
dw_2.InsertRow(1)
// after generating the random number check whether that already exist in the dw or table
// if so, re-generate the number
do while lb_findseq
	Randomize(0)
	li_Randno = Rand ( 4999 )
	li_found = dw_2.find ( "sequence = "+string(li_randno),1, dw_2.rowcount())
	if li_found = 0 then
		lb_findseq = false		
		select	count(sequence)
		into	:li_found
		from	order_detail
		where	order_no = :IOrder and 
			sequence = :li_Randno;
		if li_found = 0 then lb_findseq = false
	end if 	
loop 

dw_2.SetItem(1, "order_no", iOrder)
dw_2.SetItem(1, "sequence", li_Randno )
dw_2.SetItem(1, "part_number", ls_part)
dw_2.SetItem(1, "row_id", 0)
dw_2.SetItem(1, "destination", dw_1.GetItemString ( 1, "destination" ) )
dw_2.SetItem(1, "committed_qty", 0)
dw_2.SetItem(1, "unit", szum )
dw_2.SetItem(1, "customer_part", dw_1.GetItemString ( 1, "customer_part" ) )
dw_2.SetItem(1, "alternate_price", dw_1.GetItemNumber ( 1, "price" ) )
dw_2.SetItem(1, "price", dw_1.GetItemNumber ( 1, "base_price" ) )
dw_2.SetItem(1, "engineering_level", dw_1.GetItemString ( 1, "engineering_level" ) )

select	name
into		:ls_part_name
from		part
where		part = :ls_part ;

dw_2.SetItem(1, "product_name", ls_part_name )

If dw_1.object.ship_type[1] = 'N' then
	dw_2.SetItem(1, "flag", 1)
Else
	dw_2.SetItem(1, "flag", 0)
End If

dw_2.SetItem(1, "plant", dw_1.GetItemString(1, "plant"))

w_blanket_order.SetMicroHelp("Blue Rows: Ready for COP (Double Click to Set/Reset COP flag")

If dw_1.GetItemString(1, "artificial_cum") = "A" then
	dw_2.SetItem(1, "the_cum", 0)
	dw_2.SetItem(1, "our_cum", dw_1.GetItemNumber(1, "our_cum"))
	dw_2.SetTabOrder("our_cum", 0)
	dw_2.SetTabOrder("quantity",0)
Else
	dw_2.SetItem(1, "quantity", 0)
	dw_2.SetTabOrder("the_cum", 0)
	dw_2.SetTabOrder("our_cum", 0)
   dw_2.SetItem(1, "our_cum", dw_1.GetItemNumber(1, "our_cum"))
End If

dw_2.SetItem(1, "type", "F")
dw_2.ScrollToRow(1)

iReleaseRow = 1
bChanged		= TRUE

dw_2.SetColumn(1)
dw_2.SetFocus ( )
end event

event delete_release;Int  l_i_Row, &
	  l_i_value, &
	  l_i_row1

String szSalesOrder
String szRowId

l_i_Row = dw_2.GetRow()
l_i_row1 = dw_2.GetRow()

IF l_i_Row > 0 THEN
	
	l_i_value =	MessageBox("Monsys.msg_title", "Are you sure about deleting"+ " " + "Item" + " " + String(l_i_row1) , StopSign!, OKCancel!,2)
	
		iRow_id 			= dw_2.GetItemNumber(l_i_Row, "row_id")
		szSalesOrder 	= String(iOrder)
		szRowId		 	= String(iRow_Id)
IF l_i_value = 2 THEN Return

		DELETE FROM master_prod_sched  
		WHERE ( origin = :szSalesOrder ) AND  
		  		( source = :szRowId )   ;

		dw_2.DeleteRow(l_i_Row)
		bChanged	= TRUE
End If
end event

event update_release;// 04/03/00	cbr	added updating of row_id here instead of insert
String l_s_SalesOrder
String l_s_Cum
String l_s_PlantRequired
String l_s_Part
String l_s_Dest
String ls_RunCOP
String ls_data
String ls_modify
String l_s_eng


Int iRtnCode
Int iValidRow
Int i_row_count

Boolean b_rancop 
Boolean	lb_invalidquantity = FALSE

Long iRow
Long iTotalRow
Long l_l_rowcount

Real nOurCum
Real nTheCum
Real nNetQty

Decimal	ldec_quantity
Decimal	ldec_stdpack

Pointer	old_pointer

If dw_1.AcceptText ( ) = -1 Then Return
If dw_2.AcceptText ( ) = -1 Then Return
If dw_raw_fab_cum.AcceptText () = -1 Then Return

wf_disable_screen ( )

If bPartError then
	MessageBox(monsys.msg_title, "Please correct invalid part number first!", StopSign!)
	wf_enable_screen ( )
	bUpdateFinished	= TRUE
	Return
End If

If bDestError then
	MessageBox(monsys.msg_title, "Please correct invalid destination first!", StopSign!)
	wf_enable_screen ( )
	bUpdateFinished	= TRUE
	Return
End If

b_rancop = TRUE

iValidRow = wf_valid_data()

If iValidRow = 0 then

	If sle_cum.visible then			//If editing cum now...
       If Sign(Dec(sle_cum.Text)) = -1 Then 
           MessageBox ( monsys.msg_title, "Accum shipped cannot be negative!", StopSign! )
           sle_cum.Text = ""
           Return
       End If   
		dw_1.SetItem(1, "our_cum", Dec(sle_cum.text))
		wf_write_shipping_history()//Write the shipping history for cum change
	End If

	sle_cum.visible = FALSE

	l_s_Cum = dw_1.GetItemString(1, "artificial_cum")
	If Isnull(l_s_Cum) then
		MessageBox ( monsys.msg_title, "You must select release control!", StopSign!)
		wf_enable_screen ( )
		bUpdateFinished	= TRUE
		Return
	End If

	szPlant = dw_1.GetItemString(1, "Plant")

	SELECT parameters.plant_required  
	  INTO :l_s_PlantRequired  
	  FROM parameters  ;

	If l_s_PlantRequired = "Y" and Isnull(szPlant) then
		MessageBox ( monsys.msg_title, "You must select a plant!", StopSign!)
      dw_1.SetTabOrder ( "plant", 100 )
		wf_enable_screen ( )
		bUpdateFinished	= TRUE
		Return
	End If

	If dw_1.object.ship_type[1] = 'D' then
		szShipType	= 'D'
	Else
		szShipType	= 'N'
	End If

	dw_1.SetItem ( 1, "fab_cum", dw_raw_fab_cum.GetItemNumber(1, "fab_cum"))
        dw_1.SetItem ( 1, "raw_cum", dw_raw_fab_cum.GetItemNumber(1, "raw_cum"))
	dw_1.SetItem ( 1, "fab_date", dw_raw_fab_cum.GetItemdate(1, "fab_date"))
	dw_1.SetItem ( 1, "raw_date", dw_raw_fab_cum.GetItemdate(1, "raw_date"))

	if wf_checkcenglevel() = false then 
		wf_enable_screen ( )
		return
	end if 	
		
	If dw_1.Update() > 0 then
		Commit;
		l_s_Part	= dw_1.getItemString(1, "blanket_part")
		szpart = l_s_part
		dw_1.object.ship_type.Protect = 1
		l_s_eng = dw_1.object.engineering_level [1]
		
		// included these lines to cascade the engineering level to the detail rows too		
		FOR l_l_rowcount = 1 to dw_2.rowcount()
			dw_2.SetItem ( l_l_rowcount, "engineering_level",  l_s_eng )
			if isnull ( dw_2.GetItemNumber ( l_l_rowcount, "row_id" ), 0 ) = 0 then
				dw_2.SetItem ( l_l_rowcount, "row_id", il_maxrowid + 1 )
				il_maxrowid ++
			end if
		NEXT

		//ddlb_ship_type.enabled	= FALSE
	Else
		RollBack;
		wf_enable_screen ( )
		Return
	End If

	if dw_2.RowCount ( ) > 0 then
		dw_2.object.packaging_type.primary = dw_1.GetItemString ( 1, "package_type" )
		dw_2.object.unit.primary = dw_1.GetItemString ( 1, "shipping_unit" )
	end if
	
	If dw_2.Update() > 0 then
		Commit;
		recalc_releases()
		
		// cbr added the following 3/30/00
		if Isnull ( dw_1.GetItemString ( 1, "check_standard_pack" ), 'N' ) = 'Y' then
			l_l_rowcount = dw_2.RowCount ( )
			is_customer = dw_1.GetItemString ( 1, "customer" )
			lb_invalidquantity = FALSE
			for iRow = 1 to l_l_rowcount
				ldec_quantity = dw_2.GetItemDecimal ( iRow, "quantity" )
				if isnull ( dw_1.GetItemString ( 1, "package_type" ), '' ) > '' then
					ldec_stdpack = isnull ( dw_1.GetItemDecimal ( 1, "standard_pack" ), 0 )
				end if
				if ldec_stdpack <= 0 then
					ldec_stdpack = sqlca.of_customerstandardpack ( is_customer, szpart, dw_1.GetItemString ( 1, "shipping_unit" ) )
				end if
				if ldec_stdpack > 0 and ldec_quantity > 0 then
					if ldec_stdpack < ldec_quantity then
						if mod ( ldec_quantity, ldec_stdpack ) <> 0 then
							lb_invalidquantity = TRUE
							exit
						end if
					elseif ldec_stdpack > ldec_quantity then
						lb_invalidquantity = TRUE
						exit
					end if
				end if
			next
			if lb_invalidquantity then
				if MessageBox ( monsys.msg_title, "Quantity entered on line " + String ( iRow ) + " is not in standard pack increment of " + String ( ldec_stdpack, "##########" ) + ".  Would you like to continue?", Question!, YesNo!, 2 ) = 2 then
					SetPointer(Old_pointer)
					wf_enable_screen ( )
					m_blanket_order.wf_reset_screen()
					return
				end if
			end if
		end if
		// cbr end adding 3/30/00

		bNoCommit		= FALSE
	
		If szShipType = 'N' AND wf_need_to_explode() Then
			If f_ask_minicop ( ) Then
				If MessageBox(monsys.msg_title, "Do you want to run MiniCOP?", Question!, YesNo!) = 1 then				
						bFinish	= FALSE	
						istr_super_cop_parms.a_regen_all = 'N'
						istr_super_cop_parms.a_order_no  = iorder
						OpenWithParm ( w_bom_explode , istr_super_cop_parms)   
				End If
			End If
		End If
		 
		bChanged	= FALSE
	
		dw_2.Retrieve(iOrder, is_artificialcum) 
		
	Else
		RollBack;
		wf_enable_screen ( )
		Return  
	End If

	SetPointer(Old_pointer)

	w_blanket_order.SetMicroHelp ("System has successfully updated release data......" )
	
Else

    bchanged = True   

End If

wf_enable_screen ( )

m_blanket_order.wf_reset_screen()

end event

on exit_window;Close(w_blanket_order)
end on

on edit_cum;wf_disable_screen ( )

/*If dw_3.visible = TRUE Then

	dw_2.visible 				= TRUE
	dw_2.BringToTop			= TRUE
	st_release.BringToTop	= TRUE
	st_cop.BringToTop			= TRUE
	p_cop.BringToTop			= TRUE
	st_history.visible		= FALSE
	dw_3.visible				= FALSE
	st_release.visible		= TRUE
	p_cop.visible				= TRUE
	st_cop.visible				= TRUE

End If*/

bEditCum 					= True
OpenUserObject(uo_password, 1000, 500)
uo_password.BringToTop	= TRUE
uo_password.uf_set_title_and_name("Enter Operator's Password", "Password")
uo_password.sle_serial.Password	= TRUE
uo_password.cb_1.visible = FALSE

m_blanket_order.wf_reset_screen()


end on

on show_history;st_history.visible	= (Not st_history.visible)
dw_3.visible			= (Not dw_3.visible)
st_release.visible	= (Not dw_3.visible)
dw_2.visible			= (Not dw_3.visible)
p_cop.visible			= (Not dw_3.visible)
st_cop.visible			= (Not dw_3.visible)

If dw_2.visible then
	dw_2.BringToTop			= TRUE
	st_release.BringToTop	= TRUE
	st_cop.BringToTop			= TRUE
	p_cop.BringToTop			= TRUE
Else
	dw_3.BringToTop			= TRUE
End If
end on

on fastcopy;OpenWithParm(w_fastcopy_order, dw_1.GetItemNumber (1, "order_no"))
end on

on edit_note;If dw_1.RowCount() > 0 then
	If dw_1.GetItemNumber(1, "order_no") > 0 then
		wf_disable_screen ( )
		wf_show_note(TRUE)
		mle_note.text	= ""
		mle_note.text	= dw_1.GetItemString(1, "notes")
		mle_note.SetFocus ( )
	Else
		MessageBox("Warning", "Order header has to be completed first", Stopsign!)
	End If
Else
	MessageBox("Warning", "Order header has to be completed first", Stopsign!)
End If



end on

on ue_scan;STRING	l_s_Password, &
			s_Operator


l_s_Password	= uo_password.sle_serial.text

SELECT employee.operator_code  
  INTO :s_Operator
  FROM employee  
 WHERE employee.password = :l_s_Password   ;

If s_Operator > " " then
	CloseUserObject(uo_password)
	bEditCum = False
	szOperator = s_Operator
	show_reason ( )
Else
	MessageBox("Warning", "Invalid Operator's Password.", StopSign!)	
End If
end on

on ue_close_uo_scan;CloseUserObject(uo_password)
wf_enable_screen ( )
m_blanket_order.wf_reset_screen()
end on

on ue_promise_date;st_Generic_Structure lstr_Parm

If iReleaseRow > 0 then
	lstr_Parm.value1	= String(iOrder)
	lstr_Parm.value2	= String(dw_2.GetItemNumber(iReleaseRow, "row_id"))
	OpenSheetWithParm(w_order_promise_date_processor, lstr_Parm, &
							wMainScreen, 3, Layered!)
	w_order_promise_date_processor.wf_get_parent_window(w_blanket_order)
End If
end on

on ue_retrieve_detail;Recalc_releases()

end on

event ue_set_dw;/* this is to reset the window after viewing the ship history*/

If m_blanket_order.m_file.m_shiphistory.ToolbarItemText <> "Release" then 
	m_blanket_order.m_file.m_shiphistory.ToolbarItemText = "Release"
Else
	m_blanket_order.m_file.m_shiphistory.ToolbarItemText = "Shp Hist"
End If

//If m_blanket_order.m_file.m_shiphistory.ToolbarItemText = "Release" Then
//	m_blanket_order.m_file.m_fastcopy.Enabled = False
//	m_blanket_order.m_file.m_editcum.Enabled = False
//	m_blanket_order.m_file.m_promisedate.Enabled = False
//	m_blanket_order.m_file.m_edi.Enabled = False
//	m_blanket_order.m_file.m_relhistory.Enabled = False
//	m_blanket_order.m_file.m_custom1.Enabled = False
//   m_blanket_order.m_file.m_note.Enabled = False
//	m_blanket_order.m_file.m_custom2.Enabled = False
//	m_blanket_order.m_file.m_custom3.Enabled = False
//	m_blanket_order.m_file.m_insert.Enabled = False
//	m_blanket_order.m_file.m_delete.Enabled = False
//	m_blanket_order.m_file.m_update.Enabled = False
//Else
	m_blanket_order.m_file.m_fastcopy.Enabled = True
	m_blanket_order.m_file.m_editcum.Enabled = True
	m_blanket_order.m_file.m_promisedate.Enabled = True
	m_blanket_order.m_file.m_edi.Enabled = True
	m_blanket_order.m_file.m_relhistory.Enabled = True
	m_blanket_order.m_file.m_custom1.Enabled = True
   m_blanket_order.m_file.m_note.Enabled = True
	m_blanket_order.m_file.m_custom2.Enabled = True
	m_blanket_order.m_file.m_custom3.Enabled = True
	m_blanket_order.m_file.m_insert.Enabled = True
	m_blanket_order.m_file.m_delete.Enabled = True
	m_blanket_order.m_file.m_update.Enabled = True
//End If

dw_3.BringToTop			= TRUE


end event

event ue_edi_setup;gb_edi.Visible = True
dw_edi_setup.Show()
dw_edi_setup.BringtoTop = True
cb_5.Visible = True
cb_6.Visible = True

IF f_get_value ( iOrder ) <> -1  THEN
	dw_edi_setup.SetTransObject(sqlca)
	dw_edi_setup.SetTabOrder("line_feed_code", 20)
	dw_edi_setup.SetTabOrder("zone_code", 10)
	dw_edi_setup.SetTabOrder("Dock_Code", 30)
	dw_edi_setup.Retrieve(iOrder)
ELSE
   dw_edi_setup.InsertRow(1)
END IF

wf_disable_screen()
end event

event ue_save;// Declaration
String 	szPlants, szP
String 	szCum
String 	szDes, szPart, szMod, szPO, szEng
String  ls_Customer
String  ls_CustomerPart
String  ls_Units
Long	iSalesOrder
Dec	ld_Orders
Dec     lFabcum
Dec     lRawcum
Int	iRtnCode
Boolean	bClose
Date	dFabdate
Date	dRawdate

// Main Routine
bClose	= FALSE
dw_1.AcceptText ( )
is_artificialcum = dw_1.object.artificial_cum[1]
szEng = dw_1.GetItemString(1, "engineering_level")
If iOrder = -1 Then		//If this is a brand new order
	If dw_1.object.destination[1] = '' then	//If the destination is invalid
		MessageBox("Warning", "Please enter a valid destination to continue.", StopSign!)
		Return
	End If
	If IsNull ( dw_1.object.blanket_part[1], '' ) = '' then	//If the blanket part number invalid
		MessageBox("Warning", "Please enter a valid part number to continue.", StopSign!)
		Return
	End If
	If Isnull(szEng,'')='' then
		MessageBox ( "Warning!", "You must enter a valid customer engineering revision level before saving order.", Information!, Ok!, 1 )
		wMainScreen.SetMicroHelp ( "Ready" )
		dw_1.SetColumn ( "engineering_level" )
		dw_1.SetFocus ( )
		Return
	End If
	wMainScreen.SetMicroHelp ( "Saving Order..." )
	szCum = dw_1.GetItemString(1, "artificial_cum")
	If Isnull(szCum) then
		MessageBox ( "Warning!", "You must select Release Control before Saving Order.", Information!, Ok!, 1 )
		wMainScreen.SetMicroHelp ( "Ready" )
		dw_1.SetColumn ( "artificial_cum" )
		dw_1.SetFocus ( )
		Return
	End If
	ls_Units = IsNull ( dw_1.object.shipping_unit[1], '' )
	If ls_Units = '' Then
		MessageBox ( "Warning!", "You must select a Unit of Measure before Saving Order.", Information!, Ok!, 1 )
		wMainScreen.SetMicroHelp ( "Ready" )
		dw_1.SetColumn ( "shipping_unit" )
		dw_1.SetFocus ( )
		Return
	End If
	szP = dw_1.GetItemString(1, "Plant")
	SELECT	parameters.plant_required  
	INTO	:szPlants  
	FROM parameters  ;
	If szPlants = "Y" and Isnull(szP) then
		MessageBox ( "Warning", "You must select a plant code required by parameter setup", StopSign! )
		wMainScreen.SetMicroHelp ( "Ready" )
		Return
	End If
	szDes 	= dw_1.object.destination[1]
	szPart 	= dw_1.object.blanket_part[1]
	szMod	= dw_1.object.model_year[1]
	If szMod = '' then
		dw_1.SetItem(1, "model_year", "")
	End If
	szPO	= dw_1.object.customer_po[1]
	If szPO = '' then
		dw_1.SetItem(1, "customer_po", "")
	End If
	ls_Customer = dw_1.object.customer[1]
	ls_CustomerPart = dw_1.object.customer_part[1]
	If ls_CustomerPart = '' Then
		dw_1.SetItem ( 1, "customer_part", "" )
	End If
	lFabcum = dw_raw_fab_cum.GetItemNumber ( 1, "fab_cum" )
	lRawcum = dw_raw_fab_cum.GetItemNumber ( 1, "raw_cum" )
	dFabdate= dw_raw_fab_cum.GetItemdate ( 1, "fab_date" )
	dRawdate = dw_raw_fab_cum.GetItemdate ( 1, "raw_date" )
	dw_1.SetItem ( 1, "fab_cum", lFabcum )
	dw_1.SetItem ( 1, "raw_cum", lRawcum )
	dw_1.SetItem ( 1, "fab_date", dFabdate )
	dw_1.SetItem ( 1, "raw_date", dRawdate )
	SetNull ( ld_Orders )
	SELECT	count(order_header.order_no)  
	INTO	:ld_Orders 
	FROM	order_header  
	WHERE	( order_header.destination	= :szDes ) AND  
		( order_header.blanket_part	= :szPart ) AND  
		( order_header.model_year	= :szMod ) AND
		( order_header.customer_po	= :szPO) AND
		( order_header.customer_part	= :ls_CustomerPart );

	If ld_Orders > 0 Then 
		If MessageBox ( "Error", "You have entered a duplicated Blanket Order. You cannot enter the same destination, part, customer part, customer PO number, or model year in more than one release.  Would you like to make a change?", Question!, YesNo!) = 1 Then
			Return
		Else
			wMainScreen.SetMicroHelp ( "Exiting Blanket Order Maintainance..." )
			bClose	= TRUE
		End If
	End If

	If (Not bClose) then

		if NOT sqlca.of_getnextparmvalue ( "sales_order", iSalesOrder ) then
			MessageBox ("Warning", "Failed to get a new order number, please save again", StopSign!)
			wMainScreen.SetMicroHelp ( "Ready" )	
			Return
		End If

		dw_1.SetItem ( 1, "order_no", iSalesOrder )
		dw_1.SetItem ( 1, "order_type", 'B' )

		if wf_checkcenglevel() = false then return
	
		If dw_1.Update ( ) = 1 Then
			commit ;
			dw_1.Retrieve ( iSalesOrder )
			commit;
			iOrder = iSalesOrder
			bHeaderSaved = TRUE
			bChanged = False
			// below 4 inc by gph on 7/29/98 at 11:30 am
			IF dw_kanban_inv_for_orders.rowcount() > 0 THEN
				IF dw_kanban_inv_for_orders.getitemstring(1,'location')<>'' THEN
					dw_kanban_inv_for_orders.update()			
				END IF	
			END IF	  
			if dw_1.GetItemString ( 1, "status_type" ) <> 'A' then
				MessageBox ( "Save Order", "The order has been saved, however, this order's status is " + dw_1.GetItemString ( 1, "cs_status" ) + ".  You will be able to do everything except physically ship out the order.", Information! )
			end if
		Else
			Rollback ;
		End if
	Else
		Close(w_blanket_order)
	End If
Else
	// below 4 inc by gph on 7/29/98 at 11:30 am	
	IF dw_kanban_inv_for_orders.rowcount() > 0 THEN	
		IF dw_kanban_inv_for_orders.getitemstring(1,'location')<>'' THEN	
			dw_kanban_inv_for_orders.update()				
		END IF 	
	END IF 
	TriggerEvent("update_release")
End if

end event

event ue_kanban_inv_detail;Long l_l_stdpack
IF szpart<>'' THEN
  IF dw_kanban_inv_for_orders.visible = FALSE THEN
     IF dw_kanban_inv_for_orders.rowcount() = 0 THEN 
		  l_l_stdpack=dw_1.getitemnumber(1,'standard_pack')
	     dw_kanban_inv_for_orders.retrieve(szpart,szdest,l_l_stdpack)	
//        dw_kanban_inv_for_orders.setitem(1,'destination',szdest)
     END IF   
     dw_kanban_inv_for_orders.show()
  ELSE	
     dw_kanban_inv_for_orders.hide()	
  END IF 	
END IF   
end event

event ue_unapproved_message;MessageBox ( "Existing Order", "This order's status is " + dw_1.GetItemString ( 1, "cs_status" ) + ".  You will be able to do everything except physically ship out the order.", Information! )

end event

event ue_print;/*		Declare Variables		*/
st_print_preview_generic	lstr_Parm

/*		Initialize Variables		*/
lstr_Parm.Form_type = "Sales Order - Blanket"
lstr_Parm.Document_number = iOrder
lstr_Parm.Calling_window = w_blanket_order

/*		Main		*/
OpenSheetWithParm ( w_print_preview, lstr_Parm, wMainScreen, 3, Layered! )

end event

public function decimal get_value (decimal value);If IsNull(value) then
	Return 0
Else
	Return value
End If
end function

public subroutine recalc_releases ();//************************************************************************
//* Declaration
//************************************************************************
Long iTotalRow
Long iRow

Boolean bDelete
Boolean bConvert

Decimal nOurCum
Decimal nTheCum
Decimal nNetQty
Decimal nStdQty
Decimal nRatio

String  szShipType

//************************************************************************
//* Initialization
//************************************************************************

If dw_1.object.ship_type[1] = 'N' then
	szShipType	= 'N'
Else
	szShipType	= 'D'
End If

szUM		= dw_1.GetItemString(1, "shipping_unit")
szPart	= dw_1.GetItemString(1, "blanket_part")

bConvert	= (f_get_string_value(szUM) <> f_get_part_info(szPart, 'STANDARD UNIT')) AND &
			  (Not IsNull(szUM))

If bConvert then
	nRatio	= f_convert_units(szUM, "", szPart, 1)
Else
	nRatio	= 1
End If

For iRow = 1 to iDelCount
	iDelArray[iRow] = 0
Next 

iDelCount = 0

//************************************************************************
//* Main Routine
//************************************************************************
dw_2.Retrieve(iOrder, is_artificialcum)
iTotalRow = dw_2.RowCount()

dw_2.SelectRow(0, FALSE)
dw_2.SetSort("1a")
dw_2.Sort()

For iRow = 1 to dw_2.RowCount()

	If iRow = 1 then
		nOurCum 	= Get_value(dw_1.GetItemNumber(1, "our_cum"))
	Else
		nOurCum	= nTheCum
	End If

	If dw_1.GetItemString(1, "artificial_cum") = "N" then
		nNetQty = Get_value(dw_2.GetItemNumber(iRow, "quantity"))
		nTheCum = nOurCum + nNetQty
		nSTdQty	= nNetQty * nRatio
		dw_2.SetItem(iRow, 'std_qty', nStdQty)
	Else
		nTheCum = Get_value(dw_2.GetItemNumber(iRow, "the_cum"))
		nNetQty = nTheCum - nOurCum
		If nNetQty <= 0 then				//Send to DelArray
			nTheCum							= nOurCum
			iDelArray[iDelCount + 1]	= iRow
			iDelCount						= iDelCount + 1
		Else
			nStdQty	= nNetQty * nRatio
			dw_2.SetItem(iRow, "std_qty", nStdQty)
		End If
	End If
	
	dw_2.SetItem(iRow, "quantity", nNetQty)
	dw_2.SetItem(iRow, "our_cum",	 nOurCum)
	dw_2.SetItem(iRow, "the_cum",  nTheCum)
	dw_2.SetItem(iRow, "week_no",  f_get_week_no(Date(dw_2.GetItemDateTime(iRow, "due_date"))))
	dw_2.SetItem(iRow, "plant", 	 szPlant)
	dw_2.SetItem(iRow, "ship_type", szShipType)
	dw_2.SetItem ( iRow, "sequence", 9999 - iRow )
	
// below 3 lines were original code
	If szShipType = 'D' then
		dw_2.SetItem(iRow, "flag", 0)
	End If

Next 

For iRow = iDelCount to 1 Step -1
	iReleaseRow	= iDelArray[iRow]
	w_blanket_order.TriggerEvent("delete_release")
Next	

If dw_2.Update() > 0 then
	Commit;
	for iRow = 1 to dw_2.RowCount ( )
		dw_2.SetItem ( iRow, "sequence", iRow )
	next
	If dw_2.Update() > 0 then
		Commit;
		dw_2.Retrieve(iOrder, is_artificialcum)
	else
		rollback;
	end if
Else
	RollBack;
End If
iReleaseRow	= 0

end subroutine

public subroutine wf_write_shipping_history ();Long iShipper

dw_3.SetFilter ( "operator > ''" )
dw_3.Filter ( )
If dw_3.RowCount() > 0 then
	iShipper	= dw_3.GetItemNumber(dw_3.RowCount(), "shipper")
	dw_3.InsertRow(1)
	dw_3.SetItem(1, "accum_shipped", Dec(sle_cum.text))
	dw_3.SetItem(1, "date_shipped", Today())
	dw_3.SetItem(1, "shipper", iShipper)
	dw_3.SetItem(1, "part",	"CUM_CHANGE" + String(dw_3.RowCount() + 1))
	dw_3.SetItem(1, "order_no", dw_1.GetItemNumber(1, "order_no"))
	dw_3.SetItem(1, "note", szReturnedString)
	dw_3.SetItem(1, "operator", szOperator)
	If dw_3.Update() > 0 then
		Commit;
	Else
		Rollback;
	End If
End If
dw_3.SetFilter ( "" )
dw_3.Filter ( )
dw_3.Retrieve ( iOrder )
end subroutine

public subroutine show_reason ();mle_1.Text = ''
cb_1.Visible = True
cb_2.Visible = True
cb_3.Visible = True
st_2.Visible = True
mle_1.Visible = True

cb_1.BringToTop = True
cb_2.BringToTop = True
cb_3.BringToTop = True
st_2.BringToTop = True
mle_1.BringToTop = True

mle_1.SetFocus ( )
end subroutine

public subroutine hide_reason ();cb_1.Visible = False
cb_2.Visible = False
cb_3.Visible = False

st_2.Visible = False
mle_1.Visible = False
end subroutine

public subroutine wf_show_note (boolean bflag);cb_note.visible			= bFlag
cb_note_save.visible		= bFlag
cb_note_cancel.visible	= bFlag
mle_note.visible			= bFlag

end subroutine

public subroutine wf_create_dropdown ();//Integer 	iCount			//Current index in list box
//Long 		iTotalUnits		//Total items in list box
//
//iTotalUnits	= lb_unit.TotalItems()
//ddlb_unit.Reset()
//
//For iCount	= 1 to iTotalUnits
//	ddlb_unit.AddItem(lb_unit.Text(iCount))
//Next
//
//
//
end subroutine

public function integer wf_valid_data ();Long iRow
Boolean bValid
Date	dDate

bValid = TRUE

iRow	= 1
Do while bValid AND (iRow <= dw_2.RowCount())
	
	dDate	= Date ( dw_2.GetItemDateTime (iRow, "due_date") )
	If IsNull(dDate) then
		bValid	= FALSE
   	MessageBox("Datawindow Error", "Date must be entered in row " + string(iRow) + "!", Exclamation!)
      Return irow
	Else
		iRow ++
	End If
Loop

If bValid then
	iRow = 0
End If

Return iRow	
end function

public function boolean wf_need_to_explode ();Long 		iRow
Long		iTotalRows

Boolean	bFound

iTotalRows	= dw_2.RowCount()
iRow			= 1

bFound		= FALSE

Do while (Not bFound) AND (iRow <= iTotalRows)
	bFound	= (dw_2.GetItemNumber(iRow, "flag") = 1)
	iRow ++
Loop

Return bFound
end function

public subroutine wf_clear_mps ();Long iRow
Long iTotalRows
Long iRowId

iTotalRows	= dw_2.RowCount()

For iRow = 1 to iTotalRows

	If dw_2.GetItemNumber(iRow, "flag") = 1 then

		iRowId 			= dw_2.GetItemNumber(iRow, "row_id")

		Delete From master_prod_sched  
		Where ( origin = :iOrder ) And
		  		( source = :iRowId )   ;

	End If

Next

If SQLCA.SQLCode = 0 then
	Commit;
Else
	Rollback;
End If
end subroutine

public function boolean wf_part_is_staged (string szpart, long iorder);Integer iCount

Select count(*)  
  Into :iCount  
  From  shipper,   
        shipper_detail  
 Where ( shipper.id = shipper_detail.shipper ) and  
       ( shipper.status = 'S' or
         shipper.status = 'O' ) and 
       ( shipper_detail.part = :szPart) AND
		 ( shipper_detail.order_no = :iOrder) AND
		 ( shipper_detail.order_no > 0 )	  ;

Return (iCount > 0)



end function

public function decimal wf_get_qty_for_pack (string szpart, string szpackage);Decimal nStdPack

SELECT quantity  
  INTO :nStdPack  
  FROM part_packaging  
 WHERE ( part = :szPart ) AND  
       ( code = :szPackage)   ;

Return nStdPack
end function

public subroutine wf_disable_screen ();m_blanket_order.m_file.m_insert.Enabled = False
m_blanket_order.m_file.m_delete.Enabled = False
m_blanket_order.m_file.m_update.Enabled = False
m_blanket_order.m_file.m_relhistory.Enabled = False
m_blanket_order.m_file.m_edi.Enabled = False
m_blanket_order.m_file.m_editcum.Enabled = False
m_blanket_order.m_file.m_shiphistory.Enabled = False
m_blanket_order.m_file.m_fastcopy.Enabled = False
m_blanket_order.m_file.m_note.Enabled = False
m_blanket_order.m_file.m_promisedate.Enabled = False
m_blanket_order.m_file.m_custom1.Enabled = False
m_blanket_order.m_file.m_custom2.Enabled = False
m_blanket_order.m_file.m_custom3.Enabled = False
//m_blanket_order.m_file.m_exit.Enabled = False
p_note.Enabled = False
dw_1.Enabled = False
dw_2.Enabled = False
dw_raw_fab_cum.Enabled = False
//ddlb_unit.Enabled = False
//ddlb_ship_type.Enabled = False


end subroutine

public subroutine wf_enable_screen ();m_blanket_order.m_file.m_insert.Enabled = True
m_blanket_order.m_file.m_delete.Enabled = True
m_blanket_order.m_file.m_update.Enabled = True

m_blanket_order.m_file.m_relhistory.Enabled = True
m_blanket_order.m_file.m_edi.Enabled = True
m_blanket_order.m_file.m_editcum.Enabled = True
m_blanket_order.m_file.m_shiphistory.Enabled = True
m_blanket_order.m_file.m_fastcopy.Enabled = True
m_blanket_order.m_file.m_note.Enabled = True
m_blanket_order.m_file.m_promisedate.Enabled = True
m_blanket_order.m_file.m_custom1.Enabled = True
m_blanket_order.m_file.m_custom2.Enabled = True
m_blanket_order.m_file.m_custom3.Enabled = True
//m_blanket_order.m_file.m_exit.Enabled = True
p_note.Enabled = True
dw_1.Enabled = True
dw_2.Enabled = True
dw_raw_fab_cum.Enabled = True
//ddlb_unit.Enabled = True
//ddlb_ship_type.Enabled = True

//wMainScreen.Enabled = True
end subroutine

public subroutine wf_resetflag ();int    i_totrow,i_row
i_TotRow = dw_2.Retrieve(iorder, is_artificialcum)

For i_row = 1 to i_TotRow
  	dw_2.SetItem(i_row, "flag", 0)
Next 

if dw_2.update() = 1 then
   commit ;
else 
   rollback ;
end if
end subroutine

public function long wf_create_order_from_quote (long a_l_quote);//	Declarations
string	l_s_calctype,&
	l_s_customer,&
	l_s_contact,&
	l_s_status,&
	l_s_dest,&
	l_s_salesman,&
	l_s_notes,&
	l_s_part,&
	l_s_name,&
	l_s_unit,&
	l_s_terms,&
	l_s_plant, &
	ls_status, &
	ls_currency_unit, &
	ls_customerpart
long	l_l_order,&
	l_l_rowid
datetime	l_dt_quote_date,&
		l_dt_orderdate
int	l_i_sequence, &
	li_show_euro
dec	l_dec_price,&
	l_dec_qty,&
	l_dec_cost,&
	l_dec_unitweight,&
	l_dec_weight,&
	l_dec_quantity
datawindowchild	l_dwc_child

// Get calc type from parameters table
select	parameters.inv_reg_col  
into	:l_s_calctype  
from	parameters;

//	Get quote header information
select	quote.customer,   
	quote.quote_date,   
	quote.contact,   
	quote.status,   
	quote.destination,   
	quote.salesman,   
	quote.notes  
into	:l_s_customer,   
	:l_dt_quote_date,   
	:l_s_contact,   
	:l_s_status,   
	:l_s_dest,   
	:l_s_salesman,   
	:l_s_notes  
from	quote  
where	quote.quote_number = :a_l_quote;

//	Get quote detail information
select	quote_detail.sequence,   
	quote_detail.part,   
	quote_detail.product_name,   
	quote_detail.price,   
	quote_detail.quantity,   
	quote_detail.cost,   
	quote_detail.notes,   
	quote_detail.unit  
into	:l_i_sequence,   
	:l_s_part,   
	:l_s_name,   
	:l_dec_price,   
	:l_dec_qty,   
	:l_dec_cost,   
	:l_s_notes,   
	:l_s_unit  
from	quote_detail  
where	quote_detail.quote_number = :a_l_quote;

//	Get data from customer table
select	terms ,
	cs_status,
	default_currency_unit,
	show_euro_amount
into	:l_s_terms ,
	:ls_status,
	:ls_currency_unit,
	:li_show_euro
from	customer
where	customer = :l_s_customer ;

//	Get customer part
select	part_customer.customer_part
into	:ls_customerpart
from	part_customer  
where	( part_customer.part = :l_s_part ) and  
	( part_customer.customer = :l_s_customer );

l_dt_orderdate = DateTime ( Today ( ), Now ( ) )

// Determine the calculated unit for price (quantity or weight) and calculate
// the weight and price based on this
select	unit_weight
into	:l_dec_unitweight
from	part_inventory
where	part = :l_s_part;
	
l_dec_weight	= f_convert_units ( l_s_unit, '', l_s_part, l_dec_quantity ) * l_dec_unitweight
l_l_rowid	= f_get_random_number ( )
	
dw_1.BringToTop = TRUE
dw_1.SetTransObject(sqlca)
dw_1.InsertRow ( 1 )

//	Insert values into header dw
dw_1.object.our_cum[1]		= 0
dw_1.object.order_date[1]	= Today()
dw_1.object.price_unit[1]	= "P"
dw_1.object.destination[1]	= l_s_dest
dw_1.object.customer[1] 	= l_s_customer
dw_1.object.customer.protect	= 1
dw_1.object.customer.background.color	= f_get_color_value ( "gray" )
dw_1.object.blanket_part[1]	= l_s_part
dw_1.object.price[1]		= l_dec_price
dw_1.object.price_unit[1]	= 'P'
dw_1.object.term[1]		= l_s_terms
dw_1.object.salesman[1]		= l_s_salesman
dw_1.object.plant[1]		= l_s_plant
dw_1.object.shipping_unit[1]	= l_s_unit
dw_1.object.artificial_cum[1]	= 'N'
dw_1.object.cs_status[1]	= ls_status
dw_1.object.currency_unit[1]	= ls_currency_unit
dw_1.object.show_euro_amount[1]	= li_show_euro
dw_1.object.customer_part[1]	= ls_customerpart

//	Retrieve child datawindows
dw_1.GetChild ( "package_type", l_dwc_child )
l_dwc_child.SetTransObject ( sqlca )
l_dwc_child.Retrieve ( l_s_part )

dw_1.GetChild ( "shipping_unit", l_dwc_child )
l_dwc_child.SetTransObject ( sqlca )
l_dwc_child.Retrieve ( l_s_part )

p_note.BringToTop = True
dw_raw_fab_cum.InsertRow (1)
bHeaderSaved	= FALSE	/*To inform that header has not been saved*/

//	Return order no
return iorder


end function

public subroutine wf_get_packaging_types (string a_s_part);datawindowchild	l_dwc_dest
datawindowchild	l_dwc_packagetype

dw_1.GetChild ( "destination", l_dwc_dest )

l_dwc_dest.SetTransObject ( sqlca )
l_dwc_dest.Retrieve ( a_s_part )

dw_1.GetChild ( "package_type", l_dwc_packagetype )
		l_dwc_packagetype.SetTransObject ( sqlca )
		l_dwc_packagetype.Retrieve ( szPart )

//String szPackCode
//
//Declare curPackage Cursor For  
// Select part_packaging.code  
//   From part_packaging  
//  Where part_packaging.part = :szPart;
//
//dwcPack.Reset()
//
//Open curPackage;
//
//Fetch curPackage into :szPackCode;
//
//Do while SQLCA.SQLCode = 0 
//	dwcPack.InsertRow(1)
//	dwcPack.SetItem(1, 1, szPackCode)
//	Fetch curPackage into :szPackCode;
//Loop
//
//Close curPackage;
//
//
//	

  

end subroutine

public subroutine wf_change_cop_flag (long aiorder);//UPDATE order_detail  
//   SET flag = 2  
// WHERE ( order_no = :aiOrder ) AND  
//       ( flag = 1 )   ;
//
//If SQLCA.SQLCode = 0 then
//	Commit;
//Else
//	Rollback;
//End If
end subroutine

public subroutine wf_set_cop_normal_flag (long aiorder);//UPDATE order_detail  
//   SET flag = 1  
// WHERE ( order_no = :aiOrder ) AND  
//       ( flag = 2 )   ;
//
//If SQLCA.SQLCode = 0 then
//	Commit;
//Else
//	Rollback;
//End If
end subroutine

public function boolean wf_checkcenglevel ();string	ls_dcustom1, ls_customer

ls_customer = dw_1.object.customer[1]

select	custom1
into	:ls_dcustom1
from	destination
where	destination = :szdest and
	customer = :ls_customer;

if isnull(ls_dcustom1,'N') = 'Y' then
	if isnull(dw_1.object.engineering_level[1],'') = '' then 
		MessageBox ( monsys.msg_title, "This customer/destination needs a revision level, can't save the data otherwise", Information! )
		return false
	else
		return true
	end if 	
else
	return true
end if

end function

event open;// 04/03/00	cbr	added initialization of il_maxrowid to 0
// Declare local variables
String 					szNull
String					ls_Part
String					szPackage
String   				ls_Units
String					ls_status
datetime	ldt_prodend

Boolean 					bAddNew
st_generic_structure	l_str_parm
datawindowchild		ldwc_dddw

wMainScreen.ChangeMenu(m_blanket_order)

il_maxrowid = 0		// 04/03/00 cbr	added

SELECT dda_required
INTO :is_ddarequired
FROM parameters ;

if IsValid ( Message.PowerObjectParm ) then
	l_str_parm = Message.PowerObjectParm
	if isnull(l_str_parm.value1,'') > '' then
		wf_create_order_from_quote ( long ( l_str_parm.value1 ) )
	else
		is_customer = l_str_parm.value2
		szDest = l_str_parm.value3
	end if
	iOrder = -1
	bHeaderSaved = FALSE
else
	iOrder = Message.DoubleParm
	bHeaderSaved = TRUE
end if

This.SetRedraw ( True )

If f_get_value ( iOrder ) <= 0 Then
	
	iOrder = -1
	if dw_1.RowCount ( ) <= 0 then
		dw_1.InsertRow ( 1 )
		dw_1.object.our_cum[1] 		= 0
		dw_1.object.order_date[1] 	= Today()
		dw_1.object.price_unit[1]	= "P"
		dw_1.object.customer[1] = is_customer
		if isnull(is_customer,'') > '' then
			select cs_status into :ls_status from customer where customer = :is_customer ;
			dw_1.GetChild ( "destination", ldwc_dddw )
			ldwc_dddw.SetFilter ( "customer = '" + is_customer + "'" )
			ldwc_dddw.Filter ( )
			dw_1.SetItem ( 1, "cs_status", ls_status )
		end if
		dw_1.object.destination[1] = szdest
		dw_1.object.ship_type[1] = 'N'
	end if
	
	dw_raw_fab_cum.InsertRow (1)

Else
	dw_1.GetChild ( "destination", ldwc_dddw)
	ldwc_dddw.InsertRow ( 0 )
	dw_1.GetChild ( "blanket_part", ldwc_dddw)
	ldwc_dddw.InsertRow ( 0 )
	dw_1.GetChild ( "customer_part", ldwc_dddw)
	ldwc_dddw.InsertRow ( 0 )
	dw_1.GetChild ( "package_type", ldwc_dddw)
	ldwc_dddw.InsertRow ( 0 )
	dw_1.GetChild ( "shipping_unit", ldwc_dddw)
	ldwc_dddw.InsertRow ( 0 )
	
	dw_1.Retrieve ( iOrder )
	is_artificialcum = dw_1.object.artificial_cum[1]	
	dw_2.Retrieve ( iOrder, is_artificialcum )
	dw_3.Retrieve ( iOrder )
        dw_raw_fab_cum.Retrieve ( iOrder )

	If dw_1.RowCount() > 0 then
		szPart		= dw_1.GetItemString(1, "blanket_part")
		szdest      = dw_1.GetItemString(1, "destination")
		szPackage	= dw_1.GetItemString(1, "package_type")
		dw_1.SetItem(1, "standard_pack", wf_get_qty_for_pack(szPart, szPackage))
		bHaveNote = ( dw_1.GetItemString(1, "notes") > " " )

		select	prod_end
		into	:ldt_prodend
		from	part_eecustom
		where	part = :szpart;
		
		if isnull(ldt_prodend) then ldt_prodend = datetime('00/00/00')
		st_release.text = "Prodn. End Date: "+string(ldt_prodend, 'mm/dd/yy')+"                   Releases"
		
		wf_get_packaging_types ( szPart )
		is_previous_currency = dw_1.GetItemString ( 1, "currency_unit" )
		if dw_1.GetitemString ( 1, "status_type" ) <> 'A' then
			Post event ue_unapproved_message ( )
		end if
	End If
		
	bAddNew 	= FALSE
	
	dw_1.SetColumn ( "customer_po" )

End if

dw_1.SetFocus()

w_blanket_order.SetMicroHelp("Ready")

end event

event activate;if wmainscreen.menuname <> "m_blanket_order" then &
	wMainScreen.ChangeMenu(m_blanket_order)

// Added for Custom menu items
	f_build_custom_arrays("monitor.oeblanket")
// Added for Custom menu items
	f_build_custom_menu(wMainScreen.MenuID, wMainScreen)

end event

event closequery;Int iRtnCode

// Check Routine

If bChanged Then

  iRtnCode = MessageBox ( "Warning", "Would you like to save the changes?", Exclamation!, YesNoCancel!, 3 )

  Choose Case iRtnCode

    Case 1
 
       If Not bheaderSaved Then

          m_blanket_order.m_file.m_update.TriggerEvent(Clicked!)

		 Else

	       TriggerEvent ( "update_release" )

       End If

       If bChanged Then
            Message.ReturnValue = 1
       End If

    Case 2
        Close ( w_blanket_order ) 

    Case 3
        Message.ReturnValue = 1

  End Choose

Else

  Close ( w_blanket_order ) 

End If


end event

event timer;If bEditCum then
	If sle_cum.backcolor	= 16777215 then
		sle_cum.backcolor	= w_blanket_order.backcolor
	Else
		sle_cum.backcolor	= 16777215
	End If

End if

If bFinish then
	bFinish	= FALSE
//	is_artificialcum = dw_1.object.artificial_cum[1]
	dw_2.Retrieve(iOrder, is_artificialcum)
	bFinish	= FALSE
End If

If bHaveNote then
	If p_note.picturename	= "noteyes.bmp" then
		p_note.picturename	= "noteno.bmp"
	Else
		p_note.picturename	= "noteyes.bmp"
	End If
End If
	
end event

on w_blanket_order.create
this.dw_raw_fab_cum=create dw_raw_fab_cum
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_2=create cb_2
this.cb_note_save=create cb_note_save
this.cb_note_cancel=create cb_note_cancel
this.sle_cum=create sle_cum
this.cb_3=create cb_3
this.st_message=create st_message
this.lb_unit=create lb_unit
this.st_program_name=create st_program_name
this.st_mini_cop=create st_mini_cop
this.st_cop=create st_cop
this.p_cop=create p_cop
this.st_release=create st_release
this.sle_mini_cop=create sle_mini_cop
this.st_2=create st_2
this.mle_1=create mle_1
this.cb_1=create cb_1
this.dw_3=create dw_3
this.cb_note=create cb_note
this.mle_note=create mle_note
this.dw_stack=create dw_stack
this.dw_2=create dw_2
this.cb_4=create cb_4
this.gb_edi=create gb_edi
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_edi_setup=create dw_edi_setup
this.p_note=create p_note
this.gb_1=create gb_1
this.dw_kanban_inv_for_orders=create dw_kanban_inv_for_orders
this.st_history=create st_history
this.Control[]={this.dw_raw_fab_cum,&
this.cb_6,&
this.cb_5,&
this.cb_2,&
this.cb_note_save,&
this.cb_note_cancel,&
this.sle_cum,&
this.cb_3,&
this.st_message,&
this.lb_unit,&
this.st_program_name,&
this.st_mini_cop,&
this.st_cop,&
this.p_cop,&
this.st_release,&
this.sle_mini_cop,&
this.st_2,&
this.mle_1,&
this.cb_1,&
this.dw_3,&
this.cb_note,&
this.mle_note,&
this.dw_stack,&
this.dw_2,&
this.cb_4,&
this.gb_edi,&
this.gb_2,&
this.dw_1,&
this.dw_edi_setup,&
this.p_note,&
this.gb_1,&
this.dw_kanban_inv_for_orders,&
this.st_history}
end on

on w_blanket_order.destroy
destroy(this.dw_raw_fab_cum)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_2)
destroy(this.cb_note_save)
destroy(this.cb_note_cancel)
destroy(this.sle_cum)
destroy(this.cb_3)
destroy(this.st_message)
destroy(this.lb_unit)
destroy(this.st_program_name)
destroy(this.st_mini_cop)
destroy(this.st_cop)
destroy(this.p_cop)
destroy(this.st_release)
destroy(this.sle_mini_cop)
destroy(this.st_2)
destroy(this.mle_1)
destroy(this.cb_1)
destroy(this.dw_3)
destroy(this.cb_note)
destroy(this.mle_note)
destroy(this.dw_stack)
destroy(this.dw_2)
destroy(this.cb_4)
destroy(this.gb_edi)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_edi_setup)
destroy(this.p_note)
destroy(this.gb_1)
destroy(this.dw_kanban_inv_for_orders)
destroy(this.st_history)
end on

type dw_raw_fab_cum from datawindow within w_blanket_order
int X=3803
int Y=48
int Width=457
int Height=640
int TabOrder=30
string DataObject="dw_raw_fab_cum"
boolean Border=false
boolean LiveScroll=true
end type

on itemchanged;bChanged = True
end on

on editchanged;bChanged = True
end on

event constructor;settransobject ( sqlca )
end event

type cb_6 from commandbutton within w_blanket_order
int X=1527
int Y=892
int Width=247
int Height=108
int TabOrder=120
boolean Visible=false
string Text="Cancel"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;gb_edi.Visible = False
dw_edi_setup.Visible = False
cb_5.Visible = False
cb_6.Visible = False

wf_enable_Screen()

end on

type cb_5 from commandbutton within w_blanket_order
int X=1239
int Y=892
int Width=247
int Height=108
int TabOrder=100
boolean Visible=false
string Text="Save"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;IF bHeaderSaved THEN
	If dw_edi_setup.Update() > 0 then
		Commit;
	   cb_6.TriggerEvent(clicked!)
	Else
		Rollback;
	   wf_enable_Screen()
	End If
ELSE
   messageBox ("Error", "You must save the order header first!" )
   cb_6.TriggerEvent(clicked!)
   wf_enable_Screen()
END IF

end on

type cb_2 from commandbutton within w_blanket_order
int X=878
int Y=800
int Width=329
int Height=128
int TabOrder=150
boolean Visible=false
string Text="&Ok"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;hide_reason ( )
wf_enable_screen ( )

m_blanket_order.m_file.m_insert.Enabled = False
m_blanket_order.m_file.m_delete.Enabled = False
m_blanket_order.m_file.m_update.Microhelp = "Update Release"

szReturnedString = mle_1.Text

Timer ( .5 )

sle_cum.text		= String(dw_1.GetItemNumber(1, "our_cum"))
sle_cum.visible	= TRUE

sle_cum.SetFocus ( )
end on

type cb_note_save from commandbutton within w_blanket_order
int X=1737
int Y=512
int Width=238
int Height=112
int TabOrder=220
boolean Visible=false
string Text="Save"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;If dw_1.RowCount() > 0 then
	dw_1.SetItem(1, "notes", mle_note.text)
	If dw_1.Update() > 0 then
		Commit;
	Else
		Rollback;
	End If
End If

wf_show_note(FALSE)	
wf_enable_screen ( )
m_blanket_order.wf_reset_screen() // this is to reset the menu buttons if shp hist is active

If dw_1.GetItemString(1, "notes") > " " then
	p_note.picturename	= "noteyes.bmp"
	bHaveNote				= TRUE
Else
	p_note.picturename	= "noteno.bmp"
	bHaveNote				= FALSE
End If
end on

type cb_note_cancel from commandbutton within w_blanket_order
int X=2011
int Y=512
int Width=238
int Height=112
int TabOrder=210
boolean Visible=false
string Text="&Cancel"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;wf_show_note(FALSE)	
wf_enable_screen ( )
m_blanket_order.wf_reset_screen() 
end on

type sle_cum from singlelineedit within w_blanket_order
int X=2373
int Y=588
int Width=411
int Height=72
int TabOrder=200
boolean Visible=false
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;bChanged = True
end on

type cb_3 from commandbutton within w_blanket_order
int X=1243
int Y=800
int Width=329
int Height=128
int TabOrder=160
boolean Visible=false
string Text="&Cancel"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;hide_reason ( )
wf_enable_screen ( )
m_blanket_order.wf_reset_screen()
end on

type st_message from statictext within w_blanket_order
int X=567
int Y=912
int Width=1842
int Height=128
boolean Visible=false
boolean Enabled=false
boolean Border=true
string Text="Recalculating releases, please wait..."
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=255
long BackColor=12632256
long BorderColor=12632256
int TextSize=-16
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type lb_unit from listbox within w_blanket_order
int X=1792
int Y=1556
int Width=494
int Height=364
int TabOrder=60
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_program_name from statictext within w_blanket_order
int X=46
int Y=4
int Width=773
int Height=76
boolean Visible=false
boolean Enabled=false
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_mini_cop from statictext within w_blanket_order
int X=37
int Y=640
int Width=306
int Height=80
boolean Visible=false
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="Mini COP"
boolean FocusRectangle=false
long TextColor=255
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_cop from statictext within w_blanket_order
int X=1957
int Y=736
int Width=306
int Height=48
boolean Enabled=false
string Text="Ready for COP"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=16777215
int TextSize=-7
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_cop from picture within w_blanket_order
int X=1883
int Y=728
int Width=73
int Height=60
string PictureName="logo2.bmp"
boolean FocusRectangle=false
end type

type st_release from statictext within w_blanket_order
int X=23
int Y=720
int Width=4274
int Height=80
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="      Releases"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_mini_cop from singlelineedit within w_blanket_order
int X=311
int Y=640
int Width=969
int Height=148
int TabOrder=240
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=16776960
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_blanket_order
int X=878
int Y=480
int Width=1463
int Height=64
boolean Visible=false
boolean Enabled=false
string Text="Please Enter Reason For Editing Cum:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type mle_1 from multilineedit within w_blanket_order
int X=878
int Y=576
int Width=1463
int Height=192
int TabOrder=230
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_blanket_order
int X=841
int Y=448
int Width=1536
int Height=512
int TabOrder=180
boolean Visible=false
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_3 from datawindow within w_blanket_order
int X=37
int Y=764
int Width=2811
int Height=656
int TabOrder=140
boolean Visible=false
string DataObject="dw_shipping_history"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

on doubleclicked;String 	szShipper
String	szPart
st_generic_structure stParm

Long		iRow

iRow 	= this.GetClickedRow()

If iRow > 0 then
	szPart			= dw_1.GetItemString(1, "blanket_part")
	szShipper		= String(this.GetItemNumber(iRow, "shipper"))
	
	stParm.value1	= szPart
	stParm.value2	= szShipper
	
	OpenWithParm(w_display_objects_per_shipper, stParm)

End If

end on

event constructor;settransobject ( sqlca )
end event

type cb_note from commandbutton within w_blanket_order
int X=695
int Y=36
int Width=1682
int Height=636
int TabOrder=190
boolean Visible=false
boolean Enabled=false
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type mle_note from multilineedit within w_blanket_order
int X=818
int Y=92
int Width=1440
int Height=396
int TabOrder=40
boolean Visible=false
long TextColor=33554432
long BackColor=16776960
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_stack from datawindow within w_blanket_order
int X=585
int Y=352
int Width=1865
int Height=928
int TabOrder=170
boolean Visible=false
string DataObject="dw_stack"
boolean TitleBar=true
string Title="Mini COP "
boolean LiveScroll=true
end type

type dw_2 from datawindow within w_blanket_order
event ue_keypress pbm_dwnkey
event type integer ue_invalidquantity ( decimal adec_recommend )
int X=18
int Y=800
int Width=4343
int Height=1076
int TabOrder=130
string DataObject="dw_release_detail"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event ue_keypress;if is_ddarequired = 'Y' THEN 
	if key = keytab! or key = keyenter! then
		If (dw_2.getcolumnname()='quantity') then 	
			Long   li_current_row
			li_current_row = dw_2.getrow()
			dw_2.accepttext()
			st_prmlst.s_arg_part   = dw_2.object.part_number[li_current_row]
			st_prmlst.s_arg_module = dw_1.object.shipping_unit[1]
			st_prmlst.s_rtn_qtystr = dw_2.object.dimension_qty_string[li_current_row]
			st_prmlst.s_rtn_qty    = dw_2.object.quantity[li_current_row] 
			Openwithparm(w_dda,st_prmlst)
			st_prmlst = Message.PowerObjectparm
			dw_2.setitem(li_current_row,'quantity',st_prmlst.s_rtn_qty)
			dw_2.setitem(li_current_row,'dimension_qty_string',st_prmlst.s_rtn_qtystr)
		end if 
	end if 	
END IF  


end event

event ue_invalidquantity;if MessageBox ( monsys.msg_title, "Quantity entered is not in standard pack increment!  Would you like to default the recommended amount of " + String ( adec_recommend, "##########" ) + "?", Question!, YesNo!, 1 ) = 1 then
	dw_2.SetItem ( 1, "quantity", adec_recommend )
end if

return 1

end event

event clicked;iReleaseRow = dw_2.GetClickedRow()
dw_2.SetColumn("quantity")
dw_2.SetRow(iReleaseRow)


end event

event itemchanged;// changes log (date	user	notes)
//	3/30/00	cbr	added checking for divisibility of standard pack

string	ls_part
date 		d_date
decimal	ldec_unit_weight
// cbr added following 3/30/00
string	ls_unit
string	ls_customer
decimal	ldec_stdpack
decimal	ldec_quantity
decimal	ldec_recommend
// cbr end adding 3/30/00

bChanged = True

Choose Case dwo.name
	case "due_date"
		d_Date	= Date ( data )
		If IsNull(d_Date) then
			MessageBox("Datawindow Error", "Date must be entered!", Exclamation!)
			return
		End If

	case  "the_cum"
		If Long (dw_2.Gettext()) <= dw_2.GetItemNumber ( dw_2.GetRow ( ), "our_cum" )  Then
			  MessageBox ( "Error", "The cum quantity cannot be lesser than~r or equal to our cum quantity", Stopsign! )
			  dw_2.SetColumn("the_cum")
			  Return 
		End If 
		
	case "quantity"
		ls_part = GetItemString ( row, "part_number" )
		// cbr added the following 3/30/00
		if IsNull ( dw_1.GetItemString ( 1, "check_standard_pack" ), 'N' ) = 'Y' then
			ldec_quantity = Dec ( data )
			ls_customer = dw_1.GetItemString ( 1, "customer" )
			if isnull ( dw_1.GetItemString ( 1, "package_type" ), '' ) > '' then
				ldec_stdpack = isnull ( dw_1.GetItemDecimal ( 1, "standard_pack" ), 0 )
			end if
			if ldec_stdpack <= 0 then
				ldec_stdpack = sqlca.of_customerstandardpack ( ls_customer, ls_part, dw_1.GetItemString ( 1, "shipping_unit" ) )
			end if
			if ldec_stdpack > 0 and ldec_quantity > 0 then
				if ldec_stdpack < ldec_quantity then
					if mod ( ldec_quantity, ldec_stdpack ) <> 0 then
						ldec_recommend = ceiling ( ldec_quantity / ldec_stdpack ) * ldec_stdpack
						MessageBox ( monsys.msg_title, "Quantity entered is not in standard pack increment!  Recommended quantity is " + String ( ldec_recommend, "##########" ) + ".", Information! )
					end if
				elseif ldec_stdpack > ldec_quantity then
					MessageBox ( monsys.msg_title, "Quantity entered is not in standard pack increment!  Recommended quantity is " + String ( ldec_stdpack, "##########" ) + ".", Information! )
				end if
			end if
		end if
		// cbr end adding 3/30/00
		select	unit_weight
		into		:ldec_unit_weight
		from		part_inventory
		where		part = :ls_part ;
		
		SetItem ( row, "weight", Dec ( data ) * ldec_unit_weight )
End choose

end event

event doubleclicked;iReleaseRow	= Row

If dw_1.object.ship_type[1] = 'N' then
	If iReleaseRow > 0 then

		this.SetColumn("flag")
		If Long(this.GetText()) = 0 then
			dw_2.SetItem(iReleaseRow, "flag", 1)
			w_blanket_order.SetMicroHelp("Blue Rows: Ready for COP (Double Click to set/reset COP flag)")
		Else
			dw_2.SetItem(iReleaseRow, "flag", 0)
			w_blanket_order.SetMicroHelp("Double Click to set/reset COP flag")
		End If 
	End If
End If


end event

event editchanged;bChanged = TRUE

If dw_1.object.ship_type[1] = 'N' then
	dw_2.SetItem(iReleaseRow, "flag", 1)
	w_blanket_order.SetMicroHelp("Blue Rows: Ready for COP (Double Click to set/reset COP flag)")
Else
	dw_2.SetItem(iReleaseRow, "flag", 0)
End If
end event

on itemerror;dw_2.SetText ( "" )
end on

on rbuttondown;//m_Load_Menu.m_machine_load_menu.PopMenu( 300, 1300 )
end on

event constructor;settransobject ( sqlca )
end event

event retrieveend;// 04/03/00	cbr	get the max row id for this order
long	ll_row

for ll_row = 1 to rowcount
	if GetItemNumber ( ll_row, "row_id" ) > il_maxrowid then
		il_maxrowid = GetItemNumber ( ll_row, "row_id" )
	end if
next
end event

type cb_4 from commandbutton within w_blanket_order
int X=837
int Y=156
int Width=1431
int Height=836
int TabOrder=70
boolean Visible=false
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_edi from groupbox within w_blanket_order
int X=782
int Y=140
int Width=1399
int Height=944
int TabOrder=90
boolean Visible=false
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_2 from groupbox within w_blanket_order
int X=3767
int Width=530
int Height=692
int TabOrder=50
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=82042848
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_1 from datawindow within w_blanket_order
int X=59
int Y=52
int Width=2830
int Height=652
int TabOrder=20
string DataObject="dw_blanket_order_header_newone"
boolean Border=false
boolean LiveScroll=true
end type

event itemchanged;String 				szCust, szterms, szSales
String 				szVerify, szMod
String 				szPackageType
String 				ls_StdUnit
String				szCustomerPart,&
						ls_default_currency_unit,&
						ls_status,&
						ls_customer_part
Dec 					dStdPack
dec					ldec_price
dec					ldec_qty_break
datawindowchild	l_dwc_units,&
						l_dwc_packagetype,&
						ldwc_temp,&
						ldwc_dddw
int					li_show_euro_amount

long					ll_row
string	ls_dcustom1

//  If the clicked area is the destination grab it and throw related
//  customer into customer field

AcceptText ( )

Choose Case dwo.Name
	Case "destination"

		bDestError	=  FALSE

		szDest = data
		
		If Not f_valid_destination(szDest) then	
			MessageBox(monsys.msg_title, "This is not a valid destination", StopSign!)
			bDestError	= TRUE
			Return
		End If
			
	  	SELECT 	customer,
					default_currency_unit,
					show_euro_amount,
					cs_status
	    INTO  	:szCust,
		 			:ls_default_currency_unit,
					:li_show_euro_amount,
					:ls_status
	    FROM  	destination  
	   WHERE  	destination = :szDest   ;
	 
		IF Isnull ( ls_default_currency_unit, '' ) > '' then
			
			SELECT	customer.terms,   
						customer.salesrep
			INTO 		:szTerms,   
						:szSales
			FROM 		customer  
			WHERE 	customer.customer = :szCust   ;
			
		else
	
			SELECT	customer.terms,   
						customer.salesrep,
						customer.default_currency_unit,
						customer.show_euro_amount
			INTO 		:szTerms,   
						:szSales,
						:ls_default_currency_unit,
						:li_show_euro_amount 
			FROM 		customer  
			WHERE 	customer.customer = :szCust   ;
			
		end if
		
		dw_1.SetItem ( 1, "customer", szCust )
		dw_1.SetItem ( 1, "term", szTerms )
		dw_1.SetItem ( 1, "salesman", szSales )
		dw_1.SetItem ( 1, "currency_unit", ls_default_currency_unit )
		dw_1.SetItem ( 1, "show_euro_amount", li_show_euro_amount )
		dw_1.SetItem ( 1, "cs_status", ls_status )
		
		GetChild ( "customer_part", ldwc_dddw )
		if ldwc_dddw.Retrieve ( szCust ) < 1 then
			ldwc_dddw.Insertrow ( 1 )
		end if

		is_customer = szCust
// set package type according to blanket part number

	Case "blanket_part"

		szPart		= data
		szCust		= object.customer[1]
		bPartError	= FALSE

		GetChild ( "blanket_part", ldwc_dddw )
		ll_row = ldwc_dddw.Find ( "part = '" + szPart + "'", 1, ldwc_dddw.RowCount ( ) )
		if ll_row > 0 then
			if ldwc_dddw.GetItemString ( ll_row, "part" ) <> szPart then
//				MessageBox(monsys.msg_title, "This is not a valid part number", StopSign!)
				bPartError	= TRUE
				Return 1
			end if
		else		
//			MessageBox(monsys.msg_title, "This is not a valid part number", StopSign!)
			bPartError	= TRUE
			Return 1
		End If
	
		dw_1.object.package_type[1] = ""

		SELECT standard_unit
		  INTO :ls_StdUnit
		  FROM part_inventory
		 WHERE part = :szPart		;

		GetChild ( "package_type", l_dwc_packagetype )
		l_dwc_packagetype.SetTransObject ( sqlca )
		if l_dwc_packagetype.Retrieve ( szPart ) = 2 then
			SetItem ( 1, "package_type", l_dwc_packagetype.GetItemString ( 2, "code" ) )
			dw_1.SetItem ( 1, "standard_pack", wf_get_qty_for_pack(szPart, l_dwc_packagetype.GetItemString ( 2, "code" ) ))
		end if

		GetChild ( "shipping_unit", l_dwc_units )
		l_dwc_units.SetTransObject ( sqlca )
		l_dwc_units.Retrieve ( szPart )
		
		dw_1.SetItem ( 1, "shipping_unit", ls_StdUnit )
		
		SELECT part_customer.customer_part,
				 part_customer.blanket_price
		  INTO :szCustomerPart,
		  		 :ldec_price
		  FROM part_customer  
		 WHERE ( part_customer.part = :szPart ) AND  
				 ( part_customer.customer = :szCust )   ;
	
		IF SQLCA.SQLCode = 0 THEN
			SetItem ( 1, "customer_part", szCustomerPart )
		END IF

		if isnull(ldec_price,0) <= 0 then
			select	price
			into		:ldec_price
			from		part_standard
			where		part = :szpart ;
		end if
		
		sqlca.of_calculate_multicurrency_price ( '', GetItemString ( 1, "currency_unit" ), ldec_price, ldec_price )
		SetItem ( 1, "price", ldec_price )
		
	Case "package_type"

		szPackageType = data
		szPart = dw_1.GetItemString ( 1, "blanket_part" )
		dw_1.SetItem ( 1, "standard_pack", wf_get_qty_for_pack(szPart, szPackageType) )		 

	Case "currency_unit"

		getchild ( "currency_unit", ldwc_temp )
		
		if ldwc_temp.GetRow ( ) > 0 then
			SetItem ( 1, "currency_display_symbol", ldwc_temp.GetItemString ( ldwc_temp.GetRow ( ), "currency_display_symbol" ) )
		end if
	Case "customer_part"
		bPartError	= FALSE
		if IsNull ( String ( object.blanket_part[1] ), '' ) = '' then
			ls_customer_part = String ( data )
			select part into :szPart from part_customer where customer_part = :ls_customer_part and customer = :is_customer ;
			szCust		= object.customer[1]
			object.blanket_part[1] = szPart
	
			If Not f_valid_part_number(szPart) then	
				MessageBox(monsys.msg_title, "This is not a valid part number", StopSign!)
				bPartError	= TRUE
				Return 1
			End If
		
			dw_1.object.package_type[1] = ""
	
			SELECT standard_unit
			  INTO :ls_StdUnit
			  FROM part_inventory
			 WHERE part = :szPart		;
	
			GetChild ( "package_type", l_dwc_packagetype )
			l_dwc_packagetype.SetTransObject ( sqlca )
			if l_dwc_packagetype.Retrieve ( szPart ) = 2 then
				SetItem ( 1, "package_type", l_dwc_packagetype.GetItemString ( 2, "code" ) )
			end if
	
			GetChild ( "shipping_unit", l_dwc_units )
			l_dwc_units.SetTransObject ( sqlca )
			l_dwc_units.Retrieve ( szPart )
			
			dw_1.SetItem ( 1, "shipping_unit", ls_StdUnit )
			
			SELECT part_customer.customer_part,
					 part_customer.blanket_price
			  INTO :szCustomerPart,
					 :ldec_price
			  FROM part_customer  
			 WHERE ( part_customer.part = :szPart ) AND  
					 ( part_customer.customer = :szCust )   ;
		
			IF SQLCA.SQLCode = 0 THEN
				SetItem ( 1, "customer_part", szCustomerPart )
			END IF
	
			if isnull(ldec_price,0) <= 0 then
				select	price
				into		:ldec_price
				from		part_standard
				where		part = :szpart ;
			end if
		
			sqlca.of_calculate_multicurrency_price ( '', GetItemString ( 1, "currency_unit" ), ldec_price, ldec_price )
	
			SetItem ( 1, "price", ldec_price )
		end if
	Case "customer_po"
		if sqlca.of_customerpoexists ( data, GetItemString ( 1, "destination" ) ) then
			MessageBox ( monsys.msg_title, "The customer PO entered already exists for this destination.", Information! )
		end if
End Choose

bChanged = True
end event

on editchanged;bChanged = True
end on

event constructor;datawindowchild	l_dwc_child

settransobject ( sqlca )

GetChild ( "shipping_unit", l_dwc_child )
l_dwc_child.SetTransObject ( sqlca )
l_dwc_child.Retrieve ( 'None' )

GetChild ( "package_type", l_dwc_child )
l_dwc_child.SetTransObject ( sqlca )
l_dwc_child.Retrieve ( 'None' )

GetChild ( "customer_part", l_dwc_child )
l_dwc_child.SetTransObject ( sqlca )
l_dwc_child.insertrow ( 1 )

end event

event retrieveend;IF rowcount > 0 THEN
	szum = object.shipping_unit [ 1 ]
END IF
end event

type dw_edi_setup from datawindow within w_blanket_order
int X=937
int Y=380
int Width=946
int Height=364
int TabOrder=80
boolean Visible=false
string DataObject="dw_order_edi_setup"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;settransobject ( sqlca )
end event

type p_note from picture within w_blanket_order
int Width=59
int Height=60
boolean BringToTop=true
string PictureName="noteno.bmp"
boolean FocusRectangle=false
end type

type gb_1 from groupbox within w_blanket_order
int X=18
int Width=2889
int Height=720
int TabOrder=10
string Text="Header Information:"
BorderStyle BorderStyle=StyleLowered!
long TextColor=37234728
long BackColor=78682240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_kanban_inv_for_orders from datawindow within w_blanket_order
int X=754
int Y=372
int Width=1435
int Height=620
int TabOrder=110
boolean Visible=false
string DataObject="d_kanban_inv_for_orders"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = szpart
	object.destination [ 1 ] = szdest
END IF
end event

event editchanged;bChanged = True
end event

type st_history from statictext within w_blanket_order
int X=37
int Y=700
int Width=2811
int Height=76
boolean Visible=false
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="Shipping History"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=8421504
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

