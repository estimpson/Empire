HA$PBExportHeader$fuser.sru
forward
global type fuser from n_businessobjectfactory
end type
end forward

global type fuser from n_businessobjectfactory
end type

type variables

end variables

forward prototypes
public function bouser of_getusersecure (string as_userid, string as_password)
public function bouser of_getuserpassthrough ()
end prototypes

public function bouser of_getusersecure (string as_userid, string as_password);
boUser	lbo_User

//	Singleton.
lbo_User = create boUser
if lbo_User.of_ValidateUserIdPasswordCase (as_UserID, as_Password) = SUCCESS then
	return lbo_User
else
	destroy lbo_User
	return lbo_User
end if


end function

public function bouser of_getuserpassthrough ();
boUser	lbo_User

//	Singleton.
lbo_User = create boUser
if lbo_User.of_CheckUserCredentials () = SUCCESS then
	return lbo_User
else
	destroy lbo_User
	return lbo_User
end if

end function

on fuser.create
call super::create
end on

on fuser.destroy
call super::destroy
end on

