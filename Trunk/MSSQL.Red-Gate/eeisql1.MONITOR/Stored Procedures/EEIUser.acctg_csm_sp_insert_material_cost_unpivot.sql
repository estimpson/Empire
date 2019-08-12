SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_insert_material_cost_unpivot]
	@base_part varchar(50),      
	@release_id varchar(15),
	@row_id int,
    @version varchar(30),
	@inclusion varchar(50),
	@partusedforcost varchar(50),

	@jan_15 decimal(10,6), 
    @feb_15 decimal(10,6), 
    @mar_15 decimal(10,6), 
    @apr_15 decimal(10,6), 
    @may_15 decimal(10,6), 
    @jun_15 decimal(10,6), 
    @jul_15 decimal(10,6), 
    @aug_15 decimal(10,6), 
    @sep_15 decimal(10,6), 
    @oct_15 decimal(10,6), 
    @nov_15 decimal(10,6), 
    @dec_15 decimal(10,6),
    @Total_2015 decimal(10,6),
    
	@jan_16 decimal(10,6), 
    @feb_16 decimal(10,6), 
    @mar_16 decimal(10,6), 
    @apr_16 decimal(10,6), 
    @may_16 decimal(10,6), 
    @jun_16 decimal(10,6), 
    @jul_16 decimal(10,6), 
    @aug_16 decimal(10,6), 
    @sep_16 decimal(10,6), 
    @oct_16 decimal(10,6), 
    @nov_16 decimal(10,6), 
    @dec_16 decimal(10,6),
    @Total_2016 decimal(10,6),
	     
	@jan_17 decimal(10,6), 
    @feb_17 decimal(10,6), 
    @mar_17 decimal(10,6), 
    @apr_17 decimal(10,6), 
    @may_17 decimal(10,6), 
    @jun_17 decimal(10,6), 
    @jul_17 decimal(10,6), 
    @aug_17 decimal(10,6), 
    @sep_17 decimal(10,6), 
    @oct_17 decimal(10,6), 
    @nov_17 decimal(10,6), 
    @dec_17 decimal(10,6),
    @Total_2017 decimal(10,6),

	@jan_18 decimal(10,6), 
    @feb_18 decimal(10,6), 
    @mar_18 decimal(10,6), 
    @apr_18 decimal(10,6), 
    @may_18 decimal(10,6), 
    @jun_18 decimal(10,6), 
    @jul_18 decimal(10,6), 
    @aug_18 decimal(10,6), 
    @sep_18 decimal(10,6), 
    @oct_18 decimal(10,6), 
    @nov_18 decimal(10,6), 
    @dec_18 decimal(10,6),
    @Total_2018 decimal(10,6),

	     
	@jan_19 decimal(10,6), 
    @feb_19 decimal(10,6), 
    @mar_19 decimal(10,6), 
    @apr_19 decimal(10,6), 
    @may_19 decimal(10,6), 
    @jun_19 decimal(10,6), 
    @jul_19 decimal(10,6), 
    @aug_19 decimal(10,6), 
    @sep_19 decimal(10,6), 
    @oct_19 decimal(10,6), 
    @nov_19 decimal(10,6), 
    @dec_19 decimal(10,6),
    @Total_2019 decimal(10,6),
  
	@jan_20 decimal(10,6), 
    @feb_20 decimal(10,6), 
    @mar_20 decimal(10,6), 
    @apr_20 decimal(10,6), 
    @may_20 decimal(10,6), 
    @jun_20 decimal(10,6), 
    @jul_20 decimal(10,6), 
    @aug_20 decimal(10,6), 
    @sep_20 decimal(10,6), 
    @oct_20 decimal(10,6), 
    @nov_20 decimal(10,6), 
    @dec_20 decimal(10,6),
    @Total_2020 decimal(10,6),

	@jan_21 decimal(10,6), 
    @feb_21 decimal(10,6), 
    @mar_21 decimal(10,6), 
    @apr_21 decimal(10,6), 
    @may_21 decimal(10,6), 
    @jun_21 decimal(10,6), 
    @jul_21 decimal(10,6), 
    @aug_21 decimal(10,6), 
    @sep_21 decimal(10,6), 
    @oct_21 decimal(10,6), 
    @nov_21 decimal(10,6), 
    @dec_21 decimal(10,6),
    @Total_2021 decimal(10,6),

    @Total_2022 decimal(10,6), 
    @Total_2023 decimal(10,6), 
    @Total_2024 decimal(10,6), 
    @Total_2025 decimal(10,6),
	@Total_2026 decimal(10,6) 
