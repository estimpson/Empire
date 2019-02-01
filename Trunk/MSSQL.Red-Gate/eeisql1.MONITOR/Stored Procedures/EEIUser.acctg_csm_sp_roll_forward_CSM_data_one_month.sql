SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EEIUser].[acctg_csm_sp_roll_forward_CSM_data_one_month] 
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

-- delete rollover if it fails

 -- delete from eeiuser.acctg_csm_selling_prices_tabular where release_id = '2017-03'
 -- delete from eeiuser.acctg_csm_material_cost_tabular where release_id = '2017-03'
 -- delete from eeiuser.acctg_csm_base_part_attributes where release_id = '2017-03'
 -- delete from eeiuser.acctg_csm_base_part_notes where release_id = '2017-03'
 -- delete from eeiuser.acctg_csm_naihs where release_id = '2017-03'






-- exec eeiuser.acctg_csm_sp_roll_forward_CSM_data_one_month '2017-01', '2017-02'

-- declare @prior_release_id varchar(10)
-- select @prior_release_id = '2017-01'

-- declare @current_release_id varchar(10)
-- select @current_release_id = '2017-02'


--1.  Query to import CSM data into database 

/*OBSOLETE - replaced by EEIuser.acctg_csm_sp_import_CSM_demand */

--2.  Query to copy selling prices from prior month to current month
--    Each year, need to add monthly fields and another year */

--    select * from eeiuser.acctg_csm_selling_prices_tabular where release_id = '2017-02'  

--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_selling_prices_tabular'
insert into [EEIUser].[acctg_csm_selling_prices_tabular]
(	[RELEASE_ID],
	[ROW_ID] ,
	[BASE_PART],
	[VERSION] ,
	[INCLUSION], 
	[JAN_08] ,	[FEB_08] ,	[MAR_08] ,	[APR_08] ,	[MAY_08] ,	[JUN_08] ,	[JUL_08] ,	[AUG_08] ,	[SEP_08] ,	[OCT_08] ,	[NOV_08] ,	[DEC_08],	
	[JAN_09],	[FEB_09] ,	[MAR_09] ,	[APR_09] ,	[MAY_09] ,	[JUN_09] ,	[JUL_09] ,	[AUG_09] ,	[SEP_09] ,	[OCT_09] ,	[NOV_09],	[DEC_09] ,
	[JAN_10] ,	[FEB_10] ,	[MAR_10] ,	[APR_10] ,	[MAY_10] ,	[JUN_10] ,	[JUL_10] ,	[AUG_10] ,	[SEP_10] ,	[OCT_10] ,	[NOV_10] ,	[DEC_10] ,
	[JAN_11] ,	[FEB_11] ,	[MAR_11] ,	[APR_11] ,	[MAY_11] ,	[JUN_11] ,	[JUL_11] ,	[AUG_11] ,	[SEP_11] ,	[OCT_11] ,	[NOV_11] ,	[DEC_11] ,
	[JAN_12] ,	[FEB_12] ,	[MAR_12] ,	[APR_12], 	[MAY_12] ,	[JUN_12] ,	[JUL_12] ,	[AUG_12] ,	[SEP_12] ,	[OCT_12] ,	[NOV_12] ,	[DEC_12] ,
	[JAN_13] ,	[FEB_13] ,	[MAR_13] ,	[APR_13], 	[MAY_13] ,	[JUN_13] ,	[JUL_13] ,	[AUG_13] ,	[SEP_13] ,	[OCT_13] ,	[NOV_13] ,	[DEC_13] ,
	[JAN_14] ,	[FEB_14] ,	[MAR_14] ,	[APR_14], 	[MAY_14] ,	[JUN_14] ,	[JUL_14] ,	[AUG_14] ,	[SEP_14] ,	[OCT_14] ,	[NOV_14] ,	[DEC_14] ,		
	[JAN_15] ,	[FEB_15] ,	[MAR_15] ,	[APR_15], 	[MAY_15] ,	[JUN_15] ,	[JUL_15] ,	[AUG_15] ,	[SEP_15] ,	[OCT_15] ,	[NOV_15] ,	[DEC_15] ,
	[JAN_16] ,	[FEB_16] ,	[MAR_16] ,	[APR_16], 	[MAY_16] ,	[JUN_16] ,	[JUL_16] ,	[AUG_16] ,	[SEP_16] ,	[OCT_16] ,	[NOV_16] ,	[DEC_16] ,
	[JAN_17] ,	[FEB_17] ,	[MAR_17] ,	[APR_17], 	[MAY_17] ,	[JUN_17] ,	[JUL_17] ,	[AUG_17] ,	[SEP_17] ,	[OCT_17] ,	[NOV_17] ,	[DEC_17] ,
	[JAN_18] ,	[FEB_18] ,	[MAR_18] ,	[APR_18], 	[MAY_18] ,	[JUN_18] ,	[JUL_18] ,	[AUG_18] ,	[SEP_18] ,	[OCT_18] ,	[NOV_18] ,	[DEC_18] ,
	[JAN_19] ,	[FEB_19] ,	[MAR_19] ,	[APR_19], 	[MAY_19] ,	[JUN_19] ,	[JUL_19] ,	[AUG_19] ,	[SEP_19] ,	[OCT_19] ,	[NOV_19] ,	[DEC_19] ,
    [JAN_20] ,	[FEB_20] ,	[MAR_20] ,	[APR_20], 	[MAY_20] ,	[JUN_20] ,	[JUL_20] ,	[AUG_20] ,	[SEP_20] ,	[OCT_20] ,	[NOV_20] ,	[DEC_20] ,
	[DEC_21] ,
	[DEC_22] ,
	[DEC_23] ,
	[DEC_24] ,
	[DEC_25])
