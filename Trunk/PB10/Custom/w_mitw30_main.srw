HA$PBExportHeader$w_mitw30_main.srw
forward
global type w_mitw30_main from Window
end type
type cb_53 from commandbutton within w_mitw30_main
end type
type cb_43 from commandbutton within w_mitw30_main
end type
type cb_label from commandbutton within w_mitw30_main
end type
type st_3 from statictext within w_mitw30_main
end type
type st_2 from statictext within w_mitw30_main
end type
type st_1 from statictext within w_mitw30_main
end type
type cb_52 from commandbutton within w_mitw30_main
end type
type cb_51 from commandbutton within w_mitw30_main
end type
type cb_50 from commandbutton within w_mitw30_main
end type
type cb_49 from commandbutton within w_mitw30_main
end type
type cb_47 from commandbutton within w_mitw30_main
end type
type cb_46 from commandbutton within w_mitw30_main
end type
type cb_45 from commandbutton within w_mitw30_main
end type
type cb_44 from commandbutton within w_mitw30_main
end type
type cb_42 from commandbutton within w_mitw30_main
end type
type cb_41 from commandbutton within w_mitw30_main
end type
type rb_2 from radiobutton within w_mitw30_main
end type
type rb_1 from radiobutton within w_mitw30_main
end type
type cb_48 from commandbutton within w_mitw30_main
end type
type cb_40 from commandbutton within w_mitw30_main
end type
type cb_39 from commandbutton within w_mitw30_main
end type
type cb_38 from commandbutton within w_mitw30_main
end type
type cb_37 from commandbutton within w_mitw30_main
end type
type cb_36 from commandbutton within w_mitw30_main
end type
type cb_35 from commandbutton within w_mitw30_main
end type
type cb_34 from commandbutton within w_mitw30_main
end type
type cb_33 from commandbutton within w_mitw30_main
end type
type cb_32 from commandbutton within w_mitw30_main
end type
type cb_31 from commandbutton within w_mitw30_main
end type
type cb_30 from commandbutton within w_mitw30_main
end type
type cb_29 from commandbutton within w_mitw30_main
end type
type cb_28 from commandbutton within w_mitw30_main
end type
type cb_27 from commandbutton within w_mitw30_main
end type
type cb_26 from commandbutton within w_mitw30_main
end type
type cb_25 from commandbutton within w_mitw30_main
end type
type cb_24 from commandbutton within w_mitw30_main
end type
type cb_23 from commandbutton within w_mitw30_main
end type
type cb_22 from commandbutton within w_mitw30_main
end type
type cb_21 from commandbutton within w_mitw30_main
end type
type cb_20 from commandbutton within w_mitw30_main
end type
type cb_19 from commandbutton within w_mitw30_main
end type
type cb_18 from commandbutton within w_mitw30_main
end type
type cb_17 from commandbutton within w_mitw30_main
end type
type cb_16 from commandbutton within w_mitw30_main
end type
type cb_15 from commandbutton within w_mitw30_main
end type
type cb_14 from commandbutton within w_mitw30_main
end type
type cb_13 from commandbutton within w_mitw30_main
end type
type cb_12 from commandbutton within w_mitw30_main
end type
type cb_11 from commandbutton within w_mitw30_main
end type
type cb_10 from commandbutton within w_mitw30_main
end type
type cb_9 from commandbutton within w_mitw30_main
end type
type cb_8 from commandbutton within w_mitw30_main
end type
type cb_7 from commandbutton within w_mitw30_main
end type
type cb_6 from commandbutton within w_mitw30_main
end type
type cb_5 from commandbutton within w_mitw30_main
end type
type cb_4 from commandbutton within w_mitw30_main
end type
type sle_1 from singlelineedit within w_mitw30_main
end type
type cb_3 from commandbutton within w_mitw30_main
end type
type cb_2 from commandbutton within w_mitw30_main
end type
type cb_1 from commandbutton within w_mitw30_main
end type
type dw_1 from datawindow within w_mitw30_main
end type
end forward

global type w_mitw30_main from Window
int X=0
int Y=12
int Width=3602
int Height=2348
boolean TitleBar=true
string Title="Inventory Transactions"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
WindowState WindowState=maximized!
string Icon="mit.ico"
cb_53 cb_53
cb_43 cb_43
cb_label cb_label
st_3 st_3
st_2 st_2
st_1 st_1
cb_52 cb_52
cb_51 cb_51
cb_50 cb_50
cb_49 cb_49
cb_47 cb_47
cb_46 cb_46
cb_45 cb_45
cb_44 cb_44
cb_42 cb_42
cb_41 cb_41
rb_2 rb_2
rb_1 rb_1
cb_48 cb_48
cb_40 cb_40
cb_39 cb_39
cb_38 cb_38
cb_37 cb_37
cb_36 cb_36
cb_35 cb_35
cb_34 cb_34
cb_33 cb_33
cb_32 cb_32
cb_31 cb_31
cb_30 cb_30
cb_29 cb_29
cb_28 cb_28
cb_27 cb_27
cb_26 cb_26
cb_25 cb_25
cb_24 cb_24
cb_23 cb_23
cb_22 cb_22
cb_21 cb_21
cb_20 cb_20
cb_19 cb_19
cb_18 cb_18
cb_17 cb_17
cb_16 cb_16
cb_15 cb_15
cb_14 cb_14
cb_13 cb_13
cb_12 cb_12
cb_11 cb_11
cb_10 cb_10
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
sle_1 sle_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_mitw30_main w_mitw30_main

