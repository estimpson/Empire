SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_ST_Csm_SalesForecast]
	@ParentCustomer varchar(50)
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
select
	isnull(acn.Release_ID, 9999) as Release_ID
,	acn.Version
,	acn.[Mnemonic-Vehicle] as MnemonicVehicle
,	acn.[Mnemonic-Vehicle/Plant] as MnemonicVehiclePlant
,	f.base_part as BasePart
,	acn.Platform
,	f.empire_application as Application
,	acn.Program
,	f.vehicle as Vehicle
,	f.parent_customer as ParentCustomer
,	f.empire_market_subsegment as MarketSubSegment
,	f.status as Status
,	convert(varchar(10), acn.SOP, 101) as SOP
,	convert(varchar(10), acn.EOP, 101) as EOP
--,	f.customer
--,	acn.Nameplate
--,	f.empire_market_segment
--,	f.program as sf_program
--,	acn.[Mnemonic-Platform] as MnemonicPlatform
--,	f.sop as sf_sop
--,	f.eop as sf_eop
--,	f.product_line
--,	f.assembly_plant
--,	f.award_category
from 
	EEIUser.acctg_csm_NAIHS acn 
	join EEIUser.acctg_csm_vw_select_sales_forecast f
		on f.mnemonic = acn.[Mnemonic-Vehicle/Plant]
where
	f.parent_customer = @ParentCustomer
	and f.status in ('Pre-Launch', 'Launch')
order by
	Release_ID
,	MnemonicVehiclePlant
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
