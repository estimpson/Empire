SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_roll_forward_EmpireForecast_data_one_year_fall_off] 
	@prior_release_id varchar(10)
,	@current_release_id varchar(10)
,	@TranDT datetime = null out
,	@Result integer = null out
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


--<Body>
-- Copy two years prior CSM data from prior month to current month
-- (CSM data one year older than the current year falls off)

--- <Update rows="1+">
set	@TableName = 'EEIUser.eeiuser.acctg_csm_naihs'
update
	acnCurrentRelease
set	[Jan 2016] = acnPriorRelease.[Jan 2016]
  ,	[Feb 2016] = acnPriorRelease.[Feb 2016]
  ,	[Mar 2016] = acnPriorRelease.[Mar 2016]
  ,	[Apr 2016] = acnPriorRelease.[Apr 2016]
  ,	[May 2016] = acnPriorRelease.[May 2016]
  ,	[Jun 2016] = acnPriorRelease.[Jun 2016]
  ,	[Jul 2016] = acnPriorRelease.[Jul 2016]
  ,	[Aug 2016] = acnPriorRelease.[Aug 2016]
  ,	[Sep 2016] = acnPriorRelease.[Sep 2016]
  ,	[Oct 2016] = acnPriorRelease.[Oct 2016]
  ,	[Nov 2016] = acnPriorRelease.[Nov 2016]
  ,	[Dec 2016] = acnPriorRelease.[Dec 2016]
  ,	[Q1 2016]  = acnPriorRelease.[Q1 2016]
  ,	[Q2 2016]  = acnPriorRelease.[Q2 2016]
  ,	[Q3 2016]  = acnPriorRelease.[Q3 2016]
  ,	[Q4 2016]  = acnPriorRelease.[Q4 2016]
  ,	[CY 2016]  = acnPriorRelease.[CY 2016]
from
	EEIUser.acctg_csm_NAIHS acnCurrentRelease
	join EEIUser.acctg_csm_NAIHS acnPriorRelease
		on acnPriorRelease.Release_ID = @prior_release_id
			and acnPriorRelease.Version = 'CSM'
			and acnPriorRelease.[Mnemonic-Vehicle/Plant] = acnCurrentRelease.[Mnemonic-Vehicle/Plant]
where
	acnCurrentRelease.Release_ID = @current_release_id
	and acnCurrentRelease.Version = 'CSM'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating 2016 CSM in table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error updateing 2016 CSM in table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>
--</Body>


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
