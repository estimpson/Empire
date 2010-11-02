HA$PBExportHeader$n_cst_dwsrv_filter.sru
$PBExportComments$Extension DataWindow Filter service
forward
global type n_cst_dwsrv_filter from pfc_n_cst_dwsrv_filter
end type
end forward

global type n_cst_dwsrv_filter from pfc_n_cst_dwsrv_filter
end type
global n_cst_dwsrv_filter n_cst_dwsrv_filter

forward prototypes
protected function integer of_buildfilterattrib (ref n_cst_filterattrib anv_filterattrib)
end prototypes

protected function integer of_buildfilterattrib (ref n_cst_filterattrib anv_filterattrib);
//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_BuildFilterAttrib
//
//	Access: 		protected
//
//	Arguments:
//	astr_filterattrib:	A NVO attribute class, passed by reference, that
//				will hold filter information used by the Filter dialogs.
//
//	Returns: 		Integer
//				1 if it succeeds and$$HEX1$$a000$$ENDHEX$$-1 if an error occurs.
//
//	Description: 		Prepares the filter information required by the
//				Specify Filter dialogs.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0 Initial version.
//	5.0.02 Prevent excluded columns from appearing as blank entries.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries. All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

boolean	lb_Exclude

integer	li_NumCols
integer	li_NumComputes
integer	li_I
integer	li_J
integer	li_K
integer	li_Exclude

string	ls_Computes [ ]			//	Hold all the computed columns.
string	ls_FilterColumnsAll [ ]		//	Hold all filter columns prior to any exclusions.
string	ls_FilterColumnsExc [ ]		//	Hold filter columns after excluding appropriate ones.
string	ls_DBName
string	ls_Filter

//	Check the dw refernce.
if IsNull ( idw_Requestor ) or not IsValid ( idw_Requestor ) then return FAILURE

//	Get the original filter for the datawindow.
ls_Filter = of_GetFilter ( )
if Len ( ls_Filter ) > 0 And ls_Filter = is_FilterOut then
	ls_Filter = is_FilterIn
end if
anv_FilterAttrib.is_Filter = ls_Filter

//	Get all the column names on the datawindow.
li_NumCols = of_GetObjects ( ls_FilterColumnsAll, "column", "*", ib_visibleonly )

//	Get all the computed column names on the datawindow and add them to the array.
li_NumComputes = of_GetObjects ( ls_Computes, "compute", "*", ib_visibleonly )

//	Add compute columns to the array.
for li_I = 1 to li_NumComputes
	if not ( Left ( ls_Computes [ li_I ], 4 ) = "obj_" and IsNumber ( Mid ( ls_Computes [ li_I ], 5, 20 ) ) ) then
		li_NumCols ++
		ls_FilterColumnsAll [ li_NumCols ] = ls_Computes [ li_I ]
	end if
next

//	See if any columns were set to be excluded from the filter display
//	and create a new list of sort columns.
li_Exclude = UpperBound ( is_excludecolumns )
for li_J = 1 to li_NumCols
	lb_Exclude = false
	for li_I = 1 to li_Exclude
		if Lower ( is_ExcludeColumns [ li_I ] ) = Lower ( ls_FilterColumnsAll [ li_J ] ) then
			lb_Exclude = true
			exit
		end if
	next
	if not lb_Exclude then
		li_K++
		ls_FilterColumnsExc [ li_K ] = ls_FilterColumnsAll [ li_J ]
	end if
next

//	Copy the list of appropriate sort columns to the nvo.
anv_FilterAttrib.is_Columns = ls_FilterColumnsExc
li_NumCols = UpperBound ( anv_FilterAttrib.is_Columns )

//	Add the database names to the attributes.
for li_I = 1 to li_NumCols
	ls_DBName = idw_Requestor.Describe ( anv_FilterAttrib.is_Columns [ li_I ] + ".DbName" )
	if ls_DBName = "" or ls_DBName = "!" then ls_DBName = anv_FilterAttrib.is_Columns [ li_I ]
	anv_FilterAttrib.is_DBNames [ li_I ] = ls_DBName
next

//	Get the column displayname.
choose case of_GetColumnNameSource ( )

	case 0
		//	Use dw Column Names.
		for li_I = 1 to li_NumCols
			anv_FilterAttrib.is_ColNameDisplay [ li_I ] = anv_FilterAttrib.is_Columns [ li_I ]
		next

	case 1
		//	Use Database Names.
		for li_I = 1 to li_NumCols
			ls_DBName = idw_Requestor.Describe ( anv_FilterAttrib.is_Columns [ li_I ] + ".DbName" )
			IF ls_DBName = "" or ls_DBName = "!" then ls_DBName = anv_FilterAttrib.is_Columns [ li_I ]
			anv_FilterAttrib.is_ColNameDisplay [ li_I ] = ls_DBName
		next

	case 2
		//	Use Column Headers.
		for li_I = 1 to li_NumCols
			anv_FilterAttrib.is_ColNameDisplay [ li_I ] = of_GetHeaderName ( anv_FilterAttrib.is_Columns [ li_I ] )
		next
end choose

return SUCCESS

end function

on n_cst_dwsrv_filter.create
TriggerEvent( this, "constructor" )
end on

on n_cst_dwsrv_filter.destroy
TriggerEvent( this, "destructor" )
end on

