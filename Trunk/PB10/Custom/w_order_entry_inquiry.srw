HA$PBExportHeader$w_order_entry_inquiry.srw
$PBExportComments$To be removed after 4.4.2 install
forward
global type w_order_entry_inquiry from w_inquiry_ancestor
end type
end forward

global type w_order_entry_inquiry from w_inquiry_ancestor
boolean TitleBar=true
string Title="Sales Orders Entry"
end type
global w_order_entry_inquiry w_order_entry_inquiry

on w_order_entry_inquiry.create
call super::create
end on

on w_order_entry_inquiry.destroy
call super::destroy
end on

event activate;if wMainScreen.MenuName <> "m_order_entry_inquiry" then
	wMainScreen.ChangeMenu ( m_order_entry_inquiry )
end if

// Added for Custom menu items
	f_build_custom_arrays("monitor.oeinquiry")
// Added for Custom menu items
	f_build_custom_menu(wMainScreen.MenuID, wMainScreen)


TriggerEvent ( 'ue_activate' )
end event

event ue_add;st_generic_structure	lstr_parm

lstr_parm.value1 = ''
lstr_parm.value2 = ''
lstr_parm.value3 = ''

OpenWithParm ( w_add_order_type, lstr_parm )

if Message.DoubleParm = 1 then
	OpenSheetWithParm ( w_blanket_order, lstr_parm, wMainScreen, 3, Layered! )
elseif Message.DoubleParm = 2 then
	OpenSheetWithParm ( w_orders_detail, lstr_parm, wMainScreen, 3, Layered! )
end if
end event

event ue_delete;long		l_l_row,&
			l_l_order,&
			l_l_count
int		l_i_rtn_code
boolean	l_b_no_message
string	l_s_temp, &
         l_s_dest, &
			l_s_part 

l_l_row = dw_inquiry.GetRow ( )

if l_l_row < 1 or NOT dw_inquiry.IsSelected ( l_l_row ) then return

l_l_order = dw_inquiry.GetItemNumber ( l_l_row, "order_no" )

 SELECT count(order_detail.order_no)
 	INTO :l_l_count
   FROM order_detail  
  WHERE order_detail.order_no = :l_l_order   ;

If l_l_count > 0 Then
	SELECT count(shipper_detail.shipper)  
	  INTO :l_l_count
	  FROM shipper_detail,   
	       shipper  
	 WHERE ( shipper.id = shipper_detail.shipper ) AND
	       ( ( shipper_detail.order_no = :l_l_order ) AND  
	       ( shipper.status = 'O' OR  
	       shipper.status = 'S' ) )   ;
	
	If l_l_count > 0 Then
		MessageBox ( "Error", "You can not delete an order with releases committed to shippers!", StopSign! )
		Return
	else	
		If MessageBox ( "Warning", "This order contains releases!  Are you sure about deleting it?", Question!, YesNo!, 2 ) <> 1 Then
			Return
		Else
			l_b_no_message = True
		End if
	end if
End if


if l_b_no_message then
	l_i_rtn_code = 1
else
	l_i_rtn_code = MessageBox ( "Delete", "Do you really want to delete order# " + String ( l_l_order ) + "?", Question!, YesNo!, 2 )
end if

If l_i_rtn_code = 1 Then

	l_s_temp = String ( l_l_order )

	wMainScreen.SetMicroHelp ( "Deleting Records..." )

   DELETE FROM master_prod_sched  
	    WHERE ( origin = :l_l_order ) ;

	If SQLCA.SQLCode = -1 Then
		RollBack ;
		wMainScreen.SetMicroHelp ( "Delete Failed! " + SQLCA.SQLErrText )
		Return
	End if

   // the below select statement inc by gph on 7/29/98 at 11.15 am  
   SELECT destination,blanket_part
	  INTO :l_s_dest, :l_s_part
	  FROM order_header
	 WHERE order_no = :l_l_order ;
	 
   DELETE FROM order_detail  
	      WHERE order_no = :l_l_order   ;
	
	If SQLCA.SQLCode = -1 Then
		RollBack ;
		wMainScreen.SetMicroHelp ( "Delete Failed! " + SQLCA.SQLErrText )
		Return
	End if

   DELETE FROM order_header
	      WHERE order_no = :l_l_order   ;
	
	If SQLCA.SQLCode = -1 Then
		RollBack ;
		wMainScreen.SetMicroHelp ( "Delete Failed! " + SQLCA.SQLErrText )
		Return
	End if


	If dw_inquiry.DeleteRow ( l_l_row ) = -1 Then
		RollBack ;
		wMainScreen.SetMicroHelp ( "Delete Failed! " + SQLCA.SQLErrText )
		Return
	End if

//	If dw_inquiry.Update ( ) = -1 Then
//		RollBack ;
//		wMainScreen.SetMicroHelp ( "Delete Failed! " + SQLCA.SQLErrText )
//		Return		
//	End if
//
	
	// deleting data from part_location table for that blanket part & destination 
	// inc by gph on 7/29/98 at 10:38 am
	DELETE 
	FROM	part_location
	WHERE	part = :l_s_part and
	       destination = :l_s_dest ;

	Commit ;

	wMainScreen.SetMicroHelp ( "Delete Successful!" )
//	dw_inquiry.retrieve()
End if

dw_inquiry.SetRow ( 1 )
dw_inquiry.SetFocus ( )

end event

type dw_inquiry from w_inquiry_ancestor`dw_inquiry within w_order_entry_inquiry
string DataObject="dw_orders_main"
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
end type

event dw_inquiry::doubleclicked;long	l_l_order

dw_inquiry.DBcancel()

if row < 1 then return

l_l_order = GetItemNumber ( row, "order_no" )

If f_get_string_value ( GetItemString ( row, "order_type" ) ) = "B" Then
	OpenSheetWithParm ( w_blanket_order, l_l_order, wmainscreen, 3, LAYERED! )
Else 
	OpenSheetWithParm ( w_orders_detail, l_l_order, wMainScreen, 3, Layered! )
End if

end event

event dw_inquiry::retrieveend;SetPointer(Arrow!)
end event

