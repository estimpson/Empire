use tempdb
go

declare
	@transactionBegins table
	(	RowNumber int primary key
	)
		insert
			@transactionBegins
		select
			td.RowNumber
		from
			dbo.TraceData td
		where
			td.TextData like 'BEGIN TRANSACTION'
			and td.EventClass = 12
	 
declare
	@transactionEnds table
	(	RowNumber int primary key
	,	IsRolledBack bit
	)
		insert
			@transactionEnds
		select
			td.RowNumber
		,	IsRollbacked = case when td.TextData like '%rollback%' then 1 else 0 end
		from
			dbo.TraceData td
		where
			td.TextData like 'COMMIT'
			or td.TextData like '%rollback%'
	
declare
	@batchSerial table
	(	RowNumber int primary key
	,	Serial int
	,	DateStamp datetime
	)
		insert
			@batchSerial
		select
			td.RowNumber
		,	Serial = convert(int, substring(td.TextData, patindex('%serial =%', td.TextData) + 8, patindex('% and%', td.TextData) - (patindex('%serial =%', td.TextData) +8)))
		,	DateStamp  = convert(datetime, substring(td.TextData, patindex('%ts %', td.TextData) + 4, 23))
		from
			dbo.TraceData td
		where
			td.TextData like '%update%audit_trail%'
			and td.EventClass = 12

declare
	@updateAccountBalance table
	(	RowNumber int primary key
	,	Amount numeric(20,6)
	)
		insert
			@updateAccountBalance
		select
			td.RowNumber
		,	Amount = convert(numeric(20,6), substring(td.TextData, len(convert(varchar(max), td.TextData)) - patindex('%,%', reverse(convert(varchar(max), td.TextData))) + 2, 25))
		from
			dbo.TraceData td
		where
			td.TextData like '%exec%UpdateAccountBalance%'
			and td.EventClass = 10
	
declare
	@traceSkips table
	(	RowNumber int primary key
	)
		insert
			@traceSkips
		select
			td.RowNumber
		from
			dbo.TraceData td
		where
			td.EventClass = 65531
	
declare
	@glInserts table
	(	RowNumber int primary key
	,	Serial int
	,	Account varchar(10)
	,	type char(1)
	,	Line int
	--,	TextData
	)
		insert
			@glInserts
		select
			td.RowNumber
		,	Serial = substring(td.TextData, patindex('%''MON INV''%', td.TextData) + 13, patindex('%''07/%', td.TextData) - (patindex('%''MON INV''%', td.TextData) + 17))
		,	Account = substring(td.TextData, patindex('%''[0-9][0-9][0-9][0-9]12%', td.TextData) + 1, 6)
		,	Type = substring(td.TextData, patindex('%''07/%', td.TextData) + 29, 1)
		,	Line = substring(td.TextData, patindex('%''07/%', td.TextData) + 34, 1)
		--,	td.TextData
		from
			dbo.TraceData td
		where
			td.TextData like '%INSERT%gl_cost_transactions%'
			and td.EventClass = 12
  	
declare
	@glDeletes table
	(	RowNumber int primary key
	,	DeleteText varchar(100)
	)
		insert
			@glDeletes
		select
			td.RowNumber
		,	DeleteText = substring(td.TextData, 69, 100)
		from
			dbo.TraceData td
		where
			td.TextData like '%delete%gl_cost_transactions%'
			and td.EventClass = 12

declare
	@partData table
	(	Part varchar(25) primary key
	,	ProductLine varchar(30) 
	,	PartType char(1)
	,	MaterialCost numeric(20,6)
	,	LaborCost numeric(20,6)
	,	BurdenCost numeric(20,6)
	,	OtherCost numeric(20,6)
	)

	insert
		@partData
		select
			Part = phd.part
		,	ProductLine = phd.product_line
		,	PartType = phd.type
		,	MaterialCost = pshd.material_cum
		,	LaborCost = pshd.labor_cum
		,	BurdenCost = pshd.burden_cum
		,	OtherCost = pshd.other_cum
		from
			(	select
					*
				from
					Monitor.dbo.part_historical_daily phd
				where
					phd.time_stamp =
						(	select
								max(time_stamp)
							from
								Monitor.dbo.part_historical_daily
							where
								time_stamp < '2013-07-19'
						)
			) phd
			left join
				(	select
						*
					from
						Monitor.dbo.part_standard_historical_daily pshd
					where
						pshd.time_stamp =
							(	select
									max(time_stamp)
								from
									Monitor.dbo.part_standard_historical_daily
								where
									time_stamp < '2013-07-19'
							)
				) pshd
			on phd.part = pshd.part

