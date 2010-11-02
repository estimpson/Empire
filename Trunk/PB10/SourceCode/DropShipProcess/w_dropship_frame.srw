HA$PBExportHeader$w_dropship_frame.srw
forward
global type w_dropship_frame from w_frame
end type
end forward

global type w_dropship_frame from w_frame
integer width = 2706
integer height = 1904
string menuname = "m_dropship_frame"
end type
global w_dropship_frame w_dropship_frame

on w_dropship_frame.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_dropship_frame" then this.MenuID = create m_dropship_frame
end on

on w_dropship_frame.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen;call super::pfc_preopen;
//	Restore preferences.
of_SetPreference ( true )
inv_Preference.of_SetToolbars ( true )
inv_Preference.of_SetToolbarTitles ( true )

//	Attempt to connect SQLCA to an Application database.
if SQLCA.event pfc_Connect ( "Application" ) = FAILURE then
	MessageBox ( gnv_App.iapp_Object.DisplayName, SQLCA.SQLErrText )
	halt close
	return
end if

//	Add the profile to the application title.
Title += " {" + sqlca.is_Profile + "}"

end event

event pfc_postopen;call super::pfc_postopen;
//	Open the main sheet.
OpenSheet ( w_dropship_sheet, this, 0, Original! )

end event

