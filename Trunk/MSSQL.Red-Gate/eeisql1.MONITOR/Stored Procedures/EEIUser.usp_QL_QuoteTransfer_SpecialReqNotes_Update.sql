SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_SpecialReqNotes_Update]
	@OperatorCode varchar(5)
,	@Id int
,	@Answer varchar(10)
,	@Notes varchar(1000)
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
	@trancount int = @@trancount
if	@trancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName


---	<ArgumentValidation>
--- Operator is valid
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode ) begin

	set @Result = -1
	raiserror ('Invalid operator.', 16, 1)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
--- <Update Rows="1">
set	@TableName = 'EEIUser.QL_QuoteTransfer_SpecialReqNotes'
update 
	EEIUser.QL_QuoteTransfer_SpecialReqNotes
set
	Answer = @Answer
,	Notes = @Notes
,	RowModifiedUser = @OperatorCode
where
	RowID = @Id

select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Update Rows>
--- </Body>


if @trancount = 0  
    commit transaction @ProcName;  
GO
