HA$PBExportHeader$w_part_master.srw
$PBExportComments$Part master maintenance window.
forward
global type w_part_master from Window
end type
type ole_1 from olecontrol within w_part_master
end type
type tab_part_master from tab within w_part_master
end type
type tabpage_general from userobject within tab_part_master
end type
type sle_newpart from singlelineedit within tabpage_general
end type
type dw_part_general from datawindow within tabpage_general
end type
type tabpage_inventory from userobject within tab_part_master
end type
type dw_header_inventory from datawindow within tabpage_inventory
end type
type dw_part_inventory from datawindow within tabpage_inventory
end type
type tabpage_account_codes from userobject within tab_part_master
end type
type dw_header_accounts from datawindow within tabpage_account_codes
end type
type dw_payment_account from datawindow within tabpage_account_codes
end type
type dw_sales_account from datawindow within tabpage_account_codes
end type
type dw_sales_return_account from datawindow within tabpage_account_codes
end type
type tabpage_ecc from userobject within tab_part_master
end type
type dw_part_engineering_change_control from u_dw_ecc within tabpage_ecc
end type
type cb_1 from commandbutton within tabpage_ecc
end type
type cb_2 from commandbutton within tabpage_ecc
end type
type cb_3 from commandbutton within tabpage_ecc
end type
type tabpage_kanban_inventory from userobject within tab_part_master
end type
type dw_kanban_inventory_header from datawindow within tabpage_kanban_inventory
end type
type dw_kanban_inventory_details from datawindow within tabpage_kanban_inventory
end type
type tabpage_issues from userobject within tab_part_master
end type
type dw_issues from datawindow within tabpage_issues
end type
type tabpage_where_used from userobject within tab_part_master
end type
type dw_where_used from datawindow within tabpage_where_used
end type
type tabpage_custom from userobject within tab_part_master
end type
type dw_part_eecustom from datawindow within tabpage_custom
end type
type tabpage_csm from userobject within tab_part_master
end type
type sle_mnemoic_search from singlelineedit within tabpage_csm
end type
type st_5 from statictext within tabpage_csm
end type
type cb_drop from commandbutton within tabpage_csm
end type
type dw_2 from datawindow within tabpage_csm
end type
type dw_csm_unselectedmnemonics from datawindow within tabpage_csm
end type
type cb_add from commandbutton within tabpage_csm
end type
type dw_csm_selectedmnemonics from datawindow within tabpage_csm
end type
type dw_csm_header from datawindow within tabpage_csm
end type
type tabpage_csmold from userobject within tab_part_master
end type
type cbx_1 from checkbox within tabpage_csmold
end type
type st_4 from statictext within tabpage_csmold
end type
type dw_csmdatareport from datawindow within tabpage_csmold
end type
type cb_6 from commandbutton within tabpage_csmold
end type
type cb_5 from commandbutton within tabpage_csmold
end type
type cb_4 from commandbutton within tabpage_csmold
end type
type st_3 from statictext within tabpage_csmold
end type
type dw_part_header from datawindow within tabpage_csmold
end type
type dw_csmprogrameeipart from datawindow within tabpage_csmold
end type
type dw_csmplatforms from datawindow within tabpage_csmold
end type
type tabpage_njb from userobject within tab_part_master
end type
type dwpartnjb from datawindow within tabpage_njb
end type
type cb_9 from commandbutton within tabpage_njb
end type
type cb_8 from commandbutton within tabpage_njb
end type
type cb_7 from commandbutton within tabpage_njb
end type
type dwpartnjbsetups from datawindow within tabpage_njb
end type
type st_2 from statictext within w_part_master
end type
type st_1 from statictext within w_part_master
end type
type tabpage_general from userobject within tab_part_master
sle_newpart sle_newpart
dw_part_general dw_part_general
end type
type tabpage_inventory from userobject within tab_part_master
dw_header_inventory dw_header_inventory
dw_part_inventory dw_part_inventory
end type
type tabpage_account_codes from userobject within tab_part_master
dw_header_accounts dw_header_accounts
dw_payment_account dw_payment_account
dw_sales_account dw_sales_account
dw_sales_return_account dw_sales_return_account
end type
type tabpage_ecc from userobject within tab_part_master
dw_part_engineering_change_control dw_part_engineering_change_control
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
type tabpage_kanban_inventory from userobject within tab_part_master
dw_kanban_inventory_header dw_kanban_inventory_header
dw_kanban_inventory_details dw_kanban_inventory_details
end type
type tabpage_issues from userobject within tab_part_master
dw_issues dw_issues
end type
type tabpage_where_used from userobject within tab_part_master
dw_where_used dw_where_used
end type
type tabpage_custom from userobject within tab_part_master
dw_part_eecustom dw_part_eecustom
end type
type tabpage_csm from userobject within tab_part_master
sle_mnemoic_search sle_mnemoic_search
st_5 st_5
cb_drop cb_drop
dw_2 dw_2
dw_csm_unselectedmnemonics dw_csm_unselectedmnemonics
cb_add cb_add
dw_csm_selectedmnemonics dw_csm_selectedmnemonics
dw_csm_header dw_csm_header
end type
type tabpage_csmold from userobject within tab_part_master
cbx_1 cbx_1
st_4 st_4
dw_csmdatareport dw_csmdatareport
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
st_3 st_3
dw_part_header dw_part_header
dw_csmprogrameeipart dw_csmprogrameeipart
dw_csmplatforms dw_csmplatforms
end type
type tabpage_njb from userobject within tab_part_master
dwpartnjb dwpartnjb
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
dwpartnjbsetups dwpartnjbsetups
end type
type tab_part_master from tab within w_part_master
tabpage_general tabpage_general
tabpage_inventory tabpage_inventory
tabpage_account_codes tabpage_account_codes
tabpage_ecc tabpage_ecc
tabpage_kanban_inventory tabpage_kanban_inventory
tabpage_issues tabpage_issues
tabpage_where_used tabpage_where_used
tabpage_custom tabpage_custom
tabpage_csm tabpage_csm
tabpage_csmold tabpage_csmold
tabpage_njb tabpage_njb
end type
end forward

shared variables

end variables

global type w_part_master from Window
int X=14
int Y=16
int Width=4055
int Height=2004
boolean TitleBar=true
string Title="Part Master"
long BackColor=78682240
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event new_part ( )
event save_part ( )
event exit_routine ( )
event ue_open ( )
event copy_part ( )
event ue_rollup ( )
ole_1 ole_1
tab_part_master tab_part_master
st_2 st_2
st_1 st_1
end type
global w_part_master w_part_master

type variables
BOOLEAN	i_b_modified

STRING		i_s_part,&
		is_issue_select, &
                                is_class, &
		basePart

DataWindowChild	i_dwc_type, &
		i_dwc_vendor

Long		il_clickedrow=0
end variables

forward prototypes
public function boolean uf_query_save ()
public subroutine uf_assign (datawindow ar_dwo, integer ar_colno)
end prototypes

event new_part;IF uf_query_save ( ) THEN
	i_s_part = ""
	tab_part_master.tabpage_general.dw_part_general.Retrieve ( i_s_part )
	tab_part_master.tabpage_general.dw_part_general.SetColumn ( 1 )
	tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
	tab_part_master.SelectTab ( 1 )
END IF
end event

event save_part;string		ls_data
string		ls_tbp
Pointer	l_ptr_old
Decimal  ln_material_cost
string 	ls_type
string 	ls_class


//tab_part_master.tabpage_general.dw_part_general.AcceptText ( )
tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.Accepttext()
tab_part_master.tabpage_inventory.dw_part_inventory.AcceptText ( )
tab_part_master.tabpage_custom.dw_part_eecustom.accepttext()

