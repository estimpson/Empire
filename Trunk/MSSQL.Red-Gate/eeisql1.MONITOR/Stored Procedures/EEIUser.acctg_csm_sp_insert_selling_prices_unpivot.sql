SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_insert_selling_prices_unpivot]
	@release_id varchar(25),
	@base_part varchar(25),
	@sp decimal(8,4)
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
	@Version varchar(25) = 'Current Selling Price'
,	@ID int = null


set	@TableName = 'eeiuser.acctg_csm_selling_prices_header'
insert into eeiuser.acctg_csm_selling_prices_header
(
	Release_ID
,	Row_ID
,	BasePart
,	[Version]
)
select
	@release_id
,	1
,	@base_part
,	@Version

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

	set	@TableName = 'eeiuser.acctg_csm_selling_prices_detail'
	insert
		eeiuser.acctg_csm_selling_prices_detail
	(
		Header_ID
	,	Release_ID
	,	Row_ID
	,	BasePart
	,	[Version]
	,	[Period]
	,	EffectiveYear
	,	EffectiveDT
	,	SellingPrice
	)
	values
		(@ID, @release_id, 1, @base_part, @Version, 'M01', 2008, '20080101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2008, '20080201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2008, '20080301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2008, '20080401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2008, '20080501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2008, '20080601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2008, '20080701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2008, '20080801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2008, '20080901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2008, '20081001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2008, '20081101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2008, '20081201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2009, '20090101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2009, '20090201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2009, '20090301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2009, '20090401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2009, '20090501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2009, '20090601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2009, '20090701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2009, '20090801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2009, '20090901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2009, '20091001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2009, '20091101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2009, '20091201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2010, '20100101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2010, '20100201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2010, '20100301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2010, '20100401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2010, '20100501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2010, '20100601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2010, '20100701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2010, '20100801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2010, '20100901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2010, '20101001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2010, '20101101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2010, '20101201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2011, '20110101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2011, '20110201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2011, '20110301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2011, '20110401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2011, '20110501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2011, '20110601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2011, '20110701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2011, '20110801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2011, '20110901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2011, '20111001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2011, '20111101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2011, '20111201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2012, '20120101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2012, '20120201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2012, '20120301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2012, '20120401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2012, '20120501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2012, '20120601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2012, '20120701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2012, '20120801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2012, '20120901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2012, '20121001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2012, '20121101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2012, '20121201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2013, '20130101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2013, '20130201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2013, '20130301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2013, '20130401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2013, '20130501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2013, '20130601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2013, '20130701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2013, '20130801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2013, '20130901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2013, '20131001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2013, '20131101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2013, '20131201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2014, '20140101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2014, '20140201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2014, '20140301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2014, '20140401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2014, '20140501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2014, '20140601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2014, '20140701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2014, '20140801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2014, '20140901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2014, '20141001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2014, '20141101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2014, '20141201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2015, '20150101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2015, '20150201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2015, '20150301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2015, '20150401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2015, '20150501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2015, '20150601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2015, '20150701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2015, '20150801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2015, '20150901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2015, '20151001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2015, '20151101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2015, '20151201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2016, '20160101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2016, '20160201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2016, '20160301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2016, '20160401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2016, '20160501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2016, '20160601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2016, '20160701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2016, '20160801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2016, '20160901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2016, '20161001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2016, '20161101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2016, '20161201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2017, '20170101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2017, '20170201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2017, '20170301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2017, '20170401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2017, '20170501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2017, '20170601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2017, '20170701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2017, '20170801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2017, '20170901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2017, '20171001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2017, '20171101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2017, '20171201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2018, '20180101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2018, '20180201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2018, '20180301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2018, '20180401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2018, '20180501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2018, '20180601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2018, '20180701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2018, '20180801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2018, '20180901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2018, '20181001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2018, '20181101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2018, '20181201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2019, '20190101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2019, '20190201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2019, '20190301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2019, '20190401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2019, '20190501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2019, '20190601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2019, '20190701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2019, '20190801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2019, '20190901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2019, '20191001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2019, '20191101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2019, '20191201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2020, '20200101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2020, '20200201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2020, '20200301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2020, '20200401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2020, '20200501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2020, '20200601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2020, '20200701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2020, '20200801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2020, '20200901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2020, '20201001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2020, '20201101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2020, '20201201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'M01', 2021, '20210101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M02', 2021, '20210201', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M03', 2021, '20210301', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M04', 2021, '20210401', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M05', 2021, '20210501', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M06', 2021, '20210601', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M07', 2021, '20210701', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M08', 2021, '20210801', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M09', 2021, '20210901', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M10', 2021, '20211001', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M11', 2021, '20211101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'M12', 2021, '20211201', @sp )

	,	(@ID, @release_id, 1, @base_part, @Version, 'CY', 2022, '20220101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'CY', 2023, '20230101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'CY', 2024, '20240101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'CY', 2025, '20250101', @sp )
	,	(@ID, @release_id, 1, @base_part, @Version, 'CY', 2026, '20260101', @sp )


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
