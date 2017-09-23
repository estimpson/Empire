SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_RFPhysInv_BuildResults]
as
insert
	CycleCountHeaders
(	Location
,	StartDT
,	EndDT
,	BoxesStarting
)
select
	Location = BeginPhys.Row + '-0-0'
,	StartDT = BeginPhys.StartDT
,	EndDT = PutAway.LastDT
,	BoxesStarting = BeginPhys.Boxes
from
    (	select
			StartDT = at.date_stamp
		,	Row = left(at.from_loc,1)
		,	Boxes = count(distinct at.serial)
		from
			dbo.audit_trail at
		where
			at.type = 'G'
			and at.date_stamp >= '2007-10-01'
			and at.object_type is null
		group by
			date_stamp
		,	left(from_loc,1)
	) BeginPhys
	left join
	(	select
			Row = left(at.to_loc,1)
		,	LastDT = max(at.date_stamp)
		from
			dbo.audit_trail at
		where
			at.type = 'H'
			and at.date_stamp >= '2007-10-01'
		group by
			left(to_loc,1)
	) PutAway
		on BeginPhys.Row = PutAway.Row
where
	not exists
		(	select
				*
			from
				dbo.CycleCountHeaders cch
			where
				cch.StartDT = BeginPhys.StartDT
				and left(cch.Location,1) = BeginPhys.Row
		)

declare
	@LastCCH table
(	Location varchar(10)
,	LastID int
)

insert
	@LastCCH
select
	cch.Location
,	LastID = max(ID)
from
	dbo.CycleCountHeaders cch
group by
	cch.Location

declare
	@CC_ATs table
(	id int)

insert
	@CC_ATs
select
	at.id
from
	dbo.audit_trail at
	join dbo.CycleCountHeaders cch
		join @LastCCH lc
			on lc.LastID = cch.ID
		on at.date_stamp between cch.StartDT and cch.EndDT
			and left(cch.Location,1) = left(at.to_loc,1)
where
	at.type in ('G','H')
	and isnull(at.sequence,-1) != cch.ID

if	exists
	(	select
			*
		from
			@CC_ATs cat
	) begin

	begin transaction
	alter table audit_trail disable trigger all

	update
		at
	set
		sequence = cch.ID
	from
		dbo.audit_trail at
			join @CC_ATs cat on cat.id = at.id
		join dbo.CycleCountHeaders cch
			join @LastCCH lc
				on lc.LastID = cch.ID
			on at.date_stamp between cch.StartDT and cch.EndDT
				and left(cch.Location,1) = left(at.to_loc,1)
	where
		at.type in ('G','H')
		and isnull(at.sequence,-1) != cch.ID

	alter table audit_trail enable trigger all
	commit
end

declare
	@Last2CCH table
(	Location varchar(10)
,	ID int
)

insert
	@Last2CCH
select
	cch.Location
,   cch.ID
from
	(	select
			cch.Location
		,	cch.ID
		,	Occurence = row_number() over (partition by cch.Location order by ID desc)
		from
			dbo.CycleCountHeaders cch
	) cch
where
	Occurence in (1, 2)

if	exists
	(	select
			*
		from
			dbo.CycleCountHeaders cch
				join @Last2CCH lc
					on lc.ID = cch.ID
		where
			(	BoxesFoundInPos !=
				(	select	FoundInPos = count (distinct serial)
					from	audit_trail
					where	audit_trail.sequence = cch.ID and
						audit_trail.date_stamp between cch.StartDT and cch.EndDT and
						type = 'H' and
						from_loc != to_loc and
						from_loc = to_loc + '-FIS')
				or BoxesFoundInRow !=
				(	select	FoundInRow = count (distinct serial)
					from	audit_trail
					where	audit_trail.sequence = cch.ID and
						audit_trail.date_stamp between cch.StartDT and cch.EndDT and
						type = 'H' and
						object_type is null and
						from_loc != to_loc and
						from_loc like '%-%-%-FIS' and
						to_loc like left (from_loc, 1) + '%')
				or BoxesMissing !=
				(	select	Missing = count (distinct serial)
					from	audit_trail
					where	audit_trail.sequence = cch.ID and
						audit_trail.date_stamp between cch.StartDT and cch.EndDT and
						type = 'G' and
						object_type is null and
						serial not in
						(	select	serial
							from	audit_trail
								join CycleCountHeaders cch2 on audit_trail.sequence = cch2.ID and
									audit_trail.date_stamp between cch2.StartDT and cch2.EndDT
							where	cch.ID = cch2.ID and
								audit_trail.type = 'H'))
			)
	) begin
	
	update
		cch
	set
		BoxesFoundInPos =
		(	select	FoundInPos = count (distinct serial)
			from	audit_trail
			where	audit_trail.sequence = cch.ID and
				audit_trail.date_stamp between cch.StartDT and cch.EndDT and
				type = 'H' and
				from_loc != to_loc and
				from_loc = to_loc + '-FIS')
	,	BoxesFoundInRow =
		(	select	FoundInRow = count (distinct serial)
			from	audit_trail
			where	audit_trail.sequence = cch.ID and
				audit_trail.date_stamp between cch.StartDT and cch.EndDT and
				type = 'H' and
				object_type is null and
				from_loc != to_loc and
				from_loc like '%-%-%-FIS' and
				to_loc like left (from_loc, 1) + '%')
	,	BoxesMissing =
		(	select	Missing = count (distinct serial)
			from	audit_trail
			where	audit_trail.sequence = cch.ID and
				audit_trail.date_stamp between cch.StartDT and cch.EndDT and
				type = 'G' and
				object_type is null and
				serial not in
				(	select	serial
					from	audit_trail
						join CycleCountHeaders cch2 on audit_trail.sequence = cch2.ID and
							audit_trail.date_stamp between cch2.StartDT and cch2.EndDT
					where	cch.ID = cch2.ID and
						audit_trail.type = 'H'))
	from
		dbo.CycleCountHeaders cch
			join @Last2CCH lc
				on lc.ID = cch.ID
	where
		(	BoxesFoundInPos !=
			(	select	FoundInPos = count (distinct serial)
				from	audit_trail
				where	audit_trail.sequence = cch.ID and
					audit_trail.date_stamp between cch.StartDT and cch.EndDT and
					type = 'H' and
					from_loc != to_loc and
					from_loc = to_loc + '-FIS')
			or BoxesFoundInRow !=
			(	select	FoundInRow = count (distinct serial)
				from	audit_trail
				where	audit_trail.sequence = cch.ID and
					audit_trail.date_stamp between cch.StartDT and cch.EndDT and
					type = 'H' and
					object_type is null and
					from_loc != to_loc and
					from_loc like '%-%-%-FIS' and
					to_loc like left (from_loc, 1) + '%')
			or BoxesMissing !=
			(	select	Missing = count (distinct serial)
				from	audit_trail
				where	audit_trail.sequence = cch.ID and
					audit_trail.date_stamp between cch.StartDT and cch.EndDT and
					type = 'G' and
					object_type is null and
					serial not in
					(	select	serial
						from	audit_trail
							join CycleCountHeaders cch2 on audit_trail.sequence = cch2.ID and
								audit_trail.date_stamp between cch2.StartDT and cch2.EndDT
						where	cch.ID = cch2.ID and
							audit_trail.type = 'H'))
		)
end
GO
