HA$PBExportHeader$u_zoom.sru
forward
global type u_zoom from u_base_custom
end type
type st_zoom from statictext within u_zoom
end type
type sle_zoom from singlelineedit within u_zoom
end type
type cb_plus from commandbutton within u_zoom
end type
type cb_minus from commandbutton within u_zoom
end type
end forward

global type u_zoom from u_base_custom
int Width=522
int Height=117
boolean Border=false
BorderStyle BorderStyle=StyleBox!
long BackColor=79741120
string Tag="zoom control"
st_zoom st_zoom
sle_zoom sle_zoom
cb_plus cb_plus
cb_minus cb_minus
end type
global u_zoom u_zoom

on u_zoom.create
int iCurrent
call u_base_custom::create
this.st_zoom=create st_zoom
this.sle_zoom=create sle_zoom
this.cb_plus=create cb_plus
this.cb_minus=create cb_minus
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=st_zoom
this.Control[iCurrent+2]=sle_zoom
this.Control[iCurrent+3]=cb_plus
this.Control[iCurrent+4]=cb_minus
end on

on u_zoom.destroy
call u_base_custom::destroy
destroy(this.st_zoom)
destroy(this.sle_zoom)
destroy(this.cb_plus)
destroy(this.cb_minus)
end on

type st_zoom from statictext within u_zoom
int Y=25
int Width=161
int Height=73
boolean Enabled=false
string Text="Zoom"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_zoom from singlelineedit within u_zoom
event modified pbm_enmodified
int X=188
int Y=5
int Width=275
int Height=113
int TabOrder=10
boolean Enabled=false
string Tag="Manual zoom entry"
BorderStyle BorderStyle=StyleLowered!
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;INTEGER	l_i_zoom

IF Left ( text, 1 ) = 'F' THEN
	l_i_zoom = -50
	text = 'FULL'
ELSEIF left ( text, 1 ) = 'O' THEN
	l_i_zoom = 0
	text = 'ORIG'
ELSE
	l_i_zoom = Integer ( text )
	IF l_i_zoom < 0 THEN
		l_i_zoom = -50
		text = 'FULL'
	ELSEIF l_i_zoom = 0 THEN
		text = 'ORIG'
	ELSE
		text = String ( l_i_zoom )
	END IF
END IF
i_w_parent.TRIGGER DYNAMIC EVENT ue_preview_zoom ( l_i_zoom )
end event

type cb_plus from commandbutton within u_zoom
event clicked pbm_bnclicked
int X=467
int Width=60
int Height=61
int TabOrder=20
boolean Enabled=false
string Tag="Zoom In"
string Text="+"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;CHOOSE CASE sle_zoom.text
	CASE 'FULL'
		sle_zoom.text = 'ORIG'
	CASE 'ORIG'
		sle_zoom.text = '50'
	CASE ELSE
		sle_zoom.text = String ( Integer ( sle_zoom.text ) + 50 )
END CHOOSE
sle_zoom.PostEvent ( modified! )
end event

type cb_minus from commandbutton within u_zoom
event clicked pbm_bnclicked
int X=467
int Y=61
int Width=60
int Height=61
int TabOrder=2
boolean Enabled=false
string Tag="Zoom out"
string Text="-"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;CHOOSE CASE Integer ( sle_zoom.text )
	CASE 0
		sle_zoom.text = 'FULL'
	CASE IS <= 50
		sle_zoom.text = 'ORIG'
	CASE ELSE
		sle_zoom.text = String ( Integer ( sle_zoom.text ) - 50 )
END CHOOSE
sle_zoom.PostEvent ( modified! )
end event

