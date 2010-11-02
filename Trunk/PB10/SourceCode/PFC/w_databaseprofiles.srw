HA$PBExportHeader$w_databaseprofiles.srw
forward
global type w_databaseprofiles from w_response
end type
type tv_1 from treeview within w_databaseprofiles
end type
type ddlb_1 from dropdownlistbox within w_databaseprofiles
end type
type st_1 from statictext within w_databaseprofiles
end type
type cbx_1 from checkbox within w_databaseprofiles
end type
end forward

global type w_databaseprofiles from w_response
integer width = 1440
integer height = 1424
string title = "Choose Database Profile"
long backcolor = 78748035
event ue_new ( )
event ue_delete ( )
event ue_edit ( )
tv_1 tv_1
ddlb_1 ddlb_1
st_1 st_1
cbx_1 cbx_1
end type
global w_databaseprofiles w_databaseprofiles

type variables
n_cst_Registry		inv_Reg
string			is_AppProfile
end variables

forward prototypes
public subroutine wf_refreshsqlprofiles ()
public subroutine wf_refreshodbcprofiles ()
public subroutine wf_refreshsysodbcprofiles ()
public subroutine wf_refreshprofiles ()
public subroutine wf_showdefaults ()
end prototypes

event ue_new;
//	Declarations
n_cst_associative_array	lnv_Args

//	Set the arguments and open the edit window
lnv_Args.of_SetItem ( "AppProfile", is_AppProfile )
lnv_Args.of_SetItem ( "SQLProfile", "" )
OpenWithParm ( w_sqlserverprofile, lnv_Args )

end event

event ue_delete;//	Declarations
treeviewitem	ltvi_Item
long		ll_Handle

//	Get the current item
ll_Handle = tv_1.FindItem ( CurrentTreeItem!, 0 )
if ll_Handle > 0 then
	tv_1.GetItem ( ll_Handle, ltvi_Item )
	if MessageBox ( gnv_App.iapp_Object.DisplayName, "Are you sure about deleting the profile " + ltvi_Item.Label + "?", Question!, YesNo!, 2 ) = 1 then
		inv_Reg.of_DeleteSQLServerProfile ( is_AppProfile, ltvi_Item.Label )
	end if
end if
end event

event ue_edit;//	Declarations
treeviewitem		ltvi_Item
long			ll_Handle
n_cst_associative_array	lnv_Args

//	Get the current item
ll_Handle = tv_1.FindItem ( CurrentTreeItem!, 0 )
if ll_Handle > 0 then
	tv_1.GetItem ( ll_Handle, ltvi_Item )
	choose case ltvi_Item.Data
		case "ODBCLabel"
			Run ( "ODBCAD32.EXE" )
		case else
			//	Build the arguments and open the edit window
			lnv_Args.of_SetItem ( "AppProfile", is_AppProfile )
			lnv_Args.of_SetItem ( "SQLProfile", ltvi_Item.Label )
			OpenWithParm ( w_sqlserverprofile, lnv_Args )
	end choose
end if
end event

public subroutine wf_refreshsqlprofiles ();//	Declarations
integer		li_Index
long		ll_Handle
long		ll_ChildHandle
boolean		lb_DisplaySQLServer
string		ls_SQLProfiles[]
treeviewitem	ltvi_Item

//	Get the sql server database profiles and add them to the tree view
if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
	inv_Reg.of_GetSQLServerProfiles ( is_AppProfile, ls_SQLProfiles )
	ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
	ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	do while ll_ChildHandle > 0
		tv_1.DeleteItem ( ll_ChildHandle )
		ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	loop
	ltvi_Item.PictureIndex = 1
	ltvi_Item.SelectedPictureIndex = 1
	ltvi_Item.Children = FALSE
	ltvi_Item.Expanded = FALSE
	for li_Index = 1 to UpperBound ( ls_SQLProfiles )
		ltvi_Item.Label = ls_SQLProfiles[li_Index]
		ltvi_Item.Data = "SQLProfile"
		tv_1.InsertItemSort ( ll_Handle, ltvi_Item )
		//	Add item to default dropdown
		ddlb_1.AddItem ( ls_SQLProfiles[li_Index] + " - (MSS)" )
	next
