SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_SignOff_Insert]
	@OperatorCode varchar(5)
,	@QuoteNumber varchar(50)
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

--- Do not attempt to insert more than once for this quote
if exists (
		select
			1
		from
			EEIUser.QL_QuoteTransfer_SignOff so
		where
			so.QuoteNumber = @QuoteNumber ) begin

	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
--- <Insert Rows="4">
set	@TableName = 'EEIUser.QL_QuoteTransfer_SignOff'
insert 
	EEIUser.QL_QuoteTransfer_SignOff
(
	QuoteNumber
,	Title
,	RowCreateUser
,	RowModifiedUser
)
values
	(@QuoteNumber, 'Quote Engineer', @OperatorCode, @OperatorCode)
,	(@QuoteNumber, 'Material Representative', @OperatorCode, @OperatorCode)
,	(@QuoteNumber, 'PEM', @OperatorCode, @OperatorCode)
,	(@QuoteNumber, 'Product Engineer', @OperatorCode, @OperatorCode)

select
	@RowCount = @@Rowcount
				
if	@RowCount != 4 begin
	set @Result = -2
	raiserror ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 4.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Insert Rows>
--- </Body>


if @trancount = 0  
    commit transaction @ProcName;  
GO