type variables
String szLocation, szPart
String szColumn
String szWorkOrder
String szClickedPart
String szClickedLoc
Long lCurrentRow

Boolean bMouseDown
Boolean bFirstTime
Boolean bScan
Boolean bPart
Boolean bLocation
Boolean bOpened
Boolean bOpen
Boolean bPopulateParts
Boolean bPopulateLocations
Boolean bButton
Boolean bEnter

Window wLabel
end variables

forward prototypes
public subroutine wf_determine_dw (string sztype)
public subroutine wf_select_new_row ()
public subroutine wf_find_in_dw ()
public subroutine wf_disable_chars ()
public subroutine wf_enable_chars ()
public function boolean wf_valid_search_key ()
end prototypes

public subroutine wf_determine_dw (string sztype);If szType = "Location" Then

	dw_1.DataObject = "d_it_location_new"
	szColumn = "code"

Elseif szType = "Part" Then

	dw_1.DataObject = "d_it_part_search"
	szColumn = "part"

Else

	dw_1.DataObject = "d_scanned_object"

End if

dw_1.SetTransObject ( sqlca )

end subroutine

public subroutine wf_select_new_row ();SelectRow ( dw_1, 0, False )
SelectRow ( dw_1, lCurrentRow, True )

dw_1.ScrollToRow ( lCurrentRow )

end subroutine

public subroutine wf_find_in_dw ();Long lRow

lRow = dw_1.Find ( szColumn + " >= ~'" + sle_1.Text + "~'", 1, dw_1.RowCount ( ) )

If lRow < 1 Then Return

SelectRow ( dw_1, 0, False )
SelectRow ( dw_1, lRow, True )

dw_1.ScrollToRow ( lRow )
dw_1.SetRow ( lRow )

lCurrentRow = lRow

//wf_redraw_position ( )
end subroutine

public subroutine wf_disable_chars ();cb_4.Enabled = False
cb_5.Enabled = False
cb_6.Enabled = False
cb_7.Enabled = False
cb_8.Enabled = False
cb_9.Enabled = False
cb_10.Enabled = False
cb_11.Enabled = False
cb_12.Enabled = False
cb_13.Enabled = False
cb_14.Enabled = False
cb_15.Enabled = False
cb_16.Enabled = False
cb_17.Enabled = False
cb_18.Enabled = False
cb_19.Enabled = False
cb_20.Enabled = False
cb_21.Enabled = False
cb_22.Enabled = False
cb_23.Enabled = False
cb_24.Enabled = False
cb_25.Enabled = False
cb_36.Enabled = False
cb_35.Enabled = False
cb_34.Enabled = False
cb_33.Enabled = False
cb_40.Enabled = False
cb_41.Enabled = False
cb_42.Enabled = False
cb_51.Enabled = False

end subroutine

public subroutine wf_enable_chars ();cb_4.Enabled = True
cb_5.Enabled = True
cb_6.Enabled = True
cb_7.Enabled = True
cb_8.Enabled = True
cb_9.Enabled = True
cb_10.Enabled = True
cb_11.Enabled = True
cb_12.Enabled = True
cb_13.Enabled = True
cb_14.Enabled = True
cb_15.Enabled = True
cb_16.Enabled = True
cb_17.Enabled = True
cb_18.Enabled = True
cb_19.Enabled = True
cb_20.Enabled = True
cb_21.Enabled = True
cb_22.Enabled = True
cb_23.Enabled = True
cb_24.Enabled = True
cb_25.Enabled = True
cb_36.Enabled = True
cb_35.Enabled = True
cb_34.Enabled = True
cb_33.Enabled = True
cb_40.Enabled = True
cb_41.Enabled = True
cb_42.Enabled = True
cb_51.Enabled = True
end subroutine