end if

end subroutine

public subroutine wf_refreshodbcprofiles ();//	Declarations
integer		li_Index
long		ll_Handle
long		ll_ChildHandle
string		ls_ODBCProfiles[]
treeviewitem	ltvi_Item

if inv_Reg.of_DisplayODBC ( is_AppProfile ) then
	//	Get the User ODBC Profiles and add them to the tree view
	inv_Reg.of_GetODBCProfiles ( ls_ODBCProfiles )
	ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
	if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
		ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
	end if
	ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	do while ll_ChildHandle > 0
		tv_1.DeleteItem ( ll_ChildHandle )
		ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	loop
	ltvi_Item.PictureIndex = 2
	ltvi_Item.SelectedPictureIndex = 2
	ltvi_Item.Children = FALSE
	ltvi_Item.Expanded = FALSE
	for li_Index = 1 to UpperBound ( ls_ODBCProfiles )
		ltvi_Item.Label = ls_ODBCProfiles[li_Index]
		ltvi_Item.Data = "ODBCProfile"
		tv_1.InsertItemSort ( ll_Handle, ltvi_Item )
		//	Add item to default dropdown
		ddlb_1.AddItem ( ls_ODBCProfiles[li_Index] + " - (ODBC)" )
	next
end if
end subroutine

public subroutine wf_refreshsysodbcprofiles ();//	Declarations
integer		li_Index
long		ll_Handle
long		ll_ChildHandle
boolean		lb_DisplaySQLServer
string		ls_SystemODBCProfiles[]
treeviewitem	ltvi_Item

if inv_Reg.of_DisplaySystemODBC ( is_AppProfile ) then
	//	Get the System ODBC Profiles and add them to the tree view
	inv_Reg.of_GetSystemODBCProfiles ( ls_SystemODBCProfiles )
	ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
	if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
		ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
	end if
	if inv_Reg.of_DisplayODBC ( is_AppProfile ) then
		ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
	end if
	ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	do while ll_ChildHandle > 0
		tv_1.DeleteItem ( ll_ChildHandle )
		ll_ChildHandle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	loop
	ltvi_Item.PictureIndex = 3
	ltvi_Item.SelectedPictureIndex = 3
	ltvi_Item.Children = FALSE
	ltvi_Item.Expanded = FALSE
	for li_Index = 1 to UpperBound ( ls_SystemODBCProfiles )
		ltvi_Item.Label = ls_SystemODBCProfiles[li_Index]
		ltvi_Item.Data = "ODBCProfile"
		tv_1.InsertItemSort ( ll_Handle, ltvi_Item )
		//	Add item to default dropdown
		ddlb_1.AddItem ( ls_SystemODBCProfiles[li_Index] + " - (SysODBC)" )
	next
end if
end subroutine

public subroutine wf_refreshprofiles ();//	Declarations
integer		li_Index
long		ll_Handle
string		ls_DefaultProfile
string		ls_DefaultDBMS
treeviewitem	ltvi_Item

ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
do while ll_Handle > 0
	tv_1.DeleteItem ( ll_Handle )
	ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
loop

//	Get the sql server database profiles and add them to the tree view
if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
	ltvi_Item.PictureIndex = 1
	ltvi_Item.SelectedPictureIndex = 1
	ltvi_Item.Label = "SQL Server Profiles"
	ltvi_Item.Data = "SQLLabel"
	ltvi_Item.Children = TRUE
	ltvi_Item.Expanded = FALSE
	tv_1.InsertItemLast ( 0, ltvi_Item )
end if