IF IsNull ( tab_part_master.tabpage_general.dw_part_general.object.part[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid part code is required", StopSign! )
	tab_part_master.SelectTab ( 1 )
	tab_part_master.tabpage_general.dw_part_general.SetColumn ( "part" )
	tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_general.dw_part_general.object.name[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid part name is required", StopSign! )
	tab_part_master.SelectTab ( 1 )
	tab_part_master.tabpage_general.dw_part_general.SetColumn ( "name" )
	tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_general.dw_part_general.object.class[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid part class is required", StopSign! )
	tab_part_master.SelectTab ( 1 )
	tab_part_master.tabpage_general.dw_part_general.SetColumn ( "class" )
	tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
	Return
// MB 09/27/04 Included product line check as per custom request
ELSEIF IsNull ( tab_part_master.tabpage_general.dw_part_general.object.product_line[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid part product line is required", StopSign! )
	tab_part_master.SelectTab ( 1 )
	tab_part_master.tabpage_general.dw_part_general.SetColumn ( "product_line" )
	tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
	RETURN
ELSEIF IsNull ( tab_part_master.tabpage_general.dw_part_general.object.type[1], '' ) = '' THEN 
	IF	tab_part_master.tabpage_general.dw_part_general.object.class[1] <> 'A' AND &
		tab_part_master.tabpage_general.dw_part_general.object.class[1] <> 'N' THEN
		MessageBox ( monsys.msg_title, "A valid part type is required", StopSign! )
	   tab_part_master.SelectTab ( 1 )
	   tab_part_master.tabpage_general.dw_part_general.SetColumn ( "type" )
	   tab_part_master.tabpage_general.dw_part_general.SetFocus ( )
		Return
	END IF
ELSEIF IsNull ( tab_part_master.tabpage_inventory.dw_part_inventory.object.standard_pack[1], 0 ) = 0 THEN
	MessageBox ( monsys.msg_title, "A valid standard pack is required", StopSign! )
	tab_part_master.SelectTab ( 2 )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "standard_pack" )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_inventory.dw_part_inventory.object.standard_unit[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid standard unit is required", StopSign! )
	tab_part_master.SelectTab ( 2 )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "standard_unit" )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_inventory.dw_part_inventory.object.unit_weight[1], 0 ) = 0 THEN
	MessageBox ( monsys.msg_title, "A valid unit weight is required", StopSign! )
	tab_part_master.SelectTab ( 2 )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "unit_weight" )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_inventory.dw_part_inventory.object.label_format[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid label format is required", StopSign! )
	tab_part_master.SelectTab ( 2 )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "label_format" )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ( )
	Return
ELSEIF IsNull ( tab_part_master.tabpage_inventory.dw_part_inventory.object.primary_location[1], '' ) = '' THEN
	MessageBox ( monsys.msg_title, "A valid primary location is required", StopSign! )
	tab_part_master.SelectTab ( 2 )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "primary_location" )
	tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ( )
	Return
END IF 
	
// MB 09/29/04	Check if material cost is entered for purchased part.	
IF ( tab_part_master.tabpage_general.dw_part_general.object.class[1] = 'P' ) THEN
	ln_material_cost = tab_part_master.tabpage_inventory.dw_part_inventory.object.part_standard_material[1]
	IF IsNull ( ln_material_cost, -1 ) = -1 THEN
		MessageBox ( monsys.msg_title, "Material cost cannot be null!", StopSign! )
		tab_part_master.SelectTab (2)
		tab_part_master.tabpage_inventory.dw_part_inventory.SetColumn ( "part_standard_material" )
		tab_part_master.tabpage_inventory.dw_part_inventory.SetFocus ()
		Return
	ELSE
		Update part_standard
		Set material = :ln_material_cost
		where part = :i_s_part ;
		
		If SQLCA.SQLCODE <> 0 THEN
			MessageBox ( monsys.msg_title, "Unable to save material cost information for part:  " + i_s_part + ".  Save aborted", StopSign! )			
			Return 
		End if
	END IF
END IF


// MB 09/30/04 Check for price, default po, vendor etc for raw parts..
IF ( tab_part_master.tabpage_general.dw_part_general.object.type[1] = 'R' ) THEN
	IF	Isnull ( tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.object.default_po_number[1], 0 ) <= 0 THEN
		Messagebox ( monsys.msg_title, "A valid Default PO Number is required", Stopsign! )
		tab_part_master.SelectTab ( 5 )
	   tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.SetColumn ( "default_po_number" )
	   tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.SetFocus ( )
		RETURN
	END IF
	IF	Isnull ( tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.object.default_vendor[1], '' ) = '' THEN
		Messagebox ( monsys.msg_title, "A valid Default Vendor is required", Stopsign! )
		tab_part_master.SelectTab ( 5 )
	   tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.SetColumn ( "default_vendor" )
	   tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.SetFocus ( )
		RETURN
	END IF
	IF	Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.generate_mr[1], '' ) = '' THEN
		Messagebox ( monsys.msg_title, "Rounding Option must be set", Stopsign! )
		tab_part_master.SelectTab ( 8 )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "generate_mr" )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		RETURN
	END IF
	IF	Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.auto_releases[1], '' ) = '' THEN
		Messagebox ( monsys.msg_title, "Auto Release Option must be set", Stopsign! )
		tab_part_master.SelectTab ( 8 )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "auto_releases" )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		RETURN
	END IF
	IF	Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.backdays[1], 0 ) <= 0 THEN
		Messagebox ( monsys.msg_title, "A valid days to back date must be set", Stopsign! )
		tab_part_master.SelectTab ( 8 )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "backdays" )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		RETURN
	END IF
/*	
	IF	Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.team_no[1], 0 ) <= 0 THEN
		Messagebox ( monsys.msg_title, "A valid Team No must be set", Stopsign! )
		tab_part_master.SelectTab ( 8 )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "team_no" )
	   tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		RETURN
	END IF
*/	
End if

IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.team_no[1],0) < 1  THEN		
	MessageBox ( monsys.msg_title, "A valid team # is required", StopSign! )
	tab_part_master.SelectTab ( 8 )		
	tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "team_no" )
	tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
	Return
END IF

IF ( tab_part_master.tabpage_general.dw_part_general.object.class[1] = 'M' ) and &
   ( tab_part_master.tabpage_general.dw_part_general.object.type[1] = 'F' ) THEN
   
	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.eau[1],0) < 1  THEN		
		MessageBox ( monsys.msg_title, "A valid EAU # is required", StopSign! )
		tab_part_master.SelectTab ( 8 )		
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "eau" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		Return
	END IF

	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.std_hours[1],0) =  0  THEN		
		MessageBox ( monsys.msg_title, "A valid Std hours is required", StopSign! )
		tab_part_master.SelectTab ( 8 )		
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "std_hours" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		Return
	END IF

   	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.quoted_bom_cost[1],-1) < 0  THEN		
		MessageBox ( monsys.msg_title, "A valid Quoted bom cost is required", StopSign! )
		tab_part_master.SelectTab ( 8 )		
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "quoted_bom_cost" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		Return
	END IF

//	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.part_standard_material_cum[1],-1) < 0  THEN		
//		MessageBox ( monsys.msg_title, "Material cost is not specified for the one or some of the components", StopSign! )
//		tab_part_master.SelectTab ( 8 )		
//		Return
//	END IF
//
//	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.part_standard_labor_cum[1],-1) < 0  THEN		
//		MessageBox ( monsys.msg_title, "Labor cost is not specified for the one or some of the components", StopSign! )
//		tab_part_master.SelectTab ( 8 )		
//		Return
//	END IF
//
//	IF isnull(tab_part_master.tabpage_custom.dw_part_eecustom.object.part_standard_burden_cum[1],-1) < 0  THEN		
//		MessageBox ( monsys.msg_title, "Burden cost is not specified for the one or some of the components", StopSign! )
//		tab_part_master.SelectTab ( 8 )		
//		Return
//	END IF
//
END IF 
	


IF Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship[1],'N')='Y' THEN		
	if Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_operator[1],'')='' THEN		
		MessageBox ( monsys.msg_title, "A valid operator is required", StopSign! )
		tab_part_master.SelectTab ( 8 )		
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "non_ship_operator" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		Return
	else
		ls_data = tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_operator[1]
		tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_operator[1]= f_get_password(ls_data)
	end if 	
	if Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_note[1],'')='' THEN		
		MessageBox ( monsys.msg_title, "A valid note is required", StopSign! )
		tab_part_master.SelectTab ( 8 )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "non_ship_note" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )		
		Return
	end if 		
ELSEIF Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship[1],'N')='N' THEN		
	tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_operator[1]=''
	tab_part_master.tabpage_custom.dw_part_eecustom.object.non_ship_note[1]=''	
END IF