public function boolean wf_valid_search_key ();If KeyDown ( keyA! ) Or &
	KeyDown ( keyB! ) Or &
	KeyDown ( keyC! ) Or &
	KeyDown ( keyD! ) Or &
	KeyDown ( keyE! ) Or &
	KeyDown ( keyF! ) Or &
	KeyDown ( keyG! ) Or &
	KeyDown ( keyH! ) Or &
	KeyDown ( keyI! ) Or &
	KeyDown ( keyJ! ) Or &
	KeyDown ( keyK! ) Or &
	KeyDown ( keyL! ) Or &
	KeyDown ( keyM! ) Or &
	KeyDown ( keyN! ) Or &
	KeyDown ( keyO! ) Or &
	KeyDown ( keyP! ) Or &
	KeyDown ( keyQ! ) Or &
	KeyDown ( keyR! ) Or &
	KeyDown ( keyS! ) Or &
	KeyDown ( keyT! ) Or &
	KeyDown ( keyU! ) Or &
	KeyDown ( keyV! ) Or &
	KeyDown ( keyW! ) Or &
	KeyDown ( keyX! ) Or &
	KeyDown ( keyY! ) Or &
	KeyDown ( keyZ! ) Or &
	KeyDown ( key0! ) Or &
	KeyDown ( key1! ) Or &
	KeyDown ( key2! ) Or &
	KeyDown ( key3! ) Or &
	KeyDown ( key4! ) Or &
	KeyDown ( key5! ) Or &
	KeyDown ( key6! ) Or &
	KeyDown ( key7! ) Or &
	KeyDown ( key8! ) Or &
	KeyDown ( key9! ) Or &
	KeyDown ( keyBack! ) Or &
	KeyDown ( keySpaceBar! ) Or &
	KeyDown ( keyDelete! ) Or &
	KeyDown ( keyNumpad0! ) Or &
	KeyDown ( keyNumpad1! ) Or &
	KeyDown ( keyNumpad2! ) Or &
	KeyDown ( keyNumpad3! ) Or &
	KeyDown ( keyNumpad4! ) Or &
	KeyDown ( keyNumpad5! ) Or &
	KeyDown ( keyNumpad6! ) Or &
	KeyDown ( keyNumpad7! ) Or &
	KeyDown ( keyNumpad8! ) Or &
	KeyDown ( keyNumpad9! ) Or &
	KeyDown ( keyNumpad0! ) Or &
	KeyDown ( keyDecimal! ) Or &
	KeyDown ( keyDivide! ) Or &
	KeyDown ( keyDash! ) Or &
	KeyDown ( keyPeriod! ) Or &
	KeyDown ( keySlash! ) Then

	Return True

End if

Return False
end function

event open;String cPopulateParts
String cPopulateLocations

this.title = monsys.title + sqlca.profile

If szMachineParm = "" Then
	szWorkOrder = Message.StringParm
	szWorkOrder = f_get_string_value ( szWorkOrder )
End if

bOpen = True

SELECT parameters.populate_parts,   
       parameters.populate_locations  
  INTO :cPopulateParts,   
       :cPopulateLocations  
  FROM parameters  ;

If cPopulateParts = "Y" Then
	bPopulateParts = True
End if
If cPopulateLocations = "Y" Then
	bPopulateLocations = True
End if

dw_1.SetTransObject ( sqlca )

bFirstTime = True

szColumn = "code"

sle_1.SetFocus ()
wf_disable_chars ( )
bScan = True
cb_52.Enabled = True

end event

on key;If bScan And Not KeyDown ( keyEnter! ) Then Return

If wf_valid_search_key ( ) Then &
	wf_find_in_dw ( )
end on

event activate;Long	lFindRow

If Not bOpen Then
	If bLocation Then
		If Not bScan Then //And bPopulateLocations Then 
			dw_1.Retrieve ( )
			If f_get_string_value ( szClickedLoc ) <> "" Then
				lFindRow = dw_1.Find ( "code = '" + szClickedLoc + "'", 1, dw_1.RowCount ( ) )
				dw_1.ScrollToRow ( lFindRow )
				SelectRow ( dw_1, 0, False )
				SelectRow ( dw_1, lFindRow, True )
			End if
		End if
	Else
		If Not bScan Then //And bPopulateParts Then 
			dw_1.Retrieve ( )
			If f_get_string_value ( szClickedPart ) <> "" Then
				lFindRow = dw_1.Find ( "part = '" + szClickedPart + "'", 1, dw_1.RowCount ( ) )
				dw_1.ScrollToRow ( lFindRow )
				SelectRow ( dw_1, 0, False )
				SelectRow ( dw_1, lFindRow, True )
			End if
		End if
	End if
Else
	bOpen = False
End if

If Not bOpened Then sle_1.SetFocus ( )
end event