//	Get the User ODBC Profiles and add them to the tree view
if inv_Reg.of_DisplayODBC ( is_AppProfile ) then
	ltvi_Item.PictureIndex = 2
	ltvi_Item.SelectedPictureIndex = 2
	ltvi_Item.Label = "User ODBC Profiles"
	ltvi_Item.Data = "ODBCLabel"
	ltvi_Item.Children = TRUE
	ltvi_Item.Expanded = FALSE
	tv_1.InsertItemLast ( 0, ltvi_Item )
end if

//	Get the System ODBC Profiles and add them to the tree view
if inv_Reg.of_DisplaySystemODBC ( is_AppProfile ) then
	ltvi_Item.PictureIndex = 3
	ltvi_Item.SelectedPictureIndex = 3
	ltvi_Item.Label = "System ODBC Profiles"
	ltvi_Item.Data = "ODBCLabel"
	ltvi_Item.Children = TRUE
	ltvi_Item.Expanded = FALSE
	tv_1.InsertItemLast ( 0, ltvi_Item )
end if

ddlb_1.Reset ( )
ddlb_1.AddItem ( "(None)" )

wf_RefreshSQLProfiles ( )
wf_RefreshODBCProfiles ( )
wf_RefreshSysODBCProfiles ( )

wf_ShowDefaults ( )


end subroutine

public subroutine wf_showdefaults ();//	Declarations
string		ls_DefaultProfile
string		ls_DefaultDBMS
long		ll_Handle
treeviewitem	ltvi_Item

//	Set the prompt setting
cbx_1.Checked = inv_Reg.of_GetDBPrompt ( is_AppProfile )

//	Get the default from the registry and find in drop down and in tree view
inv_Reg.of_GetDefaultProfile ( is_AppProfile, ls_DefaultProfile, ls_DefaultDBMS )
ddlb_1.Text = ls_DefaultProfile + " - (" + ls_DefaultDBMS + ")"
choose case ls_DefaultDBMS
	case "MSS"
		ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
		ll_Handle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	case "ODBC"
		ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
		if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
			ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
		end if
		ll_Handle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
	case "SysODBC"
		ll_Handle = tv_1.FindItem ( RootTreeItem!, 0 )
		if inv_Reg.of_DisplaySQLServer ( is_AppProfile ) then
			ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
		end if
		ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
		ll_Handle = tv_1.FindItem ( ChildTreeItem!, ll_Handle )
end choose
do while ll_Handle <> -1
	tv_1.GetItem ( ll_Handle, ltvi_Item )
	if ltvi_Item.Label = ls_DefaultProfile then
		tv_1.SelectItem ( ll_Handle )
		ll_Handle = -1
	else
		ll_Handle = tv_1.FindItem ( NextTreeItem!, ll_Handle )
	end if
loop

end subroutine

on w_databaseprofiles.create
int iCurrent
call super::create
this.tv_1=create tv_1
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_1
end on

on w_databaseprofiles.destroy
call super::destroy
destroy(this.tv_1)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.cbx_1)
end on

event pfc_postopen;call super::pfc_postopen;wf_RefreshProfiles ( )

//	Place window on top.
SetPosition (TopMost!)

end event

event pfc_preopen;call super::pfc_preopen;
//	Store the app profile for later use
is_AppProfile = Message.StringParm

//	Set the title
Title = "Choose " + is_AppProfile + " Database Profile"

//	Turn on the base service
of_SetBase ( TRUE )

//	Turn on the resize service
of_SetResize ( TRUE )

//	Set the original size
inv_resize.of_SetOrigSize ( ( tv_1.x * 2 ) + tv_1.Width, ( ddlb_1.y * 2 ) + tv_1.y + tv_1.Height )

//	Registry the controls with the resize service
inv_resize.of_Register ( st_1, 0, 0, 0, 0 )
inv_resize.of_Register ( ddlb_1, 0, 0, 0, 0 )
inv_resize.of_Register ( cbx_1, 0, 0, 0, 0 )
inv_resize.of_Register ( tv_1, 0, 0, 100, 100 )

//	Center the window
inv_base.of_Center ( )
end event

event activate;call super::activate;wf_RefreshProfiles ( )
end event

