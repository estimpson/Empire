SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_AuditTrailPostingWithGLCompare_PCB]
	@Period varchar(1000) = 'LMo' -- YTD (Year To Date), MTD (Month To Date), LMo (Last Month), 1Mo (One Month), Ja|JAN (January), Fe|FEB (February), Mr|MAR (March), Ap|APR (April), My|MAY (May), Je|JUN (June), Jy|JUL (July), Au|AUG (August), Se|SEP (September), Oc|OCT (October), No|NOV (November), De|DEC (December)
,	@Year int = null
,	@Month int = null
,	@FromDT datetime = null
,	@ToDT datetime = null
,	@Transactions varchar(25) = null
,	@Accounts varchar(1000) = null
,	@Parts varchar(1000) = null
,	@ProductLineGL varchar(1000) = '08'
as
set nocount on
set ansi_warnings off
if	@Period in ('?', 'Help') begin
	goto help
end

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

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=No>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
create table
	#PeriodBounds
(	Period varchar(1000)
,	FromDT datetime
,	ToDT datetime
)

insert
	#PeriodBounds
(	Period
,	FromDT
,	ToDT
)
select
	Period
,	FromDT
,	ToDT
from
	dbo.udf_GetPeriodBounds (@Period, @Year, @Month, @FromDT, @ToDT) PeriodBounds

create table
	#ATTypes
(	Type varchar(2) primary key
)

insert
	#ATTypes
(	Type)
select
	distinct Type = ltrim(rtrim(Value))
from
	FT.udf_SplitStringToRows(@Transactions, ',')
where
	@Transactions > ''

create table
	#parts
(	Part varchar(25)
)

insert
	#parts
(	Part
)
select
	distinct Type = ltrim(rtrim(Value))
from
	FT.udf_SplitStringToRows(@Parts, ',')
where
	@Parts > ''

create table
	#accounts
(	Account char(6) primary key
)

insert
	#accounts
(	Account)

select
	distinct Type = ltrim(rtrim(Value))
from
	FT.udf_SplitStringToRows(@Accounts, ',')
where
	@Accounts > ''

create table
	#productLineGLSegments
(	GLSegment varchar(10) primary key
)

insert
	#productLineGLSegments
(	GLSegment)
select
	distinct Type = ltrim(rtrim(Value))
from
	FT.udf_SplitStringToRows(@ProductLineGL, ',')
where
	@ProductLineGL > ''

select distinct
	bfh.TranDT
,	bfh.SerialProduced
,	bfd.SerialConsumed
into
	#productLineTransactions
from
	dbo.BackFlushHeaders bfh
	join dbo.BackFlushDetails bfd
		on bfd.BFID = bfh.ID
	join #PeriodBounds pb
		on bfh.TranDT >= pb.FromDT and bfh.TranDT < pb.ToDT
where
	bfh.PartProduced in
	(	select
			p.part
		from
			dbo.part p
		where
			p.product_line in
			(	select
					pl.id
				from
					dbo.product_line pl
				where
					pl.gl_segment in
					(	select
							plgls.GLSegment
						from
							#productLineGLSegments plgls
					)
			)
	)
	or bfd.PartConsumed in
	(	select
			p.part
		from
			dbo.part p
		where
			p.product_line in
			(	select
					pl.id
				from
					dbo.product_line pl
				where
					pl.gl_segment in
					(	select
							plgls.GLSegment
						from
							#productLineGLSegments plgls
					)
			)
	)

