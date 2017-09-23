SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_import_CSM_Delta]
	@Release_ID char(7) -- eg. '2012-04'
,	@Version varchar(30) = 'CSM'
,	@Manufacturer varchar(255)
,	@Platform varchar(255)
,	@Program varchar(255)
,	@Nameplate varchar(255)
,	@BodyStyle varchar(255)
,	@Plant varchar(255)
,	@NewTiming varchar(255)
,	@PriorTiming varchar(255)
,	@Action varchar(255)
,	@MnemonicVehicle varchar(30)
,	@CoreNameplatePlantMnemonic varchar(30)
,	@CoreNameplateRegionMnemonic varchar(30)
,	@Notes varchar(3000)
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

---	</ArgumentValidation>


--- <Body>  
--- <Insert rows="1">
set	@TableName = 'MONITOR.eeiuser.acctg_csm_NAIHS_Delta'
insert
	MONITOR.eeiuser.acctg_csm_NAIHS_Delta
(	[Release_ID]
,	[Version]
,	Manufacturer
,	[Platform]
,	Program
,	Nameplate
,	[Body Style]
,	Plant
,	[New timing]
,	[Prior Timing]
,	[Action]
,	[Mnemonic-Vehicle]
,	[Core Nameplate Plant Mnemonic]
,	[Core Nameplate Region Mnemonic]
,	Notes
)
select
	@Release_ID
,	@Version
,	@Manufacturer
,	@Platform
,	@Program
,	@Nameplate
,	@BodyStyle
,	@Plant
,	@NewTiming
,	@PriorTiming
,	@Action
,	@MnemonicVehicle
,	@CoreNameplatePlantMnemonic
,	@CoreNameplateRegionMnemonic
,	@Notes

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert rows="1">
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