event key;call super::key;if key = KeyA! and keyflags = 3 then
	OpenWithParm ( w_databaseprofilesadmin, is_AppProfile )
end if
end event

type tv_1 from treeview within w_databaseprofiles
integer x = 18
integer y = 112
integer width = 1390
integer height = 1200
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean hideselection = false
string picturename[] = {"DatabaseProfile!","ConfigODBC!","ConfigODBC5!"}
long picturemaskcolor = 12632256
long statepicturemaskcolor = 536870912
end type

event selectionchanging;////	Declarations
//treeviewitem	ltvi_Item
//
////	Get the new item
//GetItem ( newhandle, ltvi_Item )
//
////	If the type of item is a label, dont allow to continue
//if ltvi_Item.Data = "Label" then
//	return 1
//end if
end event

event rightclicked;
if handle = 0 then return

//	Declarations
treeviewitem		ltvi_Item
m_databaseprofilespopup	lm_Popup

//	Create the popup menu
lm_Popup = create m_databaseprofilespopup

//	Get the current item
GetItem ( handle, ltvi_Item )

if ltvi_Item.Data = "SQLLabel" then
	lm_Popup.m_sqllabel.PopMenu ( PointerX ( ) + 50, PointerY ( ) + 50 )
elseif ltvi_Item.Data = "ODBCLabel" then
	lm_Popup.m_odbclabel.PopMenu ( PointerX ( ) + 50, PointerY ( ) + 50 )
elseif ltvi_Item.Data = "SQLProfile" then
	lm_Popup.m_sqlprofile.PopMenu ( PointerX ( ) + 50, PointerY ( ) + 50 )
end if

end event

event doubleclicked;
if handle = 0 then return

//	Declarations
treeviewitem		ltvi_Item
ulong			lul_IntegratedSecurity
ulong			lul_AutoCommit
string			ls_ServerName
string			ls_Database
string			ls_LogId
string			ls_LogPass
n_cst_associative_array	lnv_Args

//	Get the current item
GetItem ( handle, ltvi_Item )

lnv_Args.of_SetItem ( "profile", ltvi_Item.Label )
if ltvi_Item.Data = "SQLProfile" then
	lnv_Args.of_SetItem ( "dbms", "MSS" )
	CloseWithReturn ( Parent, lnv_Args )
elseif ltvi_Item.Data = "ODBCProfile" then
	lnv_Args.of_SetItem ( "dbms", "ODBC" )
	CloseWithReturn ( Parent, lnv_Args )
end if

end event

event key;Parent.Event key ( key, keyflags )
end event

type ddlb_1 from dropdownlistbox within w_databaseprofiles
event key pbm_keydown
integer x = 347
integer y = 16
integer width = 768
integer height = 1120
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event key;Parent.Event key ( key, keyflags )
end event

event selectionchanged;//	Declarations
string	ls_Selected
string	ls_DefaultProfile = ""
string	ls_DefaultDBMS = ""
integer	li_Pos

//	Parse out the profile and dbms
ls_Selected = Text
if ls_Selected <> "(None)" then
	li_Pos = Pos ( ls_Selected, " - (" )
	if li_Pos > 0 then
		ls_DefaultProfile = Left ( ls_Selected, li_Pos - 1 )
		ls_DefaultDBMS = Mid ( ls_Selected, li_Pos + 4, Len ( ls_Selected ) - ( li_Pos + 4 ) )
	end if
end if

//	Write the default profile to the registry
inv_Reg.of_SetDefaultProfile ( is_AppProfile, ls_DefaultProfile, ls_DefaultDBMS )

end event

type st_1 from statictext within w_databaseprofiles
integer x = 18
integer y = 32
integer width = 329
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Default Profile:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_databaseprofiles
event key pbm_keydown
integer x = 1152
integer y = 16
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Prompt"
end type

event key;Parent.Event key ( key, keyflags )
end event

event clicked;//	Write the setting to the registry
inv_Reg.of_SetDBPrompt ( is_AppProfile, Checked )

end event

