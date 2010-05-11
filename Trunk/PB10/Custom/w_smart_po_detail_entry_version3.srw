HA$PBExportHeader$w_smart_po_detail_entry_version3.srw
$PBExportComments$The smart po detail data entry window (version3)
forward
global type w_smart_po_detail_entry_version3 from Window
end type
type st_18 from statictext within w_smart_po_detail_entry_version3
end type
type p_3 from picture within w_smart_po_detail_entry_version3
end type
type st_part_name from statictext within w_smart_po_detail_entry_version3
end type
type st_16 from statictext within w_smart_po_detail_entry_version3
end type
type st_vendor_part from statictext within w_smart_po_detail_entry_version3
end type
type st_15 from statictext within w_smart_po_detail_entry_version3
end type
type p_2 from picture within w_smart_po_detail_entry_version3
end type
type st_1 from statictext within w_smart_po_detail_entry_version3
end type
type sle_lead_time from singlelineedit within w_smart_po_detail_entry_version3
end type
type st_14 from statictext within w_smart_po_detail_entry_version3
end type
type st_11 from statictext within w_smart_po_detail_entry_version3
end type
type st_9 from statictext within w_smart_po_detail_entry_version3
end type
type st_8 from statictext within w_smart_po_detail_entry_version3
end type
type st_7 from statictext within w_smart_po_detail_entry_version3
end type
type st_6 from statictext within w_smart_po_detail_entry_version3
end type
type st_5 from statictext within w_smart_po_detail_entry_version3
end type
type sle_min_order_qty from singlelineedit within w_smart_po_detail_entry_version3
end type
type sle_min_on_hand from singlelineedit within w_smart_po_detail_entry_version3
end type
type st_4 from statictext within w_smart_po_detail_entry_version3
end type
type dw_template from datawindow within w_smart_po_detail_entry_version3
end type
type st_2 from statictext within w_smart_po_detail_entry_version3
end type
type sle_mps_uncovered from singlelineedit within w_smart_po_detail_entry_version3
end type
type st_13 from statictext within w_smart_po_detail_entry_version3
end type
type sle_mps_covered from singlelineedit within w_smart_po_detail_entry_version3
end type
type st_10 from statictext within w_smart_po_detail_entry_version3
end type
type dw_price_matrix from datawindow within w_smart_po_detail_entry_version3
end type
type lb_um from listbox within w_smart_po_detail_entry_version3
end type
type st_over_received from statictext within w_smart_po_detail_entry_version3
end type
type sle_1 from singlelineedit within w_smart_po_detail_entry_version3
end type
type st_12 from statictext within w_smart_po_detail_entry_version3
end type
type dw_po_detail from u_smart_po_detail_dw within w_smart_po_detail_entry_version3
end type
type dw_mps_demand from u_monitor_data_entry_dw within w_smart_po_detail_entry_version3
end type
type uo_hard_queue from u_po_detail_hard_queue_coverage within w_smart_po_detail_entry_version3
end type
type st_17 from statictext within w_smart_po_detail_entry_version3
end type
type st_release from statictext within w_smart_po_detail_entry_version3
end type
type p_1 from picture within w_smart_po_detail_entry_version3
end type
type cb_create from commandbutton within w_smart_po_detail_entry_version3
end type
type gb_4 from groupbox within w_smart_po_detail_entry_version3
end type
type gb_1 from groupbox within w_smart_po_detail_entry_version3
end type
type cb_note from commandbutton within w_smart_po_detail_entry_version3
end type
end forward

global type w_smart_po_detail_entry_version3 from Window
int X=0
int Y=0
int Width=2853
int Height=1536
boolean TitleBar=true
string Title="PO Detail Entry"
long BackColor=77897888
boolean ControlMenu=true
event batch pbm_custom01
event print pbm_custom02
event add pbm_custom03
event delete_release pbm_custom04
event save_release pbm_custom05
event exit_release pbm_custom06
event objects pbm_custom07
event history pbm_custom08
event start_to_print_po pbm_custom09
event setup_parts_for_print pbm_custom10
event close_uo_for_print pbm_custom11
event refresh_screen pbm_custom12
event set_release pbm_custom13
event ue_refresh_releases pbm_custom14
event show_notes pbm_custom15
event ue_demand_from_hard_queue pbm_custom16
event ue_print_update pbm_custom17
event ue_save_batch ( datawindow a_dw )
event ue_save_note pbm_custom18
event ue_close_uo_note pbm_custom19
st_18 st_18
p_3 p_3
st_part_name st_part_name
st_16 st_16
st_vendor_part st_vendor_part
st_15 st_15
p_2 p_2
st_1 st_1
sle_lead_time sle_lead_time
st_14 st_14
st_11 st_11
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
sle_min_order_qty sle_min_order_qty
sle_min_on_hand sle_min_on_hand
st_4 st_4
dw_template dw_template
st_2 st_2
sle_mps_uncovered sle_mps_uncovered
st_13 st_13
sle_mps_covered sle_mps_covered
st_10 st_10
dw_price_matrix dw_price_matrix
lb_um lb_um
st_over_received st_over_received
sle_1 sle_1
st_12 st_12
dw_po_detail dw_po_detail
dw_mps_demand dw_mps_demand
uo_hard_queue uo_hard_queue
st_17 st_17
st_release st_release
p_1 p_1
cb_create cb_create
gb_4 gb_4
gb_1 gb_1
cb_note cb_note
end type
global w_smart_po_detail_entry_version3 w_smart_po_detail_entry_version3

type variables
Long iPO                //The current po number
Long iPODetailRow  = 0 //The po detail datawindow row #
Long iMPSRow       //The MPS row
Long iHistoryRow    //The row for history
Long iMPSCovered  //MPS Covered
Long iMPSUnCovered //MPS Uncovered
Long iRelease	 //To keep the release number
Long i_l_next_row_id
Long il_row_add=0
int  il_rowid
Int  i_period


String szPart           //Part number
String szUM            //To keep the unit of measure
String szPlant          //Plant code
String szShipTo       //Ship to destination code
String szTerms        //To keep terms
String szVendor	 //To keep the vendor code
String szGlAccount	 //To keep the GL account
String szShipType	 //To keep the ship type
String szShipVia	 //To keep the ship via

DatawindowChild	dwUM

Boolean bMPS        //Whether dragged MPS
Boolean bQuery      //Whether in query mode
Boolean bCheckMinOnOrder
Boolean bError = False      //Whether there are some errors
Boolean bNoInfo

Decimal nMinOnOrder
Decimal nOverreceived

st_generic_structure stParm

Date dDateDue
Date dDate7
Date dpodate

DataWindowChild    dwShipTo, &
		idw_child

Window wHostWindow

u_smart_po_printing_processor	uo_print

u_generic_note       uo_normal_note

boolean		ib_Marked_Deletion, &
		ib_data_changed





end variables

forward prototypes
public subroutine wf_create_unit_dddw ()
public function string wf_get_um ()
public function date wf_next_day (date dToday, integer iUnits, string szUnit)
public subroutine wf_post_serial (long iserial, string szbatch)
public subroutine wf_create_ship_to ()
public subroutine wf_create_mps_template ()
public subroutine wf_get_host_window (ref window wWin)
public function boolean wf_update_over_recved (string as_vendor, string as_part, decimal ac_over_received)
public function boolean wf_check_min_on_order ()
public function decimal wf_min_on_order ()
public subroutine wf_error (boolean ab_flag)
public function boolean wf_nonreocurring_item (string as_part)
public subroutine wf_delete_profile (string as_vendor, string as_part)
public function boolean wf_mark_deletion (long al_row, string as_part)
public subroutine wf_reset_demand_flywheel ()
public function boolean wf_assign_releases ()
public subroutine wf_reset_overreceived ()
public function boolean wf_partial_update_release (string a_s_vendor)
public function boolean wf_delete_marked_releases ()
public function boolean wf_update_overreceived (string a_s_Vendor, string a_s_part, decimal a_n_Qty)
public subroutine wf_update_release (string a_s_flag)
public function string wf_get_vendor_code (long al_po)
public subroutine wf_display_overreceived (string as_vendor, string as_part)
public subroutine wf_display_mps_covered (string as_part)
public function decimal wf_min_onorder (string as_part, string as_plant)
public function decimal wf_get_min_on_hand (string as_part, string as_plant)
public function decimal wf_get_lead_time (string as_part, string as_vendor)
public function string wf_get_vendor_part (string as_vendor, string as_part)
public function date wf_get_po_date (long al_po)
public subroutine wf_get_unit_of_measurement_part (string a_s_part)
public function decimal wf_get_price (decimal nqty, decimal an_price)
end prototypes

event batch;/* 02-12-2004 MB  Modified to check non order status for part and add release accordingly */

string l_s_note, &
		 l_s_nonorder_status

If IsNull(szUM) then
	MessageBox(monsys.msg_title, "Missing unit of measure, please set it up first.", StopSign!)
	Return
End If

If IsNull(szTerms) then
	MessageBox(monsys.msg_title, "Missing terms, please set them up first.", StopSign!)
	Return
End if

l_s_note = f_get_part_no_status ( szPart )
l_s_nonorder_status = Left ( l_s_note, 1 )
	
