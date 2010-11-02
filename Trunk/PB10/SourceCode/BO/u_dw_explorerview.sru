HA$PBExportHeader$u_dw_explorerview.sru
forward
global type u_dw_explorerview from u_dw
end type
end forward

global type u_dw_explorerview from u_dw
integer width = 1600
integer height = 1328
boolean hscrollbar = true
boolean hsplitscroll = true
end type
global u_dw_explorerview u_dw_explorerview

type variables

public privatewrite n_businessobject	inv_Item

end variables
event constructor;
//	Get the type of the entity being displayed.
if IsValid ( message.PowerObjectParm ) then
	inv_Item = message.PowerObjectParm
end if
DataObject = inv_Item.is_ExplorerViewSimple

//	Retrieve view.
of_SetTransObject ( SQLCA )
of_Retrieve ()

//	Disable auto-update and RMBMenu.
of_SetUpdateable ( false )
ib_RMBMenu = false

//	Turn on the sort service
of_SetSort ( true )
inv_sort.of_SetStyle ( 0 )
inv_Sort.of_SetColumnHeaderExt ( true )
inv_Sort.of_ReadSort ()

end event

event pfc_retrieve;call super::pfc_retrieve;
//	Retrieve all rows by default, override to provide user specific actions.
return Retrieve ()

end event

on u_dw_explorerview.create
call super::create
end on

on u_dw_explorerview.destroy
call super::destroy
end on

