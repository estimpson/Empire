HA$PBExportHeader$n_tr.sru
$PBExportComments$(PFD)  Extension Transaction class
forward
global type n_tr from pfc_n_tr
end type
end forward

global type n_tr from pfc_n_tr
event type integer pfc_connect ( string connectionname )
end type
global n_tr n_tr

type variables

constant integer	FAILURE = -1, SUCCESS = 1, DBSUCCESS = 0

string	platform
string	is_Profile

boolean	ib_UseRegistry = True

n_cst_registry	inv_Reg

//	Public.
Public:

boolean	PPrompt = false
boolean	TPrompt = false

constant integer	USEUNDEFINED = 0
constant integer	USEINI = 1
constant integer	USEUSERREG = 2
constant integer	USEAPPREG = 3
constant integer	SQLSUCCESS = 0
constant integer	SQLNOROWS = 100

constant integer	ODBCSQLCONNECTOR = 1
constant integer	OLESQLCONNECTOR = 2
constant integer	ADOSQLCONNECTOR = 3

integer	ii_Connect = USEUNDEFINED
integer	ii_SQLConnector

string	is_INISection = "Database"


end variables

forward prototypes
public function datetime uf_get_server_dt ()
public function character uf_get_asn_uop ()
public function string uf_get_shipper_destination (long a_l_shipper)
public function long uf_rollback ()
public function long uf_commit ()
public function long uo_get_operator (ref string arg_password)
public function boolean of_getnextparmvalue (string as_parmcolumn, ref long al_returnvalue)
public function boolean of_getnextparmvalue (string as_parmcolumn, string as_checktable[], string as_checkcolumn[], ref long al_returnvalue)
public function integer of_getidlecommittime ()
public function string of_getmssqlversion ()
public function integer of_oldconnect (string connectionname)
public function integer of_reconnect ()
end prototypes

event type integer pfc_connect(string connectionname);
//	Local variables
string	ls_Profile
string	ls_DBMS
n_cst_associative_array	lnv_Args

//	If the registry settings don't exist, set them up.
inv_Reg.of_CheckDBRegSettings ( ConnectionName )

//	Get the default profile.
inv_Reg.of_GetDefaultProfile ( ConnectionName, ls_Profile, ls_DBMS )

//	If the default profile is not valid, prompt the user.
if IsNull ( ls_Profile, '' ) = '' or inv_Reg.of_GetDBPrompt ( ConnectionName ) or KeyDown ( KeyBackQuote! ) then
	//	Make sure the splash screen isn't showing.
	do while IsValid ( w_splash )
		Yield ( )
	loop
	OpenWithParm ( w_databaseprofiles, ConnectionName )
	if not IsValid ( Message.PowerObjectParm ) then
		return FAILURE
	end if
	lnv_Args = Message.PowerObjectParm
	ls_Dbms = lnv_Args.of_GetItem ( "dbms" )
	ls_Profile = lnv_Args.of_GetItem ( "profile" )
end if

//	Get details for connection with the designated profile.
if ls_DBMS = "MSS" then
	ulong	lul_IntegratedSecurity
	ulong	lul_AutoCommit
	string	ls_ServerName, ls_Database, ls_LogID, ls_LogPass
	inv_Reg.of_GetSQLServerProfileSettings ( ConnectionName, ls_Profile, ls_ServerName, ls_Database, ls_LogID, ls_LogPass, lul_IntegratedSecurity, lul_AutoCommit )
	
	//	Refactor to functions...
	choose case ii_SQLConnector
		case OLESQLCONNECTOR
			DBMS = "OLE DB"
			LogId = ls_LogID
			LogPass = ls_LogPass
			Lock = "RU"
			AutoCommit = (lul_AutoCommit = 1)
			DBParm = "PROVIDER='SQLOLEDB',DATASOURCE='" + ls_ServerName + "',PROVIDERSTRING='database=" + ls_Database + "'"
	
			if lul_IntegratedSecurity = 1 then
				DBParm += ",INTEGRATEDSECURITY='SSPI'"
			end if
		case ADOSQLCONNECTOR
			DBMS = "ADO.Net"
			LogId = ls_LogID
			LogPass = ls_LogPass
			AutoCommit = (lul_AutoCommit = 1)
			DBParm = "Namespace='System.Data.SqlClient',DataSource='" + ls_ServerName + "',Database='" + ls_Database + "',Isolation='RU'"
		case else
			MessageBox ( "Database", "Unable to connect to " + ConnectionName + " database!  SQL Connector not defined [" + string (ii_SQLConnector) + "]." )
			return FAILURE
	end choose