on w_mitw30_main.create
this.cb_53=create cb_53
this.cb_43=create cb_43
this.cb_label=create cb_label
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_52=create cb_52
this.cb_51=create cb_51
this.cb_50=create cb_50
this.cb_49=create cb_49
this.cb_47=create cb_47
this.cb_46=create cb_46
this.cb_45=create cb_45
this.cb_44=create cb_44
this.cb_42=create cb_42
this.cb_41=create cb_41
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_48=create cb_48
this.cb_40=create cb_40
this.cb_39=create cb_39
this.cb_38=create cb_38
this.cb_37=create cb_37
this.cb_36=create cb_36
this.cb_35=create cb_35
this.cb_34=create cb_34
this.cb_33=create cb_33
this.cb_32=create cb_32
this.cb_31=create cb_31
this.cb_30=create cb_30
this.cb_29=create cb_29
this.cb_28=create cb_28
this.cb_27=create cb_27
this.cb_26=create cb_26
this.cb_25=create cb_25
this.cb_24=create cb_24
this.cb_23=create cb_23
this.cb_22=create cb_22
this.cb_21=create cb_21
this.cb_20=create cb_20
this.cb_19=create cb_19
this.cb_18=create cb_18
this.cb_17=create cb_17
this.cb_16=create cb_16
this.cb_15=create cb_15
this.cb_14=create cb_14
this.cb_13=create cb_13
this.cb_12=create cb_12
this.cb_11=create cb_11
this.cb_10=create cb_10
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.sle_1=create sle_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_53,&
this.cb_43,&
this.cb_label,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_52,&
this.cb_51,&
this.cb_50,&
this.cb_49,&
this.cb_47,&
this.cb_46,&
this.cb_45,&
this.cb_44,&
this.cb_42,&
this.cb_41,&
this.rb_2,&
this.rb_1,&
this.cb_48,&
this.cb_40,&
this.cb_39,&
this.cb_38,&
this.cb_37,&
this.cb_36,&
this.cb_35,&
this.cb_34,&
this.cb_33,&
this.cb_32,&
this.cb_31,&
this.cb_30,&
this.cb_29,&
this.cb_28,&
this.cb_27,&
this.cb_26,&
this.cb_25,&
this.cb_24,&
this.cb_23,&
this.cb_22,&
this.cb_21,&
this.cb_20,&
this.cb_19,&
this.cb_18,&
this.cb_17,&
this.cb_16,&
this.cb_15,&
this.cb_14,&
this.cb_13,&
this.cb_12,&
this.cb_11,&
this.cb_10,&
this.cb_9,&
this.cb_8,&
this.cb_7,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.sle_1,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_mitw30_main.destroy
destroy(this.cb_53)
destroy(this.cb_43)
destroy(this.cb_label)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_52)
destroy(this.cb_51)
destroy(this.cb_50)
destroy(this.cb_49)
destroy(this.cb_47)
destroy(this.cb_46)
destroy(this.cb_45)
destroy(this.cb_44)
destroy(this.cb_42)
destroy(this.cb_41)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_48)
destroy(this.cb_40)
destroy(this.cb_39)
destroy(this.cb_38)
destroy(this.cb_37)
destroy(this.cb_36)
destroy(this.cb_35)
destroy(this.cb_34)
destroy(this.cb_33)
destroy(this.cb_32)
destroy(this.cb_31)
destroy(this.cb_30)
destroy(this.cb_29)
destroy(this.cb_28)
destroy(this.cb_27)
destroy(this.cb_26)
destroy(this.cb_25)
destroy(this.cb_24)
destroy(this.cb_23)
destroy(this.cb_22)
destroy(this.cb_21)
destroy(this.cb_20)
destroy(this.cb_19)
destroy(this.cb_18)
destroy(this.cb_17)
destroy(this.cb_16)
destroy(this.cb_15)
destroy(this.cb_14)
destroy(this.cb_13)
destroy(this.cb_12)
destroy(this.cb_11)
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.sle_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

type cb_53 from commandbutton within w_mitw30_main
int X=2304
int Y=864
int Width=549
int Height=144
int TabOrder=60
string Text="Combo Scan"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Open ( w_combo_scan )
end on

type cb_43 from commandbutton within w_mitw30_main
int X=859
int Y=752
int Width=841
int Height=336
int TabOrder=50
boolean Visible=false
string Text="Printing Label..."
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_label from commandbutton within w_mitw30_main
int X=50
int Y=724
int Width=293
int Height=208
int TabOrder=80
boolean Enabled=false
string Text="Label"
int TextSize=-14
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Long		ll_Serial
st_generic_structure stParm

If dw_1.RowCount ( ) < 1 Then
	MessageBox ( "Error", "You must scan or enter a valid serial number to print a label!", StopSign! )
	sle_1.SetFocus ( )
	Return
End if

cb_43.Show ( )

ll_Serial = f_get_value ( dw_1.GetItemNumber ( 1, "serial" ) )
stParm.value1 = String ( ll_Serial )

f_print_label ( stParm )

cb_43.Hide ( )
end on

