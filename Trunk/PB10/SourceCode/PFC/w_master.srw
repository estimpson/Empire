HA$PBExportHeader$w_master.srw
$PBExportComments$(PFD)  Extension Master Window class
forward
global type w_master from pfc_w_master
end type
end forward

global type w_master from pfc_w_master
integer width = 2743
integer height = 1932
event pfc_refresh ( )
end type
global w_master w_master

type variables

Public:
n_cst_winsrv_ddelabellibrary	inv_RemoteLabelLibrary
n_cst_report	inv_Report
n_cst_winsrv_icontray	inv_IconTray

end variables
forward prototypes
public function integer of_setremotelabellibrary (boolean ab_switch)
public function integer of_setreport (boolean ab_switch)
public function integer of_seticontray (boolean ab_switch)
end prototypes

public function integer of_setremotelabellibrary (boolean ab_switch);
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  of_SetRemoteLabelLibrary
//
//	Arguments:
//	ab_switch   starts/stops the window RemoteLabelLibrary service
//
//	Returns:  integer
//	 1 = Successful operation.
//	 0 = No action necessary
//	-1 = An error was encountered
//
//	Description:
//	Starts or stops the window RemoteLabelLibrary service
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

// Check arguments.
if IsNull (ab_switch) then return -1

if ab_Switch then
	if IsNull(inv_RemoteLabelLibrary) Or not IsValid (inv_RemoteLabelLibrary) then
		inv_RemoteLabelLibrary = create n_cst_winsrv_ddelabellibrary
		inv_RemoteLabelLibrary.of_SetRequestor (this)
		li_rc = 1
	end if
else
	if IsValid (inv_RemoteLabelLibrary) then
		destroy inv_RemoteLabelLibrary
		li_rc = 1
	end if
end if

return li_rc
end function

public function integer of_setreport (boolean ab_switch);
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  of_SetReport
//
//	Arguments:
//	ab_switch   starts/stops the window Report service
//
//	Returns:  integer
//	 1 = Successful operation.
//	 0 = No action necessary
//	-1 = An error was encountered
//
//	Description:
//	Starts or stops the window Report service
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

// Check arguments.
if IsNull (ab_switch) then return -1

if ab_Switch then
	if IsNull(inv_Report) Or not IsValid (inv_Report) then
		inv_Report = create n_cst_report
		inv_Report.of_SetRequestor (this)
		li_rc = 1
	end if
else
	if IsValid (inv_Report) then
		destroy inv_Report
		li_rc = 1
	end if
end if

return li_rc
end function

public function integer of_seticontray (boolean ab_switch);
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  of_SetIcontray
//
//	Arguments:
//	ab_switch   starts/stops the window IconTray service
//
//	Returns:  integer
//	 1 = Successful operation.
//	 0 = No action necessary
//	-1 = An error was encountered
//
//	Description:
//	Starts or stops the window RemoteLabelLibrary service
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

// Check arguments.
if IsNull (ab_switch) then return -1

if ab_Switch then
	if IsNull(inv_IconTray) Or not IsValid (inv_IconTray) then
		inv_IconTray = create n_cst_winsrv_IconTray
		inv_IconTray.of_SetRequestor (this)
		li_rc = 1
	end if
else
	if IsValid (inv_IconTray) then
		destroy inv_IconTray
		li_rc = 1
	end if
end if

return li_rc
end function

on w_master.create
call super::create
end on

on w_master.destroy
call super::destroy
end on

event close;call super::close;
// Destroy instantiated services
of_SetRemoteLabelLibrary (false)
of_SetReport (false)

end event

