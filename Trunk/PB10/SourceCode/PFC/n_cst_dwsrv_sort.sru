HA$PBExportHeader$n_cst_dwsrv_sort.sru
$PBExportComments$Extension DataWindow Sort service
forward
global type n_cst_dwsrv_sort from pfc_n_cst_dwsrv_sort
end type
end forward

global type n_cst_dwsrv_sort from pfc_n_cst_dwsrv_sort
end type
global n_cst_dwsrv_sort n_cst_dwsrv_sort

type variables

constant string	is_AltHeaderSuffix = "_t1"
protected boolean	ib_ColumnHeaderSortExt = false

string	is_SortColumns [3]
string	is_SortOrders [3]

string	is_DWONameSortIndicator [3]
string	is_DWOSyntaxSortIndicator [3]

end variables

forward prototypes
public function integer of_setcolumnheaderext (boolean ab_switch)
public function integer of_setsort (string as_format)
public function integer of_readsort ()
end prototypes

public function integer of_setcolumnheaderext (boolean ab_switch);
// Check arguments.
if IsNull ( ab_switch ) then return FAILURE

ib_ColumnHeaderSortExt = ab_switch

return SUCCESS

end function

public function integer of_setsort (string as_format);
//	Call ancestor of_SetSort ()
integer	li_ReturnValue
li_ReturnValue = super::of_SetSort ( as_Format )

//	If Extended Column Sort is enabled read new sort.
if ib_ColumnHeaderSortExt and li_ReturnValue = SUCCESS then
	li_ReturnValue = of_ReadSort ()
end if

//	Return.
return li_ReturnValue

end function

public function integer of_readsort ();
n_cst_sortattrib		lnv_SortAttrib

//	Read the new sort.
if of_BuildSortAttrib ( lnv_SortAttrib ) <> SUCCESS then return FAILURE

integer	li_SortColumns
integer	li_Counter

string	ls_Destroy
string	ls_Create

li_SortColumns = UpperBound ( lnv_SortAttrib.is_OrigColumns )

for li_Counter = 1 to 3
	if is_DWONameSortIndicator [li_Counter] > "" then
		
		//	Destroy the old indicator.
		ls_Destroy += " destroy " + is_DWONameSortIndicator [li_Counter] + " "
	end if
	
	if li_Counter <= li_SortColumns then
		is_SortColumns [li_Counter] = lnv_SortAttrib.is_OrigColumns [li_Counter]
		is_SortOrders [li_Counter] = " " + lnv_SortAttrib.is_OrigOrder [li_Counter]
		
		//	Build the new one.
		is_DWONameSortIndicator [li_Counter] = is_SortColumns [li_Counter] + is_AltHeaderSuffix
		is_DWOSyntaxSortIndicator [li_Counter] = ' create text(band=header alignment="1" text='
		if is_SortOrders [li_Counter] = " A" then is_DWOSyntaxSortIndicator [li_Counter] += '"$$HEX1$$f200$$ENDHEX$$"' else is_DWOSyntaxSortIndicator [li_Counter] += '"$$HEX1$$f100$$ENDHEX$$"'
		is_DWOSyntaxSortIndicator [li_Counter] += ' border="0" color="0" x="' + idw_Requestor.Describe ( is_SortColumns [li_Counter] + ".X" ) + '" y="8" height="48" width="' + idw_Requestor.Describe ( is_SortColumns [li_Counter] + ".Width" ) + '"  name=' + is_SortColumns [li_Counter] + '_t1  font.face="Wingdings" font.height="-8" font.weight="'
		if li_Counter = 1 then is_DWOSyntaxSortIndicator [li_Counter] += '700' else is_DWOSyntaxSortIndicator [1] += '400'
		is_DWOSyntaxSortIndicator [li_Counter] += '"  font.family="0" font.pitch="2" font.charset="2" '
		if li_Counter = 3 then is_DWOSyntaxSortIndicator [li_Counter] += 'font.italic="1" '
		is_DWOSyntaxSortIndicator [li_Counter] += 'background.mode="1" background.color="553648127" ) '
		ls_Create += is_DWOSyntaxSortIndicator [li_Counter]
	else
		is_SortColumns [li_Counter] = ""
		is_SortOrders [li_Counter] = ""
		is_DWONameSortIndicator [li_Counter] = ""
		is_DWOSyntaxSortIndicator [li_Counter] = ""
	end if
