SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [estimpson].[uspTestATPostingWithGLComparePCB_PartDaily]
as
declare
	@Period varchar(1000) = 'LMo'
,	@Year int = null
,	@Month int = null
,	@FromDT datetime = null
,	@ToDT datetime = null
,	@Transactions varchar(25) = 'K, L'
,	@Accounts varchar(1000) = '152508, 152512'
,	@Parts varchar(1000) = null
,	@ProductLineGL varchar(1000) = '08, 12'

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
	dbo.udf_GetPeriodBounds ('LMo', null, null, null, null) PeriodBounds

--select
--	*
--from
--	#PeriodBounds


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

--select
--	*
--from
--	#ATTypes

create table
	#parts
(	Part varchar(25)
)

insert
	#parts
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

--select
--	*
--from
--	#productLineGLSegments

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

--select
--	count(*)
--from
--	#productLineTransactions
create index ix_#productLineTransactions on #productLineTransactions(TranDT, SerialProduced, SerialConsumed)

select
	Period = (select min(pb.Period) from #PeriodBounds pb where at.date_stamp >= pb.FromDT and at.date_stamp < pb.ToDT)
,	Serial = at.serial
,	TranDT = at.date_stamp
,	Operator = at.operator
,	Type = at.type
,	Remarks = at.remarks
,	Part = at.part
,	FromLoc = at.from_loc
,	ToLoc = at.to_loc
,	StdQty = at.std_quantity
,	WODID = at.workorder
,	BackFlushID = at.group_no
,	Posted = at.posted
into
	#resultsAT1
from
	eeh.dbo.audit_trail at with (readuncommitted)
	join #productLineTransactions plt
		on plt.TranDT = at.date_stamp
where
	at.type in ('K', 'L')

select
	tAT.Period
,	tAT.Part
,	tAT.TranDT
,	tAT.Type
,	tAT.Remarks
,	tAT.ProductLine
,	tAT.PartType
,	tAT.GLSegment
,	StdQty = sum(tAT.StdQty)
,	MaterialAccum = sum(tAT.MaterialAccum)
,	tAT.Posted
,	tAT.MaterialCr
,	tAT.MaterialDr
into
	#resultsAT
from
	(	select
		at1.Period
	,	at1.Part
	,	TranDT = dateadd(day, datediff(day, 0, at1.TranDT), 0)
	,	at1.Type
	,	at1.Remarks
	,	ProductLine = pl.id
	,	PartType = coalesce(phd.type, p.type)
	,	GLSegment = pl.gl_segment
	,	StdQty = at1.StdQty
	,	MaterialAccum = coalesce
		(	(select material_cum from dbo.part_standard_historical_daily where part = at1.Part and time_stamp = (select min(time_stamp) from dbo.part_standard_historical_daily where time_stamp > at1.TranDT))
		,	(select material_cum from dbo.part_standard where part = at1.Part)
		)
	,	at1.Posted
	,	MaterialCr = mia.material_credit + pl.gl_segment
	,	MaterialDr = mia.material_debit	+ pl.gl_segment
	from
		#resultsAT1 at1
		join dbo.part p
			on at1.Part = p.part
		left join dbo.part_historical_daily phd
			on phd.part = at1.Part
			and time_stamp = (select min(time_stamp) from dbo.part_historical_daily where time_stamp > at1.TranDT)
		join dbo.product_line pl
			on pl.id = coalesce(phd.product_line, p.product_line)
			and pl.gl_segment in
				(	select
						plgls.GLSegment
					from
						#productLineGLSegments plgls
				)
		left join dbo.monitor_inventory_accounts mia
			on mia.audit_trail_type = at1.Type
			and mia.part_type = p.type
			and mia.product_line = coalesce(phd.product_line, p.product_line)
			and mia.fiscal_year = datename(year, at1.TranDT)
	) tAT
group by
	tAT.Period
,	tAT.Part
,	tAT.TranDT
,	tAT.Type
,	tAT.Remarks
,	tAT.ProductLine
,	tAT.PartType
,	tAT.GLSegment
,	tAT.Posted
,	tAT.MaterialCr
,	tAT.MaterialDr

--select
--	*
--from
--	#resultsAT

create table
	#plt
(	TranDTString varchar(23) primary key
)

insert
	#plt
select
	CONVERT(varchar(23), TranDT, 101) + ' ' + right(CONVERT(varchar, TranDT, 126), 12)
from
	#productLineTransactions
group by
	CONVERT(varchar(23), TranDT, 101) + ' ' + right(CONVERT(varchar, TranDT, 126), 12)

select
	TranDT = dateadd(day, datediff(day, 0, convert(datetime, gct.document_id2)), 0)
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
	join #plt plt
		on plt.TranDTString = gct.document_id2
where
	document_type = 'MON INV'
	--and isdate(gct.document_id2) = 1
	--and isnumeric(gct.document_id1) = 1
	and gct.document_line in (1,2)
	and
	(	not exists
		(	select
				*
			from
				#accounts
		)
		or gct.ledger_account in
		(	select
				Account
			from
				#accounts
		)
	)
group by
	dateadd(day, datediff(day, 0, convert(datetime, gct.document_id2)), 0)
,	gct.document_id3
,	gct.ledger
,	gct.transaction_date
,	gct.document_reference1
,	gct.quantity
,	gct.changed_user_id

--select
--	count(*)
--from
--	#resultsGL

declare
	@ResultSyntax nvarchar(max)

set	@ResultSyntax = N'
select
	AT.Period
,	AT.TranDT
,	AT.Type
,	AT.Remarks
,	AT.Part
,	AT.ProductLine
,	AT.PartType
,	AT.GLSegment
,	AT.StdQty
,	AT.MaterialAccum
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
	(	not exists
		(	select
				*
			from
				#accounts
		)
		or Account in
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
N',	EmpowerType = GL.Type
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
		AT.Part = GL.Part
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
GO
