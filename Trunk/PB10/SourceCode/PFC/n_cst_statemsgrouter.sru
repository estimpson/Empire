HA$PBExportHeader$n_cst_statemsgrouter.sru
forward
global type n_cst_statemsgrouter from n_base
end type
end forward

global type n_cst_statemsgrouter from n_base autoinstantiate
end type

type variables

public constant integer	TYPEMISMATCH = -2
public constant integer	PAUSED = 2
public constant integer	ONLINE = 1
public constant integer	OFFLINE = 0
public constant integer	INVALID = -1

private n_cst_statearray	inv_StateArray
private n_cst_requestorarray	inv_RequestorArray

end variables

forward prototypes
public function integer of_requestnotification (powerobject apo_requestor, string as_eventname, string as_states[])
public function integer of_broadcast (n_cst_associative_array anv_states)
public function integer of_sendevents ()
public function integer of_sendevents (integer ai_requestor)
public function integer of_offline (powerobject apo_requestor)
public function integer of_resume (powerobject apo_requestor)
public function integer of_Pause (powerobject apo_requestor)
public function integer of_requestnotification (powerobject apo_requestor, string as_state)
end prototypes

public function integer of_requestnotification (powerobject apo_requestor, string as_eventname, string as_states[]);
//	Check that at least one State has been mapped.
integer	li_States
li_States = UpperBound ( as_States )
if li_States = 0 then return FAILURE

//	Loop through the requested states, add the event to the state map of each.
integer li_Requestor, li_Event, li_State, i
n_cst_requestor	lnv_Requestor
n_cst_event	lnv_Event
n_cst_state	lnv_State

//	Add requestor to the list.
li_Requestor = inv_RequestorArray.of_GetIndex ( apo_Requestor )
lnv_Requestor = inv_RequestorArray.invRequestors [ li_Requestor ]
lnv_Requestor.Status = ONLINE

//	Add event to the list.
li_Event = lnv_Requestor.invEventArray.of_GetIndex ( as_EventName )
lnv_Event = lnv_Requestor.invEventArray.invEvents [ li_Event ]

//	Loop through each state.
for i = 1 to li_States
	//	Add states to the list.
	li_State = inv_StateArray.of_AddState ( as_States[i] )
	lnv_State = inv_StateArray.invStates [ li_State ]
	inv_StateArray.invStates [ li_State ].Name = as_States[i]
	//	Add a referenct to the requestor to each state.
	inv_StateArray.invStates [ li_State ].of_GetIndex ( li_Requestor )
	
	//	Add state to the list of states attached to this event.
	li_State = lnv_Event.invStateArray.of_AddState ( as_States[i] )
	lnv_Event.invStateArray.invStates [ li_State ] = lnv_State
next

//	Finished.
return success

end function

public function integer of_broadcast (n_cst_associative_array anv_states);
//	Check that at least one State has been sent.
long	ll_States
ll_States = anv_States.of_UpperBound ( )
if ll_States = 0 then return FAILURE

//	Loop through the sent states...
integer	li_State
long i, j, k
string	ls_StateName
any	la_StateValue
long	ll_Requestors, ll_Events
integer	li_RequestorStatus
n_cst_state	lnv_State
n_cst_requestor	lnv_Requestor
n_cst_event	lnv_Event
for i = 1 to ll_States
	ls_StateName = anv_States.of_GetItemIndexor ( i )
	la_StateValue = anv_States.of_GetItem ( i )
	//	Set current state value.
	li_State = inv_StateArray.of_AddState ( ls_StateName )
	lnv_State = inv_StateArray.invStates [ li_State ]
	if isnull ( la_StateValue ) then
		SetNull ( lnv_State.Value )
	elseif ClassName ( lnv_State.Value ) = ClassName ( la_StateValue ) or ClassName ( lnv_State.Value ) = "any" or IsNull ( lnv_State.Value )  then
		lnv_State.Value = la_StateValue
	else
		return TYPEMISMATCH
	end if
	
	//	Loop through list of state requestors.
	ll_Requestors = UpperBound ( lnv_State.iRequestorIndexes )
	for j = 1 to ll_Requestors
		//	Check requestor status.
		lnv_Requestor = inv_RequestorArray.invRequestors [ lnv_State.iRequestorIndexes [j] ]
		li_RequestorStatus = lnv_Requestor.Status
		lnv_Requestor.HasEvents = ( li_RequestorStatus = ONLINE or li_RequestorStatus = PAUSED )
		if ( li_RequestorStatus = ONLINE or li_RequestorStatus = PAUSED ) then
			//	Loop through list of events.
			ll_Events = lnv_Requestor.invEventArray.of_UpperBound ( )
			for k = 1 to ll_Events
				lnv_Event = lnv_Requestor.invEventArray.invEvents [k]
				//	Look at event for this state.
				lnv_Event.NeedsProcessing = lnv_Event.NeedsProcessing or lnv_Event.invStateArray.of_GetIndex ( ls_StateName ) > 0
			next
		end if
	next
