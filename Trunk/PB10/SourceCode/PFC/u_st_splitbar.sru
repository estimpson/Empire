HA$PBExportHeader$u_st_splitbar.sru
$PBExportComments$Extension SplitBar class
forward
global type u_st_splitbar from pfc_u_st_splitbar
end type
end forward

global type u_st_splitbar from pfc_u_st_splitbar
end type
global u_st_splitbar u_st_splitbar

forward prototypes
public function integer of_unregister (dragobject ado_Control)
end prototypes

public function integer of_unregister (dragobject ado_Control);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_UnRegister	
//
//	Access:  		public
//
//	Arguments:		
//	ado_Control		The control to unregister.
//
//	Returns:  		integer
//				1 if it succeeds and$$HEX1$$a000$$ENDHEX$$-1 if an error occurs.
//
//	Description:  	Unregister a control that was previously registered.
//
//////////////////////////////////////////////////////////////////////////////

integer			li_upperbound
integer			li_cnt
integer			li_registered_slot

//Check parameters
If IsNull ( ado_Control ) or ( not IsValid ( ado_Control ) ) Then
	Return -1
End If

//Find the registered object
li_registered_slot = 0
For li_cnt = 1 to ii_lefttopbound
	If idrg_lefttop [ li_cnt ] = ado_Control Then
		li_registered_slot = li_cnt
		SetNull ( idrg_lefttop [ li_registered_slot ] )
		exit
	End If
Next

For li_cnt = 1 to ii_rightbottombound
	If idrg_rightbottom [ li_cnt ] = ado_Control Then
		li_registered_slot = li_cnt
		SetNull ( idrg_rightbottom [ li_registered_slot ] )
		exit
	End If
Next

//Return
if li_registered_slot = 0 then
	return -1
end if

Return 1

end function

