SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FxPVQ].[usp_PVQ_FileManagement_Save]
	@QuoteNumber varchar(50)
,	@AttachmentCategory varchar(50)
,	@FileName sysname
,	@FileContents varbinary(max)
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
	@rowId int
set 
	@rowId = convert(int, replace(@QuoteNumber, 'PVQ_', '')) 

---	<ArgumentValidation>
/*  PartVendorQuote record exists.  */
if not exists (
		select
			*
		from
			FxPVQ.PartVendorQuotes pvq
		where
			pvq.RowID = @rowID ) begin
				
	--set @Result = -1
	raiserror ('PartVendorQuote record does not exist.  Procedure %s.', 16, 1, @ProcName)
	return
end
---	</ArgumentValidation>

---<Body>
declare
	@ProcReturn integer
--,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

declare
--	@QuoteNumber varchar(50) = '525-07'
--,	@AttachmentCategory varchar(50) = 'CustomerQuote'
--,	@FileName sysname = 'test.txt'
--,	@FileContents varbinary(max) = convert(varbinary(max), 'Testing 1...2...3...4!!!')
	@NewPathLocator hierarchyid
,	@NewStreamID uniqueidentifier


-- Save the file
execute
	@ProcReturn = EEIUser.usp_Quoting_SaveAttachment
	@QuoteNumber = @QuoteNumber
,	@AttachmentCategory = @AttachmentCategory
,	@FileName = @FileName
,	@FileContents = @FileContents
,	@NewPathLocator = @NewPathLocator out
,	@NewStreamID = @NewStreamID out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error


--select
--	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator, [@NewStreamID] = @NewStreamID

if (@Error <> 0) begin
	set @Result = -1
	raiserror ('Failed to save the file.  Procedure %s.', 16, 1, @ProcName)
	return
end

--declare
--	@initialtrancount int = @@trancount
--if	@initialtrancount > 0
--	save transaction @ProcName
--else
--	begin transaction @ProcName

-- Clear information related to the last file saved for this category (if one exists)
if exists (
		select
			1
		from
			FxPVQ.PVQ_FileManagement
		where
			PartVendorQuoteNumber = @QuoteNumber
			and AttachmentCategory = @AttachmentCategory ) begin

	--- <Delete Rows="1">
	set	@TableName = 'FxPVQ.PVQ_FileManagement'
	delete from 
		FxPVQ.PVQ_FileManagement
	where
		PartVendorQuoteNumber = @QuoteNumber
		and AttachmentCategory = @AttachmentCategory

	select
		@RowCount = @@Rowcount
				
	if	(@RowCount <> 1) begin
		set @Result = -2
		raiserror ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback transaction @ProcName
		return
	end
	--- </Delete Rows>
end


-- Store additional information related to the attached file 
--- <Insert Rows="1">
set	@TableName = 'FxPVQ.PVQ_FileManagement'
insert FxPVQ.PVQ_FileManagement
(
	PartVendorQuoteNumber
,	AttachmentCategory
,	[FileName]
,	PathLocator
,	StreamID
)
values
(
	@QuoteNumber
,	@AttachmentCategory
,	@FileName
,	@NewPathLocator
,	@NewStreamID
)

select
	@RowCount = @@Rowcount
				
if	(@RowCount <> 1) begin
	set @Result = -2
	raiserror ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Insert Rows>


-- Update PartVendorQuotes with the file name
--- <Update Rows="1">
set	@TableName = 'FxPVQ.PartVendorQuotes'

update
	FxPVQ.PartVendorQuotes
set
	QuoteFileName = @FileName
where
	RowID = @rowId

select
	@RowCount = @@Rowcount
				
if	(@RowCount <> 1) begin
	set @Result = -2
	raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
	--- </Update Rows>
---</Body>	


--if @initialtrancount = 0  
--    commit transaction @ProcName;   
GO
