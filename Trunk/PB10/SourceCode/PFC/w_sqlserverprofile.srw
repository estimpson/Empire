HA$PBExportHeader$w_sqlserverprofile.srw
forward
global type w_sqlserverprofile from w_response
end type
type dw_1 from datawindow within w_sqlserverprofile
end type
type cb_1 from commandbutton within w_sqlserverprofile
end type
type cb_2 from commandbutton within w_sqlserverprofile
end type
end forward

global type w_sqlserverprofile from w_response
int Width=1335
int Height=772
boolean TitleBar=true
string Title="Add / Edit SQL Server Profile"
long BackColor=78748035
event ue_save ( )
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
end type
global w_sqlserverprofile w_sqlserverprofile

type variables
string	is_OriginalProfile
string	is_AppProfile
end variables

event ue_save;//	Declarations
n_cst_registry	inv_Reg
string		ls_Profile
string		ls_ServerName
string		ls_Database
string		ls_LogId
string		ls_LogPassword
ulong		lul_IntegratedSecurity
ulong		lul_AutoCommit

dw_1.AcceptText ( )

//	Get the settings from the datawindow and save them to the registry
ls_Profile = dw_1.GetItemString ( 1, "Profile" )
ls_ServerName = dw_1.GetItemString ( 1, "ServerName" )
ls_Database = dw_1.GetItemString ( 1, "Database" )
ls_LogId = dw_1.GetItemString ( 1, "LogId" )
ls_LogPassword = dw_1.GetItemString ( 1, "LogPassword" )
lul_IntegratedSecurity = dw_1.GetItemNumber ( 1, "IntegratedSecurity" )
lul_AutoCommit = dw_1.GetItemNumber ( 1, "AutoCommit" )

inv_Reg.of_SetSQLServerProfileSettings ( is_AppProfile, is_OriginalProfile, ls_Profile, ls_ServerName, ls_Database, ls_LogId, ls_LogPassword, lul_IntegratedSecurity, lul_AutoCommit )

end event

event open;call super::open;
//	Declarations
n_cst_associative_array	lnv_Args

//	Turn on the base service and center the window
of_SetBase ( TRUE )
inv_base.of_Center ( )

//	Store the app profile
lnv_Args = Message.PowerObjectParm
is_AppProfile = lnv_Args.of_GetItem ( "AppProfile" )
is_OriginalProfile = lnv_Args.of_GetItem ( "SQLProfile" )

//	If a profile was sent, display it
if is_OriginalProfile > '' then
	//	Declarations
	n_cst_registry	inv_Reg
	string		ls_ServerName
	string		ls_Database
	string		ls_LogId
	string		ls_LogPassword
	ulong		lul_IntegratedSecurity
	ulong		lul_AutoCommit

	inv_Reg.of_GetSQLServerProfileSettings ( is_AppProfile, is_OriginalProfile, ls_ServerName, ls_Database, ls_LogId, ls_LogPassword, lul_IntegratedSecurity, lul_AutoCommit )
	dw_1.SetItem ( 1, "Profile", is_OriginalProfile )
	dw_1.SetItem ( 1, "ServerName", ls_ServerName )
	dw_1.SetItem ( 1, "Database", ls_Database )
	dw_1.SetItem ( 1, "LogId", ls_LogId )
	dw_1.SetItem ( 1, "LogPassword", ls_LogPassword )
	dw_1.SetItem ( 1, "IntegratedSecurity", lul_IntegratedSecurity )
	dw_1.SetItem ( 1, "AutoCommit", lul_AutoCommit )
end if



end event

on w_sqlserverprofile.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
end on

on w_sqlserverprofile.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

type dw_1 from datawindow within w_sqlserverprofile
int X=18
int Y=16
int Width=1298
int Height=496
int TabOrder=10
boolean BringToTop=true
string DataObject="d_sqlserverprofile"
boolean Border=false
end type

type cb_1 from commandbutton within w_sqlserverprofile
int X=256
int Y=544
int Width=329
int Height=112
int TabOrder=20
boolean BringToTop=true
string Text="&Ok"
boolean Default=true
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.Event ue_Save ( )
CloseWithReturn ( Parent, 1 )
end event

type cb_2 from commandbutton within w_sqlserverprofile
int X=677
int Y=544
int Width=329
int Height=112
int TabOrder=30
boolean BringToTop=true
string Text="&Cancel"
boolean Cancel=true
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;CloseWithReturn ( Parent, -1 )
end event

