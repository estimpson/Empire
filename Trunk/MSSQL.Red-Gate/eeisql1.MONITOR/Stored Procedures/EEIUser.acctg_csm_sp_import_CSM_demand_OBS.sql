SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- select distinct(Release_id) from eeiuser.acctg_csm_naihs order by 1 desc
-- exec eeiuser.acctg_csm_sp_import_CSM_demand '2016-08','CSM'

CREATE procedure [EEIUser].[acctg_csm_sp_import_CSM_demand_OBS]
	@Release_ID char(7) -- eg. '2012-04'
,	@Version varchar(30) = 'CSM'
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
/*  Temp table must exist.  (The new import method uses an application to create a temp table and insert raw data into it.)  */  
if not exists (
		select
			1
		from
			sys.tables
		where
			name = 'tempCSM' ) begin
	
	set	@Result = 999500
	RAISERROR ('Data import failed.  The tempCSM table does not exist.', 16, 1)
	rollback tran @ProcName
	return	
end

/*  Imported data cannot be duplicated.  */
if exists (
		select
			*
		from
			EEIUser.acctg_csm_NAIHS n
			join tempCSM t
				on n.Release_ID = @Release_ID
				and n.[Version] = @Version
				and n.[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant] ) begin

	set	@Result = 999501
	RAISERROR ('Data import failed.  One or more records have already been imported.  (At least one match on Release ID, Version and Mnemonic-Vehicle/Plant was found in the database.)', 16, 1)
	rollback tran @ProcName
	return	
end
---	</ArgumentValidation>


--- <Body>  
/*
-- ***** This import method is obsolete *****

if	objectproperty(object_id('tempdb..CSMTEMP'), 'IsTable') is null begin
	drop table tempdb..CSMTEMP
end

select
	*
into
	tempdb..CSMTEMP
from
	openrowset
		(	'MSDASQL'
		,	'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DefaultDir=C:\Monitor4'
		,	'select * from CSM.csv'
		)
*/



--- <Insert rows="1+">
set	@TableName = 'MONITOR.eeiuser.acctg_csm_NAIHS'
insert
	MONITOR.eeiuser.acctg_csm_NAIHS
(	[Release_ID]
,	[Version]
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
,	[Platform]
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
/*
,	[Jan 2016]
,	[Feb 2016]
,	[Mar 2016]
,	[Apr 2016]
,	[May 2016]
,	[Jun 2016]
,	[Jul 2016]
,	[Aug 2016]
,	[Sep 2016]
,	[Oct 2016]
,	[Nov 2016]
,	[Dec 2016]
,	[Jan 2017]
,	[Feb 2017]
,	[Mar 2017]
,	[Apr 2017]
,	[May 2017]
,	[Jun 2017]
,	[Jul 2017]
,	[Aug 2017]
,	[Sep 2017]
,	[Oct 2017]
,	[Nov 2017]
,	[Dec 2017]
*/
,	[Jan 2018]
,	[Feb 2018]
,	[Mar 2018]
,	[Apr 2018]
,	[May 2018]
,	[Jun 2018]
,	[Jul 2018]
,	[Aug 2018]
,	[Sep 2018]
,	[Oct 2018]
,	[Nov 2018]
,	[Dec 2018]
,	[Jan 2019]
,	[Feb 2019]
,	[Mar 2019]
,	[Apr 2019]
,	[May 2019]
,	[Jun 2019]
,	[Jul 2019]
,	[Aug 2019]
,	[Sep 2019]
,	[Oct 2019]
,	[Nov 2019]
,	[Dec 2019]
,	[Jan 2020]
,	[Feb 2020]
,	[Mar 2020]
,	[Apr 2020]
,	[May 2020]
,	[Jun 2020]
,	[Jul 2020]
,	[Aug 2020]
,	[Sep 2020]
,	[Oct 2020]
,	[Nov 2020]
,	[Dec 2020]
,	[Jan 2021]
,	[Feb 2021]
,	[Mar 2021]
,	[Apr 2021]
,	[May 2021]
,	[Jun 2021]
,	[Jul 2021]
,	[Aug 2021]
,	[Sep 2021]
,	[Oct 2021]
,	[Nov 2021]
,	[Dec 2021]


/*
,	[Q1 2016]
,	[Q2 2016]
,	[Q3 2016]
,	[Q4 2016]
,	[Q1 2017]
,	[Q2 2017]
,	[Q3 2017]
,	[Q4 2017]
*/
,	[Q1 2018]
,	[Q2 2018]
,	[Q3 2018]
,	[Q4 2018]
,	[Q1 2019]
,	[Q2 2019]
,	[Q3 2019]
,	[Q4 2019]
,	[Q1 2020]
,	[Q2 2020]
,	[Q3 2020]
,	[Q4 2020]
,	[Q1 2021]
,	[Q2 2021]
,	[Q3 2021]
,	[Q4 2021]
,	[Q1 2022]
,	[Q2 2022]
,	[Q3 2022]
,	[Q4 2022]
,	[Q1 2023]
,	[Q2 2023]
,	[Q3 2023]
,	[Q4 2023]
,	[Q1 2024]
,	[Q2 2024]
,	[Q3 2024]
,	[Q4 2024]
,	[Q1 2025]
,	[Q2 2025]
,	[Q3 2025]
,	[Q4 2025]
,	[Q1 2026]
,	[Q2 2026]
,	[Q3 2026]
,	[Q4 2026]
--,	[CY 2016]
--,	[CY 2017]
,	[CY 2018]
,	[CY 2019]
,	[CY 2020]
,	[CY 2021]
,	[CY 2022]
,	[CY 2023]
,	[CY 2024]
,	[CY 2025]
,	[CY 2026])
select
	@Release_ID