else
	DBMS = "ODBC"
	DBParm = "ConnectString='DSN=" + ls_Profile + "'"
end if

//	Attempt db connection.
if of_Connect ( ) <> DBSUCCESS then
	MessageBox ( "Database", "Unable to connect to " + ConnectionName + " database!" )
	return FAILURE
end if
is_Profile = ls_Profile

//	Connection established.
return SUCCESS

end event

public function datetime uf_get_server_dt ();DATETIME	l_dt_sys_datetime

CHOOSE CASE Left ( platform, 1 )
	CASE "M"
		SELECT Max ( GetDate ( ) )
		  INTO :l_dt_sys_datetime
		  FROM parameters  ;
	CASE "W"
		SELECT Max ( Now ( * ) )
		  INTO :l_dt_sys_datetime
		  FROM systables  ;
END CHOOSE

Return l_dt_sys_datetime
end function

public function character uf_get_asn_uop ();CHAR	l_c_asn_uop

SELECT set_asn_uop
  INTO :l_c_asn_uop
  FROM parameters  ;

RETURN l_c_asn_uop
end function

public function string uf_get_shipper_destination (long a_l_shipper);STRING	l_s_destination

SELECT	destination
  INTO	:l_s_destination
  FROM	shipper
 WHERE	id = :a_l_shipper  ;

Return l_s_destination
end function

public function long uf_rollback ();RollBack  ;
Return SQLCA.SQLCode
end function

public function long uf_commit ();Commit  ;
Return SQLCA.SQLCode
end function

public function long uo_get_operator (ref string arg_password);string ls_password
ls_password=arg_password
SELECT operator_code
  INTO :arg_password
  FROM employee
 WHERE (password = :ls_password) ;
if (SQLCA.SQLcode<>0) then arg_password='' 
Return (SQLCA.SQLcode)
end function

public function boolean of_getnextparmvalue (string as_parmcolumn, ref long al_returnvalue);//************************************************************************************//
// Function Name:	of_getnextparmvalue
//
// Description:	This function calls the overloaded function with the proper values.
//
// Syntax:			BOOL of_getnextparmvalue (	STRING	as_parmcolumn,
//															STRING	REF al_returnvalue )
//
// Where:			as_parmcolumn		The column in parameters table to get the next value for.
//						al_returnvalue		The next available value returned
//
// Returns Codes:	TRUE		Found a valid value
//						FALSE		Unable to find a valid value
//
//
//	Special Notes:
//		DO NOT turn auto commit on before calling this function
//
//************************************************************************************//
// Log of Changes:
// 01-25-2000 12:00:00		CBR		Original.
// 01-26-2000 11:00:00		GPH		Modified.
//	02-02-2000 11:30:00		CBR		Added ability to handle multiple check tables and
//												added next_issue argument.
//************************************************************************************//
//	Flow:
// 1.	declarations
// 2.	initializations
// 3.	return results of function call
//************************************************************************************//

// 1.	declarations
string	ls_table[]
string	ls_column[]

// 2.	initializations
choose case as_parmcolumn
	Case 	"next_serial"
		ls_table[1] = "object"
		ls_column[1] = "serial"
		ls_table[2] = "audit_trail"
		ls_column[2] = "serial"

	Case  "shipper"
		ls_table[1] = "shipper"
		ls_column[1] = "id"

	Case	"sales_order"
		ls_table[1] = "order_header"
		ls_column[1] = "order_no"

	Case "purchase_order"
		ls_table[1] = "po_header"
		ls_column[1] = "po_number"

	Case "next_invoice"
		ls_table[1] = "shipper"
		ls_column[1] = "invoice_number"

	Case "bol_number"
		ls_table[1] = "bill_of_lading"
		ls_column[1] = "bol_number"

	Case 	"next_workorder"
		ls_table[1] = "work_order"
		ls_column[1] = "convert(integer,work_order)"

	Case "next_issue"
		ls_table[1] = "issues"
		ls_column[1] = "issue_number"
		
