SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_rollforward_base_part_attributes]
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
-- Roll forward existing data into the current release
--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_base_part_attributes'
insert into 
	eeiuser.acctg_csm_base_part_attributes
(		
	[release_id]
,	[base_part]
,	[family]
,	[customer]
,	[parent_customer]
,	[product_line]
,	[empire_market_segment]
,	[empire_market_subsegment]
,	[empire_application]
,	[empire_sop]
,	[empire_eop]
,	[include_in_forecast]
,	[Salesperson]
,	[date_of_award]
,	[type_of_award]
,	[mid_model_year]
,	[empire_eop_note]
,	[verified_eop]
,	[verified_eop_date]
)
select 
	@CurrentRelease
,	a.[base_part]
,	a.[family]
,	a.[customer]
,	a.[parent_customer]
,	a.[product_line]
,	a.[empire_market_segment]
,	a.[empire_market_subsegment]
,	a.[empire_application]
,	a.[empire_sop]
,	a.[empire_eop]
,	a.[include_in_forecast]
,	a.[Salesperson]
,	a.[date_of_award]
,	a.[type_of_award]
,	a.[mid_model_year]
,	a.[empire_eop_note]
,	a.[verified_eop]
,	a.[verified_eop_date]
from
	EEIUser.acctg_csm_base_part_attributes a
where	
	a.release_id = @PriorRelease


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
