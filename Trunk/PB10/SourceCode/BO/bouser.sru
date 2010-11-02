HA$PBExportHeader$bouser.sru
forward
global type bouser from n_businessobject
end type
end forward

shared variables

end variables

global type bouser from n_businessobject
end type
global bouser bouser

type variables

protected string is_UserID
public privatewrite string	is_AppUserID

end variables
forward prototypes
public function integer of_validateuseridpassword (string as_userid, string as_password)
public function integer of_validateuseridpasswordcase (string as_userid, string as_password)
public function integer of_checkusercredentials ()
end prototypes

public function integer of_validateuseridpassword (string as_userid, string as_password);
//	Validate password using direct query.
select	operator_code
into	:is_UserID
from	dbo.employee
where	operator_code = :as_UserId and
	password = :as_Password using SQLCA  ;

//	Check result.
if SQLCA.SQLCode <> 0 then
	SQLCA.of_Rollback ()
	SetNull (is_UserID)
	return FAILURE
end if

//	Success.
SQLCA.of_Commit ()
return	SUCCESS

end function

public function integer of_validateuseridpasswordcase (string as_userid, string as_password);
//	Validate password using direct query.
select	operator_code
into	:is_UserID
from	dbo.employee
where	operator_code = :as_UserId and
	password = :as_Password and
	binary_checksum (operator_code, password) = binary_checksum (:as_UserID, :as_Password) using SQLCA  ;

//	Check result.
if SQLCA.SQLCode <> 0 then
	SQLCA.of_Rollback ()
	SetNull (is_UserID)
	return FAILURE
end if

//	Success.
SQLCA.of_Commit ()
return	SUCCESS

end function

public function integer of_checkusercredentials ();
string	ls_Syntax;ls_Syntax =&
"execute	FT.ftsp_LoginUser " + &
"select	FT.fn_IsPassThrough ()," + &
"	FT.fn_GetAppUserID ()," + &
"	SYSTEM_USER"


declare CheckUserCredentials dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic CheckUserCredentials ;

long	ll_Result
string	ls_SQLError
if SQLCA.SQLCode <> 0 then
	ls_SQLError = SQLCA.SQLErrText
	ll_Result = SQLCA.SQLCode
	SQLCA.of_Rollback ()
	if ls_SQLError > "" then
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to login:  " + ls_SQLError)
	else
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to login:  " + String (ll_Result))
	end if
	return FAILURE
end if

//	Get the result of the stored procedure.
integer	li_PassThrough
string	ls_ApplicaitonUser
string	ls_SystemUser
fetch	CheckUserCredentials
into	:li_PassThrough,
	:ls_ApplicaitonUser,
	:ls_SystemUser ;

if ll_Result <> 0 or SQLCA.SQLCode <> 0 then
	ls_SQLError = SQLCA.SQLErrText
	SQLCA.of_Rollback ()
	if ls_SQLError > "" then
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to login:  " + ls_SQLError)
	else
		MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to login:  " + String (ll_Result))
	end if
	return FAILURE
end if

//	Close procedure and commit.
Close CheckUserCredentials;
SQLCA.of_Commit ()

//	Set user depending on value of PassThrough credentials.
choose case IsNull (li_PassThrough, -1)
	case 0
		//	Require login.
		return SUCCESS
	case 1
		//	Addiontal login not required.
		is_AppUserID = ls_ApplicaitonUser
		is_UserId = ls_SystemUser
		return SUCCESS
	case else
		//	Unrecognized result.
		return FAILURE
end choose
return FAILURE

end function

on bouser.create
call super::create
end on

on bouser.destroy
call super::destroy
end on