select @current_release_id,
	[ROW_ID] ,
	[BASE_PART],
	[VERSION] ,
	[INCLUSION], 
	[JAN_08] ,	[FEB_08] ,	[MAR_08] ,	[APR_08] ,	[MAY_08] ,	[JUN_08] ,	[JUL_08] ,	[AUG_08] ,	[SEP_08] ,	[OCT_08] ,	[NOV_08] ,	[DEC_08],	
	[JAN_09],	[FEB_09] ,	[MAR_09] ,	[APR_09] ,	[MAY_09] ,	[JUN_09] ,	[JUL_09] ,	[AUG_09] ,	[SEP_09] ,	[OCT_09] ,	[NOV_09],	[DEC_09] ,
	[JAN_10] ,	[FEB_10] ,	[MAR_10] ,	[APR_10] ,	[MAY_10] ,	[JUN_10] ,	[JUL_10] ,	[AUG_10] ,	[SEP_10] ,	[OCT_10] ,	[NOV_10] ,	[DEC_10] ,
	[JAN_11] ,	[FEB_11] ,	[MAR_11] ,	[APR_11] ,	[MAY_11] ,	[JUN_11] ,	[JUL_11] ,	[AUG_11] ,	[SEP_11] ,	[OCT_11] ,	[NOV_11] ,	[DEC_11] ,
	[JAN_12] ,	[FEB_12] ,	[MAR_12] ,	[APR_12], 	[MAY_12] ,	[JUN_12] ,	[JUL_12] ,	[AUG_12] ,	[SEP_12] ,	[OCT_12] ,	[NOV_12] ,	[DEC_12] ,
	[JAN_13] ,	[FEB_13] ,	[MAR_13] ,	[APR_13], 	[MAY_13] ,	[JUN_13] ,	[JUL_13] ,	[AUG_13] ,	[SEP_13] ,	[OCT_13] ,	[NOV_13] ,	[DEC_13] ,
	[JAN_14] ,	[FEB_14] ,	[MAR_14] ,	[APR_14], 	[MAY_14] ,	[JUN_14] ,	[JUL_14] ,	[AUG_14] ,	[SEP_14] ,	[OCT_14] ,	[NOV_14] ,	[DEC_14] ,		
	[JAN_15] ,	[FEB_15] ,	[MAR_15] ,	[APR_15], 	[MAY_15] ,	[JUN_15] ,	[JUL_15] ,	[AUG_15] ,	[SEP_15] ,	[OCT_15] ,	[NOV_15] ,	[DEC_15] ,
	[JAN_16] ,	[FEB_16] ,	[MAR_16] ,	[APR_16], 	[MAY_16] ,	[JUN_16] ,	[JUL_16] ,	[AUG_16] ,	[SEP_16] ,	[OCT_16] ,	[NOV_16] ,	[DEC_16] ,
	[JAN_17] ,	[FEB_17] ,	[MAR_17] ,	[APR_17], 	[MAY_17] ,	[JUN_17] ,	[JUL_17] ,	[AUG_17] ,	[SEP_17] ,	[OCT_17] ,	[NOV_17] ,	[DEC_17] ,
	[JAN_18] ,	[FEB_18] ,	[MAR_18] ,	[APR_18], 	[MAY_18] ,	[JUN_18] ,	[JUL_18] ,	[AUG_18] ,	[SEP_18] ,	[OCT_18] ,	[NOV_18] ,	[DEC_18] ,
	[JAN_19] ,	[FEB_19] ,	[MAR_19] ,	[APR_19], 	[MAY_19] ,	[JUN_19] ,	[JUL_19] ,	[AUG_19] ,	[SEP_19] ,	[OCT_19] ,	[NOV_19] ,	[DEC_19] ,
    [JAN_20] ,	[FEB_20] ,	[MAR_20] ,	[APR_20], 	[MAY_20] ,	[JUN_20] ,	[JUL_20] ,	[AUG_20] ,	[SEP_20] ,	[OCT_20] ,	[NOV_20] ,	[DEC_20] ,
	[DEC_21] ,
	[DEC_22] ,
	[DEC_23] ,
	[DEC_24] ,
	[DEC_25]
	
from eeiuser.acctg_csm_selling_prices_tabular where release_id = @prior_release_id 
--and base_part in ('STK0013','STK0014','STK0015','STK0016','STK0017','STK0018','STK0019','STK0020','VNA0279','VNA0280')

-- delete from eeiuser.acctg_csm_selling_prices_tabular where release_id = '2017-02'


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
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert rows="1+">



--3.  Copy the material_cost from the prior month to the current month
--	  Each year, need to add monthly fields and another year 

--    select * from eeiuser.acctg_csm_material_cost_tabular

-- delete from eeiuser.acctg_csm_material_cost_tabular where release_id = '2017-02'

--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_material_cost_tabular'
insert into [EEIUser].[acctg_csm_material_cost_tabular]
	([RELEASE_ID],
	[ROW_ID] ,
	[BASE_PART],
	[VERSION] ,
	[INCLUSION],
	[PARTUSEDFORCOST],
	[EFFECTIVE_DATE],
		[JAN_08] ,	[FEB_08] ,	[MAR_08] ,	[APR_08] ,	[MAY_08] ,	[JUN_08] ,	[JUL_08] ,	[AUG_08] ,	[SEP_08] ,	[OCT_08] ,	[NOV_08] ,	[DEC_08],
		[JAN_09],	[FEB_09] ,	[MAR_09] ,	[APR_09] ,	[MAY_09] ,	[JUN_09] ,	[JUL_09] ,	[AUG_09] ,	[SEP_09] ,	[OCT_09] ,	[NOV_09],	[DEC_09] ,
		[JAN_10] ,	[FEB_10] ,	[MAR_10] ,	[APR_10] ,	[MAY_10] ,	[JUN_10] ,	[JUL_10] ,	[AUG_10] ,	[SEP_10] ,	[OCT_10] ,	[NOV_10] ,	[DEC_10] ,
		[JAN_11] ,	[FEB_11] ,	[MAR_11] ,	[APR_11] ,	[MAY_11] ,	[JUN_11] ,	[JUL_11] ,	[AUG_11] ,	[SEP_11] ,	[OCT_11] ,	[NOV_11] ,	[DEC_11] ,
		[JAN_12] ,	[FEB_12] ,	[MAR_12] ,	[APR_12], 	[MAY_12] ,	[JUN_12] ,	[JUL_12] ,	[AUG_12] ,	[SEP_12] ,	[OCT_12] ,	[NOV_12] ,	[DEC_12] ,
		[JAN_13] ,	[FEB_13] ,	[MAR_13] ,	[APR_13], 	[MAY_13] ,	[JUN_13] ,	[JUL_13] ,	[AUG_13] ,	[SEP_13] ,	[OCT_13] ,	[NOV_13] ,	[DEC_13] ,
		[JAN_14] ,	[FEB_14] ,	[MAR_14] ,	[APR_14], 	[MAY_14] ,	[JUN_14] ,	[JUL_14] ,	[AUG_14] ,	[SEP_14] ,	[OCT_14] ,	[NOV_14] ,	[DEC_14] ,
		[JAN_15] ,	[FEB_15] ,	[MAR_15] ,	[APR_15], 	[MAY_15] ,	[JUN_15] ,	[JUL_15] ,	[AUG_15] ,	[SEP_15] ,	[OCT_15] ,	[NOV_15] ,	[DEC_15] ,
		[JAN_16] ,	[FEB_16] ,	[MAR_16] ,	[APR_16], 	[MAY_16] ,	[JUN_16] ,	[JUL_16] ,	[AUG_16] ,	[SEP_16] ,	[OCT_16] ,	[NOV_16] ,	[DEC_16] ,
		[JAN_17] ,	[FEB_17] ,	[MAR_17] ,	[APR_17], 	[MAY_17] ,	[JUN_17] ,	[JUL_17] ,	[AUG_17] ,	[SEP_17] ,	[OCT_17] ,	[NOV_17] ,	[DEC_17] ,
		[JAN_18] ,	[FEB_18] ,	[MAR_18] ,	[APR_18], 	[MAY_18] ,	[JUN_18] ,	[JUL_18] ,	[AUG_18] ,	[SEP_18] ,	[OCT_18] ,	[NOV_18] ,	[DEC_18] ,
		[JAN_19] ,	[FEB_19] ,	[MAR_19] ,	[APR_19], 	[MAY_19] ,	[JUN_19] ,	[JUL_19] ,	[AUG_19] ,	[SEP_19] ,	[OCT_19] ,	[NOV_19] ,	[DEC_19] ,
		[JAN_20] ,	[FEB_20] ,	[MAR_20] ,	[APR_20], 	[MAY_20] ,	[JUN_20] ,	[JUL_20] ,	[AUG_20] ,	[SEP_20] ,	[OCT_20] ,	[NOV_20] ,	[DEC_20] ,
		[DEC_21] ,
		[DEC_22] ,
		[DEC_23] ,
		[DEC_24] ,
		[DEC_25] )
