HA$PBExportHeader$w_defects_entry_no_quantity.srw
forward
global type w_defects_entry_no_quantity from Window
end type
type cb_exit from commandbutton within w_defects_entry_no_quantity
end type
type st_choose_defect from statictext within w_defects_entry_no_quantity
end type
type dw_defects from datawindow within w_defects_entry_no_quantity
end type
type cb_enter from commandbutton within w_defects_entry_no_quantity
end type
end forward

global type w_defects_entry_no_quantity from Window
int X=59
int Y=72
int Width=2825
int Height=1820
long BackColor=77897888
WindowType WindowType=response!
cb_exit cb_exit
st_choose_defect st_choose_defect
dw_defects dw_defects
cb_enter cb_enter
end type
global w_defects_entry_no_quantity w_defects_entry_no_quantity

type variables
String 	sReason
String 	sDefectQuantity
Long 	NRowNumber
String 	szMachine
String 	szPart
Dec	id_Quantity
end variables

on open;dw_defects.settransobject ( sqlca )
dw_defects.retrieve ()



end on

on w_defects_entry_no_quantity.create
this.cb_exit=create cb_exit
this.st_choose_defect=create st_choose_defect
this.dw_defects=create dw_defects
this.cb_enter=create cb_enter
this.Control[]={this.cb_exit,&
this.st_choose_defect,&
this.dw_defects,&
this.cb_enter}
end on

on w_defects_entry_no_quantity.destroy
destroy(this.cb_exit)
destroy(this.st_choose_defect)
destroy(this.dw_defects)
destroy(this.cb_enter)
end on

type cb_exit from commandbutton within w_defects_entry_no_quantity
int X=727
int Y=1456
int Width=658
int Height=256
int TabOrder=30
string Text="Cancel"
int TextSize=-24
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;CloseWithReturn ( Parent, "" )
end on

type st_choose_defect from statictext within w_defects_entry_no_quantity
int X=722
int Y=32
int Width=1280
int Height=160
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Choose a Defect Code"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-24
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_defects from datawindow within w_defects_entry_no_quantity
int X=32
int Y=224
int Width=2752
int Height=1184
int TabOrder=20
string DataObject="dw_defects_list"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

on clicked;// Get Reason 

nRowNumber = dw_defects.getclickedrow ( )

////////////////////////////////////////////////////////////////////
//
//   if clicked outside dw then don't process request
//  

If nRowNumber = 0 Then Return

SelectRow ( dw_defects, 0, False )
SelectRow ( dw_defects, nRowNumber, True )

sReason = dw_defects.getitemstring ( nrownumber, "code" )



	



end on

type cb_enter from commandbutton within w_defects_entry_no_quantity
int X=1385
int Y=1456
int Width=658
int Height=256
int TabOrder=10
string Text="Enter"
int TextSize=-24
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;CloseWithReturn ( Parent, sReason )
end on

