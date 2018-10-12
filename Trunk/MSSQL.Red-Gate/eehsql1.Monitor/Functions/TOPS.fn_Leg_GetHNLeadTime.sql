SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [TOPS].[fn_Leg_GetHNLeadTime]
(	@ProductionPart varchar(25)
)
returns @HNLeadTime table
(	TopPart varchar(25)
,	Part varchar(25)
,	RealLeadTime int
,	LongestLeadTime int
,	BackDays int
)
as
begin
--- <Body>
	declare
		@BOM table
	(	TopPart varchar(25)
	,	Part varchar(25)
	,	RealLeadTime int
	,	BackDays int
	)

	if	@ProductionPart is null begin
		declare
			@finParts table
		(	FinPart varchar(25) primary key
		)

		insert
			@finParts
		(	FinPart
		)
		select distinct
			FinPart = mps.part
		from
			dbo.master_prod_sched mps
			join dbo.part pFin
				on pFin.part = mps.part
				and pFin.type = 'F'
			
		insert
			@BOM
		(	TopPart
		,	Part
		,	RealLeadTime
		,	BackDays
		)
		select
			TopPart = bq.TopPart
		,	Part = bq.Part
		,	RealLeadTime = bq.real_lead_time
		,	BackDays = pe.backdays
		from
			HN.BOM_Query bq
			left join dbo.part_eecustom pe
				on pe.part = bq.Part
		where
			bq.PartType = 'R'
			and bq.TopPart in
				(	select
						FinPart
					from
						@finParts
				)
	end
	else begin
			
		insert
			@BOM
		(	TopPart
		,	Part
		,	RealLeadTime
		,	BackDays
		)
		select
			TopPart = bq.TopPart
		,	Part = bq.Part
		,	RealLeadTime = bq.real_lead_time
		,	BackDays = pe.backdays
		from
			HN.BOM_Query bq
			left join dbo.part_eecustom pe
				on pe.part = bq.Part
		where
			bq.PartType = 'R'
			and bq.TopPart  = @ProductionPart
	end

	insert
		@HNLeadTime
	(	TopPart
	,	Part
	,	RealLeadTime
	,	LongestLeadTime
	,	BackDays
	)
	select
		b.TopPart
		,	b.Part
		,	b.RealLeadTime
		,	b.RealLeadTime
		,	b.BackDays
	from
		(	select
				b.TopPart
			,	b.Part
			,	b.RealLeadTime
			,	b.BackDays
			,	RowNumber = row_number() over(partition by b.TopPart order by b.TopPart, b.RealLeadTime desc)
			from
				@BOM b
		) b
	where
		b.RowNumber = 1
--- </Body>

---	<Return>
	return
end
GO
