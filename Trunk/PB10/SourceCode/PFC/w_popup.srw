HA$PBExportHeader$w_popup.srw
$PBExportComments$Extension Popup Window class
forward
global type w_popup from pfc_w_popup
end type
end forward

global type w_popup from pfc_w_popup
end type
global w_popup w_popup

on w_popup.create
call super::create
end on

on w_popup.destroy
call super::destroy
end on

event open;call super::open;
//	Enable base window service.
of_SetBase ( TRUE )

//	Centering window.
inv_base.of_Center ( )
end event

