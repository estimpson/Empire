SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Customer_Insert]
	@OperatorCode varchar(5)
,	@CustomerCode varchar(20)
,	@CustomerName varchar(100)
,	@Address1 varchar(250)
,	@Address2 varchar(250)
,	@Address3 varchar(250)
,	@City varchar(250)
,	@State varchar(250)
,	@Country varchar(50)
,	@PostalCode varchar(250)
,	@Terms varchar(100)
,	@LtaType varchar(50)
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

--- The customer does not exist
if exists ( 
		select
			1
		from
			EEIUser.QT_CustomersNew c
		where
			c.CustomerCode = @CustomerCode
			and c.[Status] > -1 ) begin
		
	set @Result = -1
	raiserror ('Customer %s already exists.', 16, 1, @CustomerCode)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>



--- <Body>
--- <Insert Rows="1">
set	@TableName = 'EEIUser.QT_CustomersNew'
insert EEIUser.QT_CustomersNew
(
	CustomerCode
,	CustomerName
,	Address1
,	Address2
,	Address3
,	City
,	[State]
,	Country
,	PostalCode
,	Terms
,	LtaType
,	RowCreateDT
,	RowCreateUser
,	RowModifiedDT
,	RowModifiedUser
)
select
	@CustomerCode
,	@CustomerName
,	@Address1
,	@Address2
,	@Address3
,	@City
,	@State
,	@Country
,	@PostalCode
,	@Terms
,	@LtaType
,	@TranDT
,	@OperatorCode
,	@TranDT
,	@OperatorCode

select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Insert Rows>
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