next

//	Send events.
return of_SendEvents ( )

end function

public function integer of_sendevents ();
//	Loop through requestors and send events to those that are online.
long	i
long	ll_Requestors
ll_Requestors = inv_RequestorArray.of_UpperBound ( )
for i = 1 to ll_Requestors
	if inv_RequestorArray.invRequestors [i].Status = ONLINE then
		of_SendEvents ( i )
	end if
next

//	Finished.
return SUCCESS

end function

public function integer of_sendevents (integer ai_requestor);
//	Get the status of the requestor.
long	i, j
long	ll_Events, ll_States
n_cst_requestor	lnv_Requestor
n_cst_event lnv_Event
n_cst_state lnv_State
n_cst_associative_array	lnv_Message

lnv_Requestor = inv_RequestorArray.invRequestors [ ai_Requestor ]
if not IsValid ( lnv_Requestor.Requestor ) then return INVALID
if lnv_Requestor.Status = ONLINE and lnv_Requestor.HasEvents then
	//	Loop through events and trigger those that need triggering.
	ll_Events = lnv_Requestor.invEventArray.of_UpperBound ( )
	for i = 1 to ll_Events
		lnv_Event = lnv_Requestor.invEventArray.invEvents [i]
		if lnv_Event.NeedsProcessing then
			//	Loop through states and 
			ll_States = lnv_Event.invStateArray.of_UpperBound ( )
			for j = 1 to ll_States
				lnv_State = lnv_Event.invStateArray.invStates [j]
				lnv_Message.of_SetItem ( lnv_State.Name, lnv_State.Value )
			next
//			lnv_Requestor.Requestor.dynamic event pfc_Event ( lnv_Event.Name, lnv_Message )
			lnv_Requestor.Requestor.dynamic event pfd_Event ( lnv_Event.Name, lnv_Message )
			lnv_Event.NeedsProcessing = false
		end if
	next
	lnv_Requestor.HasEvents = false
end if

//	Finished.
return SUCCESS

end function

public function integer of_offline (powerobject apo_requestor);
//	Turn the requestor off line.
integer li_Requestor
li_Requestor = inv_RequestorArray.of_GetIndex ( apo_Requestor )
inv_RequestorArray.invRequestors [ li_Requestor ].Status = OFFLINE

//	Finished.
return success

end function

public function integer of_resume (powerobject apo_requestor);
//	Bring the requestor on line.
integer li_Requestor
li_Requestor = inv_RequestorArray.of_GetIndex ( apo_Requestor )
inv_RequestorArray.invRequestors [ li_Requestor ].Status = ONLINE

//	Send missed events to the requestor (if it was paused).
of_SendEvents ( li_Requestor )

//	Finished.
return success

end function

public function integer of_Pause (powerobject apo_requestor);
//	Pause the requestor.
integer li_Requestor
li_Requestor = inv_RequestorArray.of_GetIndex ( apo_Requestor )
inv_RequestorArray.invRequestors [ li_Requestor ].Status = PAUSED

//	Finished.
return success

end function

public function integer of_requestnotification (powerobject apo_requestor, string as_state);
//	Treat the single state as an element name.
string	ls_State [1]
ls_State [1] = as_State

//	Call general function.
return of_RequestNotification ( apo_Requestor, as_State, ls_State )

end function

on n_cst_statemsgrouter.create
call super::create
end on

on n_cst_statemsgrouter.destroy
call super::destroy
end on