type st_3 from statictext within w_mitw30_main
int X=37
int Y=1008
int Width=402
int Height=128
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="Serial Scan"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;st_1.BorderStyle = StyleRaised!
st_2.BorderStyle = StyleRaised!
st_3.BorderStyle = StyleLowered!

wf_disable_chars ( )
wf_determine_dw ( "" )
sle_1.Text = ""
sle_1.SetFocus ( )
bScan = True
bPart = False
bLocation = False
cb_52.Enabled = True
cb_label.Enabled = False
cb_label.Show ( )

end on

type st_2 from statictext within w_mitw30_main
int X=987
int Y=1008
int Width=407
int Height=128
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Locations"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;SetPointer ( HourGlass! )

cb_label.Hide ( )

st_1.BorderStyle = StyleRaised!
st_3.BorderStyle = StyleRaised!
st_2.BorderStyle = StyleLowered!

wf_enable_chars ( )
wf_determine_dw ( "Location" )
//If bPopulateLocations Then
	dw_1.Retrieve ( )
//End if
sle_1.Text = ""
sle_1.TextCase = AnyCase!
sle_1.SetFocus ( )
bLocation = True
bScan = False
bPart = False
szColumn = "code"
end on

type st_1 from statictext within w_mitw30_main
int X=475
int Y=1008
int Width=485
int Height=128
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="Part Numbers"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;SetPointer ( HourGlass! )

cb_label.Hide ( )

st_2.BorderStyle = StyleRaised!
st_3.BorderStyle = StyleRaised!
st_1.BorderStyle = StyleLowered!

wf_enable_chars ( )
wf_determine_dw ( "Part" )
//If bPopulateParts Then
	dw_1.Retrieve ( )
//End if
sle_1.Text = ""
sle_1.TextCase = Upper!
sle_1.SetFocus ( )
bPart = True
bScan = False
bLocation = False
szColumn = "part"


end on

type cb_52 from commandbutton within w_mitw30_main
int X=2560
int Y=1728
int Width=293
int Height=192
int TabOrder=270
string Text="Enter"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;bButton = True
bEnter = True
sle_1.TriggerEvent ( modified! )
end on

on getfocus;If bEnter Then 
	bEnter = False
	sle_1.SetFocus ( )
End if

end on

type cb_51 from commandbutton within w_mitw30_main
int X=293
int Y=1728
int Width=256
int Height=192
int TabOrder=550
string Text="."
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_50 from commandbutton within w_mitw30_main
int X=2926
int Y=352
int Width=805
int Height=128
boolean Visible=false
string Text="Mode:  Locations"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;If cb_50.Text = "Mode:  Scan" Then
	cb_50.Text = "Mode:  Locations"
	wf_enable_chars ( )
	wf_determine_dw ( "Location" )
	dw_1.Retrieve ( )
	sle_1.SetFocus ( )
	bScan = False
	cb_52.Enabled = False	
Elseif cb_50.Text = "Mode:  Locations" Then
	cb_50.Text = "Mode:  Part Numbers"
	wf_determine_dw ( "Part" )
	dw_1.Retrieve ( )
	sle_1.SetFocus ( )
Elseif cb_50.Text = "Mode:  Part Numbers" Then
	cb_50.Text = "Mode:  Scan"
	wf_disable_chars ( )
	sle_1.SetFocus ( )
	bScan = True
	cb_52.Enabled = True
End if
end on

type cb_49 from commandbutton within w_mitw30_main
int X=2304
int Y=720
int Width=549
int Height=144
int TabOrder=90
string Text="Quality"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;SetPointer ( HourGlass! )
st_generic_structure stParm
If bScan Then stParm.Value2 = sle_1.Text
OpenWithParm ( w_quality_control, stParm )

end event

type cb_47 from commandbutton within w_mitw30_main
int X=2304
int Y=576
int Width=549
int Height=144
int TabOrder=70
string Text="Combine"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;SetPointer ( HourGlass! )

/*  Declare Variables  */

st_generic_structure stParm


/*  Initialize Variables  */

stParm.Value1 = "Combine"
If bScan Then stParm.Value2 = sle_1.Text

OpenWithParm ( w_touch_screen_generic_trans, stParm )

end on

type cb_46 from commandbutton within w_mitw30_main
int X=2304
int Y=432
int Width=549
int Height=144
int TabOrder=40
string Text="Transfer"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;st_generic_structure stParm
If bScan Then stParm.Value2 = sle_1.Text
OpenWithParm ( w_transfer, stParm )

end event

type cb_45 from commandbutton within w_mitw30_main
int X=2304
int Y=288
int Width=549
int Height=144
int TabOrder=30
string Text="Break Out"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;st_generic_structure stParm
If bScan Then stParm.Value2 = sle_1.Text
OpenWithParm ( w_break_out, stparm )
end event