// MB 02/11/04 Included these lines to check for Non Order status for part
IF Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_status[1], 'N' ) ='Y' THEN		
	
	ls_data = tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_operator[1]
	tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_operator[1]= f_get_password(ls_data)

	if Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_operator[1],'')='' THEN		
		MessageBox ( monsys.msg_title, "A valid operator is required to set Non Order status!", StopSign! )
		tab_part_master.SelectTab ( 8 )		
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "non_order_operator" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )
		Return
	end if 
	
	if Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_note[1],'')='' THEN		
		MessageBox ( monsys.msg_title, "A valid note is required to set Non Order status!", StopSign! )
		tab_part_master.SelectTab ( 8 )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetColumn ( "non_order_note" )
		tab_part_master.tabpage_custom.dw_part_eecustom.SetFocus ( )		
		Return
	end if 		
	
ELSEIF Isnull ( tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_status[1],'N')='N' THEN		

	tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_operator[1]=''
	//tab_part_master.tabpage_custom.dw_part_eecustom.object.non_order_note[1]=''	
	
END IF

w_main_screen.SetMicroHelp ( "Saving..." )
l_ptr_old = SetPointer ( HourGlass! )

IF tab_part_master.tabpage_general.dw_part_general.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save general information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	Return
ELSE
	//set update on for part if dw update is true
	tab_part_master.tabpage_general.dw_part_general.modify ("part.Update = Yes")	
END IF
IF tab_part_master.tabpage_inventory.dw_part_inventory.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save inventory information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	SQLCA.uf_rollback ( )
	Return
END IF
IF tab_part_master.tabpage_account_codes.dw_payment_account.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save purchasing information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	SQLCA.uf_rollback ( )
	Return
END IF
IF tab_part_master.tabpage_account_codes.dw_sales_account.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save customer information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	SQLCA.uf_rollback ( )
	Return
END IF

IF tab_part_master.tabpage_account_codes.dw_sales_return_account.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save customer return a/c information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	SQLCA.uf_rollback ( )
	Return
END IF

// include kanban inventory info by gph on 7/22/98 at 9.59 am, the below if block
IF tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.Update ( TRUE ) = -1 THEN
	MessageBox ( monsys.msg_title, "Unable to save kanban inventory information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	SQLCA.uf_rollback ( )
	Return
END IF

tab_part_master.tabpage_custom.dw_part_eecustom.object.prod_bom_cost[1] = tab_part_master.tabpage_custom.dw_part_eecustom.object.part_standard_material_cum[1]

IF tab_part_master.tabpage_custom.dw_part_eecustom.Update ( TRUE ) = -1 THEN
	SQLCA.uf_rollback ( )
	MessageBox ( monsys.msg_title, "Unable to save custom information for part:  " + i_s_part + ".  Save aborted", StopSign! )
	Return
END IF

//	Save CSM changes.
tab_part_master.tabpage_csm.dw_csm_header.AcceptText()
tab_part_master.tabpage_csm.dw_csm_selectedmnemonics.AcceptText()
if	tab_part_master.tabpage_csm.dw_csm_selectedmnemonics.Update(true) = -1 then
	SQLCA.uf_rollback()
	MessageBox ( monsys.msg_title, "Unable to save CSM info for base part:  " + basePart + ".  Save aborted", StopSign!)
	return
end if
//if tab_part_master.tabpage_csm.dw_csmprogrameeipart.Update ( true )  = -1 then
//	SQLCA.uf_rollback ( )
//	MessageBox ( monsys.msg_title, "Unable to save CSM info for part:  " + i_s_part + ".  Save aborted", StopSign! )
//	return
//end if

SQLCA.uf_commit ( )
tab_part_master.tabpage_general.dw_part_general.Retrieve ( i_s_part )

// mb custom work enable rollup only if manufactured wip or fin part
is_class = tab_part_master.tabpage_general.dw_part_general.object.class[1]
if ( is_class <> 'M' ) then
	m_part_master.m_file.m_rollup.enabled = false
else
	m_part_master.m_file.m_rollup.enabled = true
end if



//ASB - Warn that TBP is disabled

ls_type = tab_part_master.tabpage_general.dw_part_general.object.type[1]
ls_class= tab_part_master.tabpage_general.dw_part_general.object.class[1]
ls_tbp = tab_part_master.tabpage_custom.dw_part_eecustom.object.tb_pricing[1]

//MessageBox ( monsys.msg_title, ls_type+'  ' + ls_class+'   '+ls_tbp)

if ls_type =  'F' and (ls_class =  'M' or ls_class = 'P') then

if ( ls_tbp <> '1' ) then
	MessageBox ( monsys.msg_title, "Time Based Pricing is Disabled!", StopSign! )
	return
end if
end if
end event

event exit_routine;Close ( This )
end event

event ue_open;tab_part_master.tabpage_general.dw_part_general.Retrieve ( i_s_part )
tab_part_master.tabpage_general.dw_part_general.SetColumn ( 1 )
tab_part_master.tabpage_general.dw_part_general.SetFocus ( )

is_class = tab_part_master.tabpage_general.dw_part_general.object.class[1]
if ( is_class <> 'M') then
	m_part_master.m_file.m_rollup.enabled = false
else
	m_part_master.m_file.m_rollup.enabled = true
end if

end event

event copy_part;tab_part_master.tabpage_general.sle_newpart.show()
tab_part_master.tabpage_general.sle_newpart.setfocus()
tab_part_master.tabpage_general.sle_newpart.text=''


end event

event ue_rollup;String l_s_part, l_s_bucket = 'S'
Long   l_l_tvi

IF i_s_part <> '' THEN 

   l_s_part=i_s_part  
	SETPOINTER(Hourglass!)
	sqlca.autocommit=TRUE	
	
	IF g_s_platform = 'Microsoft SQL Server' THEN
		DECLARE mct_computecost PROCEDURE FOR 'msp_calc_costs'
			:l_s_part, :l_s_bucket ;
		Execute mct_computecost ;
		IF sqlca.sqlcode < 0 THEN
			MessageBox (monsys.msg_title, sqlca.sqlerrtext, Information! )
		ELSE
			Messagebox(monsys.msg_title,"Cost rollup was successful")
		END IF
	Else
		DECLARE mct_wccomputecost PROCEDURE FOR 'msp_calc_costs'
			:l_s_part, :l_s_bucket; 
		Execute mct_wccomputecost ;
		IF sqlca.sqlcode < 0 THEN
			MessageBox (monsys.msg_title, sqlca.sqlerrtext, Information! )
		ELSE
			Messagebox(monsys.msg_title,"Cost rollup was successful")		
		END IF
	End If	
	sqlca.autocommit=FALSE
	SETPOINTER(Arrow!)

ELSE

	Messagebox(monsys.msg_title,"Invalid Part")

END IF
end event

public function boolean uf_query_save ();INTEGER	l_i_result

IF NOT i_b_modified THEN
	Return TRUE
END IF

l_i_result = MessageBox ( monsys.msg_title, "Save changes to part:  " + i_s_part + "?", Question!, YesNoCancel! )
CHOOSE CASE l_i_result
	CASE 1
		// part column being a key update is set to false 
		tab_part_master.tabpage_general.dw_part_general.modify ("part.Update = No")
		TRIGGER EVENT save_part ( )
		Return TRUE
	CASE 2
		Return TRUE
	CASE ELSE
		REturn FALSE
END CHOOSE
end function

public subroutine uf_assign (datawindow ar_dwo, integer ar_colno);//	Declarations
string	ls_vendor
long	ll_ponumber
datawindowchild ldwc_child

//	Initilization
ar_dwo.getchild("default_po_number", ldwc_child)	
ldwc_child.settransobject(sqlca)
setnull(ls_vendor)
setnull(ll_ponumber)

ar_dwo.Accepttext()
//	If the column id default vendor, do the following
if ar_colno = 1 then 
	//	Get vendor, retrieve all the POs for that vendor
	ls_vendor = ar_dwo.getitemstring ( 1, "default_vendor")	
	ldwc_child.retrieve(ls_vendor)
	ldwc_child.insertrow(1)
	ldwc_child.scrolltorow(0)
	//	If vendor is null, get all the POs	
	if isnull(ls_vendor) then 
		ar_dwo.setitem(1, 'default_po_number',ll_ponumber)		
		ldwc_child.retrieve('')
		ldwc_child.insertrow(1)
		ldwc_child.scrolltorow(0)
	end if	
else	
	//	Get po number and 
	ll_ponumber = ar_dwo.getitemnumber(1, "default_po_number")	
	//	If not null get the vendor for that po and assign to dw
	if isnull(ll_ponumber,0) > 0 then 
		select	vendor_code
		into	:ls_vendor 
		from	po_header
		where	po_number = :ll_ponumber;
		ar_dwo.setitem(1, 'default_vendor',ls_vendor)
	else	
		//	If PO is null, then assign null to vendor and retrieve all POs
		ar_dwo.setitem(1, 'default_vendor',ls_vendor)
		ldwc_child.retrieve('')
		ldwc_child.insertrow(1)
		ldwc_child.scrolltorow(0)
	end if 	
end if 
end subroutine

on w_part_master.create
this.ole_1=create ole_1
this.tab_part_master=create tab_part_master
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.ole_1,&
this.tab_part_master,&
this.st_2,&
this.st_1}
end on

