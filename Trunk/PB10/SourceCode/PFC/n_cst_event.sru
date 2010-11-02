HA$PBExportHeader$n_cst_event.sru
forward
global type n_cst_event from n_base
end type
end forward

global type n_cst_event from n_base
end type
global n_cst_event n_cst_event

type variables

public boolean	NeedsProcessing = false
public integer	Status
public string	Name
n_cst_statearray	invStateArray

end variables

on n_cst_event.create
TriggerEvent( this, "constructor" )
end on

on n_cst_event.destroy
TriggerEvent( this, "destructor" )
end on

