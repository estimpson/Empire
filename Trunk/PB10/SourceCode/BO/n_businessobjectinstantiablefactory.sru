HA$PBExportHeader$n_businessobjectinstantiablefactory.sru
forward
global type n_businessobjectinstantiablefactory from n_base
end type
end forward

global type n_businessobjectinstantiablefactory from n_base
end type
global n_businessobjectinstantiablefactory n_businessobjectinstantiablefactory

type variables

privatewrite n_tr	itr_TransObject
end variables

forward prototypes
public function integer of_settransobject (ref n_tr atr_transobject)
public function integer of_getfulllist (ref n_businessobject abobject[])
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

public function integer of_getfulllist (ref n_businessobject abobject[]);
return FAILURE

end function

on n_businessobjectinstantiablefactory.create
call super::create
end on

on n_businessobjectinstantiablefactory.destroy
call super::destroy
end on