on w_part_master.destroy
destroy(this.ole_1)
destroy(this.tab_part_master)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;i_s_part = IsNull ( Message.StringParm, "" )

POST EVENT ue_open ( )

end event

event activate;IF w_main_screen.MenuName <> "m_part_master" THEN
	w_main_screen.ChangeMenu ( m_part_master )
	if is_class = 'M' then
		m_part_master.m_file.m_rollup.enabled = true
	else
		m_part_master.m_file.m_rollup.enabled = false
	end if
END IF
end event

event closequery;IF uf_query_save ( ) THEN
	Return 0
ELSE
	Return 1
END IF
end event

type ole_1 from olecontrol within w_part_master
int X=2025
int Y=360
int Width=192
int Height=224
int TabOrder=20
boolean Visible=false
boolean Enabled=false
BorderStyle BorderStyle=StyleLowered!
boolean FocusRectangle=false
omActivation Activation=ActivateOnDoubleClick!
omContentsAllowed ContentsAllowed=ContainsAny!
omDisplayType DisplayType=DisplayAsContent!
end type

type tab_part_master from tab within w_part_master
event create ( )
event destroy ( )
int X=14
int Y=8
int Width=3813
int Height=1688
int TabOrder=10
boolean MultiLine=true
boolean PowerTips=true
boolean RaggedRight=true
int SelectedTab=1
long BackColor=81324524
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
tabpage_general tabpage_general
tabpage_inventory tabpage_inventory
tabpage_account_codes tabpage_account_codes
tabpage_ecc tabpage_ecc
tabpage_kanban_inventory tabpage_kanban_inventory
tabpage_issues tabpage_issues
tabpage_where_used tabpage_where_used
tabpage_custom tabpage_custom
tabpage_csm tabpage_csm
tabpage_csmold tabpage_csmold
tabpage_njb tabpage_njb
end type

on tab_part_master.create
this.tabpage_general=create tabpage_general
this.tabpage_inventory=create tabpage_inventory
this.tabpage_account_codes=create tabpage_account_codes
this.tabpage_ecc=create tabpage_ecc
this.tabpage_kanban_inventory=create tabpage_kanban_inventory
this.tabpage_issues=create tabpage_issues
this.tabpage_where_used=create tabpage_where_used
this.tabpage_custom=create tabpage_custom
this.tabpage_csm=create tabpage_csm
this.tabpage_csmold=create tabpage_csmold
this.tabpage_njb=create tabpage_njb
this.Control[]={this.tabpage_general,&
this.tabpage_inventory,&
this.tabpage_account_codes,&
this.tabpage_ecc,&
this.tabpage_kanban_inventory,&
this.tabpage_issues,&
this.tabpage_where_used,&
this.tabpage_custom,&
this.tabpage_csm,&
this.tabpage_csmold,&
this.tabpage_njb}
end on

on tab_part_master.destroy
destroy(this.tabpage_general)
destroy(this.tabpage_inventory)
destroy(this.tabpage_account_codes)
destroy(this.tabpage_ecc)
destroy(this.tabpage_kanban_inventory)
destroy(this.tabpage_issues)
destroy(this.tabpage_where_used)
destroy(this.tabpage_custom)
destroy(this.tabpage_csm)
destroy(this.tabpage_csmold)
destroy(this.tabpage_njb)
end on

event selectionchanged;if newindex = 1 then 
	m_part_master.m_file.m_fastcopy.enabled = true
else
	m_part_master.m_file.m_fastcopy.enabled = false
end if 	
	
end event

type tabpage_general from userobject within tab_part_master
event create ( )
event destroy ( )
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="General"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
sle_newpart sle_newpart
dw_part_general dw_part_general
end type

on tabpage_general.create
this.sle_newpart=create sle_newpart
this.dw_part_general=create dw_part_general
this.Control[]={this.sle_newpart,&
this.dw_part_general}
end on

on tabpage_general.destroy
destroy(this.sle_newpart)
destroy(this.dw_part_general)
end on

type sle_newpart from singlelineedit within tabpage_general
int X=827
int Y=32
int Width=846
int Height=80
int TabOrder=20
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
TextCase TextCase=Upper!
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;if text > '' and len(trim(text)) > 0 then 
	//	Declare variables
	string	ls_newpart
	string	ls_oldpart
	string	ls_message
	string	ls_ExecuteStatement	
	long    ll_result
	long	ll_option
	
	//	Hide sle text
	tab_part_master.tabpage_general.sle_newpart.hide()	
	
	//	Check whether the procedure exists
	select	isnull(count(1),0)
	into	:ll_result
	from	sysobjects
	where	name = 'msp_copypart' and type = 'P';
	if ll_result = 0 then
		Messagebox ( Monsys.msg_title, 'Procedure msp_copypart is missing in the database, Contact your system administrator')
		return
	end if 		
	
	if Messagebox ( Monsys.msg_title, 'Do you wish to continue with copying process ', Question!, YesNo!, 2) = 2 then return
	
	//	Assign values to local variables
	ls_oldpart = i_s_part
	ls_newpart = text
	
	//	Declare the procedure & execute the same 
	declare copypart dynamic procedure for SQLSA;
	
	ls_ExecuteStatement = &
		"begin "+&
		"	declare @returnvalue integer "+&
		" "+&
		" 	execute msp_copypart " + &
		"		?, "+&
		"		?, "+&			
		"		@returnvalue OUTPUT "+&
		" "+&
		"	select @returnvalue "+&
		"end "
		
	prepare SQLSA from :ls_ExecuteStatement ;	
	
	execute dynamic copypart using :ls_oldpart, :ls_newpart;
	
	fetch	copypart
	into	:ll_result;
	
	close	copypart ;

	//	verify the results from the procedure and display appropriate message
	Choose Case ll_result
		Case -1
			rollback;								
			ls_message = 'Invalid Argument'
		Case -2
			rollback;				
			ls_message = 'Part ' + ls_newpart + ' already exists in the database'
		Case else
			commit ;	
			ls_message = 'Part ' + ls_oldpart + ' was copied successfully to part '+ls_newpart
			i_s_part = ls_newpart
			w_part_master.TriggerEvent("ue_open")
			
	End Choose
	if ls_message > '' then Messagebox(Monsys.msg_title,ls_message)					
end if 	
end event

type dw_part_general from datawindow within tabpage_general
event editchanged pbm_dwnchanging
event itemfocuschanged pbm_dwnitemchangefocus
event losefocus pbm_dwnkillfocus
int Y=16
int Width=1970
int Height=1180
int TabOrder=20
boolean BringToTop=true
string DataObject="d_part_master_general"
boolean Border=false
end type

event constructor;SetTransObject ( SQLCA )
GetChild ( "type", i_dwc_type )
end event

