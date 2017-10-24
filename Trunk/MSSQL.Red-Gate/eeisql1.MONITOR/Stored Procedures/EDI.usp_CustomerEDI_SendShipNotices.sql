SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EDI].[usp_CustomerEDI_SendShipNotices]
	@ShipperList varchar(max) = null
,	@FTPMailboxOverride int = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set ansi_nulls on

set @Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer

set @ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
set @TranDT = coalesce(@TranDT, getdate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Get the list of Ship Notices to send.*/
declare	@PendingShipNotices table
(	ShipperID int
,	FunctionName sysname
,	CompleteFlagDefault int
,	FTPMailBox int
)

if	@ShipperList > '' begin
	insert
		@PendingShipNotices
	select
		s.id
	,	xsnadrf.FunctionName
	,	xsnadrf.CompleteFlagDefault
	,	coalesce(@FTPMailboxOverride, xsnadrf.FTPMailBoxDefault)
	from
		dbo.shipper s
		join dbo.edi_setups es
			on es.destination = s.destination
		join EDI.XMLShipNotice_ASNDataRootFunction xsnadrf
			on xsnadrf.ASNOverlayGroup = es.asn_overlay_group
			and xsnadrf.Status >= 0
	where
		s.id in
			(	select
					convert(int, ltrim(rtrim(fsstr.Value)))
				from
					dbo.fn_SplitStringToRows(@ShipperList, ',') fsstr
				where
					ltrim(rtrim(fsstr.Value)) like '%[0-9]%'
					and ltrim(rtrim(fsstr.Value)) not like '%[^0-9]%'
			)
end
else begin
	insert
		@PendingShipNotices
	select
		s.id
	,	xsnadrf.FunctionName
	,	xsnadrf.CompleteFlagDefault
	,	coalesce(@FTPMailboxOverride, xsnadrf.FTPMailBoxDefault)
	from
		dbo.shipper s
		join dbo.edi_setups es
			on es.destination = s.destination
		join EDI.XMLShipNotice_ASNDataRootFunction xsnadrf
			on xsnadrf.ASNOverlayGroup = es.asn_overlay_group
			and xsnadrf.Status >= 0
			and xsnadrf.Status != 100
	where
		coalesce(s.type, 'N') = 'N'
		and s.status = 'C'
		and s.date_shipped > getdate() - 10
end

declare
	PendingShipNotices cursor local for
select
	psn.ShipperID
,	psn.FunctionName
,	psn.CompleteFlagDefault
,	psn.FTPMailBox
from
	@PendingShipNotices psn

open
	PendingShipNotices

while
	1 = 1 begin

	declare
		@shipperID int
	,	@xmlShipNotice_FunctionName sysname
	,	@completeFlagDefault int
	,	@ftpMailBox int
	,	@xmlShipNotice xml
	,	@generationBeginTime datetime
	,	@generationEndTime datetime
	,	@generationTimeSpan datetime


	fetch
		PendingShipNotices
	into
		@shipperID
	,	@xmlShipNotice_FunctionName
	,	@completeFlagDefault
	,	@ftpMailBox

	if	@@FETCH_STATUS != 0 begin
		break
	end

	select
		ShipperID = @shipperID
	,	XMLShipNotice_FunctionName = @xmlShipNotice_FunctionName

	--- <Call>
	set @generationBeginTime = getdate()	
	set	@CallProcName = 'EDI.usp_XMLShipNotice_GetShipNoticeXML'
	execute
		@ProcReturn = EDI.usp_XMLShipNotice_GetShipNoticeXML
		@ShipperID = @shipperID
	,	@XMLShipNotice_FunctionName = @xmlShipNotice_FunctionName
	,	@PurposeCode = '00'
	,	@Complete = @completeFlagDefault
	,	@xmlShipNotice = @xmlShipNotice out
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out
	
	set @Error = @@Error
	if @Error != 0 begin
		set @Result = 900501
		raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return
	end
	if @ProcReturn != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return
	end
	if @ProcResult != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return
	end
	set @generationEndTime = getdate()	
	set @generationTimeSpan = @generationEndTime - @generationBeginTime

	--- </Call>

	--select
	--	XMLData = @xmlShipNotice
	--,	ShipperID = @shipperID

	/*	Generate file for each Ship Notice.*/
	declare
		@xmlData varbinary(max)

	set @xmlData = convert(varbinary(max), @xmlShipNotice)

	--- <Call>
	set @CallProcName = 'FS.usp_XMLShipNotice_CreateOutboundFile'
	execute
		@ProcReturn = EEISQL2.FxEDI.FS.usp_XMLShipNotice_CreateOutboundFile
		@XMLData = @xmlData
	,	@ShipperID = @shipperID
	,	@FTPMailBox = @ftpMailBox
	,	@FunctionName = @xmlShipNotice_FunctionName
	,	@FileGenerationTime = @generationTimeSpan
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out
	
	set @Error = @@Error
	if @Error != 0 begin
		set @Result = 900501
		raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if @ProcReturn != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if @ProcResult != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
	
end

/*	Send EDI to the production mailbox. */
if	exists
	(	select
			*
		from
			@PendingShipNotices psn
		where
			psn.FTPMailBox = 1
	) begin

	--- <Call>	
	set @CallProcName = 'FxEDI.FTP.usp_SendCustomerEDI'
	execute
		@ProcReturn = EEISQL2.FxEDI.FTP.usp_SendCustomerEDI
	--	@SendFileFromFolderRoot = '\RawEDIData\CustomerEDI\OutBound'
	--,	@SendFileNamePattern = '%[0-9][0-9][0-9][0-9][0-9].xml'
	--,
		@TranDT = @TranDT out
	,	@Result = @ProcResult out

	set @Error = @@Error
	if	@Error != 0 begin
		set @Result = 900501
		raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		return
	end
	if	@ProcReturn != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		return
	end
	if	@ProcResult != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		return
	end
	--- </Call>
end

/*	Send EDI to the test mailbox. */
if	exists
	(	select
			*
		from
			@PendingShipNotices psn
		where
			psn.FTPMailBox = 0
	) begin

	--- <Call>	
	set @CallProcName = 'FxEDI.FTP.usp_SendCustomerEDI_TestMailBox'
	execute
		@ProcReturn = EEISQL2.FxEDI.FTP.usp_SendCustomerEDI_TestMailBox
	--	@SendFileFromFolderRoot sysname = '\RawEDIData\CustomerEDI_TestMailBox\OutBound'
	--,	@SendFileNamePattern sysname = '%[0-9][0-9][0-9][0-9][0-9].xml'
	--,
		@TranDT = @TranDT out
	,	@Result = @ProcResult out

	set @Error = @@Error
	if	@Error != 0 begin
		set @Result = 900501
		raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		return
	end
	if	@ProcReturn != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		return
	end
	if	@ProcResult != 0 begin
		set @Result = 900502
		raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		return
	end
	--- </Call>
end

/*	Mark shippers to production mailbox as EDI Sent. */
--- <Update rows="*">
set @TableName = 'dbo.shipper'

update
	s
set	
	s.status = 'Z'
from
	dbo.shipper s
	join @PendingShipNotices psn
		on psn.ShipperID = s.id
		and psn.FTPMailBox = 1 -- Only ASNs sent to the production mailbox get marked as sent.
where
	coalesce(@ShipperList, '') = '' -- Don't update shipper status when we're testing for a specific set of shippers.

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set @Result = 999999
	raiserror ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
--- </Body>

--	<Return>
set @Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@shipperList varchar(max) = '99622'

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI.usp_CustomerEDI_SendShipNotices
	@ShipperList = @shipperList
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	EEISQL2.FxEDI.FTP.LogDetails fld
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/




GO
