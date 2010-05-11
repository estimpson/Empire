HA$PBExportHeader$w_enter_opertor_code.srw
forward
global type w_enter_opertor_code from Window
end type
type em_1 from editmask within w_enter_opertor_code
end type
type st_5 from statictext within w_enter_opertor_code
end type
type st_4 from statictext within w_enter_opertor_code
end type
type sle_truck_number from singlelineedit within w_enter_opertor_code
end type
type sle_pro_number from singlelineedit within w_enter_opertor_code
end type
type st_3 from statictext within w_enter_opertor_code
end type
type sle_operator from singlelineedit within w_enter_opertor_code
end type
type cb_2 from commandbutton within w_enter_opertor_code
end type
type st_2 from statictext within w_enter_opertor_code
end type
type cb_1 from commandbutton within w_enter_opertor_code
end type
type sle_password from singlelineedit within w_enter_opertor_code
end type
type st_1 from statictext within w_enter_opertor_code
end type
type gb_1 from groupbox within w_enter_opertor_code
end type
end forward

global type w_enter_opertor_code from Window
int X=759
int Y=536
int Width=1179
int Height=948
boolean TitleBar=true
string Title="Enter Shipping Data"
long BackColor=77897888
WindowType WindowType=response!
em_1 em_1
st_5 st_5
st_4 st_4
sle_truck_number sle_truck_number
sle_pro_number sle_pro_number
st_3 st_3
sle_operator sle_operator
cb_2 cb_2
st_2 st_2
cb_1 cb_1
sle_password sle_password
st_1 st_1
gb_1 gb_1
end type
global w_enter_opertor_code w_enter_opertor_code

type variables
string	i_s_mode
end variables

event open;i_s_mode = Message.StringParm
em_1.text = string(today())

end event

on w_enter_opertor_code.create
this.em_1=create em_1
this.st_5=create st_5
this.st_4=create st_4
this.sle_truck_number=create sle_truck_number
this.sle_pro_number=create sle_pro_number
this.st_3=create st_3
this.sle_operator=create sle_operator
this.cb_2=create cb_2
this.st_2=create st_2
this.cb_1=create cb_1
this.sle_password=create sle_password
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.em_1,&
this.st_5,&
this.st_4,&
this.sle_truck_number,&
this.sle_pro_number,&
this.st_3,&
this.sle_operator,&
this.cb_2,&
this.st_2,&
this.cb_1,&
this.sle_password,&
this.st_1,&
this.gb_1}
end on

on w_enter_opertor_code.destroy
destroy(this.em_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_truck_number)
destroy(this.sle_pro_number)
destroy(this.st_3)
destroy(this.sle_operator)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.gb_1)
end on

type em_1 from editmask within w_enter_opertor_code
int X=517
int Y=568
int Width=521
int Height=88
int TabOrder=40
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleLowered!
string Mask="mm/dd/yy"
MaskDataType MaskDataType=DateMask!
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_enter_opertor_code
int X=146
int Y=572
int Width=320
int Height=76
boolean Enabled=false
string Text="Date shipped"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_enter_opertor_code
int X=146
int Y=448
int Width=320
int Height=76
boolean Enabled=false
string Text="Truck Number"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_truck_number from singlelineedit within w_enter_opertor_code
int X=517
int Y=448
int Width=521
int Height=88
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_pro_number from singlelineedit within w_enter_opertor_code
int X=517
int Y=324
int Width=521
int Height=88
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_enter_opertor_code
int X=174
int Y=208
int Width=247
int Height=72
boolean Enabled=false
string Text="Code"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=78682240
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_operator from singlelineedit within w_enter_opertor_code
int X=517
int Y=208
int Width=521
int Height=88
boolean Enabled=false
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
boolean DisplayOnly=true
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_2 from commandbutton within w_enter_opertor_code
int X=878
int Y=732
int Width=256
int Height=108
int TabOrder=60
string Text="Cancel"
boolean Cancel=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;bCancel	= TRUE
if i_s_mode = "w_quick_shipper" then
	w_quick_shipper.is_Operator		= ""
	w_quick_shipper.szProNumber	= ""
	setnull(w_shipping_dock.idt_dateshipped)
	
else
	w_shipping_dock.is_operator		= ""
	w_shipping_dock.szProNumber	= ""
	w_shipping_dock.is_trucknumber	= ""
	setnull(w_shipping_dock.idt_dateshipped)

end if

Close(w_enter_opertor_code)
end event

type st_2 from statictext within w_enter_opertor_code
int X=123
int Y=324
int Width=361
int Height=72
boolean Enabled=false
string Text="Pro Number"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=78682240
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_enter_opertor_code
int X=603
int Y=732
int Width=247
int Height=108
int TabOrder=50
string Text="OK"
boolean Default=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string	ls_time

If date(em_1.text) > today() then 
	Messagebox ( Monsys.msg_title, "Invalid ship date")
	em_1.setfocus()
	return
end if 	
	
ls_time = string(now())

If IsNull(sle_operator.text) OR (Trim(sle_operator.text) = '') then
	MessageBox("Warning", "You must enter password to proceed", Stopsign!)
	Return
Else
	if i_s_mode = "w_quick_shipper" then
		w_quick_shipper.is_operator	= Trim(sle_operator.text)
		w_quick_shipper.szProNumber	= Trim(sle_pro_number.text)
		w_quick_shipper.idt_dateshipped	= datetime(date(Trim(em_1.text)),time(ls_time))		
	else
		w_shipping_dock.is_operator	= Trim(sle_operator.text)
		w_shipping_dock.szProNumber	= Trim(sle_pro_number.text)
		w_shipping_dock.is_trucknumber	= Trim(sle_truck_number.text)
		w_shipping_dock.idt_dateshipped	= datetime(date(Trim(em_1.text)),time(ls_time))
		
	end if
End If
Close(w_enter_opertor_code)

end event

type sle_password from singlelineedit within w_enter_opertor_code
int X=517
int Y=92
int Width=521
int Height=88
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
boolean PassWord=true
long TextColor=33554432
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;String szPass, szCode
szPass = this.Text
Select employee.operator_code
	INTO :szCode
	From Employee
Where Employee.password = :szPass ;
If szCode <= " " Then 
	this.Setfocus()
	this.Text = ""
	sle_operator.Text = ""
	Return
Else
	sle_operator.Text = szCode
End If
end on

type st_1 from statictext within w_enter_opertor_code
int X=137
int Y=100
int Width=283
int Height=72
boolean Enabled=false
string Text="Operator"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=78682240
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_enter_opertor_code
int X=18
int Y=16
int Width=1115
int Height=692
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=78682240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

