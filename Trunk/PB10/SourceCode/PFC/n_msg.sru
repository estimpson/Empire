HA$PBExportHeader$n_msg.sru
$PBExportComments$Extension Message class
forward
global type n_msg from pfc_n_msg
end type
end forward

global type n_msg from pfc_n_msg
end type
global n_msg n_msg

type variables

Public:
n_cst_associative_array	incst_Parm

end variables

on n_msg.create
call message::create
TriggerEvent( this, "constructor" )
end on

on n_msg.destroy
call message::destroy
TriggerEvent( this, "destructor" )
end on

