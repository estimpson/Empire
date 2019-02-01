SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_insert_header]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
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
-- Insert CSM data from the spreadsheet for the current release
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_header'	
insert into eeiuser.acctg_csm_NAIHS_header
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
,	'CSM'
,	t.[Core Nameplate Region Mnemonic]
,	t.[Core Nameplate Plant Mnemonic]
,	t.[Mnemonic-Vehicle]
,	t.[Mnemonic-Vehicle/Plant]
,	t.[Mnemonic-Platform]
,   t.Region
,   t.Market
,   t.Country
,   t.[Production Plant]
,   t.City
,   t.[Plant State/Province]
,   t.[Source Plant]
,   t.[Source Plant Country]
,   t.[Source Plant Region]
,   t.[Design Parent]
,   t.[Engineering Group]
,   t.[Manufacturer Group]
,   t.Manufacturer
,   t.[Sales Parent]
,   t.[Production Brand]
,   t.[Platform Design Owner]
,   t.Architecture
,   t.[Platform]
,   t.Program
,   t.[Production Nameplate]
,   [SOP] = convert(datetime, t.[SOP (Start of Production)] + '-01')
,   [EOP] = convert(datetime, t.[EOP (End of Production)] + '-01')
,   t.[Lifecycle (Time)]
,   t.Vehicle
,   t.[Assembly Type]
,   t.[Strategic Group]
,   t.[Sales Group]
,   t.[Global Nameplate]
,   t.[Primary Design Center]
,   t.[Primary Design Country]
,   t.[Primary Design Region]
,   t.[Secondary Design Center]
,   t.[Secondary Design Country]
,   t.[Secondary Design Region]
,   t.[GVW Rating]
,   t.[GVW Class]
,   t.[Car/Truck]
,   t.[Production Type]
,   t.[Global Production Segment]
,   t.[Regional Sales Segment]
,   t.[Global Production Price Class]
,   t.[Global Sales Segment]
,   t.[Global Sales Sub-Segment]
,   t.[Global Sales Price Class]
,   t.[Short-Term Risk Rating]
,   t.[Long-Term Risk Rating]
from
	dbo.tempCSM t
where
	not exists
		(	select
				*
			from
				eeiuser.acctg_csm_NAIHS_header h
			where
				h.Release_ID = @CurrentRelease
				and h.Version = 'CSM'
				and h.[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]
		)
--- </Insert>


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
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
