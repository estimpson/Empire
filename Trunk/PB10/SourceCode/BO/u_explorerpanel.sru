HA$PBExportHeader$u_explorerpanel.sru
forward
global type u_explorerpanel from u_base
end type
end forward

global type u_explorerpanel from u_base
event type integer pfc_save ( )
end type
global u_explorerpanel u_explorerpanel

on u_explorerpanel.create
call super::create
end on

on u_explorerpanel.destroy
call super::destroy
end on