next

//	Display the sorted columns.
idw_Requestor.SetRedraw ( false )
idw_Requestor.Modify ( ls_Destroy )
idw_Requestor.Modify ( ls_Create )
idw_Requestor.SetRedraw ( true )

//	Return.
return SUCCESS


end function

on n_cst_dwsrv_sort.create
TriggerEvent( this, "constructor" )
end on

on n_cst_dwsrv_sort.destroy
TriggerEvent( this, "destructor" )
end on

event pfc_clicked;call super::pfc_clicked;string	ls_ClickedName
string 	ls_ColumnName
integer	li_RC
integer	li_SuffixLen
integer	li_HeaderLen
integer	li_AltSuffixLen
string	ls_SortString

//	Validate the dwo reference.
if IsNull ( adwo_Obj ) or not IsValid ( adwo_Obj ) then
	return FAILURE
end if

//	Check if the service is set to sort on column headers.
if not ib_ColumnHeaderSortExt then return NO_ACTION

//	Only valid on header column.
if adwo_Obj.Name = 'datawindow' then return NO_ACTION
if adwo_Obj.Band <> "header" then return NO_ACTION

//	Get column header information.
ls_ClickedName = adwo_Obj.Name
li_HeaderLen = Len ( ls_ClickedName )
li_SuffixLen = Len ( is_defaultheadersuffix )
li_AltSuffixLen = Len ( is_AltHeaderSuffix )

//	Extract the columname from the header label 
//	(by taking out the header suffix).
if Right ( ls_ClickedName, li_SuffixLen ) <> is_defaultheadersuffix then
	if Right ( ls_ClickedName, li_AltSuffixLen ) <> is_AltHeaderSuffix then 
		//	Cannot determine the column name from the header.	
		return FAILURE
	else
		ls_ColumnName = Left (ls_ClickedName, li_HeaderLen - li_AltSuffixLen )
	end if
else
	ls_ColumnName = Left (ls_ClickedName, li_HeaderLen - li_SuffixLen )
end if

//	Validate the column name.
if IsNull ( ls_ColumnName ) or Len ( Trim ( ls_ColumnName ) ) = 0 then
	return FAILURE
end if

//	Build the sort string.
if is_SortColumns [1] = ls_ColumnName then
	//	Clicked primary again, reverse sort order.
	if is_SortOrders [1] = " A" then
		is_SortOrders [1] = " D"
	else
		is_SortOrders [1] = " A"
	end if
else
	//	Clicked a different column.
	if is_SortColumns [2] <> ls_ColumnName then
		//	Didn't click an existing, move 2 to 3 and 1 to 2.
		is_SortColumns [3] = is_SortColumns [2]
		is_SortOrders [3] = is_SortOrders [2]

		is_SortColumns [2] = is_SortColumns [1]
		is_SortOrders [2] = is_SortOrders [1]
	else
		//	Clicked an existing, move 1 to 2.
		is_SortColumns [2] = is_SortColumns [1]
		is_SortOrders [2] = is_SortOrders [1]
	end if
	
	//	Set 1.
	is_SortColumns [1] = ls_ColumnName
	is_SortOrders [1] = " A"
end if

if of_GetUseDisplay ( ) and of_UsesDisplayValue ( ls_ColumnName ) then
	ls_SortString = "LookUpDisplay(" + is_SortColumns [1] + ") " + is_SortOrders [1]
	if is_SortColumns [2] > "" then
		ls_SortString += ", LookUpDisplay(" + is_SortColumns [2] + ") " + is_SortOrders [2]
		if is_SortColumns [3] > "" then
			ls_SortString += ", LookUpDisplay(" + is_SortColumns [3] + ") " + is_SortOrders [3]
		end if
	end if
else
	ls_SortString = is_SortColumns [1] + is_SortOrders [1]
	if is_SortColumns [2] > "" then
		ls_SortString += ", " + is_SortColumns [2] + is_SortOrders [2]
		if is_SortColumns [3] > "" then
			ls_SortString += ", " + is_SortColumns [3] + is_SortOrders [3]
		end if
	end if
end if

//	Perform the SetSort operation (check the rc).
li_RC = of_SetSort ( ls_SortString ) 
if li_RC < 0 then return li_RC

//	Perform the actual Sort operation (check the rc).
li_RC = of_Sort()
if li_RC < 0 then return li_RC	

return 1

end event

