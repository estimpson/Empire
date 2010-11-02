HA$PBExportHeader$w_splash.srw
$PBExportComments$(PFD)
forward
global type w_splash from w_popup
end type
type p_1 from picture within w_splash
end type
type st_1 from statictext within w_splash
end type
type p_2 from picture within w_splash
end type
end forward

global type w_splash from w_popup
integer x = 1056
integer y = 484
integer width = 2231
integer height = 1084
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 16777215
p_1 p_1
st_1 st_1
p_2 p_2
end type
global w_splash w_splash

type variables

Public:
n_cst_splashattrib inv_splashattrib
end variables

on w_splash.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_1=create st_1
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.p_2
end on

on w_splash.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.p_2)
end on

event open;call super::open;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  Open
//
//	Description:  Get splash object and display splash window
//	with appropriate settings that were specified
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0    Initial version
//	5.0.03	Use timer event for window close
//	5.0.04	Center splash window.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996 Powersoft Corporation
//
//////////////////////////////////////////////////////////////////////////////

//	Get the splash object.
inv_Splashattrib = Message.PowerObjectParm

//	Allow window to close without the CloseQuery checks being performed.
ib_DisableCloseQuery = True

//	Center the splash window.
of_SetBase ( true )
inv_base.of_Center()

//	Positioning.
SetPosition (TopMost!)

//	Set length of time for window to close.
Timer ( inv_SplashAttrib.ii_SecondsVisible, this )

end event

event timer;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	timer
//
//	Description:
//	Close window when specified length of time is reached
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0.03   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

gnv_App.event pfc_PostSplash ( )
Timer (0)
Close ( this )

end event

type p_1 from picture within w_splash
integer x = 50
integer y = 20
integer width = 2085
integer height = 324
boolean originalsize = true
string picturename = "LabelDesignStudio.bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_splash
integer x = 1815
integer y = 356
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
string text = "Version 1.0"
boolean focusrectangle = false
end type

type p_2 from picture within w_splash
integer x = 462
integer y = 408
integer width = 1170
integer height = 576
boolean originalsize = true
string picturename = "KanbanITCorporationmember4Thought.bmp"
boolean focusrectangle = false
end type

