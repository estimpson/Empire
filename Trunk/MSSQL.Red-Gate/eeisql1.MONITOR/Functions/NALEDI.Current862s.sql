SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [NALEDI].[Current862s]
()
returns @CurrentSS table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	CustomerPart varchar(50)
--,	CustomerPO varchar(50)
,	NewDocument int
)
as
begin
--- <Body>
	insert
		@CurrentSS
	select distinct
		RawDocumentGUID = ssh.RawDocumentGUID
	,	ShipToCode = ss.ShipToCode
	,	ShipFromCode = coalesce(ss.ShipFromCode,'')
	,	CustomerPart = ss.CustomerPart
	--,	CustomerPO = coalesce(ss.CustomerPO,'')
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
				(	
					  convert(char(20), ssh.DocumentDT, 120)
					+ convert(char(10), ss.ReleaseNo)
					+ convert(char(10), ssh.DocNumber)
					+ convert(char(10), ssh.ControlNumber)
					+ convert(char(20), ssh.DocumentImportDT, 120)
				)
			from
				EDI.NAL_862_Headers ssh
		join EDI.NAL_862_Releases ss
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
		join EDI.NAL_862_Headers ssh
			join EDI.NAL_862_Releases ss
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
--- </Body>

---	<Return>
	return
end


GO
