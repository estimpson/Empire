SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FxPVQ].[usp_PVQ_FileManagement_Get]
	@QuoteNumber varchar(50)
,	@AttachmentCategory varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()

declare
	@initialtrancount int = @@trancount
if	@initialtrancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName


---<Body>
declare
	@ProcReturn integer
--,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

-- Populate parameters for the 'get' procecure
declare
	@FileName sysname
,	@NewPathLocator hierarchyid
,	@NewStreamID uniqueidentifier

select
	@FileName = fm.[FileName]
,	@NewPathLocator = fm.PathLocator
from
	FxPVQ.PVQ_FileManagement fm
where
	fm.PartVendorQuoteNumber= @QuoteNumber
	and fm.AttachmentCategory = @AttachmentCategory

-- Get the file
execute
	@ProcReturn = EEIUser.usp_Quoting_GetAttachment
	@QuoteNumber = @QuoteNumber
,	@AttachmentCategory = @AttachmentCategory
,	@FileName = @FileName
,	@PathLocator = @NewPathLocator
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

/*	Model of result for Entity Framework. */
if	@Result is null begin
	select
		StreamID = newid()
	,	FileContents = convert(varbinary(max), '')
	,	FileName = convert(sysname, '')
	,	PathLocator = convert(varbinary(max), '')
	where
		1 = 0
end
--select
--	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator, [@NewStreamID] = @NewStreamID

if (@Error <> 0) begin
	set @Result = -1
	raiserror ('Failed to retrieve the file.  Procedure %s.', 16, 1, @ProcName)
	rollback transaction @ProcName
	return
end
---</Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  
GO
