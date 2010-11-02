HA$PBExportHeader$w_statusbar.srw
forward
global type w_statusbar from pfc_w_statusbar
end type
end forward

global type w_statusbar from pfc_w_statusbar
end type
global w_statusbar w_statusbar

on w_statusbar.create
call super::create
end on

on w_statusbar.destroy
call super::destroy
end on

type dw_statusbar from pfc_w_statusbar`dw_statusbar within w_statusbar
end type

