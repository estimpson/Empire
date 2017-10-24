SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEA].[fn_GetNetout]
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
,	InTransitQty numeric(30,12) default (0) not null
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
		FT.XRt xr with (readuncommitted)
	where
		(	TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-A%'
			or TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RA%'
			or TopPart like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RWA%'
		)
		and TopPart in (select part_number from dbo.order_detail od with (readuncommitted))

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
				FT.XRt XRT1 with (readuncommitted)
			where
				XRT1.ChildPart = XRt.ChildPart
		)
	,	Sequence
	from
		EEA.vwSOD SOD with (readuncommitted)
		join FT.XRt XRt with (readuncommitted)
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
	,	InTransit numeric(30,12)
	,	LowLevel int
	)

	--create index idx_#OnHand_1 on #OnHand (LowLevel, Part, OnHand)

	insert
		@Inventory
	(	Part
	,	OnHand
	,	InTransit
	,	LowLevel
	)
	select
		Part = part
	,	OnHand = sum(case when location not like '%TRAN%' then o.std_quantity else 0 end)
	,	InTransit = sum(case when location like '%TRAN%' then o.std_quantity else 0 end)
	,	LowLevel =
		(	select
				max(LowLevel)
			from
				@NetMPS
			where
				Part = o.part
		)
	from
		dbo.object o with (readuncommitted)
		join dbo.location lEEA with (readuncommitted)
			on o.location = lEEA.code
			and (	lEEA.code in ('INTRANSAL', 'TRAN-EEA')
					or lEEA.plant = 'EEA'
			)
			and coalesce (lEEA.secured_location, 'N') != 'Y'
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
	,	InTransitQty numeric(20,6)
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
		,	InTransit
		from
			@Inventory
		where
			OnHand + InTransit > 0
			and LowLevel = @LowLevel
		order by
			Part
		
		open
			PartsOnHand
			
		declare
			@Part varchar(25)
		,	@OnHandQty numeric(30,12)
		,	@InTransitQty numeric(30,12)
		
		while
			1 = 1 begin
			
			fetch
				PartsOnHand
			into
				@Part
			,	@OnHandQty
			,	@InTransitQty
			
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
			
			while
				1 = 1
				and @OnHandQty + @InTransitQty > 0 begin
				
				fetch
					Requirements
				into
					@ReqID
				,	@Balance
				,	@OrderNo
				,	@LineID
				,	@Sequence
				
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
				
				if	@Balance > @InTransitQty and @Balance > 0 and @InTransitQty > 0 begin
					update
						@NetMPS
					set
						Balance = @Balance - @InTransitQty
					,	InTransitQty = InTransitQty + @InTransitQty
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty
					,	OrderNo
					,	LineID
					,	Sequence
					,	WIPQty
					)
					select
						Part = @Part
					,	InTransitQty = @InTransitQty
					,	OrderNo = @OrderNo
					,	LineID = @LineID
					,	Sequence = @Sequence + Sequence
					,	WIPQty = @InTransitQty * XQty
					from
						FT.XRt xr
					where
						TopPart = @Part
						and Sequence > 0
					
					set	@InTransitQty = 0
				end
				else if @Balance > 0 and @InTransitQty > 0 begin
					update
						@NetMPS
					set
						Balance = 0
					,	InTransitQty = InTransitQty + @Balance
					where
						ID = @ReqID
					
					insert
						@X
					(	Part
					,	InTransitQty
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
					
					set	@InTransitQty = @InTransitQty - @Balance
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
GO
