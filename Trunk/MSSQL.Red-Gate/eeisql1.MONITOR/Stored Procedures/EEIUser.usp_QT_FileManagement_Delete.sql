SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_QT_FileManagement_Delete]
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

declare
--	@QuoteNumber varchar(50) = '525-07'
--,	@AttachmentCategory varchar(50) = 'CustomerQuote'
	@FileName sysname
--,	@FileContents varbinary(max) = convert(varbinary(max), 'Testing 1...2...3...4!!!')
,	@NewPathLocator hierarchyid
,	@NewStreamID uniqueidentifier = null

select
	@FileName = fm.[FileName]
,	@NewPathLocator = fm.PathLocator
from
	eeiuser.QT_FileManagement fm
where
	fm.QuoteNumber= @QuoteNumber
	and fm.AttachmentCategory = @AttachmentCategory


-- Delete the file
execute
	@ProcReturn = EEIUser.usp_Quoting_DeleteAttachment
	@QuoteNumber = @QuoteNumber
,	@AttachmentCategory = @AttachmentCategory
,	@FileName = @FileName
,	@PathLocator = @NewPathLocator
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator, [@NewStreamID] = @NewStreamID

if (@Error <> 0) begin
	set @Result = -1
	raiserror ('Failed to delete the file.  Procedure %s.', 16, 1, @ProcName)
	rollback transaction @ProcName
	return
end


-- Delete information related to the attached file 
--- <Delete Rows="1">
set	@TableName = 'EEIUser.QT_FileManagement'
delete from 
	eeiuser.QT_FileManagement
where
	QuoteNumber = @QuoteNumber
	and AttachmentCategory = @AttachmentCategory
	and [FileName] = @FileName

select
	@RowCount = @@Rowcount
				
if	(@RowCount <> 1) begin
	set @Result = -2
	raiserror ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Delete Rows>
---</Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  
GO
