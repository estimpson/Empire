SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_CreateRma_Honduras]
	@OperatorCode varchar(5)
,	@RtvShipper integer
,	@LocationCode varchar(25)
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

set	@TranDT = coalesce(@TranDT, GetDate())

---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
/*  Create the Honduras RMA  */
--- <Call>	
set	@CallProcName = 'eeh.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation_GlSegment'
execute @ProcReturn = eehsql1.EEH.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation_GlSegment
	@OperatorPWD = '5555'
,	@ShipperID = @RtvShipper
,	@LocationCode = @LocationCode
,	@Result = @Result out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900503
	--raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return
end
if	@ProcReturn != 0 begin
	set	@Result = 900504
	--raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return
end
---</Call>
--- </Body>


---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
