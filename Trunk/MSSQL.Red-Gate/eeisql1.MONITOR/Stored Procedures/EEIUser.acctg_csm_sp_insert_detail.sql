SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_insert_detail]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
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
-- Insert month/year CSM data from the spreadsheet for the current release
--  (Trigger will fire, updating the CSM warehouse (legacy) table)
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_detail'		
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'M' + right('0' + convert(varchar, month(dateadd(month, row_number() over (partition by Release_ID, 'CSM', [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))), 2)
,	EffectiveYear = year(dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = @CurrentRelease
	,	[Version] = 'CSM'
	,	[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]

	/*
	,	[Jan 2017] = convert(decimal(10, 2), coalesce(t.[Jan 2017], 0))
	,   [Feb 2017] = convert(decimal(10, 2), coalesce(t.[Feb 2017], 0))
	,   [Mar 2017] = convert(decimal(10, 2), coalesce(t.[Mar 2017], 0))
	,   [Apr 2017] = convert(decimal(10, 2), coalesce(t.[Apr 2017], 0))
	,   [May 2017] = convert(decimal(10, 2), coalesce(t.[May 2017], 0))
	,   [Jun 2017] = convert(decimal(10, 2), coalesce(t.[Jun 2017], 0))
	,   [Jul 2017] = convert(decimal(10, 2), coalesce(t.[Jul 2017], 0))
	,   [Aug 2017] = convert(decimal(10, 2), coalesce(t.[Aug 2017], 0))
	,   [Sep 2017] = convert(decimal(10, 2), coalesce(t.[Sep 2017], 0))
	,   [Oct 2017] = convert(decimal(10, 2), coalesce(t.[Oct 2017], 0))
	,   [Nov 2017] = convert(decimal(10, 2), coalesce(t.[Nov 2017], 0))
	,   [Dec 2017] = convert(decimal(10, 2), coalesce(t.[Dec 2017], 0))
	*/

	,	[Jan 2018] = convert(decimal(10, 2), coalesce(t.[Jan 2018], 0))
	,   [Feb 2018] = convert(decimal(10, 2), coalesce(t.[Feb 2018], 0))
	,   [Mar 2018] = convert(decimal(10, 2), coalesce(t.[Mar 2018], 0))
	,   [Apr 2018] = convert(decimal(10, 2), coalesce(t.[Apr 2018], 0))
	,   [May 2018] = convert(decimal(10, 2), coalesce(t.[May 2018], 0))
	,   [Jun 2018] = convert(decimal(10, 2), coalesce(t.[Jun 2018], 0))
	,   [Jul 2018] = convert(decimal(10, 2), coalesce(t.[Jul 2018], 0))
	,   [Aug 2018] = convert(decimal(10, 2), coalesce(t.[Aug 2018], 0))
	,   [Sep 2018] = convert(decimal(10, 2), coalesce(t.[Sep 2018], 0))
	,   [Oct 2018] = convert(decimal(10, 2), coalesce(t.[Oct 2018], 0))
	,   [Nov 2018] = convert(decimal(10, 2), coalesce(t.[Nov 2018], 0))
	,   [Dec 2018] = convert(decimal(10, 2), coalesce(t.[Dec 2018], 0))

	,	[Jan 2019] = convert(decimal(10, 2), coalesce(t.[Jan 2019], 0))
	,   [Feb 2019] = convert(decimal(10, 2), coalesce(t.[Feb 2019], 0))
	,   [Mar 2019] = convert(decimal(10, 2), coalesce(t.[Mar 2019], 0))
	,   [Apr 2019] = convert(decimal(10, 2), coalesce(t.[Apr 2019], 0))
	,   [May 2019] = convert(decimal(10, 2), coalesce(t.[May 2019], 0))
	,   [Jun 2019] = convert(decimal(10, 2), coalesce(t.[Jun 2019], 0))
	,   [Jul 2019] = convert(decimal(10, 2), coalesce(t.[Jul 2019], 0))
	,   [Aug 2019] = convert(decimal(10, 2), coalesce(t.[Aug 2019], 0))
	,   [Sep 2019] = convert(decimal(10, 2), coalesce(t.[Sep 2019], 0))
	,   [Oct 2019] = convert(decimal(10, 2), coalesce(t.[Oct 2019], 0))
	,   [Nov 2019] = convert(decimal(10, 2), coalesce(t.[Nov 2019], 0))
	,   [Dec 2019] = convert(decimal(10, 2), coalesce(t.[Dec 2019], 0))

	,	[Jan 2020] = convert(decimal(10, 2), coalesce(t.[Jan 2020], 0))
	,   [Feb 2020] = convert(decimal(10, 2), coalesce(t.[Feb 2020], 0))
	,   [Mar 2020] = convert(decimal(10, 2), coalesce(t.[Mar 2020], 0))
	,   [Apr 2020] = convert(decimal(10, 2), coalesce(t.[Apr 2020], 0))
	,   [May 2020] = convert(decimal(10, 2), coalesce(t.[May 2020], 0))
	,   [Jun 2020] = convert(decimal(10, 2), coalesce(t.[Jun 2020], 0))
	,   [Jul 2020] = convert(decimal(10, 2), coalesce(t.[Jul 2020], 0))
	,   [Aug 2020] = convert(decimal(10, 2), coalesce(t.[Aug 2020], 0))
	,   [Sep 2020] = convert(decimal(10, 2), coalesce(t.[Sep 2020], 0))
	,   [Oct 2020] = convert(decimal(10, 2), coalesce(t.[Oct 2020], 0))
	,   [Nov 2020] = convert(decimal(10, 2), coalesce(t.[Nov 2020], 0))
	,   [Dec 2020] = convert(decimal(10, 2), coalesce(t.[Dec 2020], 0))

	,	[Jan 2021] = convert(decimal(10, 2), coalesce(t.[Jan 2021], 0))
	,   [Feb 2021] = convert(decimal(10, 2), coalesce(t.[Feb 2021], 0))
	,   [Mar 2021] = convert(decimal(10, 2), coalesce(t.[Mar 2021], 0))
	,   [Apr 2021] = convert(decimal(10, 2), coalesce(t.[Apr 2021], 0))
	,   [May 2021] = convert(decimal(10, 2), coalesce(t.[May 2021], 0))
	,   [Jun 2021] = convert(decimal(10, 2), coalesce(t.[Jun 2021], 0))
	,   [Jul 2021] = convert(decimal(10, 2), coalesce(t.[Jul 2021], 0))
	,   [Aug 2021] = convert(decimal(10, 2), coalesce(t.[Aug 2021], 0))
	,   [Sep 2021] = convert(decimal(10, 2), coalesce(t.[Sep 2021], 0))
	,   [Oct 2021] = convert(decimal(10, 2), coalesce(t.[Oct 2021], 0))
	,   [Nov 2021] = convert(decimal(10, 2), coalesce(t.[Nov 2021], 0))
	,   [Dec 2021] = convert(decimal(10, 2), coalesce(t.[Dec 2021], 0))
from
	dbo.tempCSM t
	join eeiuser.acctg_csm_NAIHS_header h
		on h.Release_ID = @CurrentRelease
		and h.Version = 'CSM'
		and h.[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
	/*
		[Jan 2017]
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

		[Jan 2018]
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
	)
) as unpivoted

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>	



-- Insert quarterly CSM data from the spreadsheet for the current release
--  (Trigger will fire, updating the CSM warehouse (legacy) table)
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_detail'	
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'Q' + convert(varchar, datepart(quarter, dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')))
,	EffectiveYear = year(dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = @CurrentRelease
	,	[Version] = 'CSM'
	,	[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]								 
	/*
	,	[Q1 2017] = convert(decimal(10, 2), coalesce(t.[Q1 2017], 0))
	,   [Q2 2017] = convert(decimal(10, 2), coalesce(t.[Q2 2017], 0))
	,   [Q3 2017] = convert(decimal(10, 2), coalesce(t.[Q3 2017], 0))
	,   [Q4 2017] = convert(decimal(10, 2), coalesce(t.[Q4 2017], 0))
	*/													 
	,	[Q1 2018] = convert(decimal(10, 2), coalesce(t.[Q1 2018], 0))
	,   [Q2 2018] = convert(decimal(10, 2), coalesce(t.[Q2 2018], 0))
	,   [Q3 2018] = convert(decimal(10, 2), coalesce(t.[Q3 2018], 0))
	,   [Q4 2018] = convert(decimal(10, 2), coalesce(t.[Q4 2018], 0))
														 
	,	[Q1 2019] = convert(decimal(10, 2), coalesce(t.[Q1 2019], 0))
	,   [Q2 2019] = convert(decimal(10, 2), coalesce(t.[Q2 2019], 0))
	,   [Q3 2019] = convert(decimal(10, 2), coalesce(t.[Q3 2019], 0))
	,   [Q4 2019] = convert(decimal(10, 2), coalesce(t.[Q4 2019], 0))
														 
	,	[Q1 2020] = convert(decimal(10, 2), coalesce(t.[Q1 2020], 0))
	,   [Q2 2020] = convert(decimal(10, 2), coalesce(t.[Q2 2020], 0))
	,   [Q3 2020] = convert(decimal(10, 2), coalesce(t.[Q3 2020], 0))
	,   [Q4 2020] = convert(decimal(10, 2), coalesce(t.[Q4 2020], 0))
														 
	,	[Q1 2021] = convert(decimal(10, 2), coalesce(t.[Q1 2021], 0))
	,   [Q2 2021] = convert(decimal(10, 2), coalesce(t.[Q2 2021], 0))
	,   [Q3 2021] = convert(decimal(10, 2), coalesce(t.[Q3 2021], 0))
	,   [Q4 2021] = convert(decimal(10, 2), coalesce(t.[Q4 2021], 0))
														 
	,	[Q1 2022] = convert(decimal(10, 2), coalesce(t.[Q1 2022], 0))
	,   [Q2 2022] = convert(decimal(10, 2), coalesce(t.[Q2 2022], 0))
	,   [Q3 2022] = convert(decimal(10, 2), coalesce(t.[Q3 2022], 0))
	,   [Q4 2022] = convert(decimal(10, 2), coalesce(t.[Q4 2022], 0))
			  											 
	,	[Q1 2023] = convert(decimal(10, 2), coalesce(t.[Q1 2023], 0))
	,   [Q2 2023] = convert(decimal(10, 2), coalesce(t.[Q2 2023], 0))
	,   [Q3 2023] = convert(decimal(10, 2), coalesce(t.[Q3 2023], 0))
	,   [Q4 2023] = convert(decimal(10, 2), coalesce(t.[Q4 2023], 0))
			  											 
	,	[Q1 2024] = convert(decimal(10, 2), coalesce(t.[Q1 2024], 0))
	,   [Q2 2024] = convert(decimal(10, 2), coalesce(t.[Q2 2024], 0))
	,   [Q3 2024] = convert(decimal(10, 2), coalesce(t.[Q3 2024], 0))
	,   [Q4 2024] = convert(decimal(10, 2), coalesce(t.[Q4 2024], 0))
			 											 
	,	[Q1 2025] = convert(decimal(10, 2), coalesce(t.[Q1 2025], 0))
	,   [Q2 2025] = convert(decimal(10, 2), coalesce(t.[Q2 2025], 0))
	,   [Q3 2025] = convert(decimal(10, 2), coalesce(t.[Q3 2025], 0))
	,   [Q4 2025] = convert(decimal(10, 2), coalesce(t.[Q4 2025], 0))

	,	[Q1 2026] = convert(decimal(10, 2), coalesce(t.[Q1 2026], 0))
	,   [Q2 2026] = convert(decimal(10, 2), coalesce(t.[Q2 2026], 0))
	,   [Q3 2026] = convert(decimal(10, 2), coalesce(t.[Q3 2026], 0))
	,   [Q4 2026] = convert(decimal(10, 2), coalesce(t.[Q4 2026], 0))

from
	dbo.tempCSM t
	join eeiuser.acctg_csm_NAIHS_header h
		on h.Release_ID = @CurrentRelease
		and h.Version = 'CSM'
		and h.[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
	/*
		[Q1 2017]
	,   [Q2 2017]
	,   [Q3 2017]
	,   [Q4 2017]
	*/	
		[Q1 2018]
	,   [Q2 2018]
	,   [Q3 2018]
	,   [Q4 2018]
		
	,	[Q1 2019]
	,   [Q2 2019]
	,   [Q3 2019]
	,   [Q4 2019]
		
	,	[Q1 2020]
	,   [Q2 2020]
	,   [Q3 2020]
	,   [Q4 2020]
		
	,	[Q1 2021]
	,   [Q2 2021]
	,   [Q3 2021]
	,   [Q4 2021]
		
	,	[Q1 2022]
	,   [Q2 2022]
	,   [Q3 2022]
	,   [Q4 2022]
				  
	,	[Q1 2023]
	,   [Q2 2023]
	,   [Q3 2023]
	,   [Q4 2023]
				  
	,	[Q1 2024]
	,   [Q2 2024]
	,   [Q3 2024]
	,   [Q4 2024]
				 
	,	[Q1 2025]
	,   [Q2 2025]
	,   [Q3 2025]
	,   [Q4 2025]

	,	[Q1 2026]
	,   [Q2 2026]
	,   [Q3 2026]
	,   [Q4 2026]
	)
) as unpivoted


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




-- Insert yearly CSM data from the spreadsheet for the current release
--  (Trigger will fire, updating the CSM warehouse (legacy) table)
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_detail'	
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'CY'
,	EffectiveYear = year(dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = @CurrentRelease
	,	[Version] = 'CSM'
	,	[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]	

--	,   [CY 2017] = convert(decimal(10, 2), coalesce(t.[CY 2017], 0))
	,   [CY 2018] = convert(decimal(10, 2), coalesce(t.[CY 2018], 0))
	,   [CY 2019] = convert(decimal(10, 2), coalesce(t.[CY 2019], 0))
	,   [CY 2020] = convert(decimal(10, 2), coalesce(t.[CY 2020], 0))
	,   [CY 2021] = convert(decimal(10, 2), coalesce(t.[CY 2021], 0))
	,   [CY 2022] = convert(decimal(10, 2), coalesce(t.[CY 2022], 0))
	,   [CY 2023] = convert(decimal(10, 2), coalesce(t.[CY 2023], 0))
	,   [CY 2024] = convert(decimal(10, 2), coalesce(t.[CY 2024], 0))
	,   [CY 2025] = convert(decimal(10, 2), coalesce(t.[CY 2025], 0))
	,   [CY 2026] = convert(decimal(10, 2), coalesce(t.[CY 2026], 0))

from
	dbo.tempCSM t
	join eeiuser.acctg_csm_NAIHS_header h
		on h.Release_ID = @CurrentRelease
		and h.Version = 'CSM'
		and h.[Mnemonic-Vehicle/Plant] = t.[Mnemonic-Vehicle/Plant]
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
--	    [CY 2017]
	    [CY 2018]
	,   [CY 2019]
	,   [CY 2020]
	,   [CY 2021]
	,   [CY 2022]
	,   [CY 2023]
	,   [CY 2024]
	,   [CY 2025]
	,   [CY 2026]
	)
) as unpivoted


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
