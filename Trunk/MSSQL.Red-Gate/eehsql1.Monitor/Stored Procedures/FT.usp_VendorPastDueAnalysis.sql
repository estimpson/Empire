SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_VendorPastDueAnalysis]
	@PONumber int
,	@BeginDT datetime
,	@EndDT datetime = null
as
set nocount on
set ansi_warnings off

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

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@releasePlans table
(	ReleasePlanID int
,	GeneratedDT datetime
,	LeadTime int
,	PONumber int
,	Part varchar(25)
,	DueDate datetime
,	QtyDue int
,	PostAccum int
,	AccumRecvd int
)

insert
	@releasePlans
select
	rpr.ReleasePlanID
,	rp.GeneratedDT
,	LeadTime = pv.lead_time
,	rpr.PONumber
,	rpr.Part
,	rpr.DueDT
,	rpr.StdQty
,	rpr.PostAccum
,	rpr.AccumReceived
from
	FT.ReleasePlanRaw rpr
	join FT.ReleasePlans rp
		on rpr.ReleasePlanID = rp.ID
	join dbo.part_vendor pv
		on pv.part = rpr.Part
		and pv.vendor =
			(	select
					ph.vendor_code
				from
					dbo.po_header ph
		where
					ph.po_number = rpr.PONumber
			)
where
	rpr.PONumber = @PONumber
	and rp.GeneratedDT >= @BeginDT
	and rp.GeneratedDT <= coalesce(@EndDT, rp.GeneratedDT)
	and rp.GeneratedDT in
		(	select
				max(GeneratedDT)
			from
				FT.ReleasePlans rp2
			group by
				datediff(day, '2001-01-01', generateddt)
		);

with
	ReleasePlans
	(	ReleasePlanID
	,	GeneratedDT
	,	LeadTime
	,	PONumber
	,	Part
	,	DueDate
	,	QtyDue
	,	PostAccum
	,	AccumReceived
	)
	as
		(	select
				rp.ReleasePlanID
			,	rp.GeneratedDT
			,	rp.LeadTime
			,	rp.PONumber
			,	rp.Part
			,	rp.DueDate
			,	rp.QtyDue
			,	rp.PostAccum
			,	rp.AccumRecvd
			from
				@releasePlans rp
		)
select
	rp.ReleasePlanID
,	rp.GeneratedDT
,	rp.LeadTime
,	rp.PONumber
,	rp.Part
,	rp.DueDate
,	rp.QtyDue
,	rp.PostAccum
,	DueAtLeadTime =
		(	select
				max(rp2.PostAccum)
			from
				ReleasePlans rp2
			where
				rp2.PONumber = rp.PONumber
				and rp2.ReleasePlanID =
					(	select
							max(rp3.ReleasePlanID)
						from
							ReleasePlans rp3
						where
							rp3.PONumber = rp.PONumber
							and rp3.GeneratedDT < rp.DueDate - rp.LeadTime
					)
				and	rp2.DueDate =
					(	select
							max(rp4.DueDate)
						from
							ReleasePlans rp4
						where
							rp4.PONumber = rp.PONumber
							and rp4.ReleasePlanID = rp2.ReleasePlanID
							and rp4.DueDate <= rp.DueDate
					)
		)
,	MinAccumWithinLeadTime =
		(	select
				min(rp2.PostAccum)
			from
				ReleasePlans rp2
			where
				rp2.PONumber = rp.PONumber
				and rp2.ReleasePlanID between
					(	select
							max(rp3.ReleasePlanID)
						from
							ReleasePlans rp3
						where
							rp3.PONumber = rp.PONumber
							and rp3.GeneratedDT < rp.DueDate - rp.LeadTime
					) and rp2.ReleasePlanID
				and rp2.DueDate =
					(	select
							max(rp4.DueDate)
						from
							ReleasePlans rp4
						where
							rp4.PONumber = rp.PONumber
							and rp4.ReleasePlanID = rp2.ReleasePlanID
							and rp4.DueDate <= rp.DueDate
					)
		)
,	MinAccumWithinLeadTimeOnDT =
		(	select
				max(rp5.GeneratedDT)
			from
				ReleasePlans rp5
			where
				rp5.PONumber = rp.PONumber
				and rp5.ReleasePlanID between
					(	select
							max(rp3.ReleasePlanID)
						from
							ReleasePlans rp3
						where
							rp3.PONumber = rp.PONumber
							and rp3.GeneratedDT < rp.DueDate - rp.LeadTime
					) and rp.ReleasePlanID
				and rp5.PostAccum =
                		(	select
								min(rp2.PostAccum)
							from
								ReleasePlans rp2
							where
								rp2.PONumber = rp.PONumber
								and rp2.ReleasePlanID between
									(	select
											max(rp3.ReleasePlanID)
										from
											ReleasePlans rp3
										where
											rp3.PONumber = rp.PONumber
											and rp3.GeneratedDT < rp.DueDate - rp.LeadTime
									) and rp.ReleasePlanID
								and rp2.DueDate =
									(	select
											max(rp4.DueDate)
										from
											ReleasePlans rp4
										where
											rp4.PONumber = rp.PONumber
											and rp4.ReleasePlanID = rp2.ReleasePlanID
											and rp4.DueDate <= rp.DueDate
									)
						)
		)
,	rp.AccumReceived
from
	(	select
			ReleasePlanID = max(rp.ReleasePlanID)
		from
			@releasePlans rp
		group by
			datediff(day, '2001-01-01', rp.GeneratedDT)
	) rp1
	left join ReleasePlans rp
		on rp.ReleasePlanID = rp1.ReleasePlanID
		and rp.DueDate =
			(	select
					min(rp2.DueDate)
				from
					@releasePlans rp2
				where
					rp2.ReleasePlanID = rp1.ReleasePlanID
			)
order by
	rp.ReleasePlanID
,	rp.DueDate
--- </Body>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@PONumber int = 26209
,	@BeginDT datetime = '2012-08-01'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_VendorPastDueAnalysis
	@PONumber = @PONumber
,	@BeginDT = @BeginDT

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
