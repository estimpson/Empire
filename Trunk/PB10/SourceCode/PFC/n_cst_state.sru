HA$PBExportHeader$n_cst_state.sru
forward
global type n_cst_state from n_base
end type
end forward

global type n_cst_state from n_base
end type
global n_cst_state n_cst_state

type variables

private integer	ii_ArraySize = 0
public any	Value
public string	Name
public integer	iRequestorIndexes [ ]

end variables

forward prototypes
public function integer of_getindex (integer ai_RequestorIndex)
end prototypes

public function integer of_getindex (integer ai_RequestorIndex);
//	Check the current list of events.
integer	i
for i = 1 to ii_ArraySize
	if iRequestorIndexes [ i ] = ai_RequestorIndex then return i
next

//	Not found.  Add it.
ii_ArraySize++
iRequestorIndexes [ ii_ArraySize ] = ai_RequestorIndex
return ii_ArraySize

end function

on n_cst_state.create
TriggerEvent( this, "constructor" )
end on

on n_cst_state.destroy
TriggerEvent( this, "destructor" )
end on

