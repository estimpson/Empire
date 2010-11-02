HA$PBExportHeader$w_dropshiprefreshpo_frame.srw
forward
global type w_dropshiprefreshpo_frame from w_frame
end type
end forward

global type w_dropshiprefreshpo_frame from w_frame
integer width = 2706
integer height = 1904
string menuname = "m_dropship_frame"
end type
global w_dropshiprefreshpo_frame w_dropshiprefreshpo_frame

on w_dropshiprefreshpo_frame.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_dropship_frame" then this.MenuID = create m_dropship_frame
end on

on w_dropshiprefreshpo_frame.destroy
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
long	ll_Result
string	ls_SQLError
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_DropShipRefreshPODetail " + &
"select	@Result"

declare DropShipRefreshPODetail dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic DropShipRefreshPODetail  ;

if SQLCA.SQLCode <> 0 then
	ls_SQLError = SQLCA.SQLErrText
	ll_Result = SQLCA.SQLCode
	SQLCA.of_Rollback ()
	if ls_SQLError > "" then
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to refresh PO Detail:  " + ls_SQLError)
	else
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to refresh PO Detail:  " + String (ll_Result))
	end if
	HALT
end if

//	Get the result of the stored procedure.
fetch	DropShipRefreshPODetail
into	:ll_Result;

if ll_Result <> 0 or SQLCA.SQLCode <> 0 then
	ls_SQLError = SQLCA.SQLErrText
	SQLCA.of_Rollback ()
	if ls_SQLError > "" then
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to refresh PO Detail:  " + ls_SQLError)
	else
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to refresh PO Detail:  " + String (ll_Result))
	end if
	HALT
end if

//	Close procedure and commit.
Close	DropShipRefreshPODetail;

SQLCA.of_Commit ()
MessageBox (gnv_App.iapp_Object.DisplayName, "PO Detail Refreshed.")
HALT
end event