event itemchanged;CHOOSE CASE Integer ( dwo.ID )
	CASE 1
		IF uf_query_save ( ) THEN
			i_s_part = String ( data )
			Retrieve ( i_s_part )
			i_b_modified = FALSE
		ELSE
			object.part [ 1 ] = i_s_part
		END IF
	CASE 4
		i_b_modified = TRUE
		i_dwc_type.Retrieve ( Data )
		object.type[1] = ''
		is_Class = data
		
		//MB included this check to make sure material cost column is enabled for 'P' parts 09/29/04
		if data = 'P' then
			m_part_master.m_file.m_rollup.enabled = false
			tab_part_master.tabpage_inventory.dw_part_inventory.object.part_standard_material.protect = 0
		elseif data = 'M' then
			m_part_master.m_file.m_rollup.enabled = true
			tab_part_master.tabpage_inventory.dw_part_inventory.object.part_standard_material.protect = 1
		else
			m_part_master.m_file.m_rollup.enabled = false
		end if
		
	CASE ELSE
		i_b_modified = TRUE
END CHOOSE
end event

event retrieveend;string ls_curRevLevel

IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = i_s_part
	object.quality_alert[1] = 'N'
	object.serial_type[1] = 'I'
	object.type[1] = 'F'
	object.class[1]='I'
END IF

i_dwc_type.Retrieve ( IsNull ( object.data [ 1, 4 ], "M" ) )
tab_part_master.tabpage_inventory.dw_part_inventory.Retrieve ( i_s_part )
tab_part_master.tabpage_account_codes.dw_payment_account.Retrieve ( i_s_part )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.Retrieve ( i_s_part )
// below line inc by gph for kanban inventory info retrieval
tab_part_master.tabpage_kanban_inventory.dw_kanban_inventory_details.Retrieve ( i_s_part )
tab_part_master.tabpage_custom.dw_part_eecustom.Retrieve ( i_s_part )
tab_part_master.tabpage_account_codes.dw_sales_return_account.Retrieve ( i_s_part )
//included this line to retrieve where used report - sm 5/25/2000
tab_part_master.tabpage_where_used.dw_where_used.retrieve(i_s_part)
//	ASB - Retrieve our CSM data.
//tab_part_master.tabpage_csm.dw_part_header.retrieve ( i_s_part )
//tab_part_master.tabpage_csm.dw_csmprogrameeipart.retrieve ( i_s_part )
//tab_part_master.tabpage_csm.dw_csmdatareport.retrieve ( i_s_part )
//tab_part_master.tabpage_csm.dw_csmplatforms.SelectRow (0, false)
if	Match(Upper(i_s_part), "^[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-*") then
	basePart = left(i_s_part, 7)

	tab_part_master.tabpage_csm.dw_csm_header.retrieve (basePart)
	tab_part_master.tabpage_csm.dw_csm_selectedmnemonics.retrieve (basePart)
	tab_part_master.tabpage_csm.dw_csm_unselectedmnemonics.retrieve (basePart)
end if

//	ASB - Retrieve our NJB data.
tab_part_master.tabpage_njb.dwpartnjbsetups.retrieve ( i_s_part )
tab_part_master.tabpage_njb.dwpartnjb.retrieve ( i_s_part )


// ASB - Set Current Revel Level Flag on custom Tab
//


Select isNUll(currentrevlevel, 'N')
into	:ls_curRevLevel
from	part_eecustom
where	part = : i_s_part;

//if	ls_curRevLevel <> 'Y' then
//tab_part_master.tabpage_csm.cbx_1.Checked = FALSE
//elseif ls_curRevLevel = 'Y' then
//tab_part_master.tabpage_csm.cbx_1.Checked = TRUE
//end if

commit;
if isnull(i_s_part,'') > '' then
	tab_part_master.tabpage_issues.dw_issues.object.datawindow.table.select = is_issue_select + " WHERE product_code = '" + i_s_part + "' OR product_component = '" + i_s_part + "'"
	tab_part_master.tabpage_issues.dw_issues.retrieve ( )
end if 

i_b_modified = FALSE

ShareData ( tab_part_master.tabpage_inventory.dw_header_inventory )
end event

event retrievestart;i_dwc_type.SetTransObject ( SQLCA )
i_dwc_type.Retrieve ( 'M' )
end event

type tabpage_inventory from userobject within tab_part_master
event create ( )
event destroy ( )
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="Inventory"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
dw_header_inventory dw_header_inventory
dw_part_inventory dw_part_inventory
end type

on tabpage_inventory.create
this.dw_header_inventory=create dw_header_inventory
this.dw_part_inventory=create dw_part_inventory
this.Control[]={this.dw_header_inventory,&
this.dw_part_inventory}
end on

on tabpage_inventory.destroy
destroy(this.dw_header_inventory)
destroy(this.dw_part_inventory)
end on

type dw_header_inventory from datawindow within tabpage_inventory
int X=55
int Y=72
int Width=1998
int Height=304
int TabOrder=30
boolean BringToTop=true
string DataObject="d_part_heading"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;tab_part_master.tabpage_general.dw_part_general.ShareData ( this )
end event

type dw_part_inventory from datawindow within tabpage_inventory
int X=78
int Y=364
int Width=1623
int Height=792
int TabOrder=30
string DataObject="d_part_master_inventory"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )
end event

event itemchanged;i_b_modified = TRUE
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	This.SetItem(1, "material_issue_type", "U")
	object.part [ 1 ] = i_s_part
END IF
end event

type tabpage_account_codes from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="A/C Codes"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
dw_header_accounts dw_header_accounts
dw_payment_account dw_payment_account
dw_sales_account dw_sales_account
dw_sales_return_account dw_sales_return_account
end type

on tabpage_account_codes.create
this.dw_header_accounts=create dw_header_accounts
this.dw_payment_account=create dw_payment_account
this.dw_sales_account=create dw_sales_account
this.dw_sales_return_account=create dw_sales_return_account
this.Control[]={this.dw_header_accounts,&
this.dw_payment_account,&
this.dw_sales_account,&
this.dw_sales_return_account}
end on

on tabpage_account_codes.destroy
destroy(this.dw_header_accounts)
destroy(this.dw_payment_account)
destroy(this.dw_sales_account)
destroy(this.dw_sales_return_account)
end on

type dw_header_accounts from datawindow within tabpage_account_codes
int X=160
int Y=60
int Width=1998
int Height=308
int TabOrder=30
boolean BringToTop=true
string DataObject="d_part_heading"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;tab_part_master.tabpage_general.dw_part_general.ShareData ( this )
end event

type dw_payment_account from datawindow within tabpage_account_codes
int X=174
int Y=368
int Width=1518
int Height=80
int TabOrder=40
string DataObject="d_part_master_payment_account"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )
end event

event itemchanged;i_b_modified = TRUE
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = i_s_part
END IF
end event

type dw_sales_account from datawindow within tabpage_account_codes
int X=114
int Y=456
int Width=1426
int Height=92
int TabOrder=40
string DataObject="d_part_master_sales_account"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;tab_part_master.tabpage_general.dw_part_general.ShareData ( this )
end event

event itemchanged;i_b_modified = TRUE
end event

type dw_sales_return_account from datawindow within tabpage_account_codes
int X=114
int Y=552
int Width=1426
int Height=92
int TabOrder=50
boolean BringToTop=true
string DataObject="d_part_eecsalesreturnaccount"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;settransobject(sqlca)
end event

event itemchanged;i_b_modified = TRUE
end event

type tabpage_ecc from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="Eng. Change"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
dw_part_engineering_change_control dw_part_engineering_change_control
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type

on tabpage_ecc.create
this.dw_part_engineering_change_control=create dw_part_engineering_change_control
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.Control[]={this.dw_part_engineering_change_control,&
this.cb_1,&
this.cb_2,&
this.cb_3}
end on

on tabpage_ecc.destroy
destroy(this.dw_part_engineering_change_control)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

type dw_part_engineering_change_control from u_dw_ecc within tabpage_ecc
int X=18
int Y=48
int Width=1888
int Height=860
int TabOrder=20
boolean BringToTop=true
boolean VScrollBar=false
end type

event clicked;call super::clicked;il_clickedrow = row
end event

event dberror;//return 1
end event

type cb_1 from commandbutton within tabpage_ecc
int X=18
int Y=940
int Width=389
int Height=92
int TabOrder=70
string Text="&Save"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;tab_part_master.tabpage_ecc.dw_part_engineering_change_control.Update ( )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.Retrieve ( i_s_part )
end event