type cb_44 from commandbutton within w_mitw30_main
int X=2304
int Y=144
int Width=549
int Height=144
int TabOrder=20
string Text="Material Issue"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;st_generic_structure stParm
If bScan Then stParm.Value2 = sle_1.Text
OpenWithParm ( w_material_issue, stparm )
end event

type cb_42 from commandbutton within w_mitw30_main
int X=1902
int Y=1728
int Width=366
int Height=192
int TabOrder=540
string Text="Space"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Long lRow

sle_1.Text = sle_1.Text + " "

lRow = dw_1.Find ( szColumn + " >= ~'" + sle_1.Text + "~'", 1, dw_1.RowCount ( ) )

SelectRow ( dw_1, 0, False )
SelectRow ( dw_1, lRow, True )

dw_1.ScrollToRow ( lRow )
dw_1.SetRow ( lRow )

sle_1.SetFocus ( )
end event

type cb_41 from commandbutton within w_mitw30_main
int X=1317
int Y=1728
int Width=256
int Height=192
int TabOrder=530
string Text="_"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "_"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type rb_2 from radiobutton within w_mitw30_main
int Y=2016
int Width=704
int Height=76
boolean Visible=false
string Text="Part Numbers"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;wf_determine_dw ( "Part" )
dw_1.Retrieve ( )
sle_1.SetFocus ( )
end on

type rb_1 from radiobutton within w_mitw30_main
int X=37
int Y=1952
int Width=544
int Height=76
boolean Visible=false
string Text="Locations"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=8388608
long BackColor=12632256
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;wf_determine_dw ( "Location" )
dw_1.Retrieve ( )
sle_1.SetFocus ( )
end on

type cb_48 from commandbutton within w_mitw30_main
int X=2267
int Y=1728
int Width=293
int Height=192
int TabOrder=520
string Text="Clear"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = ""
sle_1.SetFocus ( )
end on

type cb_40 from commandbutton within w_mitw30_main
int X=549
int Y=1728
int Width=256
int Height=192
int TabOrder=260
string Text="-"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "-"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_39 from commandbutton within w_mitw30_main
int X=549
int Y=1152
int Width=256
int Height=192
int TabOrder=250
string Text="9"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "9"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_38 from commandbutton within w_mitw30_main
int X=293
int Y=1152
int Width=256
int Height=192
int TabOrder=240
string Text="8"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "8"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_37 from commandbutton within w_mitw30_main
int X=37
int Y=1152
int Width=256
int Height=192
int TabOrder=230
string Text="7"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "7"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_36 from commandbutton within w_mitw30_main
int X=2341
int Y=1536
int Width=256
int Height=192
int TabOrder=220
string Text="W"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "W"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_35 from commandbutton within w_mitw30_main
int X=2597
int Y=1536
int Width=256
int Height=192
int TabOrder=280
string Text="X"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "X"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_34 from commandbutton within w_mitw30_main
int X=805
int Y=1728
int Width=256
int Height=192
int TabOrder=300
string Text="Y"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "Y"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_33 from commandbutton within w_mitw30_main
int X=1061
int Y=1728
int Width=256
int Height=192
int TabOrder=320
string Text="Z"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "Z"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_32 from commandbutton within w_mitw30_main
int X=37
int Y=1728
int Width=256
int Height=192
int TabOrder=340
string Text="0"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "0"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_31 from commandbutton within w_mitw30_main
int X=37
int Y=1536
int Width=256
int Height=192
int TabOrder=360
string Text="1"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "1"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_30 from commandbutton within w_mitw30_main
int X=293
int Y=1536
int Width=256
int Height=192
int TabOrder=380
string Text="2"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "2"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_29 from commandbutton within w_mitw30_main
int X=549
int Y=1536
int Width=256
int Height=192
int TabOrder=400
string Text="3"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "3"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_28 from commandbutton within w_mitw30_main
int X=37
int Y=1344
int Width=256
int Height=192
int TabOrder=420
string Text="4"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "4"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_27 from commandbutton within w_mitw30_main
int X=293
int Y=1344
int Width=256
int Height=192
int TabOrder=440
string Text="5"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "5"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_26 from commandbutton within w_mitw30_main
int X=549
int Y=1344
int Width=256
int Height=192
int TabOrder=460
string Text="6"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "6"

