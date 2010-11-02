HA$PBExportHeader$n_cst_statearray.sru
forward
global type n_cst_statearray from n_base
end type
end forward

global type n_cst_statearray from n_base autoinstantiate
end type

type variables

private integer	ii_ArraySize = 0
public n_cst_state invStates [ ]

end variables

forward prototypes
public function integer of_getindex (string as_state)
public function integer of_upperbound ()
public function integer of_AddState (string as_state)
end prototypes

public function integer of_getindex (string as_state);
//	Check the current list of events.
integer	i
for i = 1 to ii_ArraySize
	if invStates [ i ].Name = as_State then return i
next
return 0

end function

public function integer of_upperbound ();
//	Return size.
return ii_ArraySize

end function

public function integer of_AddState (string as_state);
//	Check the current list of events.
integer	i
i = of_GetIndex ( as_State )
if i > 0 then return i

//	Not found.  Add it.
ii_ArraySize++
invStates [ ii_ArraySize ] = create n_cst_state
invStates [ ii_ArraySize ].Name = as_State
return ii_ArraySize

end function

on n_cst_statearray.create
TriggerEvent( this, "constructor" )
end on

on n_cst_statearray.destroy
TriggerEvent( this, "destructor" )
end on

