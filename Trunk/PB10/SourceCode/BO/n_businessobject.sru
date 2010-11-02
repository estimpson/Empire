HA$PBExportHeader$n_businessobject.sru
forward
global type n_businessobject from n_base
end type
end forward

global type n_businessobject from n_base
end type
global n_businessobject n_businessobject

type variables

public:
// - Common return value constants:
//constant integer 		SUCCESS = 1
//constant integer 		FAILURE = -1
//constant integer 		NO_ACTION = 0
constant integer	RETRY = 2
// - Continue/Prevent return value constants:
//constant integer 		CONTINUE_ACTION = 1
//constant integer 		PREVENT_ACTION = 0
//constant integer 		FAILURE = -1

public:
protectedwrite string	is_ExplorerViewClass = "u_dw_explorerview"
protectedwrite string	is_ExplorerViewSimple = ""
protectedwrite string	is_ExplorerViewMenu = "m_explorerview"
protectedwrite string	is_Type = ""
privatewrite n_tr	itr_TransObject
protectedwrite n_cst_associative_array	inv_Property

end variables
forward prototypes
public function integer of_settransobject (ref n_tr atr_transobject)
public function integer of_sqlerror (long al_result, string as_message)
end prototypes

public function integer of_settransobject (ref n_tr atr_transobject);
//	Reset current transaction
n_tr	ltr_None
itr_TransObject = ltr_None

//	Check if transaction is valid.
if IsValid ( atr_TransObject ) then
	//	Record transaction.
	itr_TransObject = atr_TransObject
	return SUCCESS
else
	return FAILURE
end if

end function

public function integer of_sqlerror (long al_result, string as_message);
string	ls_SQLError

if al_Result <> 0 or SQLCA.SQLCode <> 0 then
	choose case SQLCA.SQLDBCode
		case 999, 11
			if MessageBox (gnv_App.iapp_Object.DisplayName, "Failed connection.  Reconnect?", Exclamation!, YesNo!, 1) = 1 then
				SQLCA.of_Reconnect ()
				return RETRY
			else
				return FAILURE
			end if
	end choose
	ls_SQLError = SQLCA.SQLErrText
	if al_Result = 0 then al_Result = SQLCA.SQLCode
	SQLCA.of_Rollback ()
	
	if ls_SQLError > "" then
		MessageBox (gnv_App.iapp_Object.DisplayName, as_Message + ls_SQLError)
	else
		MessageBox (gnv_App.iapp_Object.DisplayName, as_Message + String (al_Result))
	end if
	return FAILURE
end if

return SUCCESS

end function

on n_businessobject.create
call super::create
end on

on n_businessobject.destroy
call super::destroy
end on

