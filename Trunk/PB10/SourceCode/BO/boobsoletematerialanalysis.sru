HA$PBExportHeader$boobsoletematerialanalysis.sru
forward
global type boobsoletematerialanalysis from n_businessobject
end type
end forward

shared variables

end variables

global type boobsoletematerialanalysis from n_businessobject
end type
global boobsoletematerialanalysis boobsoletematerialanalysis

type variables

public privatewrite long il_Id
public string is_CurrentRawPart

end variables

forward prototypes
public function integer of_new (string as_userid, string as_description)
public function integer of_get (long al_id)
public function integer of_addendingorder (string as_partcode, decimal adec_endingqty)
public function integer of_modifyendingorder (string as_partcode, decimal adec_endingqty)
public function integer of_removeendingorder (string as_partcode)
public function integer of_addrawpart (string as_partcode)
public function integer of_removerawpart (string as_partcode)
public function integer of_addrawpartsecurelocationexclusion (string as_locationcode)
public function integer of_removerawpartsecurelocationexclusion (string as_locationcode)
public function integer of_revertrawparttopocommitment ()
public function integer of_setrawpartnegotiatedcommitment (decimal adec_negotiatedcommitment)
end prototypes

public function integer of_new (string as_userid, string as_description);
string	ls_Syntax;ls_Syntax =&
"	declare	@NewID integer " + &
"	execute FT.ftsp_NewObsoleteMaterialAnalysis " + &
"		@Operator = ?, " + &
"		@Description = ?, " + &
"	@NewID = @NewID output  " + &
"	select	@NewID"

declare NewOMA dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic NewOMA using :as_UserID, :as_Description;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to create new obsolete material analsysis:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_New (as_UserID, as_Description)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	NewOMA
into	:il_ID  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to create new obsolete material analsysis:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_New (as_UserID, as_Description)
	case SUCCESS
end choose

//	Close procedure and commit.
Close NewOMA;
SQLCA.of_Commit ()
return	SUCCESS

end function

public function integer of_get (long al_id);
select	Id
into	:il_Id
from	FT.ObsoleteMaterialAnalysis
where	Id = :al_Id using SQLCA  ;

//	Check result.
if SQLCA.SQLCode <> 0 then
	SQLCA.of_Rollback ()
	SetNull (il_Id)
	return FAILURE
end if

//	Success.
SQLCA.of_Commit ()
return	SUCCESS

end function

public function integer of_addendingorder (string as_partcode, decimal adec_endingqty);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_AddOMAEndingOrder " + &
"	@OMAId=?,"  + &
"	@PartCode=?,"  + &
"	@EndingQty=? " + &
"select	@Result"

declare AddEndingOrder dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic AddEndingOrder using :il_Id, :as_PartCode, :adec_EndingQty ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to add ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddEndingOrder (as_PartCode, adec_EndingQty)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	AddEndingOrder
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to add ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddEndingOrder (as_PartCode, adec_EndingQty)
	case SUCCESS
end choose

//	Close procedure and commit.
Close AddEndingOrder;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_modifyendingorder (string as_partcode, decimal adec_endingqty);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_ModifyOMAEndingOrder " + &
"	@OMAId=?,"  + &
"	@PartCode=?,"  + &
"	@EndingQty=? " + &
"select	@Result"

declare ModifyEndingOrder dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic ModifyEndingOrder using :il_Id, :as_PartCode, :adec_EndingQty ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to modify ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_ModifyEndingOrder (as_PartCode, adec_EndingQty)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	ModifyEndingOrder
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to modify ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_ModifyEndingOrder (as_PartCode, adec_EndingQty)
	case SUCCESS
end choose

//	Close procedure and commit.
Close ModifyEndingOrder;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_removeendingorder (string as_partcode);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_RemoveOMAEndingOrder " + &
"	@OMAId=?,"  + &
"	@PartCode=? " + &
"select	@Result"

declare RemoveEndingOrder dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic RemoveEndingOrder using :il_Id, :as_PartCode  ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to remove ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveEndingOrder (as_PartCode)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	RemoveEndingOrder
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to remove ending order:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveEndingOrder (as_PartCode)
	case SUCCESS
end choose

//	Close procedure and commit.
Close RemoveEndingOrder;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_addrawpart (string as_partcode);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_AddOMARawPart " + &
"	@OMAId=?,"  + &
"	@PartCode=?"  + &
"select	@Result"

declare AddRawPart dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic AddRawPart using :il_Id, :as_PartCode  ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to add raw part:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddRawPart (as_PartCode)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	AddRawPart
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to add raw part:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddRawPart (as_PartCode)
	case SUCCESS
