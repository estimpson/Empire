SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_check_datecolumns]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
,	@Message varchar(500) out
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>


---	<ArgumentValidation>
if not exists (
		select
			*
		from
			dbo.employee e
		where	
			e.operator_code = @OperatorCode ) begin

	set	@Result = 999999
	RAISERROR ('Invalid operator code.  Procedure %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
-- If this is the first month of a new year, add new date columns to the underlying warehouse (legacy) table
declare 
	@maxYear char(4)
,	@colName char(8)

select @maxYear = convert(char(4), year(getdate()) + 2) 
set @colName = 'Jan ' + @maxYear

-- If new date columns are not found within the spreadsheet data, no need to proceed 
if not exists ( 
		select 
			1 
		from 
			sys.columns 
		where 
			Name = @colName --N'columnName'
			and Object_ID = Object_ID(N'dbo.tempCSM') ) begin
			
	rollback tran @ProcName
	return	@Result
end

-- New date columns exist in the spreadsheet, so if they are not already in the pivoted warehouse table, 
--  add them and notify the user that other database changes may be required
if not exists (
		select 
			1 
		from 
			sys.columns 
		where 
			Name = @colName --N'columnName'
			and Object_ID = Object_ID(N'eeiuser.acctg_csm_NAIHS') ) begin

	begin try
		-- Max year in the spreadsheet data was not found in the pivoted warehouse table, so add new month/year columns 
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Jan ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Feb ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Mar ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Apr ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [May ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Jun ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Jul ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Aug ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Sep ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Oct ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Nov ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Dec ' + @maxYear + '] decimal(10,2) null')

		-- Reset the max year and add new columns for future quarters and future calculated year
		select @maxYear = convert(char(4), year(getdate()) + 7)

		exec ('alter table eeiuser.acctg_csm_NAIHS add [Q1 ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Q2 ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Q3 ' + @maxYear + '] decimal(10,2) null')
		exec ('alter table eeiuser.acctg_csm_NAIHS add [Q4 ' + @maxYear + '] decimal(10,2) null')

		exec ('alter table eeiuser.acctg_csm_NAIHS add [CY ' + @maxYear + '] decimal(10,2) null')

		set @Message = 'New date columns found in the CSM spreadsheet. Have all related database tables and stored procedures been updated? And has the trigger on the CSM detail table been updated?'

	end try
	begin catch
		declare @errMsg nvarchar(4000)
		select @errMsg = error_message()  

		set	@Result = 900499
		RAISERROR ('Error encountered in %s.  Error: %s', 16, 1, @ProcName, @errMsg)
		rollback tran @ProcName
		return	@Result
	end catch

end
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