as
set nocount on
set ansi_warnings on

declare
	@Result int
,	@TranDT datetime

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
declare 
	@ID int = null


set	@TableName = 'eeiuser.acctg_csm_material_cost_header'
insert into eeiuser.acctg_csm_material_cost_header
(
	Release_ID
,	Row_ID
,	BasePart
,	[Version]
,	Inclusion
,	PartUsedForCost
)
select
	@release_id
,	@row_id
,	@base_part      
,   @version
,	@inclusion
,	@partusedforcost


set @ID = scope_identity()

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end


if (@ID is not null) begin

	set	@TableName = 'eeiuser.acctg_csm_material_cost_detail'
	insert
		eeiuser.acctg_csm_material_cost_detail
	(
		Header_ID
	,	Release_ID
	,	Row_ID
	,	BasePart
	,	[Version]
	,	PartUsedForCost
	,	[Period]
	,	EffectiveYear
	,	EffectiveDT
	,	MaterialCost
	)
	values
		(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2015, '20150101', @jan_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2015, '20150201', @feb_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2015, '20150301', @mar_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2015, '20150401', @apr_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2015, '20150501', @may_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2015, '20150601', @jun_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2015, '20150701', @jul_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2015, '20150801', @aug_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2015, '20150901', @sep_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2015, '20151001', @oct_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2015, '20151101', @nov_15 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2015, '20151201', @dec_15 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2016, '20160101', @jan_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2016, '20160201', @feb_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2016, '20160301', @mar_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2016, '20160401', @apr_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2016, '20160501', @may_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2016, '20160601', @jun_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2016, '20160701', @jul_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2016, '20160801', @aug_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2016, '20160901', @sep_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2016, '20161001', @oct_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2016, '20161101', @nov_16 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2016, '20161201', @dec_16 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2017, '20170101', @jan_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2017, '20170201', @feb_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2017, '20170301', @mar_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2017, '20170401', @apr_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2017, '20170501', @may_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2017, '20170601', @jun_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2017, '20170701', @jul_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2017, '20170801', @aug_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2017, '20170901', @sep_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2017, '20171001', @oct_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2017, '20171101', @nov_17 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2017, '20171201', @dec_17 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2018, '20180101', @jan_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2018, '20180201', @feb_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2018, '20180301', @mar_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2018, '20180401', @apr_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2018, '20180501', @may_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2018, '20180601', @jun_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2018, '20180701', @jul_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2018, '20180801', @aug_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2018, '20180901', @sep_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2018, '20181001', @oct_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2018, '20181101', @nov_18 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2018, '20181201', @dec_18 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2019, '20190101', @jan_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2019, '20190201', @feb_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2019, '20190301', @mar_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2019, '20190401', @apr_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2019, '20190501', @may_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2019, '20190601', @jun_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2019, '20190701', @jul_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2019, '20190801', @aug_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2019, '20190901', @sep_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2019, '20191001', @oct_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2019, '20191101', @nov_19 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2019, '20191201', @dec_19 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2020, '20200101', @jan_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2020, '20200201', @feb_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2020, '20200301', @mar_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2020, '20200401', @apr_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2020, '20200501', @may_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2020, '20200601', @jun_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2020, '20200701', @jul_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2020, '20200801', @aug_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2020, '20200901', @sep_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2020, '20201001', @oct_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2020, '20201101', @nov_20 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2020, '20201201', @dec_20 )

	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M01', 2021, '20210101', @jan_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M02', 2021, '20210201', @feb_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M03', 2021, '20210301', @mar_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M04', 2021, '20210401', @apr_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M05', 2021, '20210501', @may_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M06', 2021, '20210601', @jun_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M07', 2021, '20210701', @jul_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M08', 2021, '20210801', @aug_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M09', 2021, '20210901', @sep_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M10', 2021, '20211001', @oct_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M11', 2021, '20211101', @nov_21 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'M12', 2021, '20211201', @dec_21 )


	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'CY', 2022, '20220101', @Total_2022 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'CY', 2023, '20230101', @Total_2023 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'CY', 2024, '20240101', @Total_2024 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'CY', 2025, '20250101', @Total_2025 )
	,	(@ID, @release_id, @row_id, @base_part, @Version, @partusedforcost, 'CY', 2026, '20260101', @Total_2026 )


	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end

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
