HA$PBExportHeader$w_dropship_shipment.srw
forward
global type w_dropship_shipment from w_response
end type
type cb_cancel from commandbutton within w_dropship_shipment
end type
type cb_ok from commandbutton within w_dropship_shipment
end type
type dw_shipment from u_dw within w_dropship_shipment
end type
end forward

global type w_dropship_shipment from w_response
integer width = 1568
integer height = 996
string title = "Shipment"
cb_cancel cb_cancel
cb_ok cb_ok
dw_shipment dw_shipment
end type
global w_dropship_shipment w_dropship_shipment

on w_dropship_shipment.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_shipment=create dw_shipment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_shipment
end on

on w_dropship_shipment.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_shipment)
end on

type cb_cancel from commandbutton within w_dropship_shipment
integer x = 1207
integer y = 212
integer width = 279
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
CloseWithReturn (parent, FAILURE)

end event

type cb_ok from commandbutton within w_dropship_shipment
integer x = 1207
integer y = 72
integer width = 279
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Ok"
boolean default = true
end type

event clicked;
dw_Shipment.AcceptText ()
datastore	lds_Shipment
lds_Shipment = create datastore
lds_Shipment.DataObject = dw_Shipment.DataObject
integer	li_Result; li_Result = dw_Shipment.RowsCopy (1, 1, Primary!, lds_Shipment, 1, Primary!)
gnv_App.inv_Global.of_SetItem ("DropShipShipment", lds_Shipment)
CloseWithReturn (parent, SUCCESS)

end event

type dw_shipment from u_dw within w_dropship_shipment
integer x = 37
integer y = 60
integer width = 1097
integer height = 732
integer taborder = 10
string dataobject = "d_dropship_shipout"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;
string	ls_SupplierCode,ls_ShipToCode

ls_SupplierCode = IsNull (gnv_App.inv_Global.of_GetItem ("SupplierCode"), ls_SupplierCode)
ls_ShipToCode = IsNull (gnv_App.inv_Global.of_GetItem ("ShipToCode"), ls_ShipToCode)

datawindowchild	ldwc_ShipperList
if dw_shipment.GetChild ("shipper", ldwc_ShipperList) = 1 then
	ldwc_ShipperList.SetTransObject(SQLCA)
	ldwc_ShipperList.Retrieve (ls_SupplierCode, ls_ShipToCode)
	ldwc_ShipperList.InsertRow (0)
end if

of_SetUpdateable (false)
of_SetDropDownCalendar (true)
iuo_Calendar.of_Register (iuo_Calendar.DDLB_WITHARROW)
of_SetTransObject (SQLCA)
Retrieve ()

end event

