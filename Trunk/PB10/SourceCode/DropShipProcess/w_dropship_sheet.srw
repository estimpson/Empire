HA$PBExportHeader$w_dropship_sheet.srw
forward
global type w_dropship_sheet from w_sheet
end type
type cb_retrieve from commandbutton within w_dropship_sheet
end type
type dw_choosesuppliershipto from u_dw within w_dropship_sheet
end type
type dw_requirements from u_dw within w_dropship_sheet
end type
type cb_ship from commandbutton within w_dropship_sheet
end type
type gb_ship from groupbox within w_dropship_sheet
end type
type gb_choose from groupbox within w_dropship_sheet
end type
end forward

global type w_dropship_sheet from w_sheet
integer width = 2546
integer height = 2324
string menuname = "m_dropship_frame"
boolean controlmenu = false
boolean minbox = false
windowstate windowstate = maximized!
cb_retrieve cb_retrieve
dw_choosesuppliershipto dw_choosesuppliershipto
dw_requirements dw_requirements
cb_ship cb_ship
gb_ship gb_ship
gb_choose gb_choose
end type
global w_dropship_sheet w_dropship_sheet

type variables

end variables

forward prototypes
public function integer of_processshipment ()
end prototypes

public function integer of_processshipment ();
gnv_App.inv_Global.of_SetItem ("SupplierCode", dw_choosesuppliershipto.object.suppliercode [1])
gnv_App.inv_Global.of_SetItem ("ShipToCode", dw_choosesuppliershipto.object.shiptocode [1])

Open (w_dropship_shipment)
int	li_ReturnValue
li_ReturnValue = Message.DoubleParm
if li_ReturnValue <> SUCCESS then
	return FAILURE
end if

datastore	lds_Shipment
lds_Shipment = IsNull (gnv_App.inv_Global.of_GetItem ("DropShipShipment"), lds_Shipment)
if lds_Shipment.RowCount () <= 0 then return FAILURE

datetime	ldt_ShipDate
string	ls_SupplierShipper
string	ls_PRONumber
string	ls_UserCode
string	ls_UserPassword
long	ll_ShipperID

ll_ShipperID = lds_Shipment.object.shipper [1];if ll_ShipperID <= 0 then SetNull (ll_ShipperID)
ldt_ShipDate = lds_Shipment.object.shipdate [1]
ls_SupplierShipper = IsNull (lds_Shipment.object.suppliershipper [1], "")
ls_PRONumber = IsNull (lds_Shipment.object.pronumber [1], "")
ls_UserCode = IsNulL (lds_Shipment.object.usercode [1], "")
ls_UserPassword = IsNull (lds_Shipment.object.userpassword [1], "")

destroy	lds_Shipment

if MessageBox (gnv_App.iapp_Object.DisplayName, "The selected line items will be shipped as of " + String (ldt_ShipDate, "[shortdate]") + " on supplier shipper [" + ls_SupplierShipper + "] by " + ls_UserCode + ".", Information!, OkCancel!, 2) = 2 then
	return NO_ACTION
end if

decimal	ldec_ShipQty
int	li_ShipLines
long	ll_SalesOrderDetailID
long	ll_Result
string	ls_SQLError
string	ls_Syntax;ls_Syntax =&
"declare	@Result int," + &
"		@ShipperID int " + &
"set	@ShipperID = ? " + &
"execute	@Result = FT.ftsp_DropShipProcessShipment" + &
"	@SalesOrderDetailID = ?," + &
"	@ShipperID = @ShipperID out," + &
"	@ShipQty = ?," + &
"	@ShipDate = ?," + &
"	@SupplierShipper = ?," + &
"	@PRONumber = ?," + &
"	@UserCode = ?," + &
"	@UserPassword = ?" + &
"select	@Result," + &
"	@ShipperID "

for li_ShipLines = 1 to dw_requirements.RowCount ()
	
	ll_SalesOrderDetailID = dw_requirements.object.orderdetailid [li_ShipLines]
	ldec_ShipQty = dw_requirements.object.orderqty [li_ShipLines]
	declare DropShipProcessShipment dynamic procedure for SQLSA ;
	prepare SQLSA from :ls_Syntax using SQLCA ;
	execute dynamic DropShipProcessShipment using :ll_ShipperID, :ll_SalesOrderDetailID, :ldec_ShipQty, :ldt_ShipDate, :ls_SupplierShipper, :ls_PRONumber, :ls_UserCode, :ls_UserPassword  ;

	if SQLCA.SQLCode <> 0 then
		ls_SQLError = SQLCA.SQLErrText
		ll_Result = SQLCA.SQLCode
		SQLCA.of_Rollback ()
		if ls_SQLError > "" then
			MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to process line item:  " + ls_SQLError)
		else
			MessageBox (gnv_App.iapp_Object.DisplayName, "Failed on execute, unable to process line item:  " + String (ll_Result))
		end if
		return FAILURE
	end if

	//	Get the result of the stored procedure.
	fetch	DropShipProcessShipment
	into	:ll_Result,
		:ll_ShipperID;
	
	if ll_Result <> 0 or SQLCA.SQLCode <> 0 then
		ls_SQLError = SQLCA.SQLErrText
		SQLCA.of_Rollback ()
		if ls_SQLError > "" then
			MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to process line item:  " + ls_SQLError)
		else
			MessageBox (gnv_App.iapp_Object.DisplayName, "Failed during execute, unable to process line item:  " + String (ll_Result))
		end if
		return FAILURE
	end if

	//	Close procedure and commit.
	Close DropShipProcessShipment;