select @current_release_id,
	[ROW_ID] ,
	[BASE_PART],
	[VERSION] ,
	[INCLUSION],
	[PARTUSEDFORCOST],
	[EFFECTIVE_DATE],
		[JAN_08] ,	[FEB_08] ,	[MAR_08] ,	[APR_08] ,	[MAY_08] ,	[JUN_08] ,	[JUL_08] ,	[AUG_08] ,	[SEP_08] ,	[OCT_08] ,	[NOV_08] ,	[DEC_08],
		[JAN_09],	[FEB_09] ,	[MAR_09] ,	[APR_09] ,	[MAY_09] ,	[JUN_09] ,	[JUL_09] ,	[AUG_09] ,	[SEP_09] ,	[OCT_09] ,	[NOV_09],	[DEC_09] ,
		[JAN_10] ,	[FEB_10] ,	[MAR_10] ,	[APR_10] ,	[MAY_10] ,	[JUN_10] ,	[JUL_10] ,	[AUG_10] ,	[SEP_10] ,	[OCT_10] ,	[NOV_10] ,	[DEC_10] ,
		[JAN_11] ,	[FEB_11] ,	[MAR_11] ,	[APR_11] ,	[MAY_11] ,	[JUN_11] ,	[JUL_11] ,	[AUG_11] ,	[SEP_11] ,	[OCT_11] ,	[NOV_11] ,	[DEC_11] ,
		[JAN_12] ,	[FEB_12] ,	[MAR_12] ,	[APR_12], 	[MAY_12] ,	[JUN_12] ,	[JUL_12] ,	[AUG_12] ,	[SEP_12] ,	[OCT_12] ,	[NOV_12] ,	[DEC_12] ,
		[JAN_13] ,	[FEB_13] ,	[MAR_13] ,	[APR_13], 	[MAY_13] ,	[JUN_13] ,	[JUL_13] ,	[AUG_13] ,	[SEP_13] ,	[OCT_13] ,	[NOV_13] ,	[DEC_13] ,
		[JAN_14] ,	[FEB_14] ,	[MAR_14] ,	[APR_14], 	[MAY_14] ,	[JUN_14] ,	[JUL_14] ,	[AUG_14] ,	[SEP_14] ,	[OCT_14] ,	[NOV_14] ,	[DEC_14] ,
		[JAN_15] ,	[FEB_15] ,	[MAR_15] ,	[APR_15], 	[MAY_15] ,	[JUN_15] ,	[JUL_15] ,	[AUG_15] ,	[SEP_15] ,	[OCT_15] ,	[NOV_15] ,	[DEC_15] ,
		[JAN_16] ,	[FEB_16] ,	[MAR_16] ,	[APR_16], 	[MAY_16] ,	[JUN_16] ,	[JUL_16] ,	[AUG_16] ,	[SEP_16] ,	[OCT_16] ,	[NOV_16] ,	[DEC_16] ,
		[JAN_17] ,	[FEB_17] ,	[MAR_17] ,	[APR_17], 	[MAY_17] ,	[JUN_17] ,	[JUL_17] ,	[AUG_17] ,	[SEP_17] ,	[OCT_17] ,	[NOV_17] ,	[DEC_17] ,
		[JAN_18] ,	[FEB_18] ,	[MAR_18] ,	[APR_18], 	[MAY_18] ,	[JUN_18] ,	[JUL_18] ,	[AUG_18] ,	[SEP_18] ,	[OCT_18] ,	[NOV_18] ,	[DEC_18] ,
		[JAN_19] ,	[FEB_19] ,	[MAR_19] ,	[APR_19], 	[MAY_19] ,	[JUN_19] ,	[JUL_19] ,	[AUG_19] ,	[SEP_19] ,	[OCT_19] ,	[NOV_19] ,	[DEC_19] ,
		[JAN_20] ,	[FEB_20] ,	[MAR_20] ,	[APR_20], 	[MAY_20] ,	[JUN_20] ,	[JUL_20] ,	[AUG_20] ,	[SEP_20] ,	[OCT_20] ,	[NOV_20] ,	[DEC_20] ,
		[DEC_21] ,
		[DEC_22] ,
		[DEC_23] ,
		[DEC_24] ,
		[DEC_25]

from eeiuser.acctg_csm_material_cost_tabular where release_id = @prior_release_id

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
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert rows="1+">



--4.  Copy over part attributes from prior month to current month

-- select * from eeiuser.acctg_csm_base_part_attributes

-- delete from eeiuser.acctg_csm_base_part_attributes where release_id = '2017-02'

--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_base_part_attributes'
insert into eeiuser.acctg_csm_base_part_attributes
(		[release_id]
		,[base_part]
		,[family]
		,[customer]
		,[parent_customer]
		,[product_line]
		,[empire_market_segment]
		,[empire_market_subsegment]
		,[empire_application]
		,[empire_sop]
		,[empire_eop]
		,[include_in_forecast]
		,[Salesperson]
		,[date_of_award]
		,[type_of_award]
		,[mid_model_year]
		,[empire_eop_note]
		,[verified_eop]
		,[verified_eop_date]
)
select 
	  @current_release_id
      ,[base_part]
      ,[family]
      ,[customer]
      ,[parent_customer]
      ,[product_line]
      ,[empire_market_segment]
      ,[empire_market_subsegment]
      ,[empire_application]
      ,[empire_sop]
      ,[empire_eop]
      ,[include_in_forecast]
      ,[Salesperson]
	  ,[date_of_award]
	  ,[type_of_award]
	  ,[mid_model_year]
	  ,[empire_eop_note]
	  ,[verified_eop]
	  ,[verified_eop_date]
FROM	[EEIUser].[acctg_csm_base_part_attributes]
where	release_id = @prior_release_id

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
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end




--4b.  Copy over mneumonics from prior month to current month

-- select * from eeiuser.acctg_csm_base_part_mnemonic

-- delete from eeiuser.acctg_csm_base_part_mnemonic where release_id = '2018-02'

--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_base_part_mnemonic'
insert into eeiuser.acctg_csm_base_part_mnemonic
(	RELEASE_ID
      ,FORECAST_ID
      ,MNEMONIC
      ,BASE_PART
      ,QTY_PER
      ,TAKE_RATE
      ,FAMILY_ALLOCATION
)
select 
	@current_release_id
      ,FORECAST_ID
      ,MNEMONIC
      ,BASE_PART
      ,QTY_PER
      ,TAKE_RATE
      ,FAMILY_ALLOCATION
FROM	[EEIUser].acctg_csm_base_part_mnemonic
where	release_id = @prior_release_id

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
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end




--5.  Copy notes from prior month to current month

--	 select * from eeiuser.acctg_csm_base_part_notes

--   delete from eeiuser.acctg_csm_base_part_notes where release_id = '2017-02'


--- <Insert rows="1+">
set	@TableName = 'EEIUser.acctg_csm_base_part_notes'
insert into eeiuser.acctg_csm_base_part_notes
(	   [release_id]
      ,[base_part]
      ,[time_stamp]
      ,[status]
      ,[note]
)
SELECT @current_release_id
      ,[base_part]
      ,[time_stamp]
      ,[status]
      ,[note]
FROM	[EEIUser].[acctg_csm_base_part_notes]
where	release_id = @prior_release_id
--and base_part in ('STK0013','STK0014','STK0015','STK0016','STK0017','STK0018','STK0019','STK0020','VNA0279','VNA0280')

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--if	@RowCount < 1 begin
--	set	@Result = 999999
--	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
--	rollback tran @ProcName
--	return
--end



--6.  Copy Empire factor from prior month to current month
--    Each year, need to add monthly fields and another year

	

--    select * from eeiuser.acctg_csm_naihs