If Not bScan Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_25 from commandbutton within w_mitw30_main
int X=1573
int Y=1344
int Width=256
int Height=192
int TabOrder=210
string Text="L"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "L"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_24 from commandbutton within w_mitw30_main
int X=1829
int Y=1344
int Width=256
int Height=192
int TabOrder=290
string Text="M"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "M"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_23 from commandbutton within w_mitw30_main
int X=2085
int Y=1344
int Width=256
int Height=192
int TabOrder=310
string Text="N"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "N"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_22 from commandbutton within w_mitw30_main
int X=2341
int Y=1344
int Width=256
int Height=192
int TabOrder=330
string Text="O"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "O"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_21 from commandbutton within w_mitw30_main
int X=2597
int Y=1344
int Width=256
int Height=192
int TabOrder=350
string Text="P"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "P"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_20 from commandbutton within w_mitw30_main
int X=805
int Y=1536
int Width=256
int Height=192
int TabOrder=370
string Text="Q"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "Q"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_19 from commandbutton within w_mitw30_main
int X=1061
int Y=1536
int Width=256
int Height=192
int TabOrder=390
string Text="R"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "R"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_18 from commandbutton within w_mitw30_main
int X=1317
int Y=1536
int Width=256
int Height=192
int TabOrder=410
string Text="S"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "S"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_17 from commandbutton within w_mitw30_main
int X=1573
int Y=1536
int Width=256
int Height=192
int TabOrder=430
string Text="T"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "T"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_16 from commandbutton within w_mitw30_main
int X=1829
int Y=1536
int Width=256
int Height=192
int TabOrder=450
string Text="U"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "U"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_15 from commandbutton within w_mitw30_main
int X=2085
int Y=1536
int Width=256
int Height=192
int TabOrder=470
string Text="V"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "V"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_14 from commandbutton within w_mitw30_main
int X=1317
int Y=1344
int Width=256
int Height=192
int TabOrder=200
string Text="K"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "K"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_13 from commandbutton within w_mitw30_main
int X=1061
int Y=1344
int Width=256
int Height=192
int TabOrder=190
string Text="J"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "J"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_12 from commandbutton within w_mitw30_main
int X=805
int Y=1344
int Width=256
int Height=192
int TabOrder=180
string Text="I"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "I"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_11 from commandbutton within w_mitw30_main
int X=2597
int Y=1152
int Width=256
int Height=192
int TabOrder=170
string Text="H"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "H"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_10 from commandbutton within w_mitw30_main
int X=2341
int Y=1152
int Width=256
int Height=192
int TabOrder=160
string Text="G"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "G"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_9 from commandbutton within w_mitw30_main
int X=2085
int Y=1152
int Width=256
int Height=192
int TabOrder=150
string Text="F"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "F"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_8 from commandbutton within w_mitw30_main
int X=1829
int Y=1152
int Width=256
int Height=192
int TabOrder=140
string Text="E"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "E"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_7 from commandbutton within w_mitw30_main
int X=1573
int Y=1152
int Width=256
int Height=192
int TabOrder=130
string Text="D"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "D"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_6 from commandbutton within w_mitw30_main
int X=1317
int Y=1152
int Width=256
int Height=192
int TabOrder=120
string Text="C"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "C"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_5 from commandbutton within w_mitw30_main
int X=1061
int Y=1152
int Width=256
int Height=192
int TabOrder=110
string Text="B"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "B"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type cb_4 from commandbutton within w_mitw30_main
int X=805
int Y=1152
int Width=256
int Height=192
int TabOrder=100
string Text="A"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;sle_1.Text = sle_1.Text + "A"

If cb_50.Text <> "Mode:  Scan" Then wf_find_in_dw ( )

sle_1.SetFocus ( )
end on

type sle_1 from singlelineedit within w_mitw30_main
int X=1426
int Y=1008
int Width=1426
int Height=128
int TabOrder=500
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;String szTemp
String szColumn
String szExpression
String szTempPart

st_generic_structure stParm

Long lRowNumber
Long lColor
szTemp = f_get_string_value ( f_serial_validate(sle_1.Text) )

If (sle_1.text='' and szTemp = "") Then Return

If bScan And ( KeyDown ( keyEnter! ) Or bButton ) Then

	bButton = False

	SetPointer ( HourGlass! )

//	If Left ( szTemp, 1 ) = 's' Then
//		szTemp = Right ( szTemp, Len ( szTemp ) - 1 )
//		sle_1.Text = szTemp
//	Elseif Not IsNumber ( Left ( szTemp, 1 ) ) Then
//		szTemp = ""
//	End if

	If IsNull ( szTemp ) Or szTemp = "" Or Not IsNumber ( szTemp ) Then Return

	dw_1.Retrieve ( Long ( szTemp ))

	If dw_1.RowCount ( ) < 1 Then
		MessageBox ( "Error", "Invalid Serial Number!", StopSign! )
		sle_1.Text = ""
		cb_label.Enabled = False
		Return
	End if

	cb_label.Enabled = True

