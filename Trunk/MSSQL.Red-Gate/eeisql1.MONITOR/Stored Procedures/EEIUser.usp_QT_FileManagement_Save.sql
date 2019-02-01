SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_QT_FileManagement_Save]
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

--declare
--	@initialtrancount int = @@trancount
--if	@initialtrancount > 0
--	save transaction @ProcName
--else
--	begin transaction @ProcName


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
	rollback transaction @ProcName
	return
end


-- Clear information related to the last file saved for this category (if one exists)
if exists (
		select
			1
		from
			eeiuser.QT_FileManagement
		where
			QuoteNumber = @QuoteNumber
			and AttachmentCategory = @AttachmentCategory ) begin

	--- <Delete Rows="1">
	set	@TableName = 'EEIUser.QT_FileManagement'
	delete from 
		eeiuser.QT_FileManagement
	where
		QuoteNumber = @QuoteNumber
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
set	@TableName = 'EEIUser.QT_FileManagement'
insert eeiuser.QT_FileManagement
(
	QuoteNumber
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


-- Update the Quote Log quote with the file name
if (@AttachmentCategory = 'QuotePrint') begin

	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLog'

	update
		eeiuser.QT_QuoteLog
	set
		FileServerQuotePrint = @FileName
	where
		QuoteNumber = @QuoteNumber

	select
		@RowCount = @@Rowcount
				
	if	(@RowCount <> 1) begin
		set @Result = -2
		raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback transaction @ProcName
		return
	end
	 --- </Update Rows>

end
else begin

	--- <Update Rows="1">
	set	@TableName = 'EEIUser.QT_QuoteLog'

	update
		eeiuser.QT_QuoteLog
	set
		FileServerCustomerQuote = @FileName
	where
		QuoteNumber = @QuoteNumber

	select
		@RowCount = @@Rowcount
				
	if	(@RowCount <> 1) begin
		set @Result = -2
		raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback transaction @ProcName
		return
	end
	 --- </Update Rows>

end


---</Body>	


--if @initialtrancount = 0  
--    commit transaction @ProcName;   
GO