type cb_2 from commandbutton within tabpage_ecc
int X=430
int Y=940
int Width=389
int Height=92
int TabOrder=60
string Text="&Add"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;tab_part_master.tabpage_ecc.dw_part_engineering_change_control.InsertRow ( 1 )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.SetRow ( 1 )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.SetColumn ( 1 )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.SelectRow ( 0, FALSE )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.SelectRow ( 1, TRUE )
tab_part_master.tabpage_ecc.dw_part_engineering_change_control.SetFocus ( )
end event

type cb_3 from commandbutton within tabpage_ecc
int X=846
int Y=940
int Width=389
int Height=92
int TabOrder=50
string Text="&Delete"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;datetime	ldt_effectivedate

ldt_effectivedate = tab_part_master.tabpage_ecc.dw_part_engineering_change_control.object.effective_date[il_clickedrow]

delete	effective_change_notice
where	part = :i_s_part and
	effective_date = :ldt_effectivedate;

tab_part_master.tabpage_ecc.dw_part_engineering_change_control.DeleteRow ( il_clickedrow )
end event

type tabpage_kanban_inventory from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="Kanban Inv."
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
dw_kanban_inventory_header dw_kanban_inventory_header
dw_kanban_inventory_details dw_kanban_inventory_details
end type

on tabpage_kanban_inventory.create
this.dw_kanban_inventory_header=create dw_kanban_inventory_header
this.dw_kanban_inventory_details=create dw_kanban_inventory_details
this.Control[]={this.dw_kanban_inventory_header,&
this.dw_kanban_inventory_details}
end on

on tabpage_kanban_inventory.destroy
destroy(this.dw_kanban_inventory_header)
destroy(this.dw_kanban_inventory_details)
end on

type dw_kanban_inventory_header from datawindow within tabpage_kanban_inventory
int X=55
int Y=76
int Width=2002
int Height=292
int TabOrder=40
string DataObject="d_part_heading"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;tab_part_master.tabpage_general.dw_part_general.ShareData ( this )
end event

type dw_kanban_inventory_details from datawindow within tabpage_kanban_inventory
int X=146
int Y=380
int Width=1893
int Height=516
int TabOrder=50
string DataObject="d_kanban_inventory_details"
boolean Border=false
boolean LiveScroll=true
end type

event constructor;SetTransObject (SQLCA)
datawindowchild ldwc_child,&
		ldwc_vendor
					 
getchild("default_po_number", ldwc_child)
ldwc_child.settransobject(sqlca)
ldwc_child.retrieve('')
ldwc_child.insertrow(1)
ldwc_child.scrolltorow(0)

getchild("default_vendor", ldwc_vendor)
ldwc_vendor.settransobject(sqlca)
ldwc_vendor.retrieve()
ldwc_vendor.insertrow(1)

end event

event itemchanged;i_b_modified = TRUE
string	ls_data
choose case dwo.name
	case 'default_vendor'
		uf_assign(this,1)
	case 'default_po_number'
		uf_assign(this,2)		
	case 'non_ship'		
		if isnull(object.non_ship[row],'N') = 'N'  then 
			object.non_ship_operator[row] = ''
			object.non_ship_note[row] = ''
		end if
	case 'non_ship_operator'		
		ls_data = object.non_ship_operator[row]
		object.non_ship_operator[row] = f_get_password (ls_data) 
end choose
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = i_s_part
END IF
end event

event retrievestart;//i_dwc_vendor.SetTransObject ( SQLCA )
//i_dwc_vendor.Retrieve ()
end event

type tabpage_issues from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=79741120
string Text="Issues"
long TabBackColor=79741120
long TabTextColor=33554432
long PictureMaskColor=536870912
dw_issues dw_issues
end type

on tabpage_issues.create
this.dw_issues=create dw_issues
this.Control[]={this.dw_issues}
end on

on tabpage_issues.destroy
destroy(this.dw_issues)
end on

type dw_issues from datawindow within tabpage_issues
int Y=12
int Width=3049
int Height=1168
int TabOrder=20
string DataObject="d_issues_list"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event clicked;if row > 0 then

	SelectRow ( 0, FALSE )
	SelectRow ( row, TRUE )
end if
end event

event constructor;SetTransObject ( sqlca )
is_issue_select = object.datawindow.table.select
end event

event doubleclicked;st_generic_structure	lstr_parm

if row > 0 then
	lstr_parm.value1 = String ( GetItemNumber ( row, "issue_number" ) )
	OpenSheetWithParm ( w_issue_manager, lstr_parm, w_main_screen, 0, Layered! )
end if
end event

type tabpage_where_used from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=81324524
string Text="Where ~r~nUsed"
long TabBackColor=81324524
long PictureMaskColor=536870912
dw_where_used dw_where_used
end type

on tabpage_where_used.create
this.dw_where_used=create dw_where_used
this.Control[]={this.dw_where_used}
end on

on tabpage_where_used.destroy
destroy(this.dw_where_used)
end on

type dw_where_used from datawindow within tabpage_where_used
int Y=24
int Width=3081
int Height=1148
int TabOrder=30
string DataObject="d_bom_where_used"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;settransobject(sqlca)
end event

type tabpage_custom from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=81324524
string Text="Empire~r~nCustom"
long TabBackColor=16777215
long TabTextColor=16711680
long PictureMaskColor=536870912
dw_part_eecustom dw_part_eecustom
end type

on tabpage_custom.create
this.dw_part_eecustom=create dw_part_eecustom
this.Control[]={this.dw_part_eecustom}
end on

on tabpage_custom.destroy
destroy(this.dw_part_eecustom)
end on

type dw_part_eecustom from datawindow within tabpage_custom
event ue_rightclicked pbm_rbuttondown
int X=14
int Y=24
int Width=3063
int Height=1564
int TabOrder=50
string DataObject="d_part_eecustom"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
end type

event ue_rightclicked;String l_s_link, &
		 l_s_file
		 
Integer l_i_col, &
			l_i_cur_col

l_i_col = dw_part_eecustom.GetColumn ()

if l_i_col > 17 or dw_part_eecustom.GetClickedColumn ()  > 17 then	 
	if Getfileopenname ( 'Select File', l_s_link, l_s_file, 'All Files (*.*),*.*' ) = 1 then
		Setitem( 1, l_i_col, l_s_link )
	end if
end if
end event

event constructor;SetTransObject ( SQLCA )
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = i_s_part
	object.tb_pricing [ 1 ] = '1'
END IF
end event

event doubleclicked;String 	l_s_link, &
		 	l_s_file, &
			l_s_column
		 
Integer 	l_i_col, &
			l_i_cur_col

long  l_l_link, &
		l_l_status

l_i_col = dw_part_eecustom.GetColumn ()

if (l_i_col > 17 and l_i_col <28) or (dw_part_eecustom.GetClickedColumn ()  > 17 and dw_part_eecustom.GetClickedColumn () < 28) then	 
	l_s_column = dw_part_eecustom.GetColumnname ()
	
	if l_s_column > '' then &
		l_s_link = getitemstring ( row, l_s_column )
		
	l_l_link = ole_1.insertfile ( l_s_link ) 
		
	If l_l_link = 0 then
		If ole_1.Activate ( Offsite! ) < 0 then
			messagebox ( monsys.msg_title, 'Unable to activate to the object!', Information! )
			return
		end if
	else
		messagebox ( monsys.msg_title, 'Unable to link to the object!', Information! )
	End if
end if

end event

type tabpage_csm from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=82899184
string Text="CSM"
long TabBackColor=16777215
long TabTextColor=16711680
long PictureMaskColor=553648127
string PictureName="Graph!"
sle_mnemoic_search sle_mnemoic_search
st_5 st_5
cb_drop cb_drop
dw_2 dw_2
dw_csm_unselectedmnemonics dw_csm_unselectedmnemonics
cb_add cb_add
dw_csm_selectedmnemonics dw_csm_selectedmnemonics
dw_csm_header dw_csm_header
end type

