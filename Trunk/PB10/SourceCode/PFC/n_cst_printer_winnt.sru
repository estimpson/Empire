HA$PBExportHeader$n_cst_printer_winnt.sru
forward
global type n_cst_printer_winnt from n_cst_printer
end type
end forward

global type n_cst_printer_winnt from n_cst_printer
end type
global n_cst_printer_winnt n_cst_printer_winnt

type variables

Private:
string	is_DefaultPrinter

end variables

forward prototypes
public function integer of_storedefault ()
public function integer of_restoredefault ()
public function integer of_setprinter (string as_newprinter)
public function integer of_getprinters (ref string as_printers[])
end prototypes

public function integer of_storedefault ();
//	Store the default printer.
RegistryGet ( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device", RegString!, is_DefaultPrinter )

//	Return.
return SUCCESS

end function

public function integer of_restoredefault ();
//	Retore the default printer.
RegistrySet ( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device", is_DefaultPrinter )

//	Return.
return SUCCESS

end function

public function integer of_setprinter (string as_newprinter);
//	Set the printer.
string	ls_NewSpoolPort

//	Get the spool and port for specified printer.
RegistryGet ( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices", as_NewPrinter, RegString!, ls_NewSpoolPort )

//	Concatenate printer name, spool, and port to set the new printer.
RegistrySet ( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows", "Device", RegString!, as_NewPrinter + ',' + ls_NewSpoolPort )

//	Return.
return SUCCESS

end function

public function integer of_getprinters (ref string as_printers[]);
//	Get a list of local and network printers on the machine.
return RegistryValues ( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices", as_Printers )

end function

on n_cst_printer_winnt.create
TriggerEvent( this, "constructor" )
end on

on n_cst_printer_winnt.destroy
TriggerEvent( this, "destructor" )
end on