,	@Version
,	c.[Mnemonic-Vehicle]
,   c.[Mnemonic-Vehicle/Plant]
,   c.[Mnemonic-Platform]
,   c.Region
,   c.Market
,   c.Country
,   c.[Production Plant]
,   c.City
,   c.[Plant State/Province]
,   c.[Source Plant]
,   c.[Source Plant Country]
,   c.[Source Plant Region]
,   c.[Design Parent]
,   c.[Engineering Group]
,   c.[Manufacturer Group]
,   c.Manufacturer
,   c.[Sales Parent]
,   c.[Production Brand]
,   c.[Platform Design Owner]
,   c.Architecture
,   c.Platform
,   c.Program
,   c.[Production Nameplate]
,   [SOP] = convert(datetime, c.[SOP (Start of Production)] + '-01')
,   [EOP] = convert(datetime, c.[EOP (End of Production)] + '-01')
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
,   c.[Short-Term Risk Rating]
,   c.[Long-Term Risk Rating]
/*
,   [Jan 2016] = dbo.udf_StringToInt(c.[Jan 2016])
,   [Feb 2016] = dbo.udf_StringToInt(c.[Feb 2016])
,   [Mar 2016] = dbo.udf_StringToInt(c.[Mar 2016])
,   [Apr 2016] = dbo.udf_StringToInt(c.[Apr 2016])
,   [May 2016] = dbo.udf_StringToInt(c.[May 2016])
,   [Jun 2016] = dbo.udf_StringToInt(c.[Jun 2016])
,   [Jul 2016] = dbo.udf_StringToInt(c.[Jul 2016])
,   [Aug 2016] = dbo.udf_StringToInt(c.[Aug 2016])
,   [Sep 2016] = dbo.udf_StringToInt(c.[Sep 2016])
,   [Oct 2016] = dbo.udf_StringToInt(c.[Oct 2016])
,   [Nov 2016] = dbo.udf_StringToInt(c.[Nov 2016])
,   [Dec 2016] = dbo.udf_StringToInt(c.[Dec 2016])
,   [Jan 2017] = dbo.udf_StringToInt(c.[Jan 2017])
,   [Feb 2017] = dbo.udf_StringToInt(c.[Feb 2017])
,   [Mar 2017] = dbo.udf_StringToInt(c.[Mar 2017])
,   [Apr 2017] = dbo.udf_StringToInt(c.[Apr 2017])
,   [May 2017] = dbo.udf_StringToInt(c.[May 2017])
,   [Jun 2017] = dbo.udf_StringToInt(c.[Jun 2017])
,   [Jul 2017] = dbo.udf_StringToInt(c.[Jul 2017])
,   [Aug 2017] = dbo.udf_StringToInt(c.[Aug 2017])
,   [Sep 2017] = dbo.udf_StringToInt(c.[Sep 2017])
,   [Oct 2017] = dbo.udf_StringToInt(c.[Oct 2017])
,   [Nov 2017] = dbo.udf_StringToInt(c.[Nov 2017])
,   [Dec 2017] = dbo.udf_StringToInt(c.[Dec 2017])
*/
,   [Jan 2018] = dbo.udf_StringToInt(c.[Jan 2018])
,   [Feb 2018] = dbo.udf_StringToInt(c.[Feb 2018])
,   [Mar 2018] = dbo.udf_StringToInt(c.[Mar 2018])
,   [Apr 2018] = dbo.udf_StringToInt(c.[Apr 2018])
,   [May 2018] = dbo.udf_StringToInt(c.[May 2018])
,   [Jun 2018] = dbo.udf_StringToInt(c.[Jun 2018])
,   [Jul 2018] = dbo.udf_StringToInt(c.[Jul 2018])
,   [Aug 2018] = dbo.udf_StringToInt(c.[Aug 2018])
,   [Sep 2018] = dbo.udf_StringToInt(c.[Sep 2018])
,   [Oct 2018] = dbo.udf_StringToInt(c.[Oct 2018])
,   [Nov 2018] = dbo.udf_StringToInt(c.[Nov 2018])
,   [Dec 2018] = dbo.udf_StringToInt(c.[Dec 2018])
,   [Jan 2019] = dbo.udf_StringToInt(c.[Jan 2019])
,   [Feb 2019] = dbo.udf_StringToInt(c.[Feb 2019])
,   [Mar 2019] = dbo.udf_StringToInt(c.[Mar 2019])
,   [Apr 2019] = dbo.udf_StringToInt(c.[Apr 2019])
,   [May 2019] = dbo.udf_StringToInt(c.[May 2019])
,   [Jun 2019] = dbo.udf_StringToInt(c.[Jun 2019])
,   [Jul 2019] = dbo.udf_StringToInt(c.[Jul 2019])
,   [Aug 2019] = dbo.udf_StringToInt(c.[Aug 2019])
,   [Sep 2019] = dbo.udf_StringToInt(c.[Sep 2019])
,   [Oct 2019] = dbo.udf_StringToInt(c.[Oct 2019])
,   [Nov 2019] = dbo.udf_StringToInt(c.[Nov 2019])
,   [Dec 2019] = dbo.udf_StringToInt(c.[Dec 2019])