if isnull(l_s_nonorder_status,'N') = 'Y' then 
	l_s_note = Mid ( l_s_note, 3,  len ( l_s_note ) - 2 )
	messagebox ( monsys.msg_title, 'Unable to add release for this part. ' + l_s_note )
	return
end if

if wf_nonreocurring_item( szPart ) then
	MessageBox(monsys.msg_title, "Can not add release for non-reoccuring item.", Stopsign!)
	Return
else
	Openwithparm ( w_batch_release, this )
end if


end event
event print;Date dStartDate, dEndDate

If dw_po_detail.RowCount() > 0 then
	If iPO > 0 then
		dStartDate	= Date(dw_po_detail.GetItemDateTime(1, "date_due"))
		dEndDate	= Date(dw_po_detail.GetItemDateTime(dw_po_detail.RowCount(), "date_due"))
		OpenUserObject(uo_print, 622, 161)
		uo_print.visible		= TRUE
		uo_print.bringtotop	= TRUE
		uo_print.uf_setup(iPO, szPart, dStartDate, dEndDate )
		uo_print.taborder = 1
		uo_print.em_date_from.setfocus()		
	Else
		MessageBox(monsys.msg_title, "You should select a P.O. first.", StopSign!)
	End If
Else
	MessageBox(monsys.msg_title, "There are no detail items to print.", StopSign!)
End If
end event

event add;If IsNull(szUM) then
	MessageBox(monsys.msg_title, "Missing unit of measure, please set it up first.", StopSign!)
	Return
End If

If IsNull(szTerms) then
	MessageBox(monsys.msg_title, "Missing terms, please set them up first.", StopSign!)
	Return
End if

if wf_nonreocurring_item( szPart ) then
	MessageBox(monsys.msg_title, "Can not add release for non-reoccuring item.", Stopsign!)
	Return
end if

// MB 01/29/04 Included these lines to disable the batch button to avoid user enter incorrect data
if m_smart_po_detail.m_file.m_batchcreate.enabled = true  then &
	m_smart_po_detail.m_file.m_batchcreate.enabled = false
	
dw_po_detail.triggerevent( 'ue_insert' )
end event

event delete_release;If MessageBox(	monsys.msg_title, "System will set deletion mark to all " + &
					"highlighted releases. Continue to process?", StopSign!, &
					YesNo!) = 1 Then
	dw_po_detail.TriggerEvent("ue_delete")
End If







end event

event save_release;dw_po_detail.triggerevent ( "ue_save" )

// MB 01/29/04 Included these lines to enable the batch button after saving the release
if m_smart_po_detail.m_file.m_batchcreate.enabled = false  then &
	m_smart_po_detail.m_file.m_batchcreate.enabled = true

if isvalid( uo_hard_queue ) then
	if uo_hard_queue.visible then
		uo_hard_queue.uf_dw_share( this.dw_po_detail, TRUE )
		uo_hard_queue.dw_hard_queue.uf_retrieve( szPart )
		uo_hard_queue.uf_coverage()
		uo_hard_queue.uf_dw_share( this.dw_po_detail, FALSE )
	end if
end if
end event

event exit_release;boolean	lb_exit

lb_exit	= TRUE

If ib_data_changed then
	lb_exit	= (MessageBox(	monsys.msg_title, "PO detail has been changed and " + &
						"not been saved. Do you still want to exit?", &
						Question!, YesNo!) = 1)
end if

if lb_exit then
	
	w_smart_po.dw_crosstab.Reset()
	If w_smart_po.bVendorMode then
		w_smart_po.wf_build_crosstab()
	Else
		w_smart_po.wf_build_crosstab_in_part_mode()
	End If

	If IsValid( w_smart_po_detail_entry_version3) then
		Close(w_smart_po_detail_entry_version3)
	End If

end if
end event

on objects;OpenWithParm(w_smart_po_objects, szPart)
end on

on history;stParm.value1	= String(iPO)
stParm.value2	= szPart

OpenWithParm(w_smart_po_receiving_history, stParm)

end on

event start_to_print_po;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

st_print_preview_generic l_st_parm

If uo_print.ddlb_style.text = 'Release' then
	l_st_parm.form_type	= 'PO - Release'
Elseif uo_print.ddlb_style.text = 'Normal PO' then
	l_st_parm.form_type	= 'Normal PO'
Elseif uo_print.ddlb_style.text = 'Blanket PO' then
	l_st_parm.form_type	= 'Blanket PO'
End If

//IF NOT uo_print.cbx_freeze.checked THEN
//	wf_update_release ( '+' )
//END IF

uo_print.visible	= FALSE

bFinish		= FALSE
Timer(0.5)

l_st_parm.document_number = iPO

OpensheetWithParm ( w_print_preview, l_st_Parm, w_main_screen, 3, Layered! ) 

wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
dw_po_detail.Retrieve ( iPO, szPart ) 


end event

on setup_parts_for_print;uo_print.dw_parts.Reset()
uo_print.dw_parts.InsertRow(1)
uo_print.dw_parts.SetItem(1, 1, szPart)
uo_print.dw_parts.SelectRow(0, TRUE)


end on

on close_uo_for_print;If IsValid(uo_print) then
	CloseUserObject(uo_print)
End If
end on

event refresh_screen;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
dw_po_detail.Retrieve(iPO, szPart)
end event

event set_release;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

If Not uo_print.cbx_freeze.checked then
	wHostWindow.PostEvent("set_release")
	wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
	dw_po_detail.Retrieve(iPO, szPart)
	iRelease	++
	st_release.text	= "Current Release:" + String(iRelease)
End If
end event

event ue_refresh_releases;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

If Not uo_print.cbx_freeze.checked then
	w_smart_po.TriggerEvent("ue_refresh_releases")
	wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
	dw_po_detail.Retrieve(iPO, szPart)
	iRelease	++
	st_release.text	= "Current Release:" + String(iRelease)
End If
end event

event show_notes;String ls_PartNotes, &
		 ls_datatype 

Long   l_Row

l_Row = dw_po_detail.GetSelectedRow (0)

If l_Row <= 0 Then 	
	MessageBox ( monsys.msg_title, "You must first click on a release in the PO Releases Window.", Information!, OK! )
Else	
	ls_PartNotes = dw_po_detail.object.notes [ l_row ]
	ls_datatype  = dw_po_detail.object.notes.coltype
	
	openuserobjectwithparm (uo_normal_note, ls_datatype, 622,161)
	uo_normal_note.bringtotop = True
	uo_normal_note.borderstyle = StyleRaised!
	uo_normal_note.mle_note.text = ls_partnotes
	
End If
end event

on ue_demand_from_hard_queue;uo_hard_queue.visible		= not uo_hard_queue.visible
uo_hard_queue.bringtotop	= uo_hard_queue.visible

if uo_hard_queue.visible then
	uo_hard_queue.uf_dw_share( this.dw_po_detail, TRUE )
	uo_hard_queue.dw_hard_queue.uf_retrieve( szPart )
	uo_hard_queue.uf_coverage()
	uo_hard_queue.uf_dw_share( this.dw_po_detail, FALSE )
end if
end on

event ue_print_update;
String l_s_SQLErrorText																								// ADD 04-05-2000 KAZ

IF NOT uo_print.cbx_freeze.checked THEN wf_update_release ( '+' )

IF wf_delete_marked_releases( ) THEN

		IF IsNull ( szpart ) THEN
			UPDATE po_detail
			SET 	Printed = 'Y'
			WHERE Po_number = :iPO AND
					selected_for_print = 'Y' ;
		ELSE
			UPDATE po_detail 
			SET  	Printed = 'Y' 
			WHERE Po_number = :iPO AND
					selected_for_print = 'Y' AND part_number = :szpart;
		END IF
	
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT;
			TriggerEvent("ue_refresh_releases")
		ELSE
			l_s_SQLErrorText = SQLCA.SQLErrText																	// ADD 04/05/2000 KAZ
			Rollback ;
			MessageBox(monsys.msg_title, l_s_SQLErrorText, StopSign!)									// ADD 04/05/2000 KAZ
	   END IF

ELSE
	l_s_SQLErrorText = SQLCA.SQLErrText																			// ADD 04/05/2000 KAZ
	Rollback ;
	MessageBox(monsys.msg_title, l_s_SQLErrorText, StopSign!)											// ADD 04/05/2000 KAZ

END IF

end event

event ue_save_batch;Integer 	l_i_Count, &
			l_i_period
			
Date		l_d_Date

Long		l_l_count

decimal	l_n_price		

string   l_s_account, &
		   l_s_unit

IF a_dw.Rowcount() <= 0 THEN RETURN