--  delete from eeiuser.acctg_csm_naihs where release_id = '2017-02'

--- <Insert rows="1+">
set	@TableName = 'EEIUser.eeiuser.acctg_csm_naihs'
insert into eeiuser.acctg_csm_naihs
			(
			[Release_ID],			[Version],				[Core Nameplate Region Mnemonic],	[Core Nameplate Plant Mnemonic],	[Mnemonic-Vehicle],		[Mnemonic-Vehicle/Plant],			[Mnemonic-Platform],	[Region], 	[Market],
			[Country],				[Plant],				[City],					[Plant State/Province],				[Source Plant],			[Source Plant Country],
			[Source Plant Region],	[Design Parent],		[Engineering Group],	[Manufacturing Group],				[Manufacturer],			[Sales Parent],
			[Brand],				[Platform Design Owner],[Architecture],			[Platform],							[Program],				[Nameplate],
			[SOP],					[EOP],					[Lifecycle (Time)],		[Vehicle],							[Assembly Type],		[Strategic Group],
			[Sales Group],			[Global Nameplate],		[Primary Design Center],[Primary Design Country],			[Primary Design Region],[Secondary Design Center],
			[Secondary Design Country],						[Secondary Design Region],									[GVW Rating],			[GVW Class],
			[Car/Truck],			[Production Type],		[Global Production Segment],								[Regional Sales Segment],		[Global Production Price Class],
			[Global Sales Segment],	[Global Sales Sub-Segment],						[Global Sales Price Class],			[Short Term Risk Rating],		[Long Term Risk Rating],	
			[JAN 2000],	[FEB 2000],	[MAR 2000],	[APR 2000],	[MAY 2000],	[JUN 2000],	[JUL 2000],	[AUG 2000],	[SEP 2000],	[OCT 2000],	[NOV 2000],	[DEC 2000],	
			[JAN 2001],	[FEB 2001],	[MAR 2001],	[APR 2001],	[MAY 2001],	[JUN 2001],	[JUL 2001],	[AUG 2001],	[SEP 2001],	[OCT 2001],	[NOV 2001],	[DEC 2001],	
			[JAN 2002],	[FEB 2002],	[MAR 2002],	[APR 2002],	[MAY 2002],	[JUN 2002],	[JUL 2002],	[AUG 2002],	[SEP 2002],	[OCT 2002],	[NOV 2002],	[DEC 2002],	
			[JAN 2003],	[FEB 2003],	[MAR 2003],	[APR 2003],	[MAY 2003],	[JUN 2003],	[JUL 2003],	[AUG 2003],	[SEP 2003],	[OCT 2003],	[NOV 2003],	[DEC 2003],
			[JAN 2004],	[FEB 2004],	[MAR 2004],	[APR 2004], [MAY 2004],	[JUN 2004],	[JUL 2004],	[AUG 2004],	[SEP 2004],	[OCT 2004],	[NOV 2004],	[DEC 2004],	
			[JAN 2005],	[FEB 2005],	[MAR 2005],	[APR 2005],	[MAY 2005],	[JUN 2005],	[JUL 2005],	[AUG 2005],	[SEP 2005],	[OCT 2005],	[NOV 2005],	[DEC 2005],	
			[JAN 2006],	[FEB 2006],	[MAR 2006],	[APR 2006],	[MAY 2006],	[JUN 2006],	[JUL 2006],	[AUG 2006],	[SEP 2006],	[OCT 2006],	[NOV 2006],	[DEC 2006],	
			[JAN 2007],	[FEB 2007],	[MAR 2007],	[APR 2007],	[MAY 2007],	[JUN 2007],	[JUL 2007],	[AUG 2007],	[SEP 2007],	[OCT 2007],	[NOV 2007],	[DEC 2007],	
			[JAN 2008],	[FEB 2008],	[MAR 2008],	[APR 2008],	[MAY 2008],	[JUN 2008],	[JUL 2008],	[AUG 2008],	[SEP 2008],	[OCT 2008],	[NOV 2008],	[DEC 2008],	
			[JAN 2009],	[FEB 2009],	[MAR 2009],	[APR 2009],	[MAY 2009],	[JUN 2009],	[JUL 2009],	[AUG 2009],	[SEP 2009],	[OCT 2009],	[NOV 2009],	[DEC 2009],	
			[JAN 2010],	[FEB 2010],	[MAR 2010],	[APR 2010],	[MAY 2010],	[JUN 2010],	[JUL 2010],	[AUG 2010],	[SEP 2010],	[OCT 2010], [NOV 2010],	[DEC 2010],	
			[JAN 2011],	[FEB 2011],	[MAR 2011],	[APR 2011],	[MAY 2011],	[JUN 2011],	[JUL 2011],	[AUG 2011],	[SEP 2011],	[OCT 2011],	[NOV 2011],	[DEC 2011],	
			[JAN 2012],	[FEB 2012],	[MAR 2012],	[APR 2012],	[MAY 2012],	[JUN 2012],	[JUL 2012],	[AUG 2012],	[SEP 2012],	[OCT 2012],	[NOV 2012],	[DEC 2012],	
			[JAN 2013],	[FEB 2013],	[MAR 2013],	[APR 2013],	[MAY 2013],	[JUN 2013],	[JUL 2013],	[AUG 2013],	[SEP 2013],	[OCT 2013],	[NOV 2013],	[DEC 2013],
			[JAN 2014],	[FEB 2014],	[MAR 2014],	[APR 2014],	[MAY 2014],	[JUN 2014],	[JUL 2014],	[AUG 2014],	[SEP 2014],	[OCT 2014],	[NOV 2014],	[DEC 2014],
			[JAN 2015],	[FEB 2015],	[MAR 2015],	[APR 2015],	[MAY 2015],	[JUN 2015],	[JUL 2015],	[AUG 2015],	[SEP 2015],	[OCT 2015],	[NOV 2015],	[DEC 2015],
			[JAN 2016],	[FEB 2016],	[MAR 2016],	[APR 2016],	[MAY 2016],	[JUN 2016],	[JUL 2016],	[AUG 2016],	[SEP 2016],	[OCT 2016],	[NOV 2016],	[DEC 2016],
			[JAN 2017],	[FEB 2017],	[MAR 2017],	[APR 2017],	[MAY 2017],	[JUN 2017],	[JUL 2017],	[AUG 2017],	[SEP 2017],	[OCT 2017],	[NOV 2017],	[DEC 2017],
			[JAN 2018],	[FEB 2018],	[MAR 2018],	[APR 2018],	[MAY 2018],	[JUN 2018],	[JUL 2018],	[AUG 2018],	[SEP 2018],	[OCT 2018],	[NOV 2018],	[DEC 2018],
			[JAN 2019],	[FEB 2019],	[MAR 2019],	[APR 2019],	[MAY 2019],	[JUN 2019],	[JUL 2019],	[AUG 2019],	[SEP 2019],	[OCT 2019],	[NOV 2019],	[DEC 2019],
			[JAN 2020],	[FEB 2020],	[MAR 2020],	[APR 2020],	[MAY 2020],	[JUN 2020],	[JUL 2020],	[AUG 2020],	[SEP 2020],	[OCT 2020],	[NOV 2020],	[DEC 2020],
			[Q1 2008],	[Q2 2008],	[Q3 2008],	[Q4 2008],	[Q1 2009],	[Q2 2009],	[Q3 2009],	[Q4 2009],	[Q1 2010],	[Q2 2010],	[Q3 2010],	[Q4 2010],
			[Q1 2011],	[Q2 2011],	[Q3 2011],	[Q4 2011],	[Q1 2012],	[Q2 2012],	[Q3 2012],	[Q4 2012],	[Q1 2013],	[Q2 2013],	[Q3 2013],	[Q4 2013],
			[Q1 2014],	[Q2 2014],	[Q3 2014],	[Q4 2014],	[Q1 2015],	[Q2 2015],	[Q3 2015],	[Q4 2015],	[Q1 2016],	[Q2 2016],	[Q3 2016],	[Q4 2016],
			[Q1 2017],	[Q2 2017],	[Q3 2017],	[Q4 2017],	[Q1 2018],	[Q2 2018],	[Q3 2018],	[Q4 2018],	[Q1 2019],	[Q2 2019],	[Q3 2019],	[Q4 2019],
			[Q1 2020],	[Q2 2020],	[Q3 2020],	[Q4 2020],	[Q1 2021],	[Q2 2021],	[Q3 2021],	[Q4 2021],	[Q1 2022],  [Q2 2022],  [Q3 2022],  [Q4 2022],
			[Q1 2023],	[Q2 2023],	[Q3 2023],	[Q4 2023],	[Q1 2024],	[Q2 2024],	[Q3 2024],	[Q4 2024],	[Q1 2025],	[Q2 2025],	[Q3 2025],	[Q4 2025],
			[CY 2000],	[CY 2001],	[CY 2002],	[CY 2003],	[CY 2004],	[CY 2005],	[CY 2006],	[CY 2007],	[CY 2008],	[CY 2009],	[CY 2010],	[CY 2011],
			[CY 2012],	[CY 2013],	[CY 2014],	[CY 2015],	[CY 2016],	[CY 2017],	[CY 2018],	[CY 2019],	[CY 2020],  [CY 2021],  [CY 2022],  [CY 2023],
			[CY 2024],	[CY 2025]
				
	)
	select	
			@current_release_id,	
			'Empire Factor',		
			[Core Nameplate Region Mnemonic],				[Core Nameplate Plant Mnemonic],							[Mnemonic-Vehicle],		[Mnemonic-Vehicle/Plant],			
			[Mnemonic-Platform],	[Region], 				[Market],
			[Country],				[Plant],				[City],					[Plant State/Province],				[Source Plant],			[Source Plant Country],
			[Source Plant Region],	[Design Parent],		[Engineering Group],	[Manufacturing Group],				[Manufacturer],			[Sales Parent],
			[Brand],				[Platform Design Owner],[Architecture],			[Platform],							[Program],				[Nameplate],
			[SOP],					[EOP],					[Lifecycle (Time)],		[Vehicle],							[Assembly Type],		[Strategic Group],
			[Sales Group],			[Global Nameplate],		[Primary Design Center],[Primary Design Country],			[Primary Design Region],[Secondary Design Center],
			[Secondary Design Country],						[Secondary Design Region],									[GVW Rating],			[GVW Class],
			[Car/Truck],			[Production Type],		[Global Production Segment],								[Regional Sales Segment],		[Global Production Price Class],
			[Global Sales Segment],	[Global Sales Sub-Segment],						[Global Sales Price Class],			[Short Term Risk Rating],		[Long Term Risk Rating],	
			[JAN 2000],	[FEB 2000],	[MAR 2000],	[APR 2000],	[MAY 2000],	[JUN 2000],	[JUL 2000],	[AUG 2000],	[SEP 2000],	[OCT 2000],	[NOV 2000],	[DEC 2000],	
			[JAN 2001],	[FEB 2001],	[MAR 2001],	[APR 2001],	[MAY 2001],	[JUN 2001],	[JUL 2001],	[AUG 2001],	[SEP 2001],	[OCT 2001],	[NOV 2001],	[DEC 2001],	
			[JAN 2002],	[FEB 2002],	[MAR 2002],	[APR 2002],	[MAY 2002],	[JUN 2002],	[JUL 2002],	[AUG 2002],	[SEP 2002],	[OCT 2002],	[NOV 2002],	[DEC 2002],	
			[JAN 2003],	[FEB 2003],	[MAR 2003],	[APR 2003],	[MAY 2003],	[JUN 2003],	[JUL 2003],	[AUG 2003],	[SEP 2003],	[OCT 2003],	[NOV 2003],	[DEC 2003],
			[JAN 2004],	[FEB 2004],	[MAR 2004],	[APR 2004], [MAY 2004],	[JUN 2004],	[JUL 2004],	[AUG 2004],	[SEP 2004],	[OCT 2004],	[NOV 2004],	[DEC 2004],	
			[JAN 2005],	[FEB 2005],	[MAR 2005],	[APR 2005],	[MAY 2005],	[JUN 2005],	[JUL 2005],	[AUG 2005],	[SEP 2005],	[OCT 2005],	[NOV 2005],	[DEC 2005],	
			[JAN 2006],	[FEB 2006],	[MAR 2006],	[APR 2006],	[MAY 2006],	[JUN 2006],	[JUL 2006],	[AUG 2006],	[SEP 2006],	[OCT 2006],	[NOV 2006],	[DEC 2006],	
			[JAN 2007],	[FEB 2007],	[MAR 2007],	[APR 2007],	[MAY 2007],	[JUN 2007],	[JUL 2007],	[AUG 2007],	[SEP 2007],	[OCT 2007],	[NOV 2007],	[DEC 2007],	
			[JAN 2008],	[FEB 2008],	[MAR 2008],	[APR 2008],	[MAY 2008],	[JUN 2008],	[JUL 2008],	[AUG 2008],	[SEP 2008],	[OCT 2008],	[NOV 2008],	[DEC 2008],	
			[JAN 2009],	[FEB 2009],	[MAR 2009],	[APR 2009],	[MAY 2009],	[JUN 2009],	[JUL 2009],	[AUG 2009],	[SEP 2009],	[OCT 2009],	[NOV 2009],	[DEC 2009],	
			[JAN 2010],	[FEB 2010],	[MAR 2010],	[APR 2010],	[MAY 2010],	[JUN 2010],	[JUL 2010],	[AUG 2010],	[SEP 2010],	[OCT 2010], [NOV 2010],	[DEC 2010],	
			[JAN 2011],	[FEB 2011],	[MAR 2011],	[APR 2011],	[MAY 2011],	[JUN 2011],	[JUL 2011],	[AUG 2011],	[SEP 2011],	[OCT 2011],	[NOV 2011],	[DEC 2011],	
			[JAN 2012],	[FEB 2012],	[MAR 2012],	[APR 2012],	[MAY 2012],	[JUN 2012],	[JUL 2012],	[AUG 2012],	[SEP 2012],	[OCT 2012],	[NOV 2012],	[DEC 2012],	
			[JAN 2013],	[FEB 2013],	[MAR 2013],	[APR 2013],	[MAY 2013],	[JUN 2013],	[JUL 2013],	[AUG 2013],	[SEP 2013],	[OCT 2013],	[NOV 2013],	[DEC 2013],
			[JAN 2014],	[FEB 2014],	[MAR 2014],	[APR 2014],	[MAY 2014],	[JUN 2014],	[JUL 2014],	[AUG 2014],	[SEP 2014],	[OCT 2014],	[NOV 2014],	[DEC 2014],
			[JAN 2015],	[FEB 2015],	[MAR 2015],	[APR 2015],	[MAY 2015],	[JUN 2015],	[JUL 2015],	[AUG 2015],	[SEP 2015],	[OCT 2015],	[NOV 2015],	[DEC 2015],
			[JAN 2016],	[FEB 2016],	[MAR 2016],	[APR 2016],	[MAY 2016],	[JUN 2016],	[JUL 2016],	[AUG 2016],	[SEP 2016],	[OCT 2016],	[NOV 2016],	[DEC 2016],
			[JAN 2017],	[FEB 2017],	[MAR 2017],	[APR 2017],	[MAY 2017],	[JUN 2017],	[JUL 2017],	[AUG 2017],	[SEP 2017],	[OCT 2017],	[NOV 2017],	[DEC 2017],
			[JAN 2018],	[FEB 2018],	[MAR 2018],	[APR 2018],	[MAY 2018],	[JUN 2018],	[JUL 2018],	[AUG 2018],	[SEP 2018],	[OCT 2018],	[NOV 2018],	[DEC 2018],
			[JAN 2019],	[FEB 2019],	[MAR 2019],	[APR 2019],	[MAY 2019],	[JUN 2019],	[JUL 2019],	[AUG 2019],	[SEP 2019],	[OCT 2019],	[NOV 2019],	[DEC 2019],
			[JAN 2020],	[FEB 2020],	[MAR 2020],	[APR 2020],	[MAY 2020],	[JUN 2020],	[JUL 2020],	[AUG 2020],	[SEP 2020],	[OCT 2020],	[NOV 2020],	[DEC 2020],
			[Q1 2008],	[Q2 2008],	[Q3 2008],	[Q4 2008],	[Q1 2009],	[Q2 2009],	[Q3 2009],	[Q4 2009],	[Q1 2010],	[Q2 2010],	[Q3 2010],	[Q4 2010],
			[Q1 2011],	[Q2 2011],	[Q3 2011],	[Q4 2011],	[Q1 2012],	[Q2 2012],	[Q3 2012],	[Q4 2012],	[Q1 2013],	[Q2 2013],	[Q3 2013],	[Q4 2013],
			[Q1 2014],	[Q2 2014],	[Q3 2014],	[Q4 2014],	[Q1 2015],	[Q2 2015],	[Q3 2015],	[Q4 2015],	[Q1 2016],	[Q2 2016],	[Q3 2016],	[Q4 2016],
			[Q1 2017],	[Q2 2017],	[Q3 2017],	[Q4 2017],	[Q1 2018],	[Q2 2018],	[Q3 2018],	[Q4 2018],	[Q1 2019],	[Q2 2019],	[Q3 2019],	[Q4 2019],
			[Q1 2020],	[Q2 2020],	[Q3 2020],	[Q4 2020],	[Q1 2021],	[Q2 2021],	[Q3 2021],	[Q4 2021],	[Q1 2022],  [Q2 2022],  [Q3 2022],  [Q4 2022],
			[Q1 2023],	[Q2 2023],	[Q3 2023],	[Q4 2023],	[Q1 2024],	[Q2 2024],	[Q3 2024],	[Q4 2024],	[Q1 2025],	[Q2 2025],	[Q3 2025],	[Q4 2025],
			[CY 2000],	[CY 2001],	[CY 2002],	[CY 2003],	[CY 2004],	[CY 2005],	[CY 2006],	[CY 2007],	[CY 2008],	[CY 2009],	[CY 2010],	[CY 2011],
			[CY 2012],	[CY 2013],	[CY 2014],	[CY 2015],	[CY 2016],	[CY 2017],	[CY 2018],	[CY 2019],	[CY 2020],  [CY 2021],  [CY 2022],  [CY 2023],
			[CY 2024],	[CY 2025]
	from	eeiuser.acctg_csm_naihs 
	where	release_id = @prior_release_id 
			and version = 'Empire Factor'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting Empire Factor into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting Empire Factor into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end