end choose

// 3.	return results of function call
return of_getnextparmvalue ( as_parmcolumn, ls_table, ls_column, al_returnvalue )

end function

public function boolean of_getnextparmvalue (string as_parmcolumn, string as_checktable[], string as_checkcolumn[], ref long al_returnvalue);//************************************************************************************//
// Function Name:	of_getnextparmvalue
//
// Description:	This function gets the next value from parameters table and returns
//						it to the calling object after verifying that it's not in use.
//
// Syntax:			BOOL of_getnextparmvalue (	STRING	as_parmcolumn,
//															STRING	as_checktable[],
//															STRING	as_checkcolumn[],
//															STRING	REF al_returnvalue )
//
// Where:			as_parmcolumn		The column in parameters table to get the next value for.
//						as_checktable[]	The tables to check if the value is being used.
//						as_checkcolumn[]	The columns to check if the value is being used.
//						al_returnvalue		The next available value returned
//
// Returns Codes:	TRUE		Found a valid value
//						FALSE		Unable to find a valid value
//
//
//	Special Notes:
//		DO NOT turn auto commit on before calling this function
//
//************************************************************************************//
// Log of Changes:
// 01-25-2000 12:00:00		CBR		Original.
// 01-26-2000 11:00:00		GPH		Modified.
//	02-02-2000 11:30:00		CBR		Got rid of modifications from GPH by standardizing and
//												added the ability to handle multiple check tables.
//************************************************************************************//
//	Flow:
//	1.	declarations
// 2.	initializations
// 3.	construct update statement to lock parm row and execute
// 4.	check for errors in update and if so let calling object know
// 5.	get next available value
// 6.	check for errors in update and if so let calling object know
// 7.	loop until an unused value is found
// 8.	construct statement to see if value exists and execute
// 9.	construct update statement to return next value to parameters table and execute
// 10.	check for errors in update and if so let calling object know
// 11.	return success to calling object
//************************************************************************************//

//	1.	declarations
string	ls_statement
boolean	lb_sqlerror
integer	li_validvalue
integer	li_index

declare value dynamic cursor for sqlsa ;

// 2.	initializations
lb_sqlerror = FALSE

// 3.	construct update statement to lock parm row and execute
ls_statement = "update parameters set " + as_parmcolumn + " = " + as_parmcolumn + " + 1"
execute immediate :ls_statement ;

// 4.	check for errors in update and if so let calling object know
if sqlca.sqlcode <> 0 then
	return false
end if

// 5.	get next available value
ls_statement = "select " + as_parmcolumn + " - 1 from parameters"
prepare sqlsa from :ls_statement ;
open dynamic value ;
fetch value into :al_returnvalue ;
lb_sqlerror = NOT ( sqlca.sqlcode = 0 )
close value ;

// 6.	check for errors in update and if so let calling object know
if lb_sqlerror then
	return false
end if

// 7.	loop until an unused value is found
do while NOT lb_sqlerror
// 8.	construct statement to see if value exists and execute
	for li_index = 1 to UpperBound ( as_checktable )
		if NOT lb_sqlerror then
			ls_statement = "select 1 from " + as_checktable[li_index] + " where " + as_checkcolumn[li_index] + " = " + String ( al_returnvalue )
			prepare sqlsa from :ls_statement ;
			open dynamic value ;
			fetch value into :li_validvalue ;
			lb_sqlerror = NOT ( sqlca.sqlcode = 0 )
			close value ;
		end if
	next
	if NOT lb_sqlerror then
		al_returnvalue++
	end if
loop

// 9.	construct update statement to return next value to parameters table and execute
ls_statement = "update parameters set " + as_parmcolumn + " = " + String ( al_returnvalue ) + " + 1"
execute immediate :ls_statement ;