,   [Jan 2020] = dbo.udf_StringToInt(c.[Jan 2020])
,   [Feb 2020] = dbo.udf_StringToInt(c.[Feb 2020])
,   [Mar 2020] = dbo.udf_StringToInt(c.[Mar 2020])
,   [Apr 2020] = dbo.udf_StringToInt(c.[Apr 2020])
,   [May 2020] = dbo.udf_StringToInt(c.[May 2020])
,   [Jun 2020] = dbo.udf_StringToInt(c.[Jun 2020])
,   [Jul 2020] = dbo.udf_StringToInt(c.[Jul 2020])
,   [Aug 2020] = dbo.udf_StringToInt(c.[Aug 2020])
,   [Sep 2020] = dbo.udf_StringToInt(c.[Sep 2020])
,   [Oct 2020] = dbo.udf_StringToInt(c.[Oct 2020])
,   [Nov 2020] = dbo.udf_StringToInt(c.[Nov 2020])
,   [Dec 2020] = dbo.udf_StringToInt(c.[Dec 2020])

,   [Jan 2021] = dbo.udf_StringToInt(c.[Jan 2021])
,   [Feb 2021] = dbo.udf_StringToInt(c.[Feb 2021])
,   [Mar 2021] = dbo.udf_StringToInt(c.[Mar 2021])
,   [Apr 2021] = dbo.udf_StringToInt(c.[Apr 2021])
,   [May 2021] = dbo.udf_StringToInt(c.[May 2021])
,   [Jun 2021] = dbo.udf_StringToInt(c.[Jun 2021])
,   [Jul 2021] = dbo.udf_StringToInt(c.[Jul 2021])
,   [Aug 2021] = dbo.udf_StringToInt(c.[Aug 2021])
,   [Sep 2021] = dbo.udf_StringToInt(c.[Sep 2021])
,   [Oct 2021] = dbo.udf_StringToInt(c.[Oct 2021])
,   [Nov 2021] = dbo.udf_StringToInt(c.[Nov 2021])
,   [Dec 2021] = dbo.udf_StringToInt(c.[Dec 2021])















