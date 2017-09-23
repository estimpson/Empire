SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [CarPlasticsEDI].[Current830s]
()
returns @Current830s table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ICCode varchar(15)
,	CustomerPart varchar(35)
,	NewDocument int
)
as
begin
--- <Body>
	declare
		@CarPlastics830LastDocumentDTs table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	ICCode varchar(15)
	,	CustomerPart varchar(35)
	,	DocumentDT datetime
	)

	insert
		@CarPlastics830LastDocumentDTs
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart
	,	max(fh.DocumentDT)
	from
		EDI.CarPlastics_830_Headers fh
		join EDI.CarPlastics_830_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fr.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'Active'))
		)
		and fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart


	declare
		@CarPlastics830LastDocNumbers table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	ICCode varchar(15)
	,	CustomerPart varchar(35)
	,	DocumentDT datetime
	,	DocNumber varchar(50)
	)

	insert
		@CarPlastics830LastDocNumbers
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart
	,	fh.DocumentDT
	,	max(fh.DocNumber)
	from
		EDI.CarPlastics_830_Headers fh
		join EDI.CarPlastics_830_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fr.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'Active'))
		)
		and fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart
	,	fh.DocumentDT


	declare
		@CarPlastics830LastDocumentImportDTs table
	(	ShipToCode varchar (15)
	,	ShipFromCode varchar (15)
	,	ICCode varchar(15)
	,	CustomerPart varchar(35)
	,	DocumentDT datetime
	,	DocNumber varchar(50)
	,	ControlNumber varchar(10)
	,	DocumentImportDT datetime
	)

	insert
		@CarPlastics830LastDocumentImportDTs
	select
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart
	,	fh.DocumentDT
	,	fh.DocNumber
	,	fh.ControlNumber
	,	max(fh.DocumentImportDT)
	from
		EDI.CarPlastics_830_Headers fh
		join EDI.CarPlastics_830_Releases fr
			on fr.RawDocumentGUID = fh.RawDocumentGUID
	where
		fr.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'Active'))
		)
		and fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'Active'))
		)
	group by
		fr.ShipToCode
	,	fr.ShipFromCode
	,	coalesce(fr.ICCode, '')
	,	fr.CustomerPart
	,	fh.DocumentDT
	,	fh.DocNumber
	,	fh.ControlNumber
	
	insert
		@Current830s
	select distinct
		fr.RawDocumentGUID
	,	fr.ShipToCode
	,	fr.ShipFromCode
	,	fr.ICCode
	,	fr.CustomerPart
	,	case
			when fr.status = 0-- (select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'New'))
				then 1
			else 0
		end
	from
		EDI.CarPlastics_830_Releases fr
		join EDI.CarPlastics_830_Headers fh
			on fh.RawDocumentGUID = fr.RawDocumentGUID
		join @CarPlastics830LastDocumentDTs flddt
			on fr.ShipToCode = flddt.ShipToCode
			and fr.ShipFromCode = flddt.ShipFromCode
			and coalesce(fr.ICCode, '') = flddt.ICCode
			and fr.CustomerPart = flddt.CustomerPart
		join @CarPlastics830LastDocNumbers fldn
			on fr.ShipToCode = fldn.ShipToCode
			and fr.ShipFromCode = fldn.ShipFromCode
			and coalesce(fr.ICCode, '') = fldn.ICCode
			and fr.CustomerPart = fldn.CustomerPart
			and fh.DocumentDT = fldn.DocumentDT
			and fh.DocNumber = fldn.DocNumber
		join @CarPlastics830LastDocumentImportDTs fldidt
			on fr.ShipToCode = fldidt.ShipToCode
			and fr.ShipFromCode = fldidt.ShipFromCode
			and coalesce(fr.ICCode, '') = fldidt.ICCode
			and fr.CustomerPart = fldidt.CustomerPart
			and fh.DocumentDT = fldidt.DocumentDT
			and fh.DocNumber = fldidt.DocNumber
			and fh.ControlNumber = fldidt.ControlNumber
			and fh.DocumentImportDT = fldidt.DocumentImportDT
	where
		fr.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Releases', 'Status', 'Active'))
		)
		and fh.Status in
		(	0 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'New'))
		,	1 --(select dbo.udf_StatusValue('EDI.CarPlastics_830_Headers', 'Status', 'Active'))
		)
	order by
		fr.ShipToCode
	,	fr.ShipFromCode
	,	fr.ICCode
	,	fr.CustomerPart

--- </Body>

---	<Return>
	return
end
GO
