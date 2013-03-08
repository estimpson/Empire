USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_InsertQuoteCSM]    Script Date: 03/04/2013 11:19:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [EEIUser].[usp_QT_InsertQuoteCSM]
	@QuoteNumber varchar(50)
,	@CSM_Mnemonic varchar(30)
,	@Version varchar(30) = null
,	@Release_ID char(7) = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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

---	</ArgumentValidation>

--- <Body>
--- <Insert rows="1">
set	@TableName = 'EEIUser.QT_QuoteCSM'

insert
	EEIUser.QT_QuoteCSM
(	QuoteNumber
,	CSM_Mnemonic
,	Version
,	Release_ID
,	Manufacturer
,	Platform
,	Program
,	Nameplate
)
select
	QuoteNumber = @QuoteNumber
,	CSM_Mnemonic = @CSM_Mnemonic
,	Version = @Version
,	Release_ID = @Release_ID
,	Manufacturer = csmm.Manufacturer
,	Platform = csmm.Platform
,	Program = csmm.Program
,	Nameplate = csmm.Nameplate
from
	EEIUser.QT_CSM_Mnemonics csmm
where
	csmm.[Mnemonic-Vehicle/Plant] = @CSM_Mnemonic
--	and csmm.Version = @Version
--	and csmm.Release_ID = @Release_ID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999998
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>

--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
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
	@User varchar(10)
,	@CycleCountNumber varchar(50)
,	@Serial int = null

set	@User = 'mon'
set	@CycleCountNumber = '0'
set	@Serial = '0'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_InventoryControl_CycleCount_RecoverObject
	@User = @User
,	@CycleCountNumber = @CycleCountNumber
,	@Serial = @Serial
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
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