select
	TransactionBegin = tb.RowNumber
,	TransactionEnd = te.RowNumber
,	StatementRowNumber = gi.RowNumber
,	te.IsRolledBack
,	bs.RowNumber
,	bs.Serial
,	bs.DateStamp
,	pd.Part
,	pd.ProductLine
,	pd.PartType
,	pd.MaterialCost
,	pd.LaborCost
,	pd.BurdenCost
,	pd.OtherCost
,	StatementDescription = 'GL Insert - Serial = ' + convert(varchar, gi.Serial) + ', account = ' + gi.Account + ', type = ''' + gi.Type + ''', line = ' + convert(varchar, gi.Line)
from
	@transactionBegins tb
	join @transactionEnds te
		on te.RowNumber =
			(	select
					min(RowNumber)
				from
					@transactionEnds
				where
					RowNumber > tb.RowNumber
			)
	left join @batchSerial bs
		left join @partData pd
			on pd.Part =
				(	select
						max(at.part)
					from
						Monitor.dbo.audit_trail at
					where
						at.serial = bs.Serial
						and at.date_stamp = bs.DateStamp
				)
		on bs.RowNumber between tb.RowNumber and te.RowNumber
	join @glInserts gi
		on gi.RowNumber between tb.RowNumber and te.RowNumber
where
	not exists
		(	select
				*
			from
				@traceSkips ts
			where
				ts.RowNumber between tb.RowNumber and te.RowNumber          
		)
union all
select
	TransactionBegin = tb.RowNumber
,	TransactionEnd = te.RowNumber
,	StatementRowNumber = gd.RowNumber
,	te.IsRolledBack
,	bs.RowNumber
,	bs.Serial
,	bs.DateStamp
,	pd.Part
,	pd.ProductLine
,	pd.PartType
,	pd.MaterialCost
,	pd.LaborCost
,	pd.BurdenCost
,	pd.OtherCost
,	StatementDescription = 'GL Delete - ' + gd.DeleteText
from
	@transactionBegins tb
	join @transactionEnds te
		on te.RowNumber =
			(	select
					min(RowNumber)
				from
					@transactionEnds
				where
					RowNumber > tb.RowNumber
			)
	left join @batchSerial bs
		left join @partData pd
			on pd.Part =
				(	select
						max(at.part)
					from
						Monitor.dbo.audit_trail at
					where
						at.serial = bs.Serial
						and at.date_stamp = bs.DateStamp
				)
		on bs.RowNumber between tb.RowNumber and te.RowNumber
	join @glDeletes gd
		on gd.RowNumber between tb.RowNumber and te.RowNumber
where
	not exists
		(	select
				*
			from
				@traceSkips ts
			where
				ts.RowNumber between tb.RowNumber and te.RowNumber
		)
union all
select
	TransactionBegin = tb.RowNumber
,	TransactionEnd = te.RowNumber
,	StatementRowNumber = uab.RowNumber
,	te.IsRolledBack
,	bs.RowNumber
,	bs.Serial
,	bs.DateStamp
,	pd.Part
,	pd.ProductLine
,	pd.PartType
,	pd.MaterialCost
,	pd.LaborCost
,	pd.BurdenCost
,	pd.OtherCost
,	StatementDescription = 'Update account balance (303012) - amount = ' + convert(varchar, uab.Amount)
from
	@transactionBegins tb
	join @transactionEnds te
		on te.RowNumber =
			(	select
					min(RowNumber)
				from
					@transactionEnds
				where
					RowNumber > tb.RowNumber
			)
	left join @batchSerial bs
		left join @partData pd
			on pd.Part =
				(	select
						max(at.part)
					from
						Monitor.dbo.audit_trail at
					where
						at.serial = bs.Serial
						and at.date_stamp = bs.DateStamp
				)
		on bs.RowNumber between tb.RowNumber and te.RowNumber
	join @updateAccountBalance uab
		on uab.RowNumber between tb.RowNumber and te.RowNumber
where
	not exists
		(	select
				*
			from
				@traceSkips ts
			where
				ts.RowNumber between tb.RowNumber and te.RowNumber
		)
order by
	1
,	2
,	3
