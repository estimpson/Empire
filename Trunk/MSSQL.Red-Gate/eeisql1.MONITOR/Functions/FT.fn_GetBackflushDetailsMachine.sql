SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_GetBackflushDetailsMachine]
(	@WODID int,
	@QtyRequested numeric (20,6)
)
returns @Inventory table
(	Serial int
,	Part varchar(25)
,	BOMLevel tinyint
,	Sequence tinyint
,	Suffix tinyint
,	BOMID int
,	AllocationDT datetime
,	QtyPer float
,	QtyAvailable float
,	QtyRequired float
,	QtyIssue float
,	QtyOverage float
)
as
begin
--- <Body>

	declare
		@PartRequested varchar(25)
	,	@Machine varchar(10)
	,	@Department varchar(25)
		
	select
		@PartRequested = Part
	,	@Machine = WOHeaders.Machine
	,	@Department = location.group_no
	from
		WODetails
		join WOHeaders
			on WODetails.WOID = WOHeaders.ID
		join location
			on WOHeaders.Machine = location.code
	where
		WODetails.ID = @WODID
	
--	Get all XRt details for requested part.
	declare @XRt table
	(	TopPart varchar(25)
	,	ChildPart varchar(25)
	,	Department varchar(25)
	,	BOMID int
	,	Sequence tinyint
	,	BOMLevel tinyint
	,	XQty numeric(30, 12)
	)
	
	insert  @XRt
	select
		TopPart
	,	ChildPart
	,	Department = PMDpmt.Department
	,	BOMID
	,	Sequence
	,	BOMLevel
	,	XQty
	from
		FT.XRt XRt with (index = idx_XRt_5)
		left join
		(	select
				Part = PrimaryMachine.part
			,	Department = Dpt.group_no
			from
				part_machine PrimaryMachine
				join location Dpt
					on PrimaryMachine.Machine = Dpt.code
			where
				PrimaryMachine.sequence = 1
		) PMDpmt
			on XRt.ChildPart = PMDpmt.Part
	where
		TopPart in
		(	select
				ChildPart
			from
				FT.XRt
			where
				TopPart = @PartRequested
		)
	
--	Build requirements for activities performed within department of the produced part.
	declare @NetMPS table
	(	ID int not null IDENTITY(1, 1) primary key
	,	Department varchar(25) null
	,	Part varchar(25) not null
	,	BOMID int
	,	XQty numeric(30, 12)
	,	Balance numeric(20, 6) not null
	,	QtyAvailable numeric(20, 6) default (0) not null
	,	WIPQty numeric(20, 6) default (0) not null
	,	BOMLevel integer not null
	,	LowLevel integer not null
	,	Sequence integer not null
	)

	insert
		@NetMPS
	(	Department
	,	Part
	,	BOMID
	,	XQty
	,	Balance
	,	BOMLevel
	,	LowLevel
	,	Sequence
	)
	select
		Department
	,	Part = ChildPart
	,	BOMID = isnull(XRt.BOMID, -1)
	,	XQty = XRt.XQty
	,	Balance = @QtyRequested * XRt.XQty
	,	BOMLevel = XRt.BOMLevel
	,	LowLevel =
		(	select
				max(XRT1.BOMLevel)
			from
				@XRt XRT1
			where
				XRT1.TopPart = @PartRequested
				and XRT1.ChildPart = XRt.ChildPart
		)
	,	Sequence
	from
		@XRt XRt
	where
		TopPart = @PartRequested
		and BOMLevel >= 1
		and not exists
		(
			select
				*
			from
				@XRt XRt2
				join @XRt XRt3
					on XRt2.TopPart = XRt3.ChildPart
						and XRt3.TopPart = XRt.TopPart
			where
				XRt2.Sequence > 0
				and XRt3.Sequence > 0
				and XRt.Sequence = XRt2.Sequence + XRt3.Sequence
				and coalesce(XRt3.Department, '') != @Department )
	