Else

	If bPart And ( KeyDown ( keyEnter! ) OR bButton ) Then

		sle_1.Text = Upper ( sle_1.Text )

	   SELECT part.part  
   	  INTO :szTempPart  
	     FROM part
   	 WHERE part.part = :sle_1.Text   ;
		
		If SQLCA.SQLCode <> 0 Then
			MessageBox ( "Error", "Invalid part number!  Please try again.", StopSign! )
			sle_1.Text = ""
		Else
			SetPointer ( HourGlass! )

			stParm.Value1 = "Part"
			stParm.Value2 = sle_1.Text
			szClickedPart = stParm.Value2

			bOpened = True
			OpenWithParm ( w_touch_screen_serial_display, stParm )

		End if

	Elseif bLocation And ( KeyDown ( keyEnter! ) OR bButton ) Then

 	   SELECT location.code  
   	  INTO :szTemp  
	     FROM location  
   	 WHERE location.code = :sle_1.Text   ;

		If SQLCA.SQLCode <> 0 Then
			MessageBox ( "Error", "Invalid location!  Please try again.", StopSign! )
			sle_1.Text = ""
		Else

			SetPointer ( HourGlass! )

			stParm.Value1 = "Location"
			stParm.Value2 = sle_1.Text
			szClickedLoc  = stParm.Value2

			bOpened = True
			OpenWithParm ( w_touch_screen_serial_display, stParm )

		End if

	End if

End if

end event

type cb_3 from commandbutton within w_mitw30_main
int X=731
int Y=1472
int Width=549
int Height=288
int TabOrder=510
boolean Visible=false
string Text="Part "
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;//open (w_it_part_search)
end on

type cb_2 from commandbutton within w_mitw30_main
int X=2304
int Width=549
int Height=144
int TabOrder=490
string Text="Job Complete"
int TextSize=-12
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long 	ll_row 
st_generic_structure stParm

stParm.Value5 = szWorkOrder

if blocation then 
	stParm.value6 = szclickedloc
	stParm.value7 = "Location"
elseif bpart then 
	stParm.value6 = szclickedpart
	stParm.value7 = "Part"
end if 	

OpenWithParm ( w_job_complete, stparm )

end event

type cb_1 from commandbutton within w_mitw30_main
int X=1573
int Y=1728
int Width=329
int Height=192
int TabOrder=480
string Text="Exit"
int TextSize=-14
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Int iRtnCode

iRtnCode = MessageBox ( "Exit", "Are you sure you want to exit?", Question!, YesNo!, 2 )
If iRtnCode = 1 Then
	close (parent)
End if
end on

type dw_1 from datawindow within w_mitw30_main
int X=18
int Y=16
int Width=2267
int Height=976
int TabOrder=10
string DataObject="d_scanned_object"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

on scrollvertical;sle_1.SetFocus ( )
end on

event clicked;///////////////////////////////////////////////////////////////////////
////
//// select the location to display
////
//
//
st_generic_structure stParm
//
//
///////////////////////////////////////////////////////////////////////
////
////   if clicked outside dw then don't process request
////  
//
If Row < 1 Then Return

Selectrow ( dw_1, 0, false )
SelectRow ( dw_1, Row, true )

If bLocation Then
//
//	SetPointer ( HourGlass! )
//
	sle_1.text = dw_1.GetItemString ( row, "code" )
	stParm.Value1 = "Location"
	stParm.Value2 = dw_1.GetItemstring ( row, "code" )
	szClickedLoc  = stParm.Value2
//
//	bOpened = True
//	OpenWithParm ( w_touch_screen_serial_display, stParm )
//
Elseif bPart Then
//
//	SetPointer ( HourGlass! )
//
	sle_1.text = dw_1.GetItemString ( row, "part" )
	stParm.Value1 = "Part"
	stParm.Value2 = dw_1.GetItemString ( row, "part" )
	szClickedPart = stParm.Value2
//
//	bOpened = True
//	OpenWithParm ( w_touch_screen_serial_display, stParm )
//
End if
//
//
end event

event dberror;return 1
end event

on scrollhorizontal;sle_1.SetFocus ( )
end on

event doubleclicked;/////////////////////////////////////////////////////////////////////
//
// select the location to display
//

Long lRow
lRow = row

st_generic_structure stParm


/////////////////////////////////////////////////////////////////////
//
//   if clicked outside dw then don't process request
//  

If lRow < 1 Then Return

Selectrow ( dw_1, 0, false )
SelectRow ( dw_1, lRow, true )

If bLocation Then

	SetPointer ( HourGlass! )

	sle_1.text = dw_1.GetItemString ( lRow, "code" )
	stParm.Value1 = "Location"
	stParm.Value2 = dw_1.GetItemstring ( lRow, "code" )
	szClickedLoc  = stParm.Value2

	bOpened = True
	OpenWithParm ( w_touch_screen_serial_display, stParm )

Elseif bPart Then

	SetPointer ( HourGlass! )

	sle_1.text = dw_1.GetItemString ( lRow, "part" )
	stParm.Value1 = "Part"
	stParm.Value2 = dw_1.GetItemString ( lRow, "part" )
	szClickedPart = stParm.Value2

	bOpened = True
	OpenWithParm ( w_touch_screen_serial_display, stParm )

End if


end event