select
	Period = (select min(pb.Period) from #PeriodBounds pb where at.date_stamp >= pb.FromDT and at.date_stamp < pb.ToDT)
,	Serial = at.serial
,	TranDT = at.date_stamp
,	Operator = at.operator
,	Type = at.type
,	Remarks = at.remarks
,	Part = at.part
,	ProductLine = pl.id
,	PartType = coalesce(phd.type, p.type)
,	GLSegment = pl.gl_segment
,	FromLoc = at.from_loc
,	ToLoc = at.to_loc
,	StdQty = at.std_quantity
,	MaterialAccum = coalesce
	(	(select material_cum from dbo.part_standard_historical_daily where part = at.part and time_stamp = (select min(time_stamp) from dbo.part_standard_historical_daily where time_stamp > at.date_stamp))
	,	(select material_cum from dbo.part_standard where part = at.part)
	)
,	WODID = at.workorder
,	BackFlushID = group_no
,	Posted = posted
,	MaterialCr = mia.material_credit + pl.gl_segment
,	MaterialDr = mia.material_debit	+ pl.gl_segment
into
	#resultsAT
from
	eeh.dbo.audit_trail at with (readuncommitted)
	join dbo.part p
		on at.part = p.part
	left join dbo.part_historical_daily phd
		on phd.part = at.part
		and time_stamp = (select min(time_stamp) from dbo.part_historical_daily where time_stamp > at.date_stamp)
	join dbo.product_line pl
		on pl.id = coalesce(phd.product_line, p.product_line)
		and pl.gl_segment in
			(	select
					plgls.GLSegment
				from
					#productLineGLSegments plgls
			)
	left join dbo.monitor_inventory_accounts mia
		on mia.audit_trail_type = at.type
		and mia.part_type = p.type
		and mia.product_line = coalesce(phd.product_line, p.product_line)
		and mia.fiscal_year = datename(year, at.date_stamp)
where
	exists
	(	select
			*
		from
			#productLineTransactions plt
		where
			plt.TranDT = at.date_stamp
	) and
	(	@Transactions is null
		or exists
			(	select
					*
				from
					#ATTypes
				where
					Type = at.type
			)
	)

select
	Serial = convert(int, gct.document_id1)
,	TranDT = convert(datetime, gct.document_id2)
,	Type = gct.document_id3
,	DrAccount = max(case when gct.amount < 0 then null else gct.ledger_account end)
,	CrAccount = max(case when gct.amount < 0 then gct.ledger_account else null end)
,	Ledger = gct.ledger
,	ImportDT = gct.transaction_date
,	DrAmount = sum(case when gct.amount < 0 then 0 else gct.amount end)
,	CrAmount = sum(case when gct.amount < 0 then gct.amount else 0 end)
,	Part = gct.document_reference1
,	StdQuantity = gct.quantity
,	MaterialAccum = min(abs(gct.amount/gct.quantity))
,	Operator = gct.changed_user_id
into
	#resultsGL
from
	eeh.dbo.gl_cost_transactions gct with (readuncommitted)
	join #PeriodBounds pb
		on gct.transaction_date >= pb.FromDT and gct.transaction_date < pb.ToDT
where
	document_type = 'MON INV'
	--and isdate(gct.document_id2) = 1
	--and isnumeric(gct.document_id1) = 1
	and gct.document_line in (1,2)
	and exists
	(	select
			*
		from
			#productLineTransactions plt
		where
			plt.TranDT = convert(datetime, gct.document_id2)
	)
	and
	(	@Accounts is null
		or exists
			(	select
					*
				from
					#accounts
				where
					Account = gct.ledger_account
			)
	) 
group by
	gct.document_id1
,	gct.document_id2
,	gct.document_id3
,	gct.ledger
,	gct.transaction_date
,	gct.document_reference1
,	gct.quantity
,	gct.changed_user_id

declare
	@ResultSyntax nvarchar(max)

set	@ResultSyntax = N'
select
	AT.Period
,	AT.Serial
,	AT.TranDT
,	AT.Operator
,	AT.Type
,	AT.Remarks
,	AT.Part
,	AT.ProductLine
,	AT.PartType
,	AT.GLSegment
,	AT.FromLoc
,	AT.ToLoc
,	AT.StdQty
,	AT.MaterialAccum
,	AT.WODID
,	AT.BackFlushID
,	AT.Posted
,	AT.MaterialDr
,	AT.MaterialCr
,	MissingDr = case when AT.MaterialDr is null then +AT.StdQty * AT.MaterialAccum else 0 end
,	MissingCr = case when AT.MaterialCr is null then -AT.StdQty * AT.MaterialAccum else 0 end
'

declare
	materialAccounts cursor local for
select
	Account
from
	(	select
			Account = MaterialCr
		from
			#resultsAT AT
		union
		select
			MaterialDr
		from
			#resultsAT AT
		union
		select
			GL.DrAccount
		from
			#resultsGL GL
		union
		select
			GL.CrAccount
		from
			#resultsGL GL
	) Accounts
where
	(	@Accounts is null
		or
		Account in
		(	select
				Account
			from
				#accounts
		)
	)
	and
	Account is not null
order by
	Account

declare
	@materialAcct char(6)

open
	materialAccounts

while
	1 = 1 begin

	fetch
		materialAccounts
	into
		@materialAcct

	if	@@FETCH_STATUS != 0 begin
		break
	end

	set	@ResultSyntax = @ResultSyntax +
N',	[' + @materialAcct + N'] = case when GL.DrAccount = ''' + @materialAcct + N''' then GL.DrAmount when GL.CrAccount = ''' + @materialAcct + ''' then GL.CrAmount else 0 end
'
end

close
	materialAccounts

deallocate
	materialAccounts

set	@ResultSyntax = @ResultSyntax +
--',	OtherDr = case when AT.MaterialDr not in (select Account from #accounts) or ''' + coalesce(@Accounts, '') + ''' = '''' then +AT.StdQty * AT.MaterialAccum else 0 end
--,	OtherCr = case when AT.MaterialCr not in (select Account from #accounts) or ''' + coalesce(@Accounts, '') + ''' = '''' then -AT.StdQty * AT.MaterialAccum else 0 end
N',	EmpowerSerial = GL.Serial
,	EmpowerType = GL.Type
,	EmpowerTranDT = GL.TranDT
,	EmpowerImportDT = GL.ImportDT
,	EmpowerPart = GL.Part
,	EmpowerStdQuantity = GL.StdQuantity
,	EmpowerMaterialAccum = GL.MaterialAccum
,	EmpowerDrAccount = GL.DrAccount
,	EmpowerCrAccount = GL.CrAccount
,	EmpowerDrAmount = GL.DrAmount
,	EmpowerCrAmount = GL.CrAmount
from
	#resultsAT AT
	full join #resultsGL GL on
		AT.Serial = GL.Serial
		and AT.TranDT = GL.TranDT
		and AT.Type = GL.Type
where
	AT.MaterialDr is not null
	or AT.MaterialCr is not null
	or GL.DrAccount is not null
	or GL.CrAccount is not null
'

--select
--	@ResultSyntax
--,	len(@ResultSyntax)

print
	@ResultSyntax

execute
	dbo.sp_executesql
	@ResultSyntax
--- </Body>

--- <Return>
rollback

return
	0
--- </Return>

help:
print	'
Syntax:
execute
	FT.usp_AuditTrailPostingWithGLCompare_PCB
	@Period = [Period Definition], set period definitions below
,	@Year = [YYYY] - used on "Custom" periods
,	@Month = [MM] - used on "Custom" periods
,	@FromDT = [''YYYY-MM-DD''] - used on "Custom" periods
,	@ToDT = [''YYYY-MM-DD''] - used on "Custom" periods
,	@Transactions = [''Type1'', .... ''Typen'']
,	@Accounts = [''Account1'', .... ''Accountn'']
,	@Parts = [''Part1'', .... ''Partn'']
,	@ProductLineGL = [''08'', .... ''ProductLineGLn'']

Period Definitions:
	(null)|?|Help
,	Custom
,	YTD|Year To Date
,	MTD|Month To Date
,	-1Mo|Last Month
,	0Mo|Current Month
,	1Mo|Next Month
,	{n}Mo {+/- n Month}
,	Ja|JAN|January
,	Fe|FEB|February
,	Mr|MAR|March
,	Ap|APR|April
,	My|MAY|May
,	Je|JUN|June
,	Jy|JUL|July
,	Au|AUG|August
,	Se|SEP|September
,	Oc|OCT|October
,	No|NOV|November
,	De|DEC|December

Example syntax
{
-- Ex1. Last Month, Job Completes, Material Issues, Intercompany, Quality, Deletes, and Adds, WIP Wash.
execute
	FT.usp_AuditTrailPostingWithGLCompare
	@Period = ''MTD''
,	@Transactions = ''J, M, I1, I2''
,	@Accounts = ''152511, 152560''

-- Ex2. 2 Months Ago, Receipts and Shipments.
execute
	FT.usp_AuditTrailPostingWithGLCompare
	@Period = ''-2Mo''
,	@Transactions = ''R, S''

-- Ex3. January and May, Material Issues and Job Completes, WIP Wash.
execute
	FT.usp_AuditTrailPostingWithGLCompare
	@Period = ''JAN, MAY''
,	@Transactions = ''J, M''
,	@Accounts = ''152511, 152560''

-- Ex4. Custom (2011-06-01 to 2011-06-03).
execute
	FT.usp_AuditTrailPostingWithGLCompare
	@Period = ''Custom''
,	@FromDT = ''2011-07-01''
,	@ToDT = ''2011-08-01''
go
}
'
GO