end choose

//	Close procedure and commit.
Close AddRawPart;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_removerawpart (string as_partcode);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_RemoveOMARawPart " + &
"	@OMAId=?,"  + &
"	@PartCode=?"  + &
"select	@Result"

declare RemoveRawPart dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic RemoveRawPart using :il_Id, :as_PartCode  ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to remove raw part:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveRawPart (as_PartCode)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	RemoveRawPart
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to remove raw part:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveRawPart (as_PartCode)
	case SUCCESS
end choose

//	Close procedure and commit.
Close RemoveRawPart;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_addrawpartsecurelocationexclusion (string as_locationcode);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_AddOMARawPartSecureLocationExclusion " + &
"	@OMAId=?,"  + &
"	@PartCode=?,"  + &
"	@LocationCode=? " + &
"select	@Result"

declare AddOMARawPartSecureLocationExclusion dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic AddOMARawPartSecureLocationExclusion using :il_Id, :is_CurrentRawPart, :as_LocationCode ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to add raw part secure location exclusion:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddRawPartSecureLocationExclusion (as_LocationCode)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	AddOMARawPartSecureLocationExclusion
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to add raw part secure location exclusion:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_AddRawPartSecureLocationExclusion (as_LocationCode)
	case SUCCESS
end choose

//	Close procedure and commit.
Close AddOMARawPartSecureLocationExclusion;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_removerawpartsecurelocationexclusion (string as_locationcode);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_RemoveOMARawPartSecureLocationExclusion " + &
"	@OMAId=?,"  + &
"	@PartCode=?,"  + &
"	@LocationCode=? " + &
"select	@Result"

declare RemoveOMARawPartSecureLocationExclusion dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic RemoveOMARawPartSecureLocationExclusion using :il_Id, :is_CurrentRawPart, :as_LocationCode ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to remove raw part secure location exclusion:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveRawPartSecureLocationExclusion (as_LocationCode)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	RemoveOMARawPartSecureLocationExclusion
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to remove raw part secure location exclusion:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RemoveRawPartSecureLocationExclusion (as_LocationCode)
	case SUCCESS
end choose

//	Close procedure and commit.
Close RemoveOMARawPartSecureLocationExclusion;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_revertrawparttopocommitment ();
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_RevertOMARawPartToPOCommitment " + &
"	@OMAId=?,"  + &
"	@PartCode=? " + &
"select	@Result"

declare RevertOMARawPartToPOCommitment dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic RevertOMARawPartToPOCommitment using :il_Id, :is_CurrentRawPart  ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to revert raw part to PO commitment:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RevertRawPartToPOCommitment ()
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	RevertOMARawPartToPOCommitment
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to revert raw part to PO commitment:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_RevertRawPartToPOCommitment ()
	case SUCCESS
end choose

//	Close procedure and commit.
Close RevertOMARawPartToPOCommitment;
SQLCA.of_Commit ()
return SUCCESS

end function

public function integer of_setrawpartnegotiatedcommitment (decimal adec_negotiatedcommitment);
string	ls_Syntax;ls_Syntax =&
"declare	@Result int " + &
"execute	@Result = FT.ftsp_SetOMARawPartNegotiatedCommitment " + &
"	@OMAId=?,"  + &
"	@PartCode=?,"  + &
"	@NegotiatedCommitment=? " + &
"select	@Result"

declare SetOMARawPartNegotiatedCommitment dynamic procedure for SQLSA ;
prepare SQLSA from :ls_Syntax using SQLCA ;
execute dynamic SetOMARawPartNegotiatedCommitment using :il_Id, :is_CurrentRawPart, :adec_NegotiatedCommitment ;

long	ll_Result
//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed on execute, unable to set raw part negotiated commitment:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_SetRawPartNegotiatedCommitment (adec_NegotiatedCommitment)
	case SUCCESS
end choose

//	Get the result of the stored procedure.
fetch	SetOMARawPartNegotiatedCommitment
into	:ll_Result  ;

//	Check for SQL Error.
choose case of_SQLError (ll_Result, "Failed during execute, unable to set raw part negotiated commitment:  ")
	case FAILURE
		return FAILURE
	case RETRY
		return of_SetRawPartNegotiatedCommitment (adec_NegotiatedCommitment)
	case SUCCESS
end choose

//	Close procedure and commit.
Close SetOMARawPartNegotiatedCommitment;
SQLCA.of_Commit ()
return SUCCESS

end function

on boobsoletematerialanalysis.create
call super::create
end on

on boobsoletematerialanalysis.destroy
call super::destroy
end on