next

SQLCA.of_Commit ()
return SUCCESS

end function

on w_dropship_sheet.create
int iCurrent
call super::create
if this.MenuName = "m_dropship_frame" then this.MenuID = create m_dropship_frame
this.cb_retrieve=create cb_retrieve
this.dw_choosesuppliershipto=create dw_choosesuppliershipto
this.dw_requirements=create dw_requirements
this.cb_ship=create cb_ship
this.gb_ship=create gb_ship
this.gb_choose=create gb_choose
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.dw_choosesuppliershipto
this.Control[iCurrent+3]=this.dw_requirements
this.Control[iCurrent+4]=this.cb_ship
this.Control[iCurrent+5]=this.gb_ship
this.Control[iCurrent+6]=this.gb_choose
end on

on w_dropship_sheet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_retrieve)
destroy(this.dw_choosesuppliershipto)
destroy(this.dw_requirements)
destroy(this.cb_ship)
destroy(this.gb_ship)
destroy(this.gb_choose)
end on

event pfc_preopen;call super::pfc_preopen;
of_SetResize (true)
inv_Resize.of_SetOrigSize (2 * gb_ship.X + gb_ship.Width, dw_choosesuppliershipto.Y + gb_ship.Y + gb_ship.Height)
inv_Resize.of_Register (cb_retrieve, 100, 0, 0, 0)
inv_Resize.of_Register (cb_ship, 100, 100, 0, 0)
inv_Resize.of_Register (gb_ship, 0, 0, 100, 100)
inv_Resize.of_Register (dw_requirements, 0, 0, 100, 100)

end event

type cb_retrieve from commandbutton within w_dropship_sheet
integer x = 2162
integer y = 516
integer width = 279
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Retrieve"
boolean default = true
end type

event clicked;
dw_choosesuppliershipto.AcceptText ()
dw_requirements.Retrieve (dw_choosesuppliershipto.object.suppliercode [1], dw_choosesuppliershipto.object.shiptocode [1])

end event

type dw_choosesuppliershipto from u_dw within w_dropship_sheet
integer x = 64
integer y = 124
integer width = 987
integer height = 232
integer taborder = 10
string dataobject = "d_dropship_choosesuppliershipto"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;
datawindowchild	ldwc_ShipTo
if GetChild ("shiptocode", ldwc_ShipTo) <> 1 then
	MessageBox (gnv_App.iapp_Object.DisplayName, "Unable to show ship to codes!")
else
	ldwc_ShipTo.InsertRow (0)
end if

of_SetUpdateable (false)
of_SetTransObject (SQLCA)
Retrieve ()

end event

event itemchanged;call super::itemchanged;
choose case dwo.Name
	case "suppliercode"
		datawindowchild	ldwc_ShipTo
		if GetChild ("shiptocode", ldwc_ShipTo) <> 1 then
			MessageBox (gnv_App.iapp_Object.DisplayName, "Unable to show ship to codes!")
		else
			ldwc_ShipTo.SetTransObject (SQLCA)
			if ldwc_ShipTo.Retrieve (data) < 1 then
				ldwc_ShipTo.InsertRow (0)
			end if
		end if
end choose

end event

type dw_requirements from u_dw within w_dropship_sheet
integer x = 23
integer y = 648
integer width = 2441
integer height = 1068
integer taborder = 20
string dataobject = "d_dropship_listrequirements"
boolean hscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;
SetTransObject (SQLCA)
of_SetSort (true)
inv_Sort.of_SetColumnHeader (true)

end event

event itemchanged;call super::itemchanged;
choose case dwo.Name
	case "selected"
		if data = "0" then object.orderqty [row] = object.orderqty.original [row]
	case else
		object.selected [row] = 1
end choose

end event

type cb_ship from commandbutton within w_dropship_sheet
integer x = 2162
integer y = 1744
integer width = 279
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Ship..."
end type

event clicked;
dw_requirements.AcceptText ()
SetRedraw (false)
dw_requirements.SetFilter ("selected = 1")
dw_requirements.Filter ()
dw_requirements.Sort ()
SetRedraw (true)
dw_requirements.SetFilter ("")

if of_ProcessShipment () = SUCCESS then
	MessageBox (gnv_App.iapp_Object.DisplayName, "Shipment processed successfully!", Information!)
	dw_requirements.Retrieve (dw_choosesuppliershipto.object.suppliercode [1], dw_choosesuppliershipto.object.shiptocode [1])
else
	MessageBox (gnv_App.iapp_Object.DisplayName, "Shipment failed.  You may try again or contact IT for help.", Information!)
	SetRedraw (false)
	dw_requirements.Filter ()
	dw_requirements.Sort ()
	SetRedraw (true)
end if


end event

type gb_ship from groupbox within w_dropship_sheet
integer x = 14
integer y = 468
integer width = 2459
integer height = 1440
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Shipped Items:"
end type

type gb_choose from groupbox within w_dropship_sheet
integer x = 14
integer y = 16
integer width = 1070
integer height = 400
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Choose Supplier / Ship To:"
end type