l_d_Date			= a_dw.object.#3[1]
l_s_account		= f_get_part_info(a_dw.object.#1[1], "GL ACCOUNT")
l_s_unit			= f_get_part_info(a_dw.object.#1[1], "STANDARD UNIT")
l_n_price    	= a_dw.object.#7[1] 
l_i_period    	= a_dw.object.#4[1]

IF a_dw.object.#4[1] > 0 THEN

	For l_i_Count = 1 to  a_dw.object.#4[1]

		dw_po_Detail.InsertRow(1)
		dw_po_Detail.SetItem(1, "part_number", a_dw.object.#1[1] )
		dw_po_Detail.SetItem(1, "description", a_dw.object.#2[1])
		dw_po_Detail.SetItem(1, "po_number", iPO)
		dw_po_Detail.SetItem(1, "status", "A")
		dw_po_Detail.SetItem(1, "vendor_code", szvendor )
		dw_po_Detail.SetItem(1, "unit_of_measure", l_s_unit)	
		dw_po_Detail.SetItem(1, "terms", szterms )
		dw_po_Detail.SetItem(1, "printed", 'N' )
		dw_po_Detail.SetItem(1, "account_code", l_s_account )
		dw_po_Detail.SetItem(1, "ship_via", szshipvia )
		dw_po_Detail.SetItem(1, "week_no", f_get_week_no(l_d_date) )
		dw_po_Detail.SetItem(1, "price", l_n_price )
		dw_po_Detail.SetItem(1, "date_due",  l_d_date)
		dw_po_Detail.SetItem(1, "quantity", a_dw.object.#6[1])
		dw_po_Detail.SetItem(1, "received", 0)
		dw_po_Detail.SetItem(1, "balance", a_dw.object.#6[1])
		dw_po_Detail.SetItem(1, "release_no", irelease )
		dw_po_Detail.SetItem(1, "taxable", a_dw.object.#8[1])
		
  		// MB Modified to set sequential row id from po header 01/28/04
		dw_po_Detail.SetItem(1, "row_id", i_l_next_row_id + il_row_add )
		il_row_add++
		
		l_d_Date	= wf_next_day ( l_d_Date, 1, a_dw.object.#5[1] )

	Next

	dw_po_detail.accepttext()
	
	// Included this check to make sure batch routine works fine.. mb 01/28/04
	bNoInfo = False
	w_smart_po_detail_entry_version3.TriggerEvent("save_release")
	
END IF


end event

event ue_save_note;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

String ls_NewNote

Long ll_Row

Date ld_DateDue

Int i_Rowid

ls_NewNote = uo_normal_note.mle_note.text

ll_Row = dw_po_detail.GetselectedRow (0)

ld_DateDue = Date(dw_po_detail.GetItemDateTime ( ll_Row, 1 ))
i_Rowid    = dw_po_detail.GetItemNumber( ll_Row, "row_id" )

UPDATE po_detail  
   SET notes = :ls_NewNote
 WHERE ( po_number = :iPO ) AND  
       ( part_number = :szPart )AND
       ( row_id = :i_Rowid ) ; 

If SQLCA.SQLCode = 0 Then
   Commit ;
Else
   Rollback ;
End If 

Closeuserobject ( uo_normal_note )

wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
dw_po_detail.Retrieve ( iPO, szPart)


end event

event ue_close_uo_note;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

if isvalid(uo_normal_note) then
  closeuserobject(uo_normal_note)
  wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
  dw_po_detail.Retrieve(iPO, szpart)
end if
end event

public subroutine wf_create_unit_dddw ();Integer 	iCount

String	ls_UM

lb_um.reset()
dwUM.reset()

f_get_units_for_part("", szPart, lb_um)

For iCount	= 1 to lb_um.TotalItems()
	lb_um.SelectItem(iCount)
	ls_UM	= lb_um.SelectedItem()
	dwUM.InsertRow(1)
	dwUM.SetItem(1, "um", ls_UM)
Next	
end subroutine

public function string wf_get_um ();String ls_UM
String ls_Vendor

ls_Vendor	= wf_get_vendor_code(iPO)

  SELECT part_vendor.receiving_um  
    INTO :ls_UM  
    FROM part_vendor  
   WHERE ( part_vendor.part = :szPart ) AND  
         ( part_vendor.vendor = :ls_Vendor )   ;

Return trim(ls_UM)
end function

public function date wf_next_day (date dToday, integer iUnits, string szUnit);Integer iYear
Integer iMonth
Integer iDay

If szUnit	= "Day" then
	Return RelativeDate(dToday, iUnits)
End If

If szUnit	= "Week" then
	Return RelativeDate(dToday, (iUnits * 7))
End If

If szUnit	= "Month" then
	iYear		= Year(dToday)
	iMonth	= Month(dToday)
	iDay		= Day(dToday)
			
	If iMonth	= 12 then
		iYear	++
		iMonth	= 1
	Else
		iMonth	++
	End If

	If iDay > f_days_in_month(Date(iYear, iMonth, 1)) then
		iDay	= f_days_in_month(Date(iYear, iMonth, 1))
	End If

	Return date(iYear, iMonth, iDay)

End If

				

end function

public subroutine wf_post_serial (long iserial, string szbatch);UPDATE audit_trail  
   SET invoice_number = :szBatch  
 WHERE ( serial = :iSerial ) AND  
       ( type = 'R' )   ;


end subroutine

public subroutine wf_create_ship_to ();String szCode
String szName

dwShipTo.Reset()

Declare PlantCur Cursor for Select Distinct plant From Vendor Using sqlca;

Open PlantCur;

Fetch PlantCur into :szCode;

Do while sqlca.sqlcode = 0
	dwShipTo.InsertRow(1)
	dwShipTo.SetItem(1, 1, szCode)
	dwShipTo.SetItem(1, 2, "PLANT")
	Fetch PlantCur into :szCode;
Loop

Close PlantCur;

Declare LocationCur Cursor for Select Code, Name From Location Using sqlca;

Open LocationCur;

Fetch LocationCur into :szCode, :szName;

Do while sqlca.sqlcode = 0
	dwShipTo.InsertRow(1)
	dwShipTo.SetItem(1, 1, szCode)
	dwShipTo.SetItem(1, 2, szName)
	Fetch LocationCur into :szCode, :szName;
Loop

Close LocationCur;

Declare DestinationCur Cursor for Select Destination, Name From Destination Using sqlca;

Open DestinationCur;

Fetch DestinationCur into :szCode, :szName;

Do while sqlca.sqlcode = 0
	dwShipTo.InsertRow(1)
	dwShipTo.SetItem(1, 1, szCode)
	dwShipTo.SetItem(1, 2, szName)
	Fetch DestinationCur into :szCode, :szName;
Loop

Close DestinationCur;



end subroutine

public subroutine wf_create_mps_template ();Long iRow
Long iTotalRows
Long iRowFound

Date	dDate

Decimal nQty
Decimal nQtyInTemplate

dw_template.Reset()

iTotalRows	= dw_mps_demand.RowCount()

For iRow = 1 to iTotalRows

	If dw_mps_demand.IsSelected(iRow) then

		dDate			= date(dw_mps_demand.GetItemDateTime(iRow, "due"))
		iRowFound	= dw_template.Find("value1 = '" + String(dDate) + "'", 1, 99999)	
		If iRowFound > 0 then
			nQtyInTemplate	= Dec(dw_template.GetItemString(iRowFound, "value2"))
		Else
			nQtyInTemplate	= 0									
			iRowFound		= 1
			dw_template.InsertRow(1)	
			dw_template.SetItem(1, "value1", String(dDate))
		End If

		nQtyInTemplate		= nQtyInTemplate + f_get_value(dw_mps_demand.GetItemNumber(iRow, "qnty")) &
								  - f_get_value(dw_mps_demand.GetItemNumber(iRow, "qty_assigned"))

		dw_template.SetItem(iRowFound, "value2", String(nQtyInTemplate))
		
	End If

Next

end subroutine

public subroutine wf_get_host_window (ref window wWin);wHostWindow	= wWin
end subroutine

public function boolean wf_update_over_recved (string as_vendor, string as_part, decimal ac_over_received);/*
Description	:To update the over-received quantity
Author		:Jim Wu
Start Date	:02/18/96
Modification:
*/

/* Declaration */

/* Initialization */

/* Main Process */

UPDATE 	part_vendor  
SET 		qty_over_received = :ac_Over_received
WHERE 	( vendor = :as_vendor ) AND  
         ( part = :as_Part )   ;

noverreceived = ac_over_received

Return ( SQLCA.SQLCode = 0 )

end function

public function boolean wf_check_min_on_order ();return bCheckMinOnOrder
end function

public function decimal wf_min_on_order ();return nMinOnOrder
end function

public subroutine wf_error (boolean ab_flag);bError	= ab_flag
end subroutine

public function boolean wf_nonreocurring_item (string as_part);/*
Description	:	To check whether the part is nonreoccuring (whether in part
					master).
Author		:	Jim Wu
Start Date	:	02/24/96
Modification:
*/


/* Declaration */
string	ls_part

/* Initialization */


/* Main Process */

SELECT part.part  
  INTO :ls_part  
  FROM part  
 WHERE part.part = :as_part   ;

Return (SQLCA.SQLCode <> 0)
end function

public subroutine wf_delete_profile (string as_vendor, string as_part);/*
Description	:	To delete the part/vendor relation from profile.
Author		:	Jim Wu
Start Date	:	02/24/96
Modification:	
*/


/* Declaration */


/* Initialization */


/* Main Process */

DELETE FROM part_vendor  
 WHERE ( part_vendor.vendor = :as_vendor ) AND  
       ( part_vendor.part = :as_part )   ;

if SQLCA.SQLCode = 0 then
	COMMIT;	
	DELETE FROM part_vendor_price_matrix
	WHERE	( part_vendor_price_matrix.vendor = :as_vendor ) AND
			( part_vendor.part = :as_part );
	if SQLCA.SQLCode = 0 then
		COMMIT;
	else
		ROLLBACK;
	end if
else
	ROLLBACK;
end if
end subroutine

public function boolean wf_mark_deletion (long al_row, string as_part);/*
Description	:To mark the deletion of PO release.
Author		:Jim Wu
Start Date	:02/17/96
Modification:
*/


/* Declaration */


/* Initialization */


/* Main Process */

If f_valid_part_number(szPart) AND &
	f_get_part_info(szPart, "CLASS") <> "N" Then

	dw_po_detail.SetItem(al_row, "deleted", "Y")	
	dw_po_detail.SetItem(al_row, "printed", "N")
	dw_po_detail.SetItem(al_row, "quantity", 0)
	dw_po_detail.SetItem(al_row, "received", 0)
	dw_po_detail.SetItem(al_row, "balance",  0)
	dw_po_detail.SetItem(al_row, "standard_qty", 0)
	dw_po_detail.SetItem(al_row, "price", 0)

Else

	dw_po_detail.DeleteRow ( al_Row )

End If

Return TRUE
end function

public subroutine wf_reset_demand_flywheel ();Int i_count, i_delete
Long l_row
String s_value

i_count = 0
i_Delete = 0

Datetime dt_ddate7

Dt_ddate7 = datetime(ddate7)

SELECT count(po_detail.vendor_code ),
		 count(po_detail.deleted)  
INTO 	 :i_count,
		 :i_delete  
FROM 	 po_detail  
WHERE  ( po_detail.part_number = :szPart ) AND
  	    ( po_detail.date_due <= :dt_dDate7 ) AND
		 ( po_detail.status = 'A') ;

If i_delete <> i_count Then
   s_value = 'Y'
Else
   s_value = 'N' 
End If  

w_smart_po.dw_vendors.Triggerevent ( "ue_reset", 0, s_value )

end subroutine

public function boolean wf_assign_releases ();/* Declaration */

long		ll_row, &
			ll_total

date		ld_date		//To keep the current date in the po detail

string 	ls_release 	//To keep the release number

decimal	lc_qty, &
	lc_Price

Boolean	lb_NoErrors

/* Initialization */
lb_NoErrors	= TRUE
ll_row		= 1
ll_total		= dw_po_detail.rowcount()


/* Main Process */

do while lb_NoErrors AND (ll_row <= ll_total)

	ld_Date		= date ( dw_po_detail.GetItemDatetime(ll_row, "date_due") )
	lc_Qty		= dw_po_detail.object.quantity[ll_row]

	If bCheckMinOnOrder And dw_po_detail.GetItemString ( ll_Row, "deleted" ) <> "Y" then
		If lc_Qty < nMinOnOrder then
			MessageBox(monsys.msg_title, "You cannot order less than Minimum On Order Quantity for current plant (Min:" + String(nMinOnOrder) + ")", StopSign!)
			lb_NoErrors	= TRUE 
		End If
	End If

	If lb_NoErrors then
		If dw_po_detail.GetItemString(ll_row, "deleted") <> 'Y' then
			lc_Price	= Dec (dw_po_detail.object.price[ll_row])

			If f_get_value(lc_Price) <= 0 then
				dw_po_detail.SetItem( ll_row, "price", wf_get_price(lc_qty, lc_price))
			End If		

			dw_po_detail.SetItem(ll_row, "week_no", f_get_week_no(ld_Date))			
		End If
	End If

	ll_row ++
Loop

Return lb_NoErrors 
end function

public subroutine wf_reset_overreceived ();Decimal nquantity

If dw_po_detail.Rowcount() = 0 Then Return

nquantity = dw_po_detail.GetItemNumber(1, "quantity")

If i_period > 0 Then
	nquantity = nquantity * i_period
	i_period = 0

Else
	nquantity = nquantity * 1	
End If

If nquantity > noverreceived Then

	st_over_received.Text	= '0'

Else

	st_over_received.Text = String(Truncate((noverreceived - nquantity), 0))

End If
end subroutine

public function boolean wf_partial_update_release (string a_s_vendor);String  l_s_partial_update

SELECT	partial_release_update
INTO     :l_s_partial_update
FROM		vendor
WHERE    code = :a_s_vendor ;

IF  l_s_partial_update = 'Y' THEN
	RETURN TRUE
ELSE
	RETURN FALSE
END IF

end function

public function boolean wf_delete_marked_releases ();String l_s_CurrentPart
String l_s_PartList[]

Integer 	l_i_Count = 0

Decimal  l_n_TotalReceived

Boolean	l_b_OK	 = TRUE	

If IsNull(szPart) then	//Print for all parts
	Declare curPart1 Cursor For
	Select Distinct po_detail.part_number  
	From  po_detail  
	Where po_detail.po_number = :iPO AND
			po_detail.deleted = 'Y' AND
			po_detail.selected_for_print = 'Y'  ;
Else
	Declare curPart2 Cursor For
	Select Distinct po_detail.part_number  
	From  po_detail  
	Where po_detail.po_number = :iPO AND
			po_detail.deleted = 'Y' AND
			po_detail.selected_for_print = 'Y' AND
			po_detail.part_number = :szPart  ;
End If

If IsNull(szPart) then
	Open curPart1;
	Fetch curPart1 into :l_s_CurrentPart;
Else
	Open curPart2;
	Fetch curPart2 into :l_s_CurrentPart;
End If

Do While SQLCA.SQLCode = 0
	l_i_Count ++
	l_s_PartList[l_i_Count]	= l_s_CurrentPart

	If IsNull(szPart) then
		Fetch curPart1 into :l_s_CurrentPart;		
	Else
		Fetch curPart2 into :l_s_CurrentPart;
	End If

Loop

If IsNull(szPart) then
	Close curPart1;
Else
	Close curPart2;
End If

If l_i_Count > 0 then
	If MessageBox(monsys.msg_title, "Do you want to erase deletion-marked releases?", Question!, YesNo!) = 1 then
		Do while (l_i_Count > 0) AND l_b_OK

			l_s_CurrentPart	= l_s_PartList[l_i_Count]

			Select sum ( po_detail.received )  
		   Into   :l_n_TotalReceived  
		   From   po_detail  
		   Where  (po_detail.po_number = :iPO ) AND  
		          (po_detail.part_number = :l_s_CurrentPart ) AND
					 (po_detail.selected_for_print = 'Y') AND
					 (po_detail.deleted = 'Y')  ;

			l_i_Count --

			If wf_update_overreceived(szvendor, l_s_CurrentPart, l_n_TotalReceived) then
				Delete From PO_detail Where 	po_number = :iPO And
										 	part_number = :l_s_CurrentPart And
											Deleted		= 'Y';

				If SQLCA.SQLCode = 0 then
					l_b_OK	= True
				Else
					l_b_OK	= False
				End If
			Else
				l_b_OK	= FALSE
			End If
				
			Loop	
	End If
End If

Return l_b_OK
end function

public function boolean wf_update_overreceived (string a_s_Vendor, string a_s_part, decimal a_n_Qty);Decimal ln_OverReceived

SELECT part_vendor.qty_over_received  
  INTO :ln_Overreceived  
  FROM part_vendor  
 WHERE ( part_vendor.part = :a_s_part ) AND  
       ( part_vendor.vendor = :a_s_Vendor )   ;

ln_OverReceived	= f_get_value(ln_OverReceived) + a_n_Qty

UPDATE part_vendor  
   SET qty_over_received = :ln_OverReceived  
 WHERE ( part_vendor.part = :a_s_part ) AND  
       ( part_vendor.vendor = :a_s_Vendor )   ;
	
If SQLCA.SQLCode = 0 then
	Return TRUE
Else
	Return FALSE
End If
end function

public subroutine wf_update_release (string a_s_flag);Long		l_l_Release
String	l_s_Release

SELECT release_no 
  INTO :l_l_Release  
  FROM po_header  
 WHERE po_number = :iPO;

l_l_Release	 = f_get_value(l_l_Release)

If a_s_flag = '+' then

	UPDATE  po_header  
  	SET  release_no 	= :l_l_Release + 1  
  	WHERE  po_number	= :iPO;

	l_s_Release	= String(l_l_Release + 1)

	If wf_partial_update_release ( szvendor ) then

		UPDATE po_detail  
	   	SET release_no = :l_s_Release
	 	WHERE po_number 	= :iPO AND selected_for_print = 'Y'  ;

	Else

		UPDATE po_detail  
	   	SET release_no = :l_s_Release
	 	WHERE po_number 	= :iPO   ;

	End If
Else

	UPDATE  po_header  
  	SET  release_no 	= :l_l_Release - 1  
  	WHERE  po_number	= :iPO;

	l_s_Release			= String (l_l_Release - 1)

	If wf_partial_update_release ( szvendor ) then

		UPDATE po_detail  
	   	SET release_no = :l_s_Release
	 	WHERE po_number 	= :iPO AND selected_for_print = 'Y'  ;

	Else

		UPDATE po_detail  
	   	SET release_no = :l_s_Release
	 	WHERE po_number 	= :iPO   ;

	End If

End If

If SQLCA.SQLCode = 0 then
	Commit;
Else
	Rollback;
End If

end subroutine

public function string wf_get_vendor_code (long al_po);String szVendorCode

SELECT po_header.vendor_code  
  INTO :szVendorCode  
  FROM po_header  
 WHERE po_header.po_number = :al_PO   ;

Return szVendorCode
end function

public subroutine wf_display_overreceived (string as_vendor, string as_part);Decimal nQtyOverReceived

SELECT part_vendor.qty_over_received  
  INTO :nQtyOverReceived  
  FROM part_vendor  
 WHERE ( part_vendor.part = :as_Part ) AND  
       ( part_vendor.vendor = :as_Vendor )   ;

st_over_received.text	= String(Truncate(nQtyOverReceived, 0))





end subroutine

public subroutine wf_display_mps_covered (string as_part);Long iTotal
Long iCovered

If szPlant > ' ' then
	Select sum(master_prod_sched.qnty ),   
   	    sum(master_prod_sched.qty_assigned )  
	  Into :iTotal,   
	       :iCovered  
	  From master_prod_sched  
	  Where master_prod_sched.part 	=: as_part AND 
			  master_prod_sched.plant	=: szPlant;
Else
	Select sum(master_prod_sched.qnty ),   
   	    sum(master_prod_sched.qty_assigned )  
	  Into :iTotal,   
	       :iCovered  
	  From master_prod_sched  
	  Where master_prod_sched.part =: as_part;
End If

iMPSCovered		= f_get_value(iCovered)
iMPSUnCovered	= f_get_value(iTotal) - iMPSCovered

sle_mps_covered.text		= String(iMPSCovered)
sle_mps_uncovered.text	= String(iMPSUnCovered)

end subroutine

public function decimal wf_min_onorder (string as_part, string as_plant);
Decimal nQty

SELECT part_vendor.min_on_order  
  INTO :nQty  
  FROM part_vendor  
 WHERE ( part_vendor.part = :as_Part ) AND  
       ( part_vendor.vendor = :szVendor )   ;

Return nQty

end function

public function decimal wf_get_min_on_hand (string as_part, string as_plant);Decimal nQty

SELECT plant_part.min_onhand  
  INTO :nQty  
  FROM plant_part  
 WHERE ( plant_part.plant = :as_Plant ) AND  
       ( plant_part.part = :as_Part )   ;

Return f_get_value(nQty)
end function

public function decimal wf_get_lead_time (string as_part, string as_vendor);Decimal nLeadTime

  SELECT part_vendor.lead_time  
    INTO :nLeadTime  
    FROM part_vendor  
   WHERE ( part_vendor.part = :as_Part ) AND  
         ( part_vendor.vendor = :as_vendor ) ;

Return f_get_value(nLeadTime)
end function

public function string wf_get_vendor_part (string as_vendor, string as_part);String szVendorPart

Select part_vendor.vendor_part  
  Into :szVendorPart  
  From part_vendor  
 Where ( part_vendor.part = :as_Part ) AND  
       ( part_vendor.vendor = :as_Vendor );

Return szVendorPart

end function

public function date wf_get_po_date (long al_po);Datetime dt_dpodate

SELECT po_date
INTO   :dt_dpodate
FROM   po_header
WHERE  po_number = :al_po ;

dpodate = date(dt_dpodate)

Return  dpodate 
end function

public subroutine wf_get_unit_of_measurement_part (string a_s_part);/* 04-05-2000 KAZ Created to populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

dw_po_detail.SetTransObject (sqlca)							// ADD 04-05-2000 KAZ
dw_po_detail.GetChild ("unit_of_measure", idw_child)	// ADD 04-05-2000 KAZ
idw_child.SetTransObject (sqlca)								// ADD 04-05-2000 KAZ
idw_child.retrieve ( a_s_part )								// ADD 04-05-2000 KAZ
	
end subroutine

public function decimal wf_get_price (decimal nqty, decimal an_price);Integer iTotalRows
Integer iRow

String  l_s_header_cunit

Decimal nPrice

Boolean bFound
 
bFound		= FALSE
iTotalRows	= dw_price_matrix.RowCount()
iRow			= iTotalRows

Do while (Not bFound) AND (iRow > 0)

	bFound = (nQty >= dw_price_matrix.GetItemNumber(iRow, "break_qty"))

	If Not bFound then
		iRow --
	End If

Loop

If iRow = 0 then
	bFound	= FALSE
End If

select currency_unit
into  :l_s_header_cunit 
from  po_header
where po_number = :ipo ;

If bFound then
	nprice = Truncate(dw_price_matrix.GetItemNumber(iRow, 6 ) + 0.0000009, 6)	
//	sqlca.of_calculate_multicurrency_price ( dw_price_matrix.GetItemString ( irow, 5 ), l_s_header_cunit, &
//		Truncate(dw_price_matrix.GetItemNumber(iRow, 6 ) + 0.0000009, 6), nPrice )
Else
//	sqlca.of_calculate_multicurrency_price ( '', l_s_header_cunit, &
//		Truncate(Dec(f_get_part_info(szpart, "STANDARD COST")) + 0.0000009, 6), nprice )
	nPrice = an_price
	If nQty > 0 then
		nPrice	= f_convert_units(szUM, "", szPart, nQty) * nPrice / nQty
	Else
		nPrice	= f_convert_units(szUm, "", szPart, 1)
	End If
End If

Return nPrice


end function

event open;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

//************************************************************************
//* Declaration
//************************************************************************

dw_price_matrix.SetTransObject(sqlca)

Integer iRtnCode

String  szModify, szRtnString
String	ls_release_control

//************************************************************************
//* Initialization
//************************************************************************

stParm			= Message.PowerObjectParm

bNoInfo			= True										// ZZ

iPO				= Long(stParm.value1)
szPart			= stParm.value2
szShipTo			= stParm.value3
szTerms			= stParm.value4
szShipType		= Left(stParm.value5, 1)
szPlant			= stParm.value6
szVendor			= stParm.value7
iRelease			= Long(stParm.value8)
szShipVia		= stParm.value9
dDate7         = Date(stParm.Value10)

szGLAccount		= f_get_part_info(szPart, "GL ACCOUNT")
st_release.text= "Current Release:" + String(iRelease)

bCheckMinOnOrder				= (szShipType = "N")
If bCheckMinOnOrder then
	nMinOnOrder					= wf_min_onorder(szPart, szVendor)
	sle_min_order_qty.text	= String(Truncate(nMinOnOrder, 2))
End If

sle_min_on_hand.text			= String(Truncate(wf_get_min_on_hand(szPart, szPlant),2))
sle_lead_time.text			= String(Truncate(wf_get_lead_time(szPart, szVendor), 2))
st_part_name.text				= f_get_part_info(szPart, "NAME")
st_vendor_part.text			= wf_get_vendor_part(szVendor, szPart)

this.Title	= "Release Entry  (Part:" + szPart + " PO:" + String(iPO) + ")"

szUM			= wf_get_um()

wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
dw_po_detail.Retrieve (iPO, szPart)
dw_mps_demand.Retrieve (szPart)

dw_price_matrix.Retrieve (wf_get_vendor_code(iPO), szpart)

SELECT po_header.release_control  
  INTO :ls_release_control  
  FROM po_header  
 WHERE po_header.po_number = :iPO   ;

If f_get_string_value ( ls_release_control ) = 'A' then
	wf_display_overreceived(wf_get_vendor_code(iPO), szPart)
Else
	st_over_received.Text = '0'
End if

wf_display_mps_covered(szPart)

// MB 01/28/04 modified to get next seq no from po header
i_l_next_row_id = f_get_podet_next_seqno ( iPO )

If dw_po_detail.RowCount ( ) > 0 Then
	st_part_name.Text = dw_po_detail.GetItemString ( 1, "description" )
End if

dpodate = wf_get_po_date(ipo)
end event

event timer;/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

If bFinish then
	
	Timer(0)
	bNoCommit	= FALSE
	f_recalc_po_detail_per_part(iPO, szPart, w_smart_po_detail_entry_version3)
	SetMicroHelp ( 'Recalculating assigned quantities in MPS : ' + szpart )
	f_update_qty_asgnd_part ( szpart ) 
	dw_mps_demand.Retrieve(szPart)
	wf_get_unit_of_measurement_part ( szpart )					// ADD 04-05-2000 KAZ
	dw_po_detail.Retrieve(iPO, szPart)
	bFinish	= FALSE
	
End If
end event

on close;If IsValid(uo_print) then
	CloseUserObject(uo_print)
End If
end on

event activate;If w_main_screen.MenuName <> "m_smart_po_detail" Then &
	w_main_screen.ChangeMenu ( m_smart_po_detail )
end event

on w_smart_po_detail_entry_version3.create
this.st_18=create st_18
this.p_3=create p_3
this.st_part_name=create st_part_name
this.st_16=create st_16
this.st_vendor_part=create st_vendor_part
this.st_15=create st_15
this.p_2=create p_2
this.st_1=create st_1
this.sle_lead_time=create sle_lead_time
this.st_14=create st_14
this.st_11=create st_11
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.sle_min_order_qty=create sle_min_order_qty
this.sle_min_on_hand=create sle_min_on_hand
this.st_4=create st_4
this.dw_template=create dw_template
this.st_2=create st_2
this.sle_mps_uncovered=create sle_mps_uncovered
this.st_13=create st_13
this.sle_mps_covered=create sle_mps_covered
this.st_10=create st_10
this.dw_price_matrix=create dw_price_matrix
this.lb_um=create lb_um
this.st_over_received=create st_over_received
this.sle_1=create sle_1
this.st_12=create st_12
this.dw_po_detail=create dw_po_detail
this.dw_mps_demand=create dw_mps_demand
this.uo_hard_queue=create uo_hard_queue
this.st_17=create st_17
this.st_release=create st_release
this.p_1=create p_1
this.cb_create=create cb_create
this.gb_4=create gb_4
this.gb_1=create gb_1
this.cb_note=create cb_note
this.Control[]={this.st_18,&
this.p_3,&
this.st_part_name,&
this.st_16,&
this.st_vendor_part,&
this.st_15,&
this.p_2,&
this.st_1,&
this.sle_lead_time,&
this.st_14,&
this.st_11,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.sle_min_order_qty,&
this.sle_min_on_hand,&
this.st_4,&
this.dw_template,&
this.st_2,&
this.sle_mps_uncovered,&
this.st_13,&
this.sle_mps_covered,&
this.st_10,&
this.dw_price_matrix,&
this.lb_um,&
this.st_over_received,&
this.sle_1,&
this.st_12,&
this.dw_po_detail,&
this.dw_mps_demand,&
this.uo_hard_queue,&
this.st_17,&
this.st_release,&
this.p_1,&
this.cb_create,&
this.gb_4,&
this.gb_1,&
this.cb_note}
end on

on w_smart_po_detail_entry_version3.destroy
destroy(this.st_18)
destroy(this.p_3)
destroy(this.st_part_name)
destroy(this.st_16)
destroy(this.st_vendor_part)
destroy(this.st_15)
destroy(this.p_2)
destroy(this.st_1)
destroy(this.sle_lead_time)
destroy(this.st_14)
destroy(this.st_11)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.sle_min_order_qty)
destroy(this.sle_min_on_hand)
destroy(this.st_4)
destroy(this.dw_template)
destroy(this.st_2)
destroy(this.sle_mps_uncovered)
destroy(this.st_13)
destroy(this.sle_mps_covered)
destroy(this.st_10)
destroy(this.dw_price_matrix)
destroy(this.lb_um)
destroy(this.st_over_received)
destroy(this.sle_1)
destroy(this.st_12)
destroy(this.dw_po_detail)
destroy(this.dw_mps_demand)
destroy(this.uo_hard_queue)
destroy(this.st_17)
destroy(this.st_release)
destroy(this.p_1)
destroy(this.cb_create)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.cb_note)
end on

event closequery;/* 04-05-2000 KAZ Added to prompt the user to save if the Detail line has been modified
						before continuing processing.  Issue # 13220 */

Int iRtnCode

If Not bNoInfo Then

	iRtnCode = messagebox( monsys.msg_title, 'Do you want to save the changes?', &
						Exclamation!, YesNoCancel! , 3 )

	CHOOSE Case iRtnCode 

		Case 1
			dw_po_detail.triggerevent ( "ue_save" )
			w_smart_po.dw_crosstab.Reset()
			If w_smart_po.bVendorMode then
				w_smart_po.wf_build_crosstab()
			Else
				w_smart_po.wf_build_crosstab_in_part_mode()
			End If
			If IsValid( w_smart_po_detail_entry_version3) then
				Close(w_smart_po_detail_entry_version3)
			End If
		Case 2 
         close ( this )
		Case 3
			Message.Returnvalue = 1       
	End Choose
Else
	close ( this )
End If

end event

type st_18 from statictext within w_smart_po_detail_entry_version3
int X=2711
int Y=736
int Width=128
int Height=52
boolean Enabled=false
string Text="Notes"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_3 from picture within w_smart_po_detail_entry_version3
int X=2638
int Y=736
int Width=69
int Height=60
boolean Enabled=false
string PictureName="noteyes.bmp"
boolean FocusRectangle=false
end type

type st_part_name from statictext within w_smart_po_detail_entry_version3
int X=1806
int Y=100
int Width=1001
int Height=48
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_16 from statictext within w_smart_po_detail_entry_version3
int X=1445
int Y=100
int Width=366
int Height=48
boolean Enabled=false
string Text="Part Description:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_vendor_part from statictext within w_smart_po_detail_entry_version3
int X=896
int Y=100
int Width=512
int Height=48
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_15 from statictext within w_smart_po_detail_entry_version3
int X=526
int Y=100
int Width=357
int Height=48
boolean Enabled=false
string Text="Vendor Part No:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_2 from picture within w_smart_po_detail_entry_version3
int X=2272
int Y=732
int Width=69
int Height=64
string PictureName="delbox.bmp"
boolean FocusRectangle=false
end type

type st_1 from statictext within w_smart_po_detail_entry_version3
int X=2350
int Y=736
int Width=288
int Height=48
boolean Enabled=false
string Text="Mark Deleted"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_lead_time from singlelineedit within w_smart_po_detail_entry_version3
int X=1408
int Y=4
int Width=233
int Height=80
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_14 from statictext within w_smart_po_detail_entry_version3
int X=1184
int Y=48
int Width=197
int Height=48
boolean Enabled=false
string Text="Time"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=8421504
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_11 from statictext within w_smart_po_detail_entry_version3
int X=1239
int Width=114
int Height=48
boolean Enabled=false
string Text="Lead"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_9 from statictext within w_smart_po_detail_entry_version3
int X=2304
int Y=48
int Width=247
int Height=52
boolean Enabled=false
string Text="Uncovered"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_8 from statictext within w_smart_po_detail_entry_version3
int X=1733
int Y=48
int Width=192
int Height=48
boolean Enabled=false
string Text="Covered"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_7 from statictext within w_smart_po_detail_entry_version3
int X=640
int Y=48
int Width=197
int Height=48
boolean Enabled=false
string Text="Qty"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=8421504
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_6 from statictext within w_smart_po_detail_entry_version3
int X=50
int Y=48
int Width=288
int Height=52
boolean Enabled=false
string Text="Qty"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=8421504
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_smart_po_detail_entry_version3
int X=640
int Width=215
int Height=68
boolean Enabled=false
string Text="Min Order "
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=8421504
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_min_order_qty from singlelineedit within w_smart_po_detail_entry_version3
int X=873
int Y=4
int Width=233
int Height=80
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_min_on_hand from singlelineedit within w_smart_po_detail_entry_version3
int X=361
int Y=4
int Width=233
int Height=80
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_smart_po_detail_entry_version3
int X=69
int Width=288
int Height=52
boolean Enabled=false
string Text="Min On Hand"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=8421504
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_template from datawindow within w_smart_po_detail_entry_version3
int X=855
int Y=1856
int Width=489
int Height=356
int TabOrder=110
boolean Visible=false
string DataObject="dw_external_template"
boolean LiveScroll=true
end type

type st_2 from statictext within w_smart_po_detail_entry_version3
int X=1861
int Width=128
int Height=48
boolean Enabled=false
string Text="(Blue)"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
long BorderColor=65280
int TextSize=-7
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_mps_uncovered from singlelineedit within w_smart_po_detail_entry_version3
int X=2560
int Y=4
int Width=256
int Height=80
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;MessageBox(monsys.msg_title, "Total uncovered MPS quantity for the current part", Information!)
end event

type st_13 from statictext within w_smart_po_detail_entry_version3
int X=2304
int Y=4
int Width=210
int Height=52
boolean Enabled=false
string Text="MPS"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_mps_covered from singlelineedit within w_smart_po_detail_entry_version3
int X=2007
int Y=4
int Width=233
int Height=80
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event rbuttondown;Messagebox(monsys.msg_title, "Total MPS covered quantity for the current part", Information!)
end event

type st_10 from statictext within w_smart_po_detail_entry_version3
int X=1733
int Width=105
int Height=48
boolean Enabled=false
string Text="MPS"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_price_matrix from datawindow within w_smart_po_detail_entry_version3
int X=343
int Y=1856
int Width=489
int Height=356
int TabOrder=100
boolean Visible=false
string DataObject="dw_smart_vendor_part_price_matrix"
boolean LiveScroll=true
end type

type lb_um from listbox within w_smart_po_detail_entry_version3
int X=32
int Y=1856
int Width=270
int Height=176
int TabOrder=90
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_over_received from statictext within w_smart_po_detail_entry_version3
int X=1321
int Y=736
int Width=210
int Height=56
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_1 from singlelineedit within w_smart_po_detail_entry_version3
int X=14
int Width=2830
int Height=100
int TabOrder=10
boolean Enabled=false
boolean Border=false
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_12 from statictext within w_smart_po_detail_entry_version3
int X=2112
int Y=736
int Width=160
int Height=48
boolean Enabled=false
string Text="Printed"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_po_detail from u_smart_po_detail_dw within w_smart_po_detail_entry_version3
int X=32
int Y=792
int Width=2793
int Height=620
int TabOrder=30
string DragIcon="MONITOR.ICO"
boolean HScrollBar=true
boolean VScrollBar=true
end type

event dragdrop;Long iRow
Long iRowId

Decimal nQty

String szStdUM
String szYear, szMonth, szDay
String szName
String l_s_vendor
dec	ld_price

Date	dDate

Integer li_seqno

If Not bMPS then
	Return
End If

//MB 01/29/04 Included this check to see if user was trying to add a release and return if info is not saved yet.
If m_smart_po_detail.m_file.m_batchcreate.enabled = false then
	Return
End if

If IsNull(szUM) then
	MessageBox(monsys.msg_title, "Missing unit of measure, please set it up first", StopSign!)
	Return
End If

If IsNull(szTerms) then
	MessageBox(monsys.msg_title, "Missing terms, please set it up first", StopSign!)
	Return
End If

bMPS			= false
bNoInfo		= false
szStdUm		= f_get_part_info(szPart, "STANDARD UNIT")
szName		= f_get_part_info(szPart, "NAME")
l_s_vendor		= wf_get_vendor_code(iPO)
szGLAccount	= f_get_part_info(szPart, "GL ACCOUNT")

wf_create_mps_template()

For iRow	= 1 to dw_template.RowCount()

	dw_po_detail.InsertRow(1)
	dw_po_detail.SetItem(1, "part_number"	, szPart)
	dw_po_detail.SetItem(1, "description"	, szName)
	dw_po_detail.SetItem(1, "po_number"		, iPO)
	dw_po_detail.SetItem(1, "status", "A")
	dw_po_detail.SetItem(1, "vendor_code", l_s_vendor)
	dw_po_detail.SetItem(1, "terms", szTerms)
	dw_po_detail.SetItem(1, "received", 0)

	nQty		= Dec(dw_template.GetItemString(iRow, "value2"))
	dDate		= Date(dw_template.GetItemString(iRow, "value1"))

	szYear	= Right(String(Year(dDate)), 2)
	szMonth	= String(Month(dDate))
	szDay		= String(Day(dDate))
	ld_price = dw_po_detail.getitemdecimal(1, "price")
	
	dw_po_detail.SetItem(1, "standard_qty", nQty)
	nQty	= f_convert_units("", szUM, szPart, nQty)
	dw_po_detail.SetItem(1, "quantity", nQty)
	dw_po_detail.SetItem(1, "date_due", dDate)
	dw_po_detail.SetItem(1, "balance", nQty)
	dw_po_detail.SetItem(1, "unit_of_measure", szUM)
	dw_po_detail.SetItem(1, "release_no", iRelease)
	dw_po_detail.SetItem(1, "terms", szTerms)
	dw_po_detail.SetItem(1, "week_no", f_get_week_no(dDate))	
	dw_po_detail.SetItem(1, "plant", szPlant)
	dw_po_detail.SetItem(1, "account_code", szGLAccount)
	dw_po_detail.SetItem(1, "ship_via", szShipVia)
	dw_po_detail.SetItem(1, "week_no", f_get_week_no(dpodate))
	dw_po_detail.SetItem(1, "price", uf_get_price ( nQty, ld_price ) )
	dw_po_detail.SetItem(1, "row_id", i_l_next_row_id + il_row_add )
	
	// Modified to set sequential row id from po header MB 01/28/04
	il_row_add++
	
	iPODetailRow	= 1

Next 

Parent.TriggerEvent("save_release")
end event

event ue_delete;/* Declaration */

long		ll_row, &
			ll_row_deleted, &
			ll_total

date		ld_datedue

boolean	lb_NoDelete

string	ls_message

decimal	lc_received

/* Initialization */
ll_row_deleted	= 0
ll_total			= this.rowcount()

/* Main Process */

For ll_row = ll_total to 1 Step -1
	If this.isselected(ll_row) Then
		ll_row_deleted	++
		If (f_get_string_value(&
				this.getitemstring(ll_row, "deleted")) <> 'Y') then
			ld_DateDue	= Date(this.getitemdatetime( ll_row, "date_due" ))
			lb_NoDelete	= (this.getitemstring( ll_row, "printed") = 'Y' )
	
			lc_received	= 	dec(st_over_received.text) + &
							 	f_get_value(&
									this.GetItemNumber(ll_row, "received"))
			st_over_received.text	= 	String(Truncate(lc_received, 0))

			wf_mark_deletion( ll_row, szPart )
			ib_marked_deletion	= TRUE
			If Update ( ) = -1 Then
					RollBack ;
			Else
					Commit ;
			End If
			ib_data_changed	= TRUE
		End If
	End If
Next

This.TriggerEvent ( "ue_save" )

This.selectrow(0, FALSE)


end event

event ue_save;/* 03-17-2000 KAZ Modified to exit if there is no new or changed data.  Issue # 13221 */
/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */

integer li_seqno

If bNoInfo Then												// ADD 03-17-2000 KAZ
	wf_get_unit_of_measurement_part ( szpart )		// ADD 04-05-2000 KAZ
	dw_po_detail.retrieve(iPO, szPart ) 				// ADD 03-17-2000 KAZ
	il_row_add = 0
	return														// ADD 03-17-2000 KAZ
End If															// ADD 03-17-2000 KAZ

If bError Then
   MessageBox(monsys.msg_title, "You cannot order less than ~rMinimum On Order Quantity!", StopSign!	)
   dw_po_detail.SetText("")
	Return
End If

/* Routine to remove the printed for the existing po detail */
If dw_po_detail.RowCount() = 0 Then
	If wf_nonreocurring_item( szPart ) Then
		Messagebox( monsys.msg_title, 'Since this is a non-' + &
						'reoccuring item, the system will ' + &
						'automatically delete vendor/part profile.', + &
						StopSign!)
		wf_delete_profile( szVendor, szPart )
		If IsValid( wHostWindow ) Then
			wHostWindow.TriggerEvent( 'ue_delete_profile' )
		End If
	End If
Else
	il_rowid = dw_po_detail.GetItemNumber ( dw_po_detail.GetRow (), "row_id" )

	 UPDATE po_detail  
       SET printed = 'N'  
  	  WHERE po_detail.po_number = :ipo  AND  
     		  po_detail.part_number = :szpart   AND
        	  po_detail.row_id = :il_rowid ;

	dw_po_detail.SetItem ( il_rowid, 'printed', "" )
End If
/* End of Routine */

If ISNULL(st_over_received.text) or st_over_received.text = '' Then 
   st_over_received.text = '0'
End If
 
If Parent.wf_assign_releases() then		//If no errors in assigning release#
	If Parent.wf_update_over_recved(szVendor, szPart, dec(st_over_received.text)) Then
		If (This.Update() > 0)  Then
			li_seqno = i_l_next_row_id + il_row_add
			// MB 01/27/04 update po_header with next seq no 
			Update po_header
			Set  next_seqno = :li_seqno
			Where po_number = :iPO ;
				
			IF sqlca.sqlcode <> 0 THEN
				rollback ;
				messagebox ( monsys.msg_title, "Unable to update next sequence number in PO Header table!" )
			END IF
			
			Commit;
			i_l_next_row_id = li_seqno
			il_row_add = 0
			wf_reset_demand_flywheel()
			wf_reset_overreceived()
			bNoCommit = FALSE
			f_recalc_po_detail_per_part(iPO, szPart, w_smart_po_detail_entry_version3)
			SetMicroHelp ( 'Recalculating assigned quantities in MPS : ' + szpart )
		   f_update_qty_asgnd_part ( szpart ) 
			dw_mps_demand.Retrieve(szPart)
			wf_get_unit_of_measurement_part ( szpart )	// ADD 04-05-2000 KAZ
			this.Retrieve(iPO, szPart)
			ib_data_changed	= FALSE
			bNoInfo = True											// ADD 03-17-2000 KAZ

	   Else
			
			Rollback;
			
		End If
	Else
		Rollback;
	End If
		parent.wf_display_mps_covered(szPart)

End If

SetMicroHelp ( 'Ready' )										// ADD 03-17-2000 KAZ
end event

event ue_insert;/* 03-17-2000 KAZ Modified to exit if there is no new or changed data.  Issue # 13221 */
/* 04-05-2000 KAZ Modified to call window function wf_get_unit_of_measurement_part to 
						populate unit of measure DDDW in dw_po_detail.  Issue # 13193 */
/* 02-12-2004 MB  Modified to check non order status for part and add release accordingly */

LONG	l_l_count

String l_s_nonorder_status, &
		 l_s_note

bNoInfo = True																				// ADD 03-17-2000 KAZ

wf_get_unit_of_measurement_part ( szPart )										// ADD 04-05-2000 KAZ

l_s_note = f_get_part_no_status ( szPart )
l_s_nonorder_status = Left ( l_s_note, 1 )
	
if l_s_nonorder_status = 'N' then 
	l_s_note = Mid ( l_s_note, 3,  len ( l_s_note ) - 2 )
	messagebox ( monsys.msg_title, 'Unable to add release for this part. ' + l_s_note )
	return 1
end if

dw_po_detail.InsertRow(1)
dw_po_detail.SetItem(1, "date_due",  datetime ( today(), time ( '00:00:00' ) ) )
dw_po_detail.SetItem(1, "part_number", szPart)
dw_po_detail.SetItem(1, "po_number", iPO)
dw_po_detail.SetItem(1, "status", "A")
dw_po_detail.SetItem(1, "vendor_code", wf_get_vendor_code(iPO))
dw_po_detail.SetItem(1, "received", 0)
dw_po_detail.SetItem(1, "unit_of_measure", szUM)	
dw_po_detail.SetItem(1, "description", f_get_part_info(szPart, "NAME"))
dw_po_detail.SetItem(1, "terms", szTerms)
dw_po_detail.SetItem(1, "plant", szPlant)
dw_po_detail.SetItem(1, "printed", "N")
dw_po_detail.SetItem(1, "release_no", iRelease)
dw_po_detail.SetItem(1, "account_code", szGLAccount)
dw_po_detail.SetItem(1, "ship_type", szShipType)
dw_po_detail.SetItem(1, "ship_via", szShipVia)
dw_po_detail.SetItem(1, "week_no", f_get_week_no(dpodate) )
dw_po_detail.SetItem(1, "row_id", i_l_next_row_id + il_row_add )
il_row_add = il_row_add + 1

dw_po_detail.accepttext()

dw_po_detail.SetRow(1)
dw_po_detail.SetColumn(1)
dw_po_detail.SetFocus()


end event

event clicked;Long ll_Row
Long ll_PreviousRow

Int ll_Count

// To select a bunch of rows to mark for deletion

ll_Row = dw_po_detail.GetClickedRow ( )

If ll_Row < 1 Then Return

If ll_Row > 0 then

	this.SelectRow(ll_Row, TRUE)
    
 	If this.GetItemString(ll_Row, "deleted") = 'Y' then
		this.SetTabOrder("date_due", 0)
		this.SetTabOrder("quantity", 0)
		this.SetTabOrder("received", 0)
		this.SetTabOrder("price", 0)
		this.SetTabOrder("terms", 0)
	Else
		this.SetTabOrder("date_due", 10)
		this.SetTabOrder("quantity", 20)
		this.SetTabOrder("received", 0)
		this.SetTabOrder("price", 40)
		this.SetTabOrder("terms", 50)
	End If
End if

If KeyDown ( keyShift! ) Then
   
	ll_PreviousRow = dw_po_Detail.GetRow() 
   SelectRow (this, 0, False) 
   If ll_PreviousRow < ll_Row Then
		For ll_Count = ll_PreviousRow to ll_Row
			SelectRow ( This, ll_Count, True )
		Next
   Else
    	For ll_Count = ll_Row to ll_PreviousRow
			SelectRow ( This, ll_Count, True )
		Next
   End If

Elseif KeyDown ( keyControl! ) Then

	ll_Count = This.GetRow() 
	SelectRow ( dw_po_detail, ll_Count, True )

Else
 
   SelectRow ( this, 0, False )
   SelectRow ( this, ll_Row, True )

End if

ll_PreviousRow = ll_Count

// End of routine to select bunch of rows to mark for deletion




end event

event constructor;dw_po_detail.Modify("quantity.color = '0~tif(status =~~'H~~', 255, 0)'")
dw_po_detail.Modify("date_due.color = '0~tif(status =~~'H~~', 255, 0)'")
dw_po_detail.Modify("received.color = '0~tif(status =~~'H~~', 255, 0)'")
dw_po_detail.Modify("unit_of_measure.color = '0~tif(status =~~'H~~', 255, 0)'")
dw_po_detail.Modify("balance.color = '0~tif(status =~~'H~~', 255, 0)'")

call super::constructor


end event

event doubleclicked;Long	ll_row


ll_row	= this.uf_row_clicked(2)
If this.uf_clicked_value('ship_type') = 'D' then //Do not allow to delete the ship type
	this.SelectRow(ll_row, FALSE)
	MessageBox(monsys.msg_title, "You can not highlight DROP-SHIP releases for deletion.", &
					StopSign!)
Else
	if this.uf_clicked_value('deleted') = 'Y' then
		this.SelectRow(ll_row, FALSE)
		messagebox(monsys.msg_title, "This release has already been marked " + &
						"for deletion.", StopSign!)
	end if
End If
end event

event rbuttondown;MessageBox(monsys.msg_title, "P.O. Releases", Information!)
end event

event itemchanged;call super::itemchanged;/* 03-17-2000 KAZ Modified to exit if there is no new or changed data.  Issue # 13221 */
/* 04-05-2000 KAZ Modified to get price from part_vendor_price_matrix.  Issue # 13323 */

Dec   ln_price	// ADD 04-05-2000 KAZ
Dec	ld_price

IF dwo.name = 'date_due' THEN
	dw_po_detail.SetItem ( row, "week_no", f_get_week_no ( date ( dw_po_detail.object.date_due[row] ) ) )
END IF

IF dwo.name = 'quantity' THEN																// ADD 04-05-2000 KAZ
	ld_price = object.price[row]
  	ln_price		= wf_get_price ( Dec(dw_po_detail.gettext()), ld_price )		// ADD 04-05-2000 KAZ
	dw_po_detail.SetItem ( row, "price", ln_price )									// ADD 04-05-2000 KAZ
End If																							// ADD 04-05-2000 KAZ

bNoInfo = False																				// ADD 03-17-2000 KAZ

end event

event editchanged;/* 03-17-2000 KAZ Modified to exit if there is no new or changed data.  Issue # 13221 */

bNoInfo = False																		// ADD 03-17-2000 KAZ
end event

type dw_mps_demand from u_monitor_data_entry_dw within w_smart_po_detail_entry_version3
int X=37
int Y=164
int Width=2793
int Height=528
int TabOrder=50
string DragIcon="MONITOR.ICO"
string DataObject="dw_smart_mps_demand_query"
boolean VScrollBar=true
end type

on dragdrop;call u_monitor_data_entry_dw::dragdrop;bMPS	= FALSE
end on

event constructor;call super::constructor;dw_mps_demand.Modify("due.color = '0~tif(qnty = qty_assigned, 16711680, 0)'")
dw_mps_demand.Modify("qnty.color = '0~tif(qnty = qty_assigned, 16711680 , 0)'")
dw_mps_demand.Modify("source.color = '0~tif(qnty = qty_assigned, 16711680, 0)'")
dw_mps_demand.Modify("origin.color = '0~tif(qnty = qty_assigned, 16711680, 0)'")
dw_mps_demand.Modify("dead_start.color = '0~tif(qnty = qty_assigned, 16711680, 0)'")
dw_mps_demand.Modify("assigned.color = '0~tif(qnty = qty_assigned, 16711680, 0)'")

call super::constructor
end event

on rbuttondown;call u_monitor_data_entry_dw::rbuttondown;MessageBox("Help", "COP exploded MPS requirements", Information!)
end on

on clicked;iMPSRow	= this.uf_row_clicked(0)

bMPS	= FALSE

If iMPSRow > 0 then
	bMPS	= TRUE
	this.Drag(Begin!)
End If	
end on

event doubleclicked;Long iRow

iRow	= this.GetClickedRow()

If iRow > 0 then
	If this.GetItemNumber(iRow, "qnty") = this.GetItemNumber(iRow, "qty_assigned") then
		MessageBox(monsys.msg_title, "Demand has already been scheduled for receiving!", StopSign!)
	Else		
		this.SelectRow(iRow, Not(this.IsSelected(iRow)))
	End If
End If
end event

type uo_hard_queue from u_po_detail_hard_queue_coverage within w_smart_po_detail_entry_version3
int X=14
int Y=100
int Width=2885
int TabOrder=60
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on uo_hard_queue.destroy
call u_po_detail_hard_queue_coverage::destroy
end on

type st_17 from statictext within w_smart_po_detail_entry_version3
int X=978
int Y=736
int Width=334
int Height=52
boolean Enabled=false
string Text="OverReceived:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_release from statictext within w_smart_po_detail_entry_version3
int X=1536
int Y=736
int Width=471
int Height=60
boolean Enabled=false
string Text="Current Release:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_1 from picture within w_smart_po_detail_entry_version3
int X=2021
int Y=732
int Width=69
int Height=64
string PictureName="printer.bmp"
boolean FocusRectangle=false
end type

type cb_create from commandbutton within w_smart_po_detail_entry_version3
int X=1074
int Y=444
int Width=1129
int Height=704
int TabOrder=70
boolean Visible=false
boolean Enabled=false
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_4 from groupbox within w_smart_po_detail_entry_version3
int X=14
int Y=96
int Width=2830
int Height=640
int TabOrder=40
string Text="MPS Demand"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_smart_po_detail_entry_version3
int X=14
int Y=736
int Width=2830
int Height=700
int TabOrder=20
string Text="PO Releases"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=77897888
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_note from commandbutton within w_smart_po_detail_entry_version3
int X=526
int Y=420
int Width=1833
int Height=592
int TabOrder=80
boolean Visible=false
boolean Enabled=false
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