/*
,   [Q1 2016] = dbo.udf_StringToInt(c.[Q1 2016])
,   [Q2 2016] = dbo.udf_StringToInt(c.[Q2 2016])
,   [Q3 2016] = dbo.udf_StringToInt(c.[Q3 2016])
,   [Q4 2016] = dbo.udf_StringToInt(c.[Q4 2016])
,   [Q1 2017] = dbo.udf_StringToInt(c.[Q1 2017])
,   [Q2 2017] = dbo.udf_StringToInt(c.[Q2 2017])
,   [Q3 2017] = dbo.udf_StringToInt(c.[Q3 2017])
,   [Q4 2017] = dbo.udf_StringToInt(c.[Q4 2017])
*/
,   [Q1 2018] = dbo.udf_StringToInt(c.[Q1 2018])
,   [Q2 2018] = dbo.udf_StringToInt(c.[Q2 2018])
,   [Q3 2018] = dbo.udf_StringToInt(c.[Q3 2018])
,   [Q4 2018] = dbo.udf_StringToInt(c.[Q4 2018])
,   [Q1 2019] = dbo.udf_StringToInt(c.[Q1 2019])
,   [Q2 2019] = dbo.udf_StringToInt(c.[Q2 2019])
,   [Q3 2019] = dbo.udf_StringToInt(c.[Q3 2019])
,   [Q4 2019] = dbo.udf_StringToInt(c.[Q4 2019])
,   [Q1 2020] = dbo.udf_StringToInt(c.[Q1 2020])
,   [Q2 2020] = dbo.udf_StringToInt(c.[Q2 2020])
,   [Q3 2020] = dbo.udf_StringToInt(c.[Q3 2020])
,   [Q4 2020] = dbo.udf_StringToInt(c.[Q4 2020])
,   [Q1 2021] = dbo.udf_StringToInt(c.[Q1 2021])
,   [Q2 2021] = dbo.udf_StringToInt(c.[Q2 2021])
,   [Q3 2021] = dbo.udf_StringToInt(c.[Q3 2021])
,   [Q4 2021] = dbo.udf_StringToInt(c.[Q4 2021])
,   [Q1 2022] = dbo.udf_StringToInt(c.[Q1 2022])
,   [Q2 2022] = dbo.udf_StringToInt(c.[Q2 2022])
,   [Q3 2022] = dbo.udf_StringToInt(c.[Q3 2022])
,   [Q4 2022] = dbo.udf_StringToInt(c.[Q4 2022])
,   [Q1 2023] = dbo.udf_StringToInt(c.[Q1 2023])
,   [Q2 2023] = dbo.udf_StringToInt(c.[Q2 2023])
,   [Q3 2023] = dbo.udf_StringToInt(c.[Q3 2023])
,   [Q4 2023] = dbo.udf_StringToInt(c.[Q4 2023])
,   [Q1 2024] = dbo.udf_StringToInt(c.[Q1 2024])
,   [Q2 2024] = dbo.udf_StringToInt(c.[Q2 2024])
,   [Q3 2024] = dbo.udf_StringToInt(c.[Q3 2024])
,   [Q4 2024] = dbo.udf_StringToInt(c.[Q4 2024])
,   [Q1 2025] = dbo.udf_StringToInt(c.[Q1 2025])
,   [Q2 2025] = dbo.udf_StringToInt(c.[Q2 2025])
,   [Q3 2025] = dbo.udf_StringToInt(c.[Q3 2025])
,   [Q4 2025] = dbo.udf_StringToInt(c.[Q4 2025])
,   [Q1 2026] = dbo.udf_StringToInt(c.[Q1 2026])
,   [Q2 2026] = dbo.udf_StringToInt(c.[Q2 2026])
,   [Q3 2026] = dbo.udf_StringToInt(c.[Q3 2026])
,   [Q4 2026] = dbo.udf_StringToInt(c.[Q4 2026])

--,   [CY 2016] = dbo.udf_StringToInt(c.[CY 2016])
--,   [CY 2017] = dbo.udf_StringToInt(c.[CY 2017])
,   [CY 2018] = dbo.udf_StringToInt(c.[CY 2018])
,   [CY 2019] = dbo.udf_StringToInt(c.[CY 2019])
,   [CY 2020] = dbo.udf_StringToInt(c.[CY 2020])
,   [CY 2021] = dbo.udf_StringToInt(c.[CY 2021])
,   [CY 2022] = dbo.udf_StringToInt(c.[CY 2022])
,   [CY 2023] = dbo.udf_StringToInt(c.[CY 2023])
,   [CY 2024] = dbo.udf_StringToInt(c.[CY 2024])
,   [CY 2025] = dbo.udf_StringToInt(c.[CY 2025])
,	[CY 2026] = dbo.udf_StringToInt(c.[CY 2026])
from
	--tempdb..CSMTEMP c
	tempCSM c -- this temp table is created by the application


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
