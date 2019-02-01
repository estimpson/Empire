SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [EEIUser].[acctg_csm_sp_rollforward_header_GC]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
,	@PriorRelease char(7)
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
-- Roll forward all data for CSM, Empire Adjusted and Empire Factor into the current release
declare @Region varchar(50)
set @Region = 'Greater China'

--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_header'	
insert into
	eeiuser.acctg_csm_NAIHS_header
	(
		Release_ID
	,	[Version]
	,	[Core Nameplate Region Mnemonic]
	,	[Core Nameplate Plant Mnemonic]
	,	[Mnemonic-Vehicle]
	,	[Mnemonic-Vehicle/Plant]
	,	[Mnemonic-Platform]
	,	Region
	,	Market
	,	Country
	,	Plant
	,	City
	,	[Plant State/Province]
	,	[Source Plant]
	,	[Source Plant Country]
	,	[Source Plant Region]
	,	[Design Parent]
	,	[Engineering Group]
	,	[Manufacturing Group]
	,	Manufacturer
	,	[Sales Parent]
	,	Brand
	,	[Platform Design Owner]
	,	Architecture
	,	Platform
	,	Program
	,	Nameplate
	,	SOP
	,	EOP
	,	[Lifecycle (Time)]
	,	Vehicle
	,	[Assembly Type]
	,	[Strategic Group]
	,	[Sales Group]
	,	[Global Nameplate]
	,	[Primary Design Center]
	,	[Primary Design Country]
	,	[Primary Design Region]
	,	[Secondary Design Center]
	,	[Secondary Design Country]
	,	[Secondary Design Region]
	,	[GVW Rating]
	,	[GVW Class]
	,	[Car/Truck]
	,	[Production Type]
	,	[Global Production Segment]
	,	[Regional Sales Segment]
	,	[Global Production Price Class]
	,	[Global Sales Segment]
	,	[Global Sales Sub-Segment]
	,	[Global Sales Price Class]
	,	[Short Term Risk Rating]
	,	[Long Term Risk Rating]
	)
select
	@CurrentRelease
,	c.[Version]
,	c.[Core Nameplate Region Mnemonic]
,	c.[Core Nameplate Plant Mnemonic]
,	c.[Mnemonic-Vehicle]
,	c.[Mnemonic-Vehicle/Plant]
,	c.[Mnemonic-Platform]
,   c.Region
,   c.Market
,   c.Country
,   c.Plant
,   c.City
,   c.[Plant State/Province]
,   c.[Source Plant]
,   c.[Source Plant Country]
,   c.[Source Plant Region]
,   c.[Design Parent]
,   c.[Engineering Group]
,   c.[Manufacturing Group]
,   c.Manufacturer
,   c.[Sales Parent]
,   c.Brand
,   c.[Platform Design Owner]
,   c.Architecture
,   c.[Platform]
,   c.Program
,   c.Nameplate
,   c.SOP
,   c.EOP
,   c.[Lifecycle (Time)]
,   c.Vehicle
,   c.[Assembly Type]
,   c.[Strategic Group]
,   c.[Sales Group]
,   c.[Global Nameplate]
,   c.[Primary Design Center]
,   c.[Primary Design Country]
,   c.[Primary Design Region]
,   c.[Secondary Design Center]
,   c.[Secondary Design Country]
,   c.[Secondary Design Region]
,   c.[GVW Rating]
,   c.[GVW Class]
,   c.[Car/Truck]
,   c.[Production Type]
,   c.[Global Production Segment]
,   c.[Regional Sales Segment]
,   c.[Global Production Price Class]
,   c.[Global Sales Segment]
,   c.[Global Sales Sub-Segment]
,   c.[Global Sales Price Class]
,   c.[Short Term Risk Rating]
,   c.[Long Term Risk Rating]
from
	eeiuser.acctg_csm_NAIHS c
where
	c.Release_ID = @PriorRelease
	and c.Region = @Region


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
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