--	Get available inventory...
	declare	@OnHand table
	(	Serial int
	,	Part varchar (25) not null
	,	AllocationSequence tinyint
	,	AllocationDT datetime not null
	,	QtyAvailable numeric (20,6) not null
	,	QtyIssue numeric (20,6) default (0) not null
	,	LowLevel tinyint
	)
	
--			...at the machine.
	insert
		@OnHand
	(	Serial
	,	Part
	,	AllocationSequence
	,	AllocationDT
	,	QtyAvailable
	,	LowLevel
	)
	select
		Serial = object.serial
	,	Part = object.part
	,	AllocationSequence = 0
	,	AllocationDT = coalesce(
			(	select
					max(date_stamp)
				from
					dbo.audit_trail
				where
					type in ('T', 'E')
					and audit_trail.serial = object.serial
			)
		,	(	select
					max(date_stamp)
				from
					dbo.audit_trail
				where
					audit_trail.serial = object.serial
					and type = 'B'
			)
		,	object.last_date
		)
	,	QtyAvailable = object.std_quantity
	,	LowLevel = pl.LowLevel
	from
		object
		join
		(	select
				Part
			,	LowLevel = max(LowLevel)
			from
				@NetMPS
			group by
				Part
		) PL
			on object.part = pl.part
	where
		location = @Machine
		and status = 'A'
		and std_quantity > 0
	
