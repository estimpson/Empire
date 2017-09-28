
/*
Create function TableFunction.MONITOR.EEA.fn_GetNetout_NewIntransit.sql
*/

use MONITOR
go

if	objectproperty(object_id('EEA.fn_GetNetout_NewIntransit'), 'IsTableFunction') = 1 begin
	drop function EEA.fn_GetNetout_NewIntransit
end
go

create function EEA.fn_GetNetout_NewIntransit
()
returns @NetMPS table
(	ID int identity primary key
,	OrderNo int default (-1) not null
,	LineID int not null
,	Part varchar(25) not null
,	RequiredDT datetime not null
,	GrossDemand numeric(30,12) not null
,	Balance numeric(30,12) not null
,	OnHandQty numeric(30,12) default (0) not null
,	InTransitQty1 numeric(30,12) default (0) not null
,	InTransitQty2 numeric(30,12) default (0) not null
,	WIPQty numeric(30,12) default (0) not null
,	LowLevel int not null
,	Sequence int not null
)
as
begin
--- <Body>
	declare
		@CurrentDatetime datetime
	
	set @CurrentDatetime = (select CurrentDatetime from dbo.vwGetDate vgd)
	
	declare
		@EEAPartList table
	(	Part varchar(25) primary key
	)

	insert
		@EEAPartList
	select distinct
		ChildPart
	from
		FT.XRt xr
	where
		(	TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-A%'
			or TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RA%'
			or TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RWA%'
		)
		and TopPart in (select part_number from dbo.order_detail od)

	--create index idx_#NetMPS_1 on #NetMPS (LowLevel, Part)
	--create index idx_#NetMPS_2 on #NetMPS (Part, RequiredDT, Balance)
	
	insert
		@NetMPS
	(	OrderNo
	,	LineID
	,	Part
	,	RequiredDT
	,	GrossDemand
	,	Balance
	,	LowLevel
	,	Sequence)
	select
		OrderNo
	,	LineID
	,	Part = XRt.ChildPart
	,	RequiredDT = ShipDT
	,	GrossDemand = StdQty * XQty
	,	Balance = StdQty * XQty
	,	LowLevel =
		(	select
				max(XRT1.BOMLevel)
			from
				FT.XRt XRT1
			where
				XRT1.ChildPart = XRt.ChildPart
		)
	,	Sequence
	from
		EEA.vwSOD SOD
		join FT.XRt XRt
			on SOD.Part = XRt.TopPart
	where
		SOD.Part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-A%'
		or SOD.Part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RA%'
		or SOD.Part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RWA%'

	--select
	--	*
	--from
	--	@NetMPS

	declare @Inventory table
	(	Part varchar(25)
	,	OnHand numeric(30,12)
	,	InTransitQty1 numeric(30,12)
	,	InTransitQty2 numeric(30,12)
	,	InTransitDT1 datetime
	,	InTransitDT2 datetime
	,	LowLevel int
	)

	--create index idx_#OnHand_1 on #OnHand (LowLevel, Part, OnHand)

	insert
		@Inventory
	(	Part
	,	OnHand
	,	InTransitQty1
	,	InTransitQty2
	,	InTransitDT1
	,	InTransitDT2
	,	LowLevel
	)
	select
		Part = part
	,	OnHand = sum(case when lEEA.plant = 'EEA' then o.std_quantity else 0 end)
	,	InTransitQty1 = sum(case when il.ArrivalDate = ic.FridayOfCurrentWeek then o.std_quantity else 0 end)
	,	InTransitQty2 = sum(case when il.ArrivalDate = ic.FridayOfNextWeek then o.std_quantity else 0 end)
	,	InTransitDT1 = min(ic.FridayOfCurrentWeek)
	,	InTransitDT2 = min(ic.FridayOfNextWeek)
	,	LowLevel =
		(	select
				max(LowLevel)
			from
				@NetMPS
			where
				Part = o.part
		)
	from
		dbo.object o
		left join dbo.location lEEA
			on o.location = lEEA.code
			and lEEA.plant = 'EEA'
			and coalesce (lEEA.secured_location, 'N') != 'Y'
		left join EEA.IntransitLocations il
			on o.location = il.InTranLocation
		cross join EEA.IntransitCalendar ic
	where
		o.status in ('A', 'H')
		and o.type is null
		and o.part in (select Part from @EEAPartList epl)
	group by
		o.part

	--select
	--	*
	--from
	--	@Inventory

	declare @X table
	(	Part varchar(25)
	,	OnhandQty numeric(20,6)
	,	InTransitQty1 numeric(30,12)
	,	InTransitQty2 numeric(30,12)
	,	InTransitDT1 datetime
	,	InTransitDT2 datetime
	,	OrderNo int
	,	LineID int
	,	Sequence int
	,	WIPQty numeric(30,12)
	)

	--create index idx_#X_1 on #X (OrderNo, LineID, Sequence)

	declare
		@LowLevel int
	,	@MaxLowLevel int

	set	@MaxLowLevel =
		(	select
				max(LowLevel)
			from
				@NetMPS
		)

	set	@LowLevel = 0
	while
		@LowLevel <= @MaxLowLevel begin

		declare	PartsOnHand cursor local for
		select
			Part
		,	OnHand
		,	InTransitQty1
		,	InTransitQty2
		,	InTransitDT1
		,	InTransitDT2
		from
			@Inventory
		where
			OnHand + InTransitQty1 + InTransitQty2 > 0
			and LowLevel = @LowLevel
		order by
			Part
		
		open
			PartsOnHand
			
		declare
			@Part varchar(25)
		,	@OnHandQty numeric(30,12)
		,	@InTransitQty1 numeric(30,12)
		,	@InTransitQty2 numeric(30,12)
		,	@InTransitDT1 datetime
		,	@InTransitDT2 datetime
		
		while
			1 = 1 begin
			
			fetch
				PartsOnHand
			into
				@Part
			,	@OnHandQty
			,	@InTransitQty1
			,	@InTransitQty2
			,	@InTransitDT1
			,	@InTransitDT2
			
			if	@@FETCH_STATUS != 0 begin
				break
			end
			
			declare	Requirements cursor local for
			select
				ID
			,	Balance
			,	OrderNo
			,	LineID
			,	Sequence
			,	RequiredDT
			from
				@NetMPS
			where
				Part = @Part
				and Balance > 0
			order by
				RequiredDT asc
			
			open
				Requirements
			
			declare
				@ReqID integer
			,   @Balance numeric(30,12)
			,   @OrderNo integer
			,   @LineID integer
			,   @Sequence integer
			,	@RequireDT datetime
			
			while
				1 = 1
				and @OnHandQty + @InTransitQty1 + @InTransitQty2 > 0 begin
				
				fetch
					Requirements
				into
					@ReqID
				,	@Balance
				,	@OrderNo
				,	@LineID
				,	@Sequence
				,	@RequireDT
				
				if	@@FETCH_STATUS != 0 begin
					break
				end
				
				if	@Balance > @OnHandQty and @OnHandQty > 0 begin
					update
						@NetMPS
					set
						Balance = @Balance - @OnHandQty
					,	OnHandQty = OnHandQty + @OnHandQty
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	OnhandQty
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	OnhandQty = @OnHandQty
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @OnHandQty * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@Balance = @Balance - @OnHandQty
					set	@OnHandQty = 0
				end
				else if @OnHandQty > 0 begin
					update
						@NetMPS
					set
						Balance = 0
					,	OnHandQty = OnHandQty + @Balance
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	OnhandQty
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	OnhandQty = @Balance
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @Balance * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@OnHandQty = @OnHandQty - @Balance
					set @Balance = 0
				end
				
				/*	Netout First In Transit Qty*/
				if	@Balance > @InTransitQty1
					and @Balance > 0
					and @InTransitQty1 > 0
					and @RequireDT >= @InTransitDT1 begin
					update
						@NetMPS
					set
						Balance = @Balance - @InTransitQty1
					,	InTransitQty1 = InTransitQty1 + @InTransitQty1
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty1
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	InTransitQty = @InTransitQty1
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @InTransitQty1 * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@InTransitQty1 = 0
				end
				else if
					@Balance > 0
					and @InTransitQty1 > 0
					and @RequireDT >= @InTransitDT1 begin
					update
						@NetMPS
					set
						Balance = 0
					,	InTransitQty1 = InTransitQty1 + @Balance
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty1
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	InTransitQty = @Balance
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @Balance * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@InTransitQty1 = @InTransitQty1 - @Balance
				end
				
				/*	Netout Second In Transit Qty*/
				if	@Balance > @InTransitQty2
					and @Balance > 0
					and @InTransitQty2 > 0
					and @RequireDT >= @InTransitDT2 begin
					update
						@NetMPS
					set
						Balance = @Balance - @InTransitQty2
					,	InTransitQty1 = InTransitQty1 + @InTransitQty2
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty2
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	InTransitQty = @InTransitQty2
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @InTransitQty2 * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@InTransitQty2 = 0
				end
				else if
					@Balance > 0
					and @InTransitQty2 > 0
					and @RequireDT >= @InTransitDT2 begin
					update
						@NetMPS
					set
						Balance = 0
					,	InTransitQty2 = InTransitQty2 + @Balance
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty2
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	InTransitQty = @Balance
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @Balance * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@InTransitQty2 = @InTransitQty2 - @Balance
				end
			end
			close
				Requirements
			deallocate
				Requirements
		end
		close
			PartsOnHand
		deallocate
			PartsOnHand

		set	@LowLevel = @LowLevel + 1
		
		update
			nmps
		set	WIPQty = coalesce(
			(	select
					sum(WIPQty)
				from
					@X
				where
					OrderNo = nmps.OrderNo
					and LineID = nmps.LineID
					and Sequence = nmps.Sequence
			), 0)
		from
			@NetMPS nmps
		where
			LowLevel = @LowLevel

		update
			nmps
		set	Balance = Balance - WIPQty
		from
			@NetMPS nmps
		where
			LowLevel = @LowLevel
	end
--- </Body>

---	<Return>
	return
end
go

select
	sum(GrossDemand)
,	sum(Balance)
,	sum(OnHandQty)
,	sum(InTransitQty1)
,	sum(InTransitQty2)
,	sum(WIPQty)
from
	EEA.fn_GetNetout_NewIntransit()
--order by
--	Part
--,	RequiredDT
go

