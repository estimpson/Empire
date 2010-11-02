HA$PBExportHeader$n_cst_winsrv_icontray.sru
$PBExportComments$Extension Base Window Service class
forward
global type n_cst_winsrv_icontray from n_cst_winsrv
end type
type notifyicondata from structure within n_cst_winsrv_icontray
end type
end forward

type notifyicondata from structure
	long		cbsize
	long		hwnd
	long		uid
	long		uflags
	long		ucallbackmessage
	long		hicon
	character		sztip[64]
end type

global type n_cst_winsrv_icontray from n_cst_winsrv
end type
global n_cst_winsrv_icontray n_cst_winsrv_icontray

type prototypes
function long Shell_NotifyIcon ( long dwMessage, ref notifyicondata lpData ) library "shell32.dll"
function long LoadImageA ( long hInstance, string lpszName, uint uType, int a, int b, uint l ) library "user32.dll"
function long GetClassLongA ( long hwndMainWindow, int class ) library "user32.dll"

end prototypes

type variables

Protected:
boolean	ib_SysTrayExists = false

constant long	NIF_MESSAGE = 1
constant long	NIF_ICON = 2
constant long	NIF_TIP = 4
constant long	NIM_ADD = 0
constant long	NIM_MODIFY = 1
constant long	NIM_DELETE = 2

private notifyicondata	istr_Data

end variables

forward prototypes
public function integer of_deleteicon ()
public function integer of_modifyicon (string as_iconname)
public function integer of_modifytip (string as_tiptext)
public function boolean of_trayexists ()
public function integer of_addicon (string as_iconname, character as_tiptext[])
end prototypes

public function integer of_deleteicon ();
if not ib_SysTrayExists then return NO_ACTION
return shell_notifyicon (NIM_DELETE, istr_Data)

end function

public function integer of_modifyicon (string as_iconname);
if not ib_SysTrayExists then return NO_ACTION
istr_Data.uFlags = NIF_ICON
istr_Data.hIcon = LoadImageA (0, as_IconName, 1, 0, 0, 80)
return shell_notifyicon (NIM_MODIFY, istr_Data)

end function

public function integer of_modifytip (string as_tiptext);
if not ib_SysTrayExists then return NO_ACTION
istr_Data.szTip = as_TipText + char(0)
istr_Data.uFlags = NIF_TIP
return shell_notifyicon (NIM_MODIFY, istr_Data)

end function

public function boolean of_trayexists ();
return ib_SystrayExists

end function

public function integer of_addicon (string as_iconname, character as_tiptext[]);
if not ib_SysTrayExists then return NO_ACTION
if not IsValid (iw_Requestor) then return FAILURE

istr_Data.szTip = as_TipText + char(0)
istr_Data.uFlags = NIF_ICON + NIF_TIP + NIF_MESSAGE
istr_Data.uID = 100
istr_Data.cbSize = 88
istr_Data.hWnd = Handle (iw_Requestor)
istr_Data.uCallbackMessage = 1024
istr_Data.hIcon = LoadImageA (0, as_IconName, 1, 0, 0, 80)
return shell_notifyicon (NIM_ADD, istr_Data)

end function

on n_cst_winsrv_icontray.create
call super::create
end on

on n_cst_winsrv_icontray.destroy
call super::destroy
end on

event destructor;call super::destructor;
of_DeleteIcon ()

end event

event constructor;call super::constructor;
choose case gnv_App.ienv_Object.OSType
	case Windows!, WindowsNT!
		ib_SysTrayExists = gnv_App.ienv_Object.OSMajorRevision >= 4
end choose

end event