--	Perform netout to allocate the available inventory to the requested quantity.
	declare @X table
	(	Sequence integer
	,	WIPQty numeric(20,6)
	)

	declare @Y table
	(	BOMID int
	,	Serial int
	,	QtyIssue numeric(20,6)
	)

	declare
		@LowLevel integer

	set	@LowLevel = 0

	while
		@LowLevel <=
		(	select
				max(LowLevel)
			from
				@NetMPS
		) begin
		
		declare	PartsQtyAvailable cursor local for
		select
			Serial
		,	Part
		,	QtyAvailable
		from
			@OnHand
		where
			QtyAvailable > 0
			and LowLevel = @LowLevel
		order by
			AllocationSequence
		,	AllocationDT
		
		open
			PartsQtyAvailable

		declare
			@Serial int
		,	@PartInventory varchar(25)
		,	@QtyAvailable numeric(20,6)

		
		while
			1 = 1 begin
			
			fetch
				PartsQtyAvailable
			into
				@Serial
			,	@PartInventory
			,	@QtyAvailable
			
			if	@@fetch_status != 0 begin
				break
			end
			
			declare
				@ReqID integer
			,	@Balance numeric(30, 12)
			,	@Sequence integer
			
			declare	Requirements cursor local for
			select
				ID
			,	Balance
			,	Sequence
			from
				@NetMPS
			where
				Part = @PartInventory
				and Balance > 0
			order by
				BOMLevel
			,	BOMID
			
			open
				Requirements
		
			while
				1 = 1
				and @QtyAvailable > 0  begin	
				
				fetch
					Requirements
				into
					@ReqID
				,	@Balance
				,	@Sequence
				
				if	@@fetch_status != 0 begin
					break
				end
				
				if @Balance > @QtyAvailable begin
					update
						@NetMPS
					set 
						Balance = @Balance - @QtyAvailable
					,	QtyAvailable = QtyAvailable + @QtyAvailable
					where
						ID = @ReqID

					insert
						@X
					(	Sequence
					,	WIPQty 
					)
					select
						Sequence = @Sequence + XRt.Sequence
					,	WIPQty = @QtyAvailable * XRt.XQty
					from
						@XRt XRt
					where
						XRt.TopPart = @PartInventory
						and XRt.Sequence > 0
		
					insert
						@Y
					(	BOMID
					,	Serial
					,	QtyIssue
					)
					select
						BOMID
					,	@Serial
					,	@QtyAvailable
					from
						@NetMPS
					where
						ID = @ReqID
		
					set	@QtyAvailable = 0
				end
				else begin			
					update
						@NetMPS
					set 
						Balance = 0
					,	QtyAvailable = QtyAvailable + @Balance
					where
						ID = @ReqID

					insert  @X
							(										 Sequence
							,WIPQty 
							)
							select
								Sequence = @Sequence + XRt.Sequence
							,	WIPQty = @Balance * XRt.XQty
							from
								@XRt XRt
							where
								XRt.TopPart = @PartInventory
								and XRt.Sequence > 0

					insert  @Y
							(										 BOMID
							,Serial
							,QtyIssue
							)
							select
								BOMID
							,	@Serial
							,	@Balance
							from
								@NetMPS
							where
								ID = @ReqID
		
					set	@QtyAvailable = @QtyAvailable - @Balance
				end
			end
			close
				Requirements
			deallocate
				Requirements
		end
		close
			PartsQtyAvailable
		deallocate
			PartsQtyAvailable
		
		set	@LowLevel = @LowLevel + 1

		update
			@NetMPS
		set 
			WIPQty = coalesce(
				(	select
						sum(WIPQty)
					 from
						@X X
					 where
						NetMPS.Sequence = X.Sequence
				)
			,	0
			)
		from
			@NetMPS NetMPS
		where
			LowLevel = @LowLevel

		update
			@NetMPS
		set 
			Balance = Balance - WIPQty
		where
			LowLevel = @LowLevel
	end
	
	--	Build result set.
	insert
		@Inventory
	(	Serial
	,	Part
	,	BOMLevel
	,	Sequence
	,	Suffix
	,	BOMID
	,	AllocationDT
	,	QtyPer
	,	QtyAvailable
	,	QtyRequired
	,	QtyIssue
	,	QtyOverage
	)
	select
		coalesce(OnHand.Serial, -1)
	,	NetMPS.Part
	,	NetMPS.BOMLevel
	,	NetMPS.Sequence
	,	Suffix = 0
	,	BOMID = coalesce(NetMPS.BOMID, -1)
	,	AllocationDT = OnHand.AllocationDT
	,	QtyPer = NetMPS.XQty
	,	QtyAvailable = OnHand.QtyAvailable - coalesce(
		(	select
				sum(QtyIssue)
			from
				@Y
			where
				Serial = OnHand.Serial
				and BOMID < NetMPS.BOMID
			)
		,	0
		)
	,	QtyRequired = NetMPS.Balance + NetMPS.QtyAvailable + NetMPS.WIPQty
	,	QtyIssue = InventoryAllocation.QtyIssue
	,	QtyOverage =
			case
				when OnHand.Serial is null then NetMPS.Balance
				when OnHand.Serial =
					(	select
							max(Serial)
						from
							@OnHand
						where
							Part = NetMPS.Part
							and AllocationDT = coalesce(LastAllocation.LastAllocated, OnHand.AllocationDT)
					) then NetMPS.Balance
				else 0
			end
	from
		@NetMPS NetMPS
		left join @Y InventoryAllocation
			on NetMPS.BOMID = InventoryAllocation.BOMID
		left join @OnHand OnHand
			on InventoryAllocation.Serial = OnHand.Serial
		left join
		(	select
				Part
			,	LastAllocated = max(AllocationDT)
			from
				@OnHand
			group by
				Part
		) LastAllocation
			on OnHand.Part = LastAllocation.Part
		join
		(	select
				Part
			,	TotalRequirement = sum(XQty)
			from
				@NetMPS
			group by
				Part
		) TotalRequirement
			on NetMPS.Part = TotalRequirement.Part
	where
		(	OnHand.Serial is null
	 		and coalesce(NetMPS.Department, '') != @Department
		)
		or coalesce(InventoryAllocation.QtyIssue, -1) > 0
	order by
		NetMPS.Sequence
	,	OnHand.AllocationDT
--- </Body>

---	<Return>
	return
end
/*
declare
	@WODID int,
	@QtyRequested numeric (20,6)

set	@WODID = 7
set	@QtyRequested = 4000

select
	*
from
	FT.fn_GetBackflushDetailsMachine (@WODID, @QtyRequested)
*/
GO
