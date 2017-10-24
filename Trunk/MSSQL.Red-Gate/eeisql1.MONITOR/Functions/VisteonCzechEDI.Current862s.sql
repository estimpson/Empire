SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [VisteonCzechEDI].[Current862s]
()
returns @Current862s table
(	RawDocumentGUID uniqueidentifier
,	NewDocument int
)
as
begin
--- <Body>
	declare
		@VisteonCzech862LastDocumentDTs table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	DocumentDT datetime
	)

	insert
		@VisteonCzech862LastDocumentDTs
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	max(fh.DocumentDT)
	from
		EDI.VisteonCzech_862_Headers fh
		join EDI.VisteonCzech_862_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	
	declare
		@VisteonCzech862LastReleases table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	Release varchar(30)
	)

	insert
		@VisteonCzech862LastReleases
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	max(fh.Release)
	from
		EDI.VisteonCzech_862_Headers fh
		join EDI.VisteonCzech_862_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	
	declare
		@VisteonCzech862LastDocumentImportDTs table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	CustomerPart varchar(35)
	,	DocumentDT datetime
	,	DocNumber varchar(50)
	,	ControlNumber varchar(10)
	,	DocumentImportDT datetime
	)

	insert
		@VisteonCzech862LastDocumentImportDTs
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	fr.CustomerPart
	,	fh.DocumentDT
	,	fh.DocNumber
	,	fh.ControlNumber
	,	max(fh.DocumentImportDT)
	from
		EDI.VisteonCzech_862_Headers fh
		join EDI.VisteonCzech_862_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	,	fr.CustomerPart
	,	fh.DocumentDT
	,	fh.DocNumber
	,	fh.ControlNumber
	
	insert
		@Current862s
	select distinct
		fh.RawDocumentGUID
	,	case
			when fh.status = 0 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'New'))
				then 1
			else 0
		end
	from
		EDI.VisteonCzech_862_Headers fh
		join EDI.VisteonCzech_862_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
		join @VisteonCzech862LastDocumentDTs flddt
			on fr.ShipToCode = flddt.ShipToCode
			and fr.ShipFromCode = flddt.ShipFromCode
			and fh.DocumentDT = flddt.DocumentDT
		join @VisteonCzech862LastReleases flr
			on fr.ShipToCode = flr.ShipToCode
			and fr.ShipFromCode = flr.ShipFromCode
			and fh.Release = flr.Release
		join @VisteonCzech862LastDocumentImportDTs fldidt
			on fr.ShipToCode = fldidt.ShipToCode
			and fr.ShipFromCode = fldidt.ShipFromCode
			and fr.CustomerPart = fldidt.CustomerPart
			and fh.DocumentDT = fldidt.DocumentDT
			and fh.DocNumber = fldidt.DocNumber
			and fh.ControlNumber = fldidt.ControlNumber
			and fh.DocumentImportDT = fldidt.DocumentImportDT
	where
		fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.VisteonCzech_862_Headers', 'Status', 'Active'))
		)
	
--- </Body>

---	<Return>
	return
end
GO
