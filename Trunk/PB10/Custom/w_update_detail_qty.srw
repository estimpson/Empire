HA$PBExportHeader$w_update_detail_qty.srw
$PBExportComments$Update shipper detail quantity
forward
global type w_update_detail_qty from Window
end type
type st_um_pack from statictext within w_update_detail_qty
end type
type sle_qty_packed from singlelineedit within w_update_detail_qty
end type
type st_qty_pack from statictext within w_update_detail_qty
end type
type st_um2 from statictext within w_update_detail_qty
end type
type st_um from statictext within w_update_detail_qty
end type
type cb_2 from commandbutton within w_update_detail_qty
end type
type cb_1 from commandbutton within w_update_detail_qty
end type
type sle_new_qty from singlelineedit within w_update_detail_qty
end type
type st_3 from statictext within w_update_detail_qty
end type
type sle_orig_qty from singlelineedit within w_update_detail_qty
end type
type st_2 from statictext within w_update_detail_qty
end type
type sle_part from singlelineedit within w_update_detail_qty
end type
type st_1 from statictext within w_update_detail_qty
end type
type gb_1 from groupbox within w_update_detail_qty
end type
end forward

global type w_update_detail_qty from Window
int X=782
int Y=596
int Width=1344
int Height=812
boolean TitleBar=true
string Title="Update Quantity Required"
long BackColor=77897888
boolean ControlMenu=true
WindowType WindowType=popup!
st_um_pack st_um_pack
sle_qty_packed sle_qty_packed
st_qty_pack st_qty_pack
st_um2 st_um2
st_um st_um
cb_2 cb_2
cb_1 cb_1
sle_new_qty sle_new_qty
st_3 st_3
sle_orig_qty sle_orig_qty
st_2 st_2
sle_part sle_part
st_1 st_1
gb_1 gb_1
end type
global w_update_detail_qty w_update_detail_qty

forward prototypes
public subroutine wf_reset_picklist_flag ()
end prototypes

public subroutine wf_reset_picklist_flag ();Long iShipper

iShipper	= w_list_of_active_shippers.iShipper

If iShipper > 0 then
	Update Shipper Set Picklist_printed = 'N' Where Id = :iShipper;
	If SQLCA.SQLCode = 0 then
		Commit;
		w_list_of_active_shippers.dw_shipping_dock.SetItem(w_list_of_active_shippers.iSelectedRow, "shipper_picklist_printed", "N")
	Else
		Rollback;
	End If
End If
end subroutine

on open;Long iDetailRow
Datawindow dWin

iDetailRow	= w_shipping_dock.iDetailRow
dWin			= w_shipping_dock.dw_shipper_detail

sle_part.text			= dWin.GetItemString(iDetailRow, "part")
sle_orig_qty.text		= String(dWin.GetItemNumber(iDetailRow, "shipper_detail_qty_required"))
sle_qty_packed.text	= String(dWin.GetItemNumber(iDetailRow, "shipper_detail_alternative_qty"))
st_um.text				= dWin.GetItemString(iDetailRow, "shipper_detail_alternative_unit")
st_um2.text				= st_um.text
st_um_pack.text	= st_um.text
sle_new_qty.SetFocus()
end on

on deactivate;//close(this)
end on

on w_update_detail_qty.create
this.st_um_pack=create st_um_pack
this.sle_qty_packed=create sle_qty_packed
this.st_qty_pack=create st_qty_pack
this.st_um2=create st_um2
this.st_um=create st_um
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_new_qty=create sle_new_qty
this.st_3=create st_3
this.sle_orig_qty=create sle_orig_qty
this.st_2=create st_2
this.sle_part=create sle_part
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_um_pack,&
this.sle_qty_packed,&
this.st_qty_pack,&
this.st_um2,&
this.st_um,&
this.cb_2,&
this.cb_1,&
this.sle_new_qty,&
this.st_3,&
this.sle_orig_qty,&
this.st_2,&
this.sle_part,&
this.st_1,&
this.gb_1}
end on

on w_update_detail_qty.destroy
destroy(this.st_um_pack)
destroy(this.sle_qty_packed)
destroy(this.st_qty_pack)
destroy(this.st_um2)
destroy(this.st_um)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_new_qty)
destroy(this.st_3)
destroy(this.sle_orig_qty)
destroy(this.st_2)
destroy(this.sle_part)
destroy(this.st_1)
destroy(this.gb_1)
end on

type st_um_pack from statictext within w_update_detail_qty
int X=1097
int Y=272
int Width=128
int Height=80
boolean Enabled=false
string Text="UM"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_qty_packed from singlelineedit within w_update_detail_qty
int X=558
int Y=272
int Width=535
int Height=88
boolean Enabled=false
boolean AutoHScroll=false
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_qty_pack from statictext within w_update_detail_qty
int X=146
int Y=272
int Width=366
int Height=80
boolean Enabled=false
string Text="Qty Packed"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_um2 from statictext within w_update_detail_qty
int X=1097
int Y=360
int Width=128
int Height=80
boolean Enabled=false
string Text="UM"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_um from statictext within w_update_detail_qty
int X=1097
int Y=184
int Width=128
int Height=80
boolean Enabled=false
string Text="UM"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_2 from commandbutton within w_update_detail_qty
int X=987
int Y=592
int Width=256
int Height=108
int TabOrder=30
string Text="Cancel"
boolean Cancel=true
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Close(parent)
end on

type cb_1 from commandbutton within w_update_detail_qty
int X=677
int Y=592
int Width=247
int Height=108
int TabOrder=20
string Text="Ok"
boolean Default=true
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Boolean bUpdate

bUpdate	= TRUE

If  (Not IsNumber(sle_new_qty.text)) OR (Dec(sle_new_qty.text) < 0) then
	MessageBox("Warning", "Invalid Data Entry")
	Return
End If
	
If Dec(sle_new_qty.text) = 0 then
	If MessageBox("Warning", "This will delete the current line item" + "~rOk to continue", StopSign!, YesNo!) = 2 then
		bUpdate	= 	FALSE
	End If
End If

If bUpdate then
	wf_reset_picklist_flag()
	w_shipping_dock.wf_set_detail_qty(Dec(sle_new_qty.text))
	close(w_update_detail_qty)
End If
end on

type sle_new_qty from singlelineedit within w_update_detail_qty
int X=558
int Y=368
int Width=535
int Height=88
int TabOrder=10
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_update_detail_qty
int X=146
int Y=360
int Width=366
int Height=80
boolean Enabled=false
string Text="New Qty"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_orig_qty from singlelineedit within w_update_detail_qty
int X=558
int Y=180
int Width=535
int Height=88
boolean Enabled=false
boolean AutoHScroll=false
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_update_detail_qty
int X=142
int Y=184
int Width=366
int Height=80
boolean Enabled=false
string Text="Original Qty"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_part from singlelineedit within w_update_detail_qty
int X=558
int Y=80
int Width=635
int Height=88
boolean Enabled=false
boolean AutoHScroll=false
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_update_detail_qty
int X=142
int Y=84
int Width=247
int Height=80
boolean Enabled=false
string Text="Part"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_update_detail_qty
int X=73
int Width=1189
int Height=560
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

