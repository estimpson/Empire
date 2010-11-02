HA$PBExportHeader$u_calendar.sru
$PBExportComments$Extension Calendar class
forward
global type u_calendar from pfc_u_calendar
end type
end forward

global type u_calendar from pfc_u_calendar
end type
global u_calendar u_calendar

type variables

Protected:

integer	ORIGHEIGHT = 640
integer	ORIGWIDTH = 695
end variables

forward prototypes
public function integer of_setdate (date ad_date, boolean ab_setrequestor)
end prototypes

public function integer of_setdate (date ad_date, boolean ab_setrequestor);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetDate
//
//	Access:    Protected
//
//	Arguments:
//  ad_date		The date to set.
//	 ab_setrequestor	Switch stating if the requestor object should get this date.
//
//	Returns:  Integer
//		1 if it succeeds and$$HEX1$$a000$$ENDHEX$$-1 if an error occurs.
//
//	Description: Sets a new date on the Visual calendar date.  If appropriate, it
//		will also set the requestor to get this new date.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer			li_rc = 1
Integer 			li_month
Integer 			li_year
Integer 			li_day
Integer  		li_FirstDayNum
String			ls_newcell
String			ls_date

// Check the argument(s).
If Not inv_datetime.of_IsValid(ad_date) Then
	Return -1
End If

// Set the new date.
id_date = ad_date

// If appropriate, set the requestor with the new date.
If ab_setrequestor Then
	// Convert the date into a string.
	ls_date = string(ad_date, is_dateformat)

	// Set the requestor with the new date.
	If IsValid(idw_requestor) Then
		idw_requestor.SetText(ls_date)
		if not IsValid ( inv_DropDown ) then idw_Requestor.AcceptText()
	ElseIf IsValid(iem_requestor) Then
		iem_requestor.Text = ls_date	
		iem_requestor.post event modified ( )
	Else 
		Return -1
	End If
End If
						 
//If appropriate, draw a new month.
If (Year(ad_date) <> Year(id_prevdate) Or Month(ad_date) <> Month(id_prevdate)) Or &
	ib_alwaysredraw Then
	of_DrawMonth(ad_date)
End If
						 
//Initialize local values.
li_year = Year(ad_date)
li_month = Month(ad_date)
li_day = Day(ad_date)

// Unhighlight any previous cell.
If Len(Trim(is_prevcell)) > 0 Then
	If dw_cal.Modify(is_prevcell + ".border=0") <> "" Then
		li_rc = -1
	End If
End If

//Highlight the current date.
li_FirstDayNum = DayNumber(Date(li_year, li_month, 1))
ls_newcell = 'cell'+string(li_FirstDayNum + li_day - 1)
If dw_cal.Modify(ls_newcell + ".border=5") <> "" Then
	li_rc = -1
End if

// Store the new previous infomration.
is_prevcell = ls_newcell
id_prevdate = ad_date

Return li_rc




end function

on u_calendar.create
call super::create
end on

on u_calendar.destroy
call super::destroy
end on

event constructor;call super::constructor;
//	Setup resize.
of_SetResize ( true )

//	Set original size.
inv_resize.of_SetOrigSize ( ORIGWIDTH, ORIGHEIGHT )

//	Register controls.
inv_resize.of_Register ( dw_cal, 0, 0, 100, 100 )

end event

event dw_cal::constructor;call super::constructor;
//	Setup datawindow resize.
of_SetResize ( true )

//	Set original size.
inv_resize.post function of_SetOrigSize ( ORIGWIDTH, ORIGHEIGHT )

//	Set minimum size.
inv_resize.post function of_SetMinSize ( width / 2, ORIGHEIGHT )