on tabpage_csm.create
this.sle_mnemoic_search=create sle_mnemoic_search
this.st_5=create st_5
this.cb_drop=create cb_drop
this.dw_2=create dw_2
this.dw_csm_unselectedmnemonics=create dw_csm_unselectedmnemonics
this.cb_add=create cb_add
this.dw_csm_selectedmnemonics=create dw_csm_selectedmnemonics
this.dw_csm_header=create dw_csm_header
this.Control[]={this.sle_mnemoic_search,&
this.st_5,&
this.cb_drop,&
this.dw_2,&
this.dw_csm_unselectedmnemonics,&
this.cb_add,&
this.dw_csm_selectedmnemonics,&
this.dw_csm_header}
end on

on tabpage_csm.destroy
destroy(this.sle_mnemoic_search)
destroy(this.st_5)
destroy(this.cb_drop)
destroy(this.dw_2)
destroy(this.dw_csm_unselectedmnemonics)
destroy(this.cb_add)
destroy(this.dw_csm_selectedmnemonics)
destroy(this.dw_csm_header)
end on

type sle_mnemoic_search from singlelineedit within tabpage_csm
int X=288
int Y=1400
int Width=1143
int Height=100
int TabOrder=90
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;
dw_csm_unselectedmnemonics.SetRedraw(false)

string	searchText
searchText = Upper(Text)
if	searchText > "" then
	dw_csm_unselectedmnemonics.SetFilter( &
		"(upper(mnemonic) like '%" + searchText + "%') or " + &
		"(upper(platform_mnemonic) like '%" + searchText + "%') or " + &
		"(upper(badge) like '%" + searchText + "%') or " + &
		"(upper(nameplate) like '%" + searchText + "%') or " + &
		"(upper(program) like '%" + searchText + "%') or " + &
		"(upper(platform) like '%" + searchText + "%') or " + &
		"(upper(product_type) like '%" + searchText + "%') or " + &
		"(upper(source_plant) like '%" + searchText + "%') or " + &
		"(upper(source_plant_country) like '%" + searchText + "%')")

else
	dw_csm_unselectedmnemonics.SetFilter("")
end if
dw_csm_unselectedmnemonics.Filter()
dw_csm_unselectedmnemonics.Sort()

dw_csm_unselectedmnemonics.SetRedraw(true)

end event
type st_5 from statictext within tabpage_csm
int X=91
int Y=1408
int Width=229
int Height=80
boolean Enabled=false
string Text="Search:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_drop from commandbutton within tabpage_csm
int X=3465
int Y=908
int Width=293
int Height=116
int TabOrder=80
string Text="<-- DROP /"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
long row, newrow; row = 0

do while dw_csm_selectedmnemonics.GetSelectedRow(0) > 0
	row = dw_csm_selectedmnemonics.GetSelectedRow(0)
	
	dw_csm_selectedmnemonics.DeleteRow(row)
loop

dw_csm_selectedmnemonics.Update(true)
commit;

dw_csm_selectedmnemonics.Retrieve(basePart)
dw_csm_unselectedmnemonics.Retrieve(basePart)

end event

type dw_2 from datawindow within tabpage_csm
int X=311
int Y=1540
int Width=2967
int Height=612
int TabOrder=90
string DataObject="d_csm_selectedmnemonics"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

type dw_csm_unselectedmnemonics from datawindow within tabpage_csm
int X=288
int Y=908
int Width=3150
int Height=480
int TabOrder=70
string DataObject="d_csm_unselectedmnemonics"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event constructor;
SetTransObject(SQLCA)

end event

event clicked;
if	row > 0 then
	SelectRow(row, not IsSelected(row))
end if

end event

event retrieveend;
sle_mnemoic_search.Text=""

end event

type cb_add from commandbutton within tabpage_csm
int Y=908
int Width=261
int Height=116
int TabOrder=60
string Text="^-- ADD"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
long row, newrow; row = 0

do while dw_csm_unselectedmnemonics.GetSelectedRow(row) > 0
	row = dw_csm_unselectedmnemonics.GetSelectedRow(row)
	
	newrow = dw_csm_selectedmnemonics.InsertRow(0)
	if left(dw_csm_unselectedmnemonics.object.mnemonic[row], 1) = 'M' then
		dw_csm_selectedmnemonics.object.forecast_id[newrow] = 'C'
	else
		dw_csm_selectedmnemonics.object.forecast_id[newrow] = 'M'
	end if
	dw_csm_selectedmnemonics.object.mnemonic[newrow] = dw_csm_unselectedmnemonics.object.mnemonic[row]
		
	dw_csm_selectedmnemonics.object.sop[newrow] = dw_csm_unselectedmnemonics.object.sop[row]
	dw_csm_selectedmnemonics.object.eop[newrow] = dw_csm_unselectedmnemonics.object.eop[row]
	dw_csm_selectedmnemonics.object.platform_mnemonic[newrow] = dw_csm_unselectedmnemonics.object.platform_mnemonic[row]
	dw_csm_selectedmnemonics.object.badge[newrow] = dw_csm_unselectedmnemonics.object.badge[row]
	dw_csm_selectedmnemonics.object.nameplate[newrow] = dw_csm_unselectedmnemonics.object.nameplate[row]
	dw_csm_selectedmnemonics.object.program[newrow] = dw_csm_unselectedmnemonics.object.program[row]
	dw_csm_selectedmnemonics.object.product_type[newrow] = dw_csm_unselectedmnemonics.object.product_type[row]
	dw_csm_selectedmnemonics.object.source_plant[newrow] = dw_csm_unselectedmnemonics.object.source_plant[row]
	dw_csm_selectedmnemonics.object.source_plant_country[newrow] = dw_csm_unselectedmnemonics.object.source_plant_country[row]
	
	if	dw_csm_header.RowCount() = 0 then
		dw_csm_header.InsertRow(0)
		dw_csm_header.object.basepart[1] = basePart
		dw_csm_header.object.customer[1] = left(basePart, 3)
	end if
	dw_csm_selectedmnemonics.object.base_part[newrow] = dw_csm_header.object.basepart[1]
	dw_csm_selectedmnemonics.object.family[newrow] = dw_csm_header.object.family[1]
	dw_csm_selectedmnemonics.object.customer[newrow] = dw_csm_header.object.customer[1]
	dw_csm_selectedmnemonics.object.empire_market_segment[newrow] = dw_csm_header.object.marketsegment[1]
	dw_csm_selectedmnemonics.object.empire_application[newrow] = dw_csm_header.object.partapplication[1]
loop

dw_csm_selectedmnemonics.Update(true)
commit;

dw_csm_selectedmnemonics.Retrieve(basePart)
dw_csm_unselectedmnemonics.Retrieve(basePart)

end event

type dw_csm_selectedmnemonics from datawindow within tabpage_csm
int Y=328
int Width=3758
int Height=556
int TabOrder=50
string DataObject="d_csm_selectedmnemonics"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event constructor;
SetTransObject(SQLCA)

end event

event clicked;
if	row > 0 then
	SelectRow(row, not IsSelected(row))
end if

end event

type dw_csm_header from datawindow within tabpage_csm
int Y=16
int Width=3758
int Height=288
int TabOrder=50
string DataObject="d_csm_header"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;
SetTransObject(SQLCA)

end event

event itemchanged;
choose case dwo.Name
	case "family"
		dw_csm_selectedmnemonics.object.family.primary = data
	case "marketsegment"
		dw_csm_selectedmnemonics.object.empire_market_segment.primary = data
	case "partapplication"
		dw_csm_selectedmnemonics.object.empire_application.primary = data
end choose


end event

type tabpage_csmold from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
boolean Visible=false
long BackColor=82899184
string Text="CSM"
long TabBackColor=16777215
long TabTextColor=16711680
long PictureMaskColor=553648127
string PictureName="Graph!"
cbx_1 cbx_1
st_4 st_4
dw_csmdatareport dw_csmdatareport
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
st_3 st_3
dw_part_header dw_part_header
dw_csmprogrameeipart dw_csmprogrameeipart
dw_csmplatforms dw_csmplatforms
end type

on tabpage_csmold.create
this.cbx_1=create cbx_1
this.st_4=create st_4
this.dw_csmdatareport=create dw_csmdatareport
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.st_3=create st_3
this.dw_part_header=create dw_part_header
this.dw_csmprogrameeipart=create dw_csmprogrameeipart
this.dw_csmplatforms=create dw_csmplatforms
this.Control[]={this.cbx_1,&
this.st_4,&
this.dw_csmdatareport,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.st_3,&
this.dw_part_header,&
this.dw_csmprogrameeipart,&
this.dw_csmplatforms}
end on