// 10.	check for errors in update and if so let calling object know
if sqlca.sqlcode <> 0 then
	return false
end if

// 11.	return success to calling object
return true

end function

public function integer of_getidlecommittime ();Return isnull(ProfileInt ( "monitor.ini", "IdleCommit", "Minutes", 0 ), 0 )
end function

public function string of_getmssqlversion ();string Stringvar, Sqlstatement
integer Intvar
Sqlstatement = "SELECT @@version from parameters"
PREPARE SQLSA FROM :Sqlstatement ;
DESCRIBE SQLSA INTO SQLDA ;
DECLARE my_cursor DYNAMIC CURSOR FOR SQLSA ;
OPEN DYNAMIC my_cursor USING DESCRIPTOR SQLDA ;
FETCH my_cursor USING DESCRIPTOR SQLDA ;
Stringvar = GetDynamicString(SQLDA, 1)
CLOSE my_cursor ;

return Left ( Stringvar, 25 )
end function

public function integer of_oldconnect (string connectionname);
//	Local variables
ulong	lul_IntegratedSecurity
ulong	lul_AutoCommit
string	ls_Profile
string	ls_DBMS
n_cst_associative_array	lnv_Args

//	If the registry settings don't exist, set them up.
inv_Reg.of_CheckDBRegSettings ( ConnectionName )

//	Get the default profile.
inv_Reg.of_GetDefaultProfile ( ConnectionName, ls_Profile, ls_DBMS )

//	If the default profile is not valid, prompt the user.
if IsNull ( ls_Profile, '' ) = '' or inv_Reg.of_GetDBPrompt ( ConnectionName ) or KeyDown ( KeyBackQuote! ) then
	//	Make sure the splash screen isn't showing.
	do while IsValid ( w_splash )
		Yield ( )
	loop
	OpenWithParm ( w_databaseprofiles, ConnectionName )
	if not IsValid ( Message.PowerObjectParm ) then
		return FAILURE
	end if
	lnv_Args = Message.PowerObjectParm
	dbms = lnv_Args.of_GetItem ( "dbms" )
	ls_Profile = lnv_Args.of_GetItem ( "profile" )
	if dbms = "MSS" then
		ServerName = lnv_Args.of_GetItem ( "servername" )
		Database = lnv_Args.of_GetItem ( "database" )
		LogId = lnv_Args.of_GetItem ( "logid" )
		LogPass = lnv_Args.of_GetItem ( "logpass" )
		AutoCommit = lnv_Args.of_GetItem ( "autocommit" )
		if lnv_Args.of_GetItem ( "integratedsecurity" ) then
			dbparm = "Secure=1"
		end if
	else
		dbparm = lnv_Args.of_GetItem ( "dbparm" )
	end if
else
	if ls_DBMS = "MSS" then
		dbms = "MSS"
		inv_Reg.of_GetSQLServerProfileSettings ( ConnectionName, ls_Profile, ServerName, Database, LogId, LogPass, lul_IntegratedSecurity, lul_AutoCommit )
		if lul_IntegratedSecurity = 1 then
			dbparm = "Secure=1"
		end if
		AutoCommit = ( lul_AutoCommit = 1 )
	else
		dbms = "ODBC"
		dbparm = "ConnectString='DSN=" + ls_Profile + "'"
	end if
end if

//	Attempt db connection.
if of_Connect ( ) <> DBSUCCESS then
	MessageBox ( "Database", "Unable to connect to database!" )
	return FAILURE
end if
is_Profile = ls_Profile

//	Connection established.
return SUCCESS

end function

public function integer of_reconnect ();
//	Close previous connection.
of_Disconnect ()

//	Reconnect.
if of_Connect () = 0 then
	//	Notify of reconnect.
	n_cst_associative_array lnv_Connect
	lnv_Connect.of_SetItem ("Connect", 1)
	gnv_App.inv_StateMsgRouter.of_Broadcast (lnv_Connect)
	return 0
else
	return -1
end if

return -1

end function

on n_tr.create
call super::create
end on

on n_tr.destroy
call super::destroy
end on