//	Register controls.
inv_resize.post function of_Register ( "prevmonth", 0, 0, 10, 0 )
inv_resize.post function of_Register ( "st_month", 10, 0, 80, 0 )
inv_resize.post function of_Register ( "nextmonth", 90, 0, 10, 0 )
inv_resize.post function of_Register ( "s", 0, 0, 14, 0 )
inv_resize.post function of_Register ( "m", 14, 0, 14, 0 )
inv_resize.post function of_Register ( "t", 29, 0, 14, 0 )
inv_resize.post function of_Register ( "w", 43, 0, 14, 0 )
inv_resize.post function of_Register ( "r", 57, 0, 14, 0 )
inv_resize.post function of_Register ( "f", 71, 0, 14, 0 )
inv_resize.post function of_Register ( "a", 86, 0, 14, 0 )
inv_resize.post function of_Register ( "l", 0, 0, 100, 0 )
inv_resize.post function of_Register ( "cell1", 0, 0, 14, 16 )
inv_resize.post function of_Register ( "cell2", 14, 0, 14, 16 )
inv_resize.post function of_Register ( "cell3", 29, 0, 14, 16 )
inv_resize.post function of_Register ( "cell4", 43, 0, 14, 16 )
inv_resize.post function of_Register ( "cell5", 57, 0, 14, 16 )
inv_resize.post function of_Register ( "cell6", 71, 0, 14, 16 )
inv_resize.post function of_Register ( "cell7", 86, 0, 14, 16 )
inv_resize.post function of_Register ( "cell8", 0, 16, 14, 16 )
inv_resize.post function of_Register ( "cell9", 14, 16, 14, 16 )
inv_resize.post function of_Register ( "cell10", 29, 16, 14, 16 )
inv_resize.post function of_Register ( "cell11", 43, 16, 14, 16 )
inv_resize.post function of_Register ( "cell12", 57, 16, 14, 16 )
inv_resize.post function of_Register ( "cell13", 71, 16, 14, 16 )
inv_resize.post function of_Register ( "cell14", 86, 16, 14, 16 )
inv_resize.post function of_Register ( "cell15", 0, 33, 14, 16 )
inv_resize.post function of_Register ( "cell16", 14, 33, 14, 16 )
inv_resize.post function of_Register ( "cell17", 29, 33, 14, 16 )
inv_resize.post function of_Register ( "cell18", 43, 33, 14, 16 )
inv_resize.post function of_Register ( "cell19", 57, 33, 14, 16 )
inv_resize.post function of_Register ( "cell20", 71, 33, 14, 16 )
inv_resize.post function of_Register ( "cell21", 86, 33, 14, 16 )
inv_resize.post function of_Register ( "cell22", 0, 50, 14, 16 )
inv_resize.post function of_Register ( "cell23", 14, 50, 14, 16 )
inv_resize.post function of_Register ( "cell24", 29, 50, 14, 16 )
inv_resize.post function of_Register ( "cell25", 43, 50, 14, 16 )
inv_resize.post function of_Register ( "cell26", 57, 50, 14, 16 )
inv_resize.post function of_Register ( "cell27", 71, 50, 14, 16 )
inv_resize.post function of_Register ( "cell28", 86, 50, 14, 16 )
inv_resize.post function of_Register ( "cell29", 0, 67, 14, 16 )
inv_resize.post function of_Register ( "cell30", 14, 67, 14, 16 )
inv_resize.post function of_Register ( "cell31", 29, 67, 14, 16 )
inv_resize.post function of_Register ( "cell32", 43, 67, 14, 16 )
inv_resize.post function of_Register ( "cell33", 57, 67, 14, 16 )
inv_resize.post function of_Register ( "cell34", 71, 67, 14, 16 )
inv_resize.post function of_Register ( "cell35", 86, 67, 14, 16 )
inv_resize.post function of_Register ( "cell36", 0, 83, 14, 16 )
inv_resize.post function of_Register ( "cell37", 14, 83, 14, 16 )
inv_resize.post function of_Register ( "cell38", 29, 83, 14, 16 )
inv_resize.post function of_Register ( "cell39", 43, 83, 14, 16 )
inv_resize.post function of_Register ( "cell40", 57, 83, 14, 16 )
inv_resize.post function of_Register ( "cell41", 71, 83, 14, 16 )
inv_resize.post function of_Register ( "cell42", 86, 83, 14, 16 )

end event

event dw_cal::losefocus;call super::losefocus;
//	If the requestor is valid, accept date.
if IsValid ( idw_Requestor ) then idw_Requestor.AcceptText ()

end event