--7.  Copy Empire adjustments from prior month to current month
--    Each year, need to add monthly fields and another year

--    select * from eeiuser.acctg_csm_naihs

--- <Insert rows="1+">
set	@TableName = 'EEIUser.eeiuser.acctg_csm_naihs'
insert into eeiuser.acctg_csm_naihs
			(
			[Release_ID],			[Version],				
			[Core Nameplate Region Mnemonic],				[Core Nameplate Plant Mnemonic],							[Mnemonic-Vehicle],		[Mnemonic-Vehicle/Plant],			
			[Mnemonic-Platform],	[Region], 				[Market],
			[Country],				[Plant],				[City],					[Plant State/Province],				[Source Plant],			[Source Plant Country],
			[Source Plant Region],	[Design Parent],		[Engineering Group],	[Manufacturing Group],				[Manufacturer],			[Sales Parent],
			[Brand],				[Platform Design Owner],[Architecture],			[Platform],							[Program],				[Nameplate],
			[SOP],					[EOP],					[Lifecycle (Time)],		[Vehicle],							[Assembly Type],		[Strategic Group],
			[Sales Group],			[Global Nameplate],		[Primary Design Center],[Primary Design Country],			[Primary Design Region],[Secondary Design Center],
			[Secondary Design Country],						[Secondary Design Region],									[GVW Rating],			[GVW Class],
			[Car/Truck],			[Production Type],		[Global Production Segment],								[Regional Sales Segment],		[Global Production Price Class],
			[Global Sales Segment],	[Global Sales Sub-Segment],						[Global Sales Price Class],			[Short Term Risk Rating],		[Long Term Risk Rating],	
			[JAN 2000],	[FEB 2000],	[MAR 2000],	[APR 2000],	[MAY 2000],	[JUN 2000],	[JUL 2000],	[AUG 2000],	[SEP 2000],	[OCT 2000],	[NOV 2000],	[DEC 2000],	
			[JAN 2001],	[FEB 2001],	[MAR 2001],	[APR 2001],	[MAY 2001],	[JUN 2001],	[JUL 2001],	[AUG 2001],	[SEP 2001],	[OCT 2001],	[NOV 2001],	[DEC 2001],	
			[JAN 2002],	[FEB 2002],	[MAR 2002],	[APR 2002],	[MAY 2002],	[JUN 2002],	[JUL 2002],	[AUG 2002],	[SEP 2002],	[OCT 2002],	[NOV 2002],	[DEC 2002],	
			[JAN 2003],	[FEB 2003],	[MAR 2003],	[APR 2003],	[MAY 2003],	[JUN 2003],	[JUL 2003],	[AUG 2003],	[SEP 2003],	[OCT 2003],	[NOV 2003],	[DEC 2003],
			[JAN 2004],	[FEB 2004],	[MAR 2004],	[APR 2004], [MAY 2004],	[JUN 2004],	[JUL 2004],	[AUG 2004],	[SEP 2004],	[OCT 2004],	[NOV 2004],	[DEC 2004],	
			[JAN 2005],	[FEB 2005],	[MAR 2005],	[APR 2005],	[MAY 2005],	[JUN 2005],	[JUL 2005],	[AUG 2005],	[SEP 2005],	[OCT 2005],	[NOV 2005],	[DEC 2005],	
			[JAN 2006],	[FEB 2006],	[MAR 2006],	[APR 2006],	[MAY 2006],	[JUN 2006],	[JUL 2006],	[AUG 2006],	[SEP 2006],	[OCT 2006],	[NOV 2006],	[DEC 2006],	
			[JAN 2007],	[FEB 2007],	[MAR 2007],	[APR 2007],	[MAY 2007],	[JUN 2007],	[JUL 2007],	[AUG 2007],	[SEP 2007],	[OCT 2007],	[NOV 2007],	[DEC 2007],	
			[JAN 2008],	[FEB 2008],	[MAR 2008],	[APR 2008],	[MAY 2008],	[JUN 2008],	[JUL 2008],	[AUG 2008],	[SEP 2008],	[OCT 2008],	[NOV 2008],	[DEC 2008],	
			[JAN 2009],	[FEB 2009],	[MAR 2009],	[APR 2009],	[MAY 2009],	[JUN 2009],	[JUL 2009],	[AUG 2009],	[SEP 2009],	[OCT 2009],	[NOV 2009],	[DEC 2009],	
			[JAN 2010],	[FEB 2010],	[MAR 2010],	[APR 2010],	[MAY 2010],	[JUN 2010],	[JUL 2010],	[AUG 2010],	[SEP 2010],	[OCT 2010], [NOV 2010],	[DEC 2010],	
			[JAN 2011],	[FEB 2011],	[MAR 2011],	[APR 2011],	[MAY 2011],	[JUN 2011],	[JUL 2011],	[AUG 2011],	[SEP 2011],	[OCT 2011],	[NOV 2011],	[DEC 2011],	
			[JAN 2012],	[FEB 2012],	[MAR 2012],	[APR 2012],	[MAY 2012],	[JUN 2012],	[JUL 2012],	[AUG 2012],	[SEP 2012],	[OCT 2012],	[NOV 2012],	[DEC 2012],	
			[JAN 2013],	[FEB 2013],	[MAR 2013],	[APR 2013],	[MAY 2013],	[JUN 2013],	[JUL 2013],	[AUG 2013],	[SEP 2013],	[OCT 2013],	[NOV 2013],	[DEC 2013],
			[JAN 2014],	[FEB 2014],	[MAR 2014],	[APR 2014],	[MAY 2014],	[JUN 2014],	[JUL 2014],	[AUG 2014],	[SEP 2014],	[OCT 2014],	[NOV 2014],	[DEC 2014],
			[JAN 2015],	[FEB 2015],	[MAR 2015],	[APR 2015],	[MAY 2015],	[JUN 2015],	[JUL 2015],	[AUG 2015],	[SEP 2015],	[OCT 2015],	[NOV 2015],	[DEC 2015],
			[JAN 2016],	[FEB 2016],	[MAR 2016],	[APR 2016],	[MAY 2016],	[JUN 2016],	[JUL 2016],	[AUG 2016],	[SEP 2016],	[OCT 2016],	[NOV 2016],	[DEC 2016],
			[JAN 2017],	[FEB 2017],	[MAR 2017],	[APR 2017],	[MAY 2017],	[JUN 2017],	[JUL 2017],	[AUG 2017],	[SEP 2017],	[OCT 2017],	[NOV 2017],	[DEC 2017],
			[JAN 2018],	[FEB 2018],	[MAR 2018],	[APR 2018],	[MAY 2018],	[JUN 2018],	[JUL 2018],	[AUG 2018],	[SEP 2018],	[OCT 2018],	[NOV 2018],	[DEC 2018],
			[JAN 2019],	[FEB 2019],	[MAR 2019],	[APR 2019],	[MAY 2019],	[JUN 2019],	[JUL 2019],	[AUG 2019],	[SEP 2019],	[OCT 2019],	[NOV 2019],	[DEC 2019],
			[JAN 2020],	[FEB 2020],	[MAR 2020],	[APR 2020],	[MAY 2020],	[JUN 2020],	[JUL 2020],	[AUG 2020],	[SEP 2020],	[OCT 2020],	[NOV 2020],	[DEC 2020],
			[Q1 2008],	[Q2 2008],	[Q3 2008],	[Q4 2008],	[Q1 2009],	[Q2 2009],	[Q3 2009],	[Q4 2009],	[Q1 2010],	[Q2 2010],	[Q3 2010],	[Q4 2010],
			[Q1 2011],	[Q2 2011],	[Q3 2011],	[Q4 2011],	[Q1 2012],	[Q2 2012],	[Q3 2012],	[Q4 2012],	[Q1 2013],	[Q2 2013],	[Q3 2013],	[Q4 2013],
			[Q1 2014],	[Q2 2014],	[Q3 2014],	[Q4 2014],	[Q1 2015],	[Q2 2015],	[Q3 2015],	[Q4 2015],	[Q1 2016],	[Q2 2016],	[Q3 2016],	[Q4 2016],
			[Q1 2017],	[Q2 2017],	[Q3 2017],	[Q4 2017],	[Q1 2018],	[Q2 2018],	[Q3 2018],	[Q4 2018],	[Q1 2019],	[Q2 2019],	[Q3 2019],	[Q4 2019],
			[Q1 2020],	[Q2 2020],	[Q3 2020],	[Q4 2020],	[Q1 2021],	[Q2 2021],	[Q3 2021],	[Q4 2021],	[Q1 2022],  [Q2 2022],  [Q3 2022],  [Q4 2022],
			[Q1 2023],	[Q2 2023],	[Q3 2023],	[Q4 2023],	[Q1 2024],	[Q2 2024],	[Q3 2024],	[Q4 2024],	[Q1 2025],	[Q2 2025],	[Q3 2025],	[Q4 2025],
			[CY 2000],	[CY 2001],	[CY 2002],	[CY 2003],	[CY 2004],	[CY 2005],	[CY 2006],	[CY 2007],	[CY 2008],	[CY 2009],	[CY 2010],	[CY 2011],
			[CY 2012],	[CY 2013],	[CY 2014],	[CY 2015],	[CY 2016],	[CY 2017],	[CY 2018],	[CY 2019],	[CY 2020],  [CY 2021],  [CY 2022],  [CY 2023],
			[CY 2024],	[CY 2025]
	)
	select	@current_release_id,	
			'Empire Adjustment',	
			[Core Nameplate Region Mnemonic],				[Core Nameplate Plant Mnemonic],							[Mnemonic-Vehicle],		[Mnemonic-Vehicle/Plant],			
			[Mnemonic-Platform],	[Region], 				[Market],
			[Country],				[Plant],				[City],					[Plant State/Province],				[Source Plant],			[Source Plant Country],
			[Source Plant Region],	[Design Parent],		[Engineering Group],	[Manufacturing Group],				[Manufacturer],			[Sales Parent],
			[Brand],				[Platform Design Owner],[Architecture],			[Platform],							[Program],				[Nameplate],
			[SOP],					[EOP],					[Lifecycle (Time)],		[Vehicle],							[Assembly Type],		[Strategic Group],
			[Sales Group],			[Global Nameplate],		[Primary Design Center],[Primary Design Country],			[Primary Design Region],[Secondary Design Center],
			[Secondary Design Country],						[Secondary Design Region],									[GVW Rating],			[GVW Class],
			[Car/Truck],			[Production Type],		[Global Production Segment],								[Regional Sales Segment],		[Global Production Price Class],
			[Global Sales Segment],	[Global Sales Sub-Segment],						[Global Sales Price Class],			[Short Term Risk Rating],		[Long Term Risk Rating],	
			[JAN 2000],	[FEB 2000],	[MAR 2000],	[APR 2000],	[MAY 2000],	[JUN 2000],	[JUL 2000],	[AUG 2000],	[SEP 2000],	[OCT 2000],	[NOV 2000],	[DEC 2000],	
			[JAN 2001],	[FEB 2001],	[MAR 2001],	[APR 2001],	[MAY 2001],	[JUN 2001],	[JUL 2001],	[AUG 2001],	[SEP 2001],	[OCT 2001],	[NOV 2001],	[DEC 2001],	
			[JAN 2002],	[FEB 2002],	[MAR 2002],	[APR 2002],	[MAY 2002],	[JUN 2002],	[JUL 2002],	[AUG 2002],	[SEP 2002],	[OCT 2002],	[NOV 2002],	[DEC 2002],	
			[JAN 2003],	[FEB 2003],	[MAR 2003],	[APR 2003],	[MAY 2003],	[JUN 2003],	[JUL 2003],	[AUG 2003],	[SEP 2003],	[OCT 2003],	[NOV 2003],	[DEC 2003],
			[JAN 2004],	[FEB 2004],	[MAR 2004],	[APR 2004], [MAY 2004],	[JUN 2004],	[JUL 2004],	[AUG 2004],	[SEP 2004],	[OCT 2004],	[NOV 2004],	[DEC 2004],	
			[JAN 2005],	[FEB 2005],	[MAR 2005],	[APR 2005],	[MAY 2005],	[JUN 2005],	[JUL 2005],	[AUG 2005],	[SEP 2005],	[OCT 2005],	[NOV 2005],	[DEC 2005],	
			[JAN 2006],	[FEB 2006],	[MAR 2006],	[APR 2006],	[MAY 2006],	[JUN 2006],	[JUL 2006],	[AUG 2006],	[SEP 2006],	[OCT 2006],	[NOV 2006],	[DEC 2006],	
			[JAN 2007],	[FEB 2007],	[MAR 2007],	[APR 2007],	[MAY 2007],	[JUN 2007],	[JUL 2007],	[AUG 2007],	[SEP 2007],	[OCT 2007],	[NOV 2007],	[DEC 2007],	
			[JAN 2008],	[FEB 2008],	[MAR 2008],	[APR 2008],	[MAY 2008],	[JUN 2008],	[JUL 2008],	[AUG 2008],	[SEP 2008],	[OCT 2008],	[NOV 2008],	[DEC 2008],	
			[JAN 2009],	[FEB 2009],	[MAR 2009],	[APR 2009],	[MAY 2009],	[JUN 2009],	[JUL 2009],	[AUG 2009],	[SEP 2009],	[OCT 2009],	[NOV 2009],	[DEC 2009],	
			[JAN 2010],	[FEB 2010],	[MAR 2010],	[APR 2010],	[MAY 2010],	[JUN 2010],	[JUL 2010],	[AUG 2010],	[SEP 2010],	[OCT 2010], [NOV 2010],	[DEC 2010],	
			[JAN 2011],	[FEB 2011],	[MAR 2011],	[APR 2011],	[MAY 2011],	[JUN 2011],	[JUL 2011],	[AUG 2011],	[SEP 2011],	[OCT 2011],	[NOV 2011],	[DEC 2011],	
			[JAN 2012],	[FEB 2012],	[MAR 2012],	[APR 2012],	[MAY 2012],	[JUN 2012],	[JUL 2012],	[AUG 2012],	[SEP 2012],	[OCT 2012],	[NOV 2012],	[DEC 2012],	
			[JAN 2013],	[FEB 2013],	[MAR 2013],	[APR 2013],	[MAY 2013],	[JUN 2013],	[JUL 2013],	[AUG 2013],	[SEP 2013],	[OCT 2013],	[NOV 2013],	[DEC 2013],
			[JAN 2014],	[FEB 2014],	[MAR 2014],	[APR 2014],	[MAY 2014],	[JUN 2014],	[JUL 2014],	[AUG 2014],	[SEP 2014],	[OCT 2014],	[NOV 2014],	[DEC 2014],
			[JAN 2015],	[FEB 2015],	[MAR 2015],	[APR 2015],	[MAY 2015],	[JUN 2015],	[JUL 2015],	[AUG 2015],	[SEP 2015],	[OCT 2015],	[NOV 2015],	[DEC 2015],
			[JAN 2016],	[FEB 2016],	[MAR 2016],	[APR 2016],	[MAY 2016],	[JUN 2016],	[JUL 2016],	[AUG 2016],	[SEP 2016],	[OCT 2016],	[NOV 2016],	[DEC 2016],
			[JAN 2017],	[FEB 2017],	[MAR 2017],	[APR 2017],	[MAY 2017],	[JUN 2017],	[JUL 2017],	[AUG 2017],	[SEP 2017],	[OCT 2017],	[NOV 2017],	[DEC 2017],
			[JAN 2018],	[FEB 2018],	[MAR 2018],	[APR 2018],	[MAY 2018],	[JUN 2018],	[JUL 2018],	[AUG 2018],	[SEP 2018],	[OCT 2018],	[NOV 2018],	[DEC 2018],
			[JAN 2019],	[FEB 2019],	[MAR 2019],	[APR 2019],	[MAY 2019],	[JUN 2019],	[JUL 2019],	[AUG 2019],	[SEP 2019],	[OCT 2019],	[NOV 2019],	[DEC 2019],
			[JAN 2020],	[FEB 2020],	[MAR 2020],	[APR 2020],	[MAY 2020],	[JUN 2020],	[JUL 2020],	[AUG 2020],	[SEP 2020],	[OCT 2020],	[NOV 2020],	[DEC 2020],
			[Q1 2008],	[Q2 2008],	[Q3 2008],	[Q4 2008],	[Q1 2009],	[Q2 2009],	[Q3 2009],	[Q4 2009],	[Q1 2010],	[Q2 2010],	[Q3 2010],	[Q4 2010],
			[Q1 2011],	[Q2 2011],	[Q3 2011],	[Q4 2011],	[Q1 2012],	[Q2 2012],	[Q3 2012],	[Q4 2012],	[Q1 2013],	[Q2 2013],	[Q3 2013],	[Q4 2013],
			[Q1 2014],	[Q2 2014],	[Q3 2014],	[Q4 2014],	[Q1 2015],	[Q2 2015],	[Q3 2015],	[Q4 2015],	[Q1 2016],	[Q2 2016],	[Q3 2016],	[Q4 2016],
			[Q1 2017],	[Q2 2017],	[Q3 2017],	[Q4 2017],	[Q1 2018],	[Q2 2018],	[Q3 2018],	[Q4 2018],	[Q1 2019],	[Q2 2019],	[Q3 2019],	[Q4 2019],
			[Q1 2020],	[Q2 2020],	[Q3 2020],	[Q4 2020],	[Q1 2021],	[Q2 2021],	[Q3 2021],	[Q4 2021],	[Q1 2022],  [Q2 2022],  [Q3 2022],  [Q4 2022],
			[Q1 2023],	[Q2 2023],	[Q3 2023],	[Q4 2023],	[Q1 2024],	[Q2 2024],	[Q3 2024],	[Q4 2024],	[Q1 2025],	[Q2 2025],	[Q3 2025],	[Q4 2025],
			[CY 2000],	[CY 2001],	[CY 2002],	[CY 2003],	[CY 2004],	[CY 2005],	[CY 2006],	[CY 2007],	[CY 2008],	[CY 2009],	[CY 2010],	[CY 2011],
			[CY 2012],	[CY 2013],	[CY 2014],	[CY 2015],	[CY 2016],	[CY 2017],	[CY 2018],	[CY 2019],	[CY 2020],  [CY 2021],  [CY 2022],  [CY 2023],
			[CY 2024],	[CY 2025]
	from	eeiuser.acctg_csm_naihs 
	where	release_id = @prior_release_id
			and version = 'Empire Adjustment'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting Empire Adjustment into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting Empire Adjustment into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end



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
