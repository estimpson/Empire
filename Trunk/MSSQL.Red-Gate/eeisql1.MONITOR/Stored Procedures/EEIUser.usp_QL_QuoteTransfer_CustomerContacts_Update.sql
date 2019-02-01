SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_CustomerContacts_Update]
	@OperatorCode varchar(5)
,	@Id int
,	@FirstName varchar(50)
,	@LastName varchar(50)
,	@PhoneNumber varchar(20)
,	@FaxNumber varchar(20)
,	@EmailAddress varchar(320)
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
set	@TableName = 'EEIUser.QL_QuoteTransfer_CustomerContacts'
update
	EEIUser.QL_QuoteTransfer_CustomerContacts
set
	FirstName = @FirstName
,	LastName = @LastName
,	PhoneNumber = @PhoneNumber
,	FaxNumber = @FaxNumber
,	EmailAddress = @EmailAddress
,	RowModifiedUser = @OperatorCode
where
	RowID = @Id

select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 4.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Update Rows>
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  


GO
