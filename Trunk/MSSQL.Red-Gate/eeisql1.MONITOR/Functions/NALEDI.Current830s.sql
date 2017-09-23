SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [NALEDI].[Current830s]
()
returns @CurrentSS table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	CustomerPart varchar(50)
--,	CustomerPO varchar(50)-- Andre S. Boulanger Fore-thought, LLC 2012-08-16, NAL Sends miultiple POs and Blank POs with an 830; however the schedule needs to be written to one Monitor sales order. Currently there is no requirment to return the PO number on either labels. ASN, or paperwork
,	NewDocument int
)
as
begin
--- <Body>
	insert
		@CurrentSS
	select
		RawDocumentGUID = ssh.RawDocumentGUID
	,	ShipToCode = ss.ShipToCode
	,	ShipFromCode = coalesce(ss.ShipFromCode,'')
	,	CustomerPart = ss.CustomerPart
	--,	CustomerPO = coalesce(ss.CustomerPO,'') --because it's sometimes missing
	,	NewDocument =
			case
				when ssh.Status = 0 --(select dbo.udf_StatusValue('EDIMagnaPT.ShipScheduleHeaders', 'Status', 'New'))
					then 1
				else 0
			end
	from
		(	select
				ShipToCode = ss.ShipToCode
			,	ShipFromCode = coalesce(ss.ShipFromCode,'')
			,	CustomerPart = ss.CustomerPart
			--,	CustomerPO = coalesce(ss.CustomerPO,'')
			,	CheckLast = max
				(	  convert(char(20), ssh.DocumentDT, 120)
					+ convert(char(10), ss.ReleaseNo)
					+ convert(char(10), ssh.DocNumber)
					+ convert(char(10), ssh.ControlNumber)
					+ convert(char(20), ssh.DocumentImportDT, 120)
				)
			from
				EDI.NAL_830_Headers ssh
		join EDI.NAL_830_Releases ss
					on ss.RawDocumentGUID = ssh.RawDocumentGUID
			where
				ssh.Status in
				(	0 --(select dbo.udf_StatusValue('EDIMagnaPT.ShipScheduleHeaders', 'Status', 'New'))
				,	1 --(select dbo.udf_StatusValue('EDIMagnaPT.ShipScheduleHeaders', 'Status', 'Active'))
				)
			group by
				ss.ShipToCode
			,	coalesce(ss.ShipFromCode,'')
			,	ss.CustomerPart
			--,	coalesce(ss.CustomerPO,'')
		) cl
		join EDI.NAL_830_Headers ssh
			join EDI.NAL_830_Releases ss
				on ss.RawDocumentGUID = ssh.RawDocumentGUID
			on ss.ShipToCode = cl.ShipToCode
			and coalesce(ss.ShipFromCode, '') = cl.ShipFromCode
			and ss.CustomerPart = cl.CustomerPart
			--and coalesce(ss.CustomerPO, '') = cl.CustomerPO
			and	(	
					 convert(char(20), ssh.DocumentDT, 120)
					+ convert(char(10), ss.ReleaseNo)
					+ convert(char(10), ssh.DocNumber)
					+ convert(char(10), ssh.ControlNumber)
					+ convert(char(20), ssh.DocumentImportDT, 120)
				) = cl.CheckLast
	group by
		ssh.RawDocumentGUID
	,	ss.ShipToCode
	,	coalesce(ss.ShipFromCode,'')
	,	ss.CustomerPart
	--,	coalesce(ss.CustomerPO,'')
	,	case
			when ssh.Status = 0 --(select dbo.udf_StatusValue('EDIMagnaPT.ShipScheduleHeaders', 'Status', 'New'))
				then 1
			else 0
		end
	--having coalesce(ss.CustomerPO,'') != ''
--- </Body>

---	<Return>
	return
end


GO