on tabpage_csmold.destroy
destroy(this.cbx_1)
destroy(this.st_4)
destroy(this.dw_csmdatareport)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.st_3)
destroy(this.dw_part_header)
destroy(this.dw_csmprogrameeipart)
destroy(this.dw_csmplatforms)
end on

type cbx_1 from checkbox within tabpage_csmold
int X=1595
int Y=16
int Width=553
int Height=80
string Text="Active Revision Level "
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=81324524
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//cbx_1 Set CurrentRevLevel for all other base parts for this part to NULL when Clicked and Set This part to 'Y'

string	ls_Part
ls_Part = dw_part_header.object.part[1]
if checked then
	update 	part_eecustom 
	set 	currentRevLevel = 'Y' 
	where	part = :ls_Part;
	
	if SQLCA.SQLCode <> 0 then
		Rollback;
		messagebox ('Message', 'Update Failed')
	end if
		
	
	string ls_BasePart
	ls_BasePart = left (ls_Part, pos (ls_Part,'-')-1)
	
	if len (ls_BasePart) = 7 then
		update 	part_eecustom 
		set 	currentRevLevel = 'N' 
		where	part like :ls_BasePart + '%' and
			part != :ls_Part;
		
		if SQLCA.SQLCode <> 0 then
			Rollback;
			messagebox ('Message', 'Update Failed')
		else
			Commit;
			messagebox ('Message', 'Update Success')
		end if
	end if
	
else
	update 	part_eecustom 
	set 	currentRevLevel = 'N' 
	where	part = :ls_Part;
	
	if SQLCA.SQLCode <> 0 then
		Rollback;
		messagebox ('Message', 'Update Failed')
	else
		Commit;
		messagebox ('Message', 'Update Success')
	end if
	
	
end if

end event

type st_4 from statictext within tabpage_csmold
int X=1477
int Y=128
int Width=1257
int Height=80
boolean Enabled=false
boolean Border=true
string Text="CSM Vehicle Data Associated to Monitor Part"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=67108864
int TextSize=-7
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_csmdatareport from datawindow within tabpage_csmold
int X=1504
int Y=1316
int Width=686
int Height=500
int TabOrder=90
boolean Visible=false
string DataObject="dw_report_csmprogram_eeipart"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )
end event

type cb_6 from commandbutton within tabpage_csmold
int X=3150
int Y=8
int Width=603
int Height=108
int TabOrder=30
string Text="Print CSM Data"
int TextSize=-7
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long job

job = PrintOpen( )
// Each DataWindow starts printing on a new page.
PrintDataWindow(job, dw_csmdatareport)


PrintClose(job)
end event

type cb_5 from commandbutton within tabpage_csmold
int X=3090
int Y=1356
int Width=654
int Height=144
int TabOrder=80
string Text="Disassociate CSM Programs"
int TextSize=-7
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
//	Loop until no more rows are highlighted.
do while dw_csmprogrameeipart.GetSelectedRow ( 0 ) > 0
	dw_csmprogrameeipart.DeleteRow ( dw_csmprogrameeipart.GetSelectedRow ( 0 ) )
loop

if dw_csmprogrameeipart.Update ( ) = 1 then
	commit using SQLCA  ;
	MessageBox ( "Success", "Rows deleted" )
else
	rollback using SQLCA  ;
	MessageBox ( "Failure", "Rows not deleted" )
end if

//	Retrieve.
dw_csmprogrameeipart.Retrieve ( i_s_part )

end event

type cb_4 from commandbutton within tabpage_csmold
int X=960
int Y=1356
int Width=590
int Height=144
int TabOrder=70
string Text="Associate CSM Programs"
int TextSize=-7
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
//	Loop through highlighted programs and add to part programs table.
string	ls_Programs [], ls_SQLError
ls_Programs = dw_csmplatforms.object.program.selected

integer	li_Program

datastore	lds_Associate
lds_Associate = create datastore
lds_Associate.DataObject = "d_associatecsmprogram"
lds_Associate.SetTransObject (SQLCA)
for li_Program = 1 to UpperBound ( ls_Programs )
	
	
	if lds_Associate.Retrieve (i_s_part, ls_Programs [li_Program]) < 0 then
		ls_SQLError = SQLCA.SQLErrText
		rollback using SQLCA  ;
		MessageBox ( "Failure on insert", ls_SQLError )
	else
		commit using SQLCA  ;
	end if
next
destroy lds_Associate

dw_csmplatforms.SelectRow ( 0, false )

//	Retrieve.
dw_csmprogrameeipart.Retrieve ( i_s_part )

end event

type st_3 from statictext within tabpage_csmold
int X=14
int Y=20
int Width=197
int Height=88
boolean Enabled=false
string Text="Part"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=81324524
int TextSize=-10
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_part_header from datawindow within tabpage_csmold
int X=210
int Y=16
int Width=1230
int Height=104
int TabOrder=30
string DataObject="dw_part_header"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )

end event

type dw_csmprogrameeipart from datawindow within tabpage_csmold
int X=663
int Y=204
int Width=3081
int Height=1132
int TabOrder=60
string DragIcon="Rectangle!"
string DataObject="dw_csmprogram_eeipart"
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )

end event

event clicked;
//	Highlight or unhighlight the clicked row.
if row <= 0 then return
SelectRow ( row, not IsSelected (row) )

end event

type dw_csmplatforms from datawindow within tabpage_csmold
int X=9
int Y=132
int Width=631
int Height=1308
int TabOrder=50
string DragIcon="C:\PWRS\ArtGal\Icons\BACKUP.ICO"
string DataObject="dw_csm_mnemonic"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;
//	Retrieve list.
SetTransObject ( SQLCA )
Retrieve ()

end event

event clicked;
//	Highlight or unhighlight the clicked row.
if row <= 0 then return
SelectRow ( row, not IsSelected (row) )

end event

type tabpage_njb from userobject within tab_part_master
int X=18
int Y=152
int Width=3776
int Height=1520
long BackColor=81324524
string Text="New Job~r~nBuild"
long TabBackColor=16777215
long TabTextColor=16711680
long PictureMaskColor=553648127
string PictureName="Custom044!"
dwpartnjb dwpartnjb
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
dwpartnjbsetups dwpartnjbsetups
end type

on tabpage_njb.create
this.dwpartnjb=create dwpartnjb
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.dwpartnjbsetups=create dwpartnjbsetups
this.Control[]={this.dwpartnjb,&
this.cb_9,&
this.cb_8,&
this.cb_7,&
this.dwpartnjbsetups}
end on

on tabpage_njb.destroy
destroy(this.dwpartnjb)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.dwpartnjbsetups)
end on

type dwpartnjb from datawindow within tabpage_njb
int X=59
int Y=560
int Width=3694
int Height=912
int TabOrder=60
string DataObject="dw_part_njb"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )
end event

type cb_9 from commandbutton within tabpage_njb
int X=3237
int Y=392
int Width=343
int Height=144
int TabOrder=70
string Text="Modify NJB"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_8 from commandbutton within tabpage_njb
int X=2779
int Y=220
int Width=407
int Height=144
int TabOrder=70
string Text="Show Open NJB"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_7 from commandbutton within tabpage_njb
int X=2775
int Y=388
int Width=411
int Height=144
int TabOrder=60
string Text="New NJB"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dwpartnjbsetups from datawindow within tabpage_njb
int X=55
int Y=44
int Width=2693
int Height=484
int TabOrder=70
string DataObject="dw_part_njb_setups"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;SetTransObject ( SQLCA )
end event

event retrieveend;IF NOT rowcount > 0 THEN
	InsertRow ( 1 )
	object.part [ 1 ] = i_s_part
END IF
end event

type st_2 from statictext within w_part_master
int X=174
int Y=1720
int Width=247
int Height=76
boolean Enabled=false
string Text="Required"
boolean FocusRectangle=false
long TextColor=255
long BackColor=78682240
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
boolean Underline=true
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_part_master
int X=87
int Y=1708
int Width=69
int Height=92
boolean Enabled=false
string Text="*"
boolean FocusRectangle=false
long BackColor=78682240
int TextSize=-24
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

