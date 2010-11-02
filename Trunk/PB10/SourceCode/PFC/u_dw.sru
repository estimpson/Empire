HA$PBExportHeader$u_dw.sru
$PBExportComments$Extension DataWindow class
forward
global type u_dw from pfc_u_dw
end type
end forward

global type u_dw from pfc_u_dw
event pfd_event ( string eventname,  n_cst_associative_array eventmessage )
end type
global u_dw u_dw

type variables

Public:
integer	ii_Column

long	il_HScrollPos
long	il_VScrollPos
long	il_Row

n_cst_dwsrv_linkdwsearch	inv_LinkDWSearch
n_cst_dwsrv_search inv_search

Private:
boolean	ib_Redraw = true
boolean ib_Refresh = false

end variables

forward prototypes
public function integer setredraw (boolean ab_redraw)
public function integer of_refresh (boolean ab_refresh)
public function integer of_setlinkdwsearch (boolean ab_switch)
public function integer of_setsearch (boolean ab_switch)
public function integer of_settransobject (n_tr atr_object)
end prototypes

event pfd_event(string eventname, n_cst_associative_array eventmessage);
choose case EventName
	case "Connect"
		SetTransObject (itr_Object)
end choose

end event

public function integer setredraw (boolean ab_redraw);
//	Record redraw.
ib_Redraw = ab_Redraw

//	Return.
return super::SetRedraw ( ib_Redraw )
end function

public function integer of_refresh (boolean ab_refresh);
//	Set refresh.
ib_Refresh = ab_Refresh

//	Retrieve.
return 0

end function

public function integer of_setlinkdwsearch (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Event:  of_SetLinkDWSearch
//
//	(Arguments: boolean
//   TRUE  - Start (create) the service
//   FALSE - Stop (destroy ) the service
//
//	Returns:  		Integer
//						 1 - Successful operation.
//						 0 - No action taken.
//						-1 - An error was encountered.
//
//	Description:  Starts or stops the DropDownDataWindow search services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//Check arguments
If IsNull(ab_switch) Then
	Return FAILURE
End If

IF ab_Switch THEN
	IF IsNull(inv_LinkDWSearch) Or Not IsValid (inv_LinkDWSearch) THEN
		inv_LinkDWSearch = Create n_cst_dwsrv_LinkDWSearch
		inv_LinkDWSearch.of_SetRequestor ( this )
		Return SUCCESS
	END IF
ELSE 
	IF IsValid (inv_LinkDWSearch) THEN
		Destroy inv_LinkDWSearch
		Return SUCCESS
	END IF	
END IF 

Return NO_ACTION
end function

public function integer of_setsearch (boolean ab_switch);
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  of_SetDropdownSearch
//
//	(Arguments: boolean
//   TRUE  - Start (create) the service
//   FALSE - Stop (destroy ) the service
//
//	Returns:  		Integer
//						 1 - Successful operation.
//						 0 - No action taken.
//						-1 - An error was encountered.
//
//	Description:  Starts or stops the DropDownDataWindow search services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//Check arguments
If IsNull(ab_switch) Then
	Return FAILURE
End If

IF ab_Switch THEN
	IF IsNull(inv_search) Or Not IsValid (inv_search) THEN
		inv_search = Create n_cst_dwsrv_search
		inv_search.of_SetRequestor ( this )
		Return SUCCESS
	END IF
ELSE 
	IF IsValid (inv_search) THEN
		Destroy inv_search
		Return SUCCESS
	END IF	
END IF 

Return NO_ACTION
end function

public function integer of_settransobject (n_tr atr_object);
//	Ask for notification of reconnects.
gnv_App.inv_StateMsgRouter.of_RequestNotification (this, "Connect")

//	Invoke ancestor script.
return super::of_SetTransObject (atr_Object)

end function

event retrievestart;call super::retrievestart;
//	Record current positions.
il_HScrollPos = Long ( object.datawindow.horizontalscrollposition )
il_VScrollPos = Long ( object.datawindow.verticalscrollposition )
ii_Column = GetColumn ()
il_Row = GetRow ( )

//	Set redraw off to prevent flicker.
super::SetRedraw ( false )
end event

event retrieveend;call super::retrieveend;
//	If refresh, set positions.
if ib_Refresh then
	ib_Refresh = false
	object.datawindow.horizontalscrollposition = String (il_HScrollPos)
	object.datawindow.verticalscrollposition = String (il_VScrollPos)
	SetColumn (ii_Column)
	SetRow (il_Row)
end if

//	Restore redraw.
super::SetRedraw (ib_Redraw)
end event

event destructor;call super::destructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			Destructor
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	
//	Destroy the instantiated datawindow services attached to this dw.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
// 6.0 	Added cleanup for new 6.0 services.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

of_SetLinkDWSearch (false)

end event

on u_dw.create
call super::create
end on

on u_dw.destroy
call super::destroy
end on

event itemfocuschanged;call super::itemfocuschanged;
if IsValid(inv_DropDownSearch) then
	inv_DropDownSearch.Event pfc_itemfocuschanged (row, dwo)
end if

if IsValid(inv_Search) Then
	inv_Search.Event pfc_itemfocuschanged (row, dwo)
end if

end event

event editchanged;call super::editchanged;
if IsValid(inv_DropDownSearch) then
	inv_DropDownSearch.Event pfc_itemfocuschanged (row, dwo)
end if

if IsValid(inv_Search) then
	inv_Search.Event pfc_itemfocuschanged (row, dwo)
end if

end event

