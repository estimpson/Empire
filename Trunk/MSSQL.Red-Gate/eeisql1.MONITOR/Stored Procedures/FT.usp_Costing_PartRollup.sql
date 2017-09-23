SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_Costing_PartRollup]
	@PartCode varchar(max) = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

/* This procedure is the same as [FT].[usp_Costing_GlobalRollup] except that it comments out the clause "or @partcode = Null" in order to prevent accidentally initiating the global rollup of all parts if the @partcode where not passed to the stored procedure  */
/* Please copy any changes made to this procedure to [FT].[usp_Costing_GlobalRollup] */

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
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
/*	Make sure XRt is up to date. */
if	@PartCode is not null begin

/*		Incremental update of XRt. */
	--- <Call>
	set	@CallProcName = 'FT.ftsp_IncUpdXRt'
	execute
		@ProcReturn = FT.ftsp_IncUpdXRt 

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
end
else begin
/*		Rebuild of XRt. */
	--- <Call>	
	set	@CallProcName = 'FT.ftsp_RebuildXRt'
	execute
		@ProcReturn = FT.ftsp_RebuildXRt 
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
end
	
--- <Update rows="*">
set	@TableName = 'dbo.part_standard'

update
	ps
set cost = vpsa.Cost
,	material = vpsa.Material
,	labor = vpsa.Labor
,	burden = vpsa.Burden
,	cost_cum = vpsa.CostAccum
,	material_cum = vpsa.MaterialAccum
,	labor_cum = vpsa.LaborAccum
,	burden_cum = vpsa.BurdenAccum
,	cost_changed_date = getdate()
from
	dbo.part_standard ps
	join dbo.vwPartStandardAccum vpsa
		on vpsa.Part = ps.part
where
	ps.part in
	(	select
			xr.ChildPart
		from
			FT.XRt xr
		where
			xr.TopPart in
				(	select
						ltrim(usstr.Value)
					from
						dbo.fn_SplitStringToRows(@PartCode, ',') usstr
				)
	)
/*	2013-07-29 Commented out to pokeyoke procedure from accidentally initiating a global rollup */
--	or @PartCode is null

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
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
	@PartCode varchar(25) = null

set	@PartCode = 'HEL0081-HA00'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_PartRollup
	@PartCode = @PartCode
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
