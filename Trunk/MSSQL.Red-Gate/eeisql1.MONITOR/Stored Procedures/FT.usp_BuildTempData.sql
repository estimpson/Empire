SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_BuildTempData]
	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
with encryption
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	declare
		@cDebug int = @Debug + 2 -- Proc level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@TimeDiff varchar(max)
		,	@TocMsg varchar(max)
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@TranDT] = @TranDT
					,	[@Result] = @Result
					,	[@Debug] = @Debug
					,	[@DebugMsg] = @DebugMsg
					for xml raw			
				)
			)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	set	@Result = 999999

	--- <Error Handling>
	declare
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname
	,	@ProcReturn integer
	,	@ProcResult integer
	,	@Error integer
	,	@RowCount integer

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>

		---	</ArgumentValidation>

		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Build Trading Partner data. */
		set @TocMsg = 'Build Trading Partner data.'
		begin
			if	object_id('tempdb..TradingPartners') is not null begin
				drop table
					tempdb..TradingPartners
			end

			create table tempdb..TradingPartners
			(	TradingPartner varchar(50)
			,	ICN int
			)

			insert
				tempdb..TradingPartners
			(	TradingPartner
			,	ICN
			)
			select top(50)
				ed.TradingPartner
			,	ed.ICN
			from
				(	select
						*
					,	RowNum = row_number() over (partition by ed.TradingPartner, ed.ICN order by RowTS desc)
					from
						(	select top(1000)
								ed.TradingPartner
							,	ICN = ed.Data.value('(*/TRN-INFO/@ICN)[1]', 'int')
							,	ed.RowTS
							from
								FxEDI.EDI.EDIDocuments ed
							where
								ed.TradingPartner is not null
							order by
								ed.RowTS desc
						) ed
					where
						ed.ICN is not null
				) ed
			where
				ed.RowNum = 1
			order by
				ed.TradingPartner
			,	ed.ICN

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Ship To data. */
		set @TocMsg = 'Build Ship To data.'
		begin
			if	object_id('tempdb..ShipTos') is not null begin
				drop table
					tempdb..ShipTos
			end

			create table tempdb..ShipTos
			(	ShipTo varchar(50)
			,	ICN int
			,	TradingPartner varchar(50)
			)

			insert
				tempdb..ShipTos
			(	ShipTo
			,	ICN
			,	TradingPartner
			)
			select
				ed.ShipTo
			,	ed.ICN
			,	ed.TradingPartner
			from
				(	select
						*
					,	RowNum = row_number() over (partition by ed.TradingPartner, ed.ICN, ed.ShipTo order by RowTS desc)
					from
						(	select top(1000)
								ed.TradingPartner
							,	ICN = ed.Data.value('(*/TRN-INFO/@ICN)[1]', 'int')
							,	ShipTo = coalesce
									(	ed.Data.value('(*/LOOP-N1/SEG-N1 [DE[.="ST"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-N1/SEG-N1 [DE[.="MI"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-NAD/SEG-NAD[DE[.="BY"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-NAD/SEG-NAD[DE[.="MI"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-GIS/LOOP-NAD/SEG-NAD[DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-GEI/LOOP-NAD/SEG-NAD[DE[.="ST"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
								)
							,	ed.RowTS
							from
								FxEDI.EDI.EDIDocuments ed
							where
								ed.TradingPartner is not null
							order by
								ed.RowTS desc
						) ed
					where
						ed.ICN is not null
						and ed.TradingPartner is not null
						and ed.ShipTo is not null
				) ed
			where
				ed.RowNum = 1
			order by
				ed.TradingPartner
			,	ed.ICN
			,	ed.ShipTo

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Ship From data. */
		set @TocMsg = 'Build Ship From data.'
		begin
			if	object_id('tempdb..ShipFroms') is not null begin
				drop table
					tempdb..ShipFroms
			end

			create table tempdb..ShipFroms
			(	ShipFrom varchar(50)
			,	ICN int
			,	TradingPartner varchar(50)
			)

			insert
				tempdb..ShipFroms
			(	ShipFrom
			,	ICN
			,	TradingPartner
			)
			select
				ed.ShipFrom
			,	ed.ICN
			,	ed.TradingPartner
			from
				(	select
						*
					,	RowNum = row_number() over (partition by ed.TradingPartner, ed.ICN, ed.ShipFrom order by RowTS desc)
					from
						(	select top(1000)
								ed.TradingPartner
							,	ICN = ed.Data.value('(*/TRN-INFO/@ICN)[1]', 'int')
							,	ShipFrom = coalesce
									(	ed.Data.value('(*/LOOP-N1/SEG-N1 [DE[.="SU" or .="SF" or .="SE"][@code="0098"]]/DE[@code="0067"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-NAD/SEG-NAD[DE[.="SU" or .="SF" or .="SE"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
									,	ed.Data.value('(*/LOOP-GIS/LOOP-NAD/SEG-NAD[DE[.="SU" or .="SF" or .="SE"][@code="3035"]]/CE/DE[@code="3039"])[1]', 'varchar(100)')
								)
							,	ed.RowTS
							from
								FxEDI.EDI.EDIDocuments ed
							where
								ed.TradingPartner is not null
							order by
								ed.RowTS desc
						) ed
					where
						ed.ICN is not null
						and ed.TradingPartner is not null
						and ed.ShipFrom is not null
				) ed
			where
				ed.RowNum = 1
			order by
				ed.TradingPartner
			,	ed.ICN
			,	ed.ShipFrom

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Requirement data. */
		set @TocMsg = 'Build Requirement data.'
		begin
			if	object_id('tempdb..Requirements') is not null begin
				drop table
					tempdb..Requirements
			end

			create table tempdb..Requirements
			(	EDI_ShipToName varchar(50)
			,	ShipToName varchar(50)
			,	EDI_PartName varchar(50)
			,	PartName varchar(50)
			,	Quantity numeric(20,6)
			,	Accum numeric(20,6)
			,	DueDT datetime
			,	ICN int
			,	TradingPartner varchar(50)
			)

			insert
				tempdb..Requirements
			(	EDI_ShipToName
			,	ShipToName
			,	EDI_PartName
			,	PartName
			,	Quantity
			,	Accum
			,	DueDT
			,	ICN
			,	TradingPartner
			)
			select
				EDI_ShipToName = st.ShipTo
			,	ShiptoName = es.destination
			,	EDI_PartName = od.customer_part
			,	PartName = od.part_number
			,	Quantity = od.std_qty
			,	Accum = od.the_cum
			,	DueDT = od.due_date
			,	st.ICN
			,	st.TradingPartner
			from
				dbo.order_detail od
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
			where
				od.due_date between getdate() - 1 and getdate() + 7
			order by
				1, 3, 7

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Part data. */
		set @TocMsg = 'Build Part data.'
		begin
			if	object_id('tempdb..Parts') is not null begin
				drop table
					tempdb..Parts
			end

			create table tempdb..Parts
			(	ICN int
			,	TradingPartner varchar(50)
			,	EDI_ShipToName varchar(50)
			,	ShipToName varchar(50)
			,	EDI_PartName varchar(50)
			,	PartName varchar(50)
			,	StandardPack numeric(20,6)
			,	CurrentAccum numeric(20,6)
			,	UnitWeight numeric(20,6)
			)

			insert
				tempdb..Parts
			(	ICN
			,	TradingPartner
			,	EDI_ShipToName
			,	ShipToName
			,	EDI_PartName
			,	PartName
			,	StandardPack
			,	CurrentAccum
			,	UnitWeight
			)
			select
				sp.ICN
			,	sp.TradingPartner
			,	sp.EDI_ShipToName
			,	sp.ShiptoName
			,	sp.EDI_PartName
			,	max(sp.PartName)
			,	min(sp.StandardPack)
			,	max(sp.CurrentAccum)
			,	max(sp.UnitWeight)
			from
				(	select distinct
						st.ICN
					,	st.TradingPartner
					,	EDI_ShipToName = st.ShipTo
					,	ShiptoName = es.destination
					,	EDI_PartName = od.customer_part
					,	PartName = left(od.part_number, 7)
					,	StandardPack = coalesce
							(	case
									when oh.standard_pack > 1 then oh.standard_pack
								end
							,	(	select
		 								max(pp.quantity)
		 							from
		 								dbo.part_packaging pp
									where
										pp.part = od.part_number
										and pp.quantity > 1
		 						)
							,	(	select
		 								max(at.quantity)
		 							from
		 								dbo.audit_trail at
									where
										at.part = od.part_number
										and at.type = 'S'
		 						)
							,	999
							)
					,	CurrentAccum = oh.our_cum
					,	UnitWeight = pInv.unit_weight
					from
						dbo.order_detail od
						join dbo.order_header oh
							on oh.order_no = od.order_no
						join dbo.edi_setups es
							on es.destination = od.destination
							join tempdb..ShipTos st
								on st.ShipTo = es.EDIShipToID
						join dbo.part_inventory pInv
							on pInv.part = od.part_number
					where
						od.due_date between getdate() - 1 and  getdate() + 7
				) sp
			group by
				sp.ICN
			,	sp.TradingPartner
			,	sp.EDI_ShipToName
			,	sp.ShiptoName
			,	sp.EDI_PartName

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Pack data. */
		set @TocMsg = 'Build Pack data.'
		begin
			if	object_id('tempdb..Packs') is not null begin
				drop table
					tempdb..Packs
			end

			create table tempdb..Packs
			(	ICN int
			,	TradingPartner varchar(50)
			,	EDI_PackName varchar(50)
			,	Weight numeric(20,6)
			,	Type char(1)
			)

			insert
				tempdb..Packs
			(	ICN
			,	TradingPartner
			,	EDI_PackName
			,	Weight
			,	Type
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			--,	EDI_PartName = od.customer_part
			,	EDI_PackName = pm.code
			,	Weight = pm.weight
			,	Type = 'B'
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.part_packaging pp
					join dbo.package_materials pm
						on pm.code = pp.code
						and pm.type = 'B'
					on pp.part = od.part_number
			where
				od.due_date between getdate() - 1 and  getdate() + 7

			insert
				tempdb..Packs
			(	ICN
			,	TradingPartner
			,	EDI_PackName
			,	Weight
			,	Type
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			--,	EDI_PartName = od.customer_part
			,	EDI_PackName = pm.code
			,	Weight = pm.weight
			,	Type = 'P'
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.part_packaging pp
					join dbo.package_materials pm
						on pm.code = pp.code
						and coalesce(pm.type, 'x') != 'B'
					on pp.part = od.part_number
			where
				od.due_date between getdate() - 1 and  getdate() + 7

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Part-Pack data. */
		set @TocMsg = 'Build Part-Pack data.'
		begin
			if	object_id('tempdb..PartPacks') is not null begin
				drop table
					tempdb..PartPacks
			end

			create table tempdb..PartPacks
			(	ICN int
			,	TradingPartner varchar(50)
			,	EDI_PartName varchar(50)
			,	EDI_PackName varchar(50)
			,	StandardPack numeric(20,6)
			)

			insert
				tempdb..PartPacks
			(	ICN
			,	TradingPartner
			,	EDI_PartName
			,	EDI_PackName
			,	StandardPack
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			,	EDI_PartName = od.customer_part
			,	EDI_PackName = pm.code
			,	StandardPack = coalesce(nullif(pp.quantity, 1), 99)
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.part_packaging pp
					join dbo.package_materials pm
						on pm.code = pp.code
						and pm.type = 'B'
					on pp.part = od.part_number
			where
				od.due_date between getdate() - 1 and  getdate() + 7

			insert
				tempdb..PartPacks
			(	ICN
			,	TradingPartner
			,	EDI_PartName
			,	EDI_PackName
			,	StandardPack
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			,	EDI_PartName = od.customer_part
			,	EDI_PackName = pm.code
			,	StandardPack = coalesce(nullif(pp.quantity, 1), 99)
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.part_packaging pp
					join dbo.package_materials pm
						on pm.code = pp.code
						and coalesce(pm.type, 'x') != 'B'
					on pp.part = od.part_number
			where
				od.due_date between getdate() - 1 and  getdate() + 7

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Carrier data. */
		set @TocMsg = 'Build Carrier data.'
		begin
			if	object_id('tempdb..Carriers') is not null begin
				drop table
					tempdb..Carriers
			end

			create table tempdb..Carriers
			(
			--	ICN int
			--,	TradingPartner varchar(50)
			--,	EDI_ShipToName varchar(50)
			--,	ShipToName varchar(50)
			--,	
				EDI_CarrierName varchar(50)
			,	CarrierName varchar(50)
			)

			insert
				tempdb..Carriers
			(
			--	ICN
			--,	TradingPartner
			--,	EDI_ShipToName
			--,	ShipToName
			--,
				EDI_CarrierName
			,	CarrierName
			)
			select distinct
			--	st.ICN
			--,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			--,
				EDI_CarrierName = s.ship_via
			,	CarrierName = c.name
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.shipper_detail sd
					join dbo.shipper s
						on s.id = sd.shipper
					on sd.order_no = oh.order_no
				join dbo.carrier c
					on c.scac = s.ship_via
			where
				s.date_shipped > getdate() - 90

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Trans Mode data. */
		set @TocMsg = 'Build Trans Mode data.'
		begin
			if	object_id('tempdb..TransModes') is not null begin
				drop table
					tempdb..TransModes
			end

			create table tempdb..TransModes
			(
				ICN int
			,	TradingPartner varchar(50)
			--,	EDI_ShipToName varchar(50)
			--,	ShipToName varchar(50)
			,	
				EDI_TransModeName varchar(50)
			,	TransModeName varchar(50)
			)

			insert
				tempdb..TransModes
			(
				ICN
			,	TradingPartner
			--,	EDI_ShipToName
			--,	ShipToName
			,
				EDI_TransModeName
			,	TransModeName
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			,
				EDI_TransModeName = tm.code
			,	TransModeName = tm.description
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.shipper_detail sd
					join dbo.shipper s
						on s.id = sd.shipper
					on sd.order_no = oh.order_no
				join dbo.trans_mode tm
					on s.trans_mode = tm.code
			where
				s.date_shipped > getdate() - 90

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Freight Type data. */
		set @TocMsg = 'Build Freight Type data.'
		begin
			if	object_id('tempdb..FreightTypes') is not null begin
				drop table
					tempdb..FreightTypes
			end

			create table tempdb..FreightTypes
			(
				ICN int
			,	TradingPartner varchar(50)
			--,	EDI_ShipToName varchar(50)
			--,	ShipToName varchar(50)
			,	
				EDI_FreightTypeName varchar(50)
			,	FreightTypeName varchar(50)
			)

			insert
				tempdb..FreightTypes
			(
				ICN
			,	TradingPartner
			--,	EDI_ShipToName
			--,	ShipToName
			,
				EDI_FreightTypeName
			,	FreightTypeName
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			--,	EDI_ShipToName = st.ShipTo
			--,	ShiptoName = es.destination
			,
				EDI_FreightTypeName = ftd.type_name
			,	FreightTypeName = ftd.type_name
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.shipper_detail sd
					join dbo.shipper s
						on s.id = sd.shipper
					on sd.order_no = oh.order_no
				join dbo.freight_type_definition ftd
					on ftd.type_name = s.freight_type
			where
				s.date_shipped > getdate() - 90

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Transportation Definition data. */
		set @TocMsg = 'Build Transportation Definition data.'
		begin
			if	object_id('tempdb..TransportationDefinitions') is not null begin
				drop table
					tempdb..TransportationDefinitions
			end

			create table tempdb..TransportationDefinitions
			(
				ICN int
			,	TradingPartner varchar(50)
			,	EDI_ShipToName varchar(50)
			,	ShipToName varchar(50)
			,	EDI_CarrierName varchar(50)
			,	EDI_TransModeName varchar(50)
			,	EDI_FreightTypeName varchar(50)
			)

			insert
				tempdb..TransportationDefinitions
			(
				ICN
			,	TradingPartner
			,	EDI_ShipToName
			,	ShipToName
			,	EDI_CarrierName
			,	EDI_TransModeName
			,	EDI_FreightTypeName
			)
			select distinct
				st.ICN
			,	st.TradingPartner
			,	EDI_ShipToName = st.ShipTo
			,	ShiptoName = es.destination
			,	EDI_CarrierName = c.scac
			,	EDI_TransModeName = tm.code
			,	EDI_FreightTypeName = ftd.type_name
			from
				dbo.order_detail od
				join dbo.order_header oh
					on oh.order_no = od.order_no
				join dbo.edi_setups es
					on es.destination = od.destination
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
				join dbo.shipper_detail sd
					join dbo.shipper s
						on s.id = sd.shipper
					on sd.order_no = oh.order_no
				join dbo.carrier c
					on s.ship_via = c.scac
				join dbo.trans_mode tm
					on s.trans_mode = tm.code
				join dbo.freight_type_definition ftd
					on ftd.type_name = s.freight_type
			where
				s.date_shipped > getdate() - 90

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Ship To XRef data. */
		set @TocMsg = 'Build Ship To XRef data.'

		/*	Build Shipper data. */
		set @TocMsg = 'Build Shipper data.'
		begin
			if	object_id('tempdb..Shippers') is not null begin
				drop table
					tempdb..Shippers
			end

			create table tempdb..Shippers
			(	EDI_ShipToName varchar(50)
			,	ShipperNumber int
			,	ShipperStatus char(1)
			,	EDI_CarrierName char(4)
			,	EDI_TransportationCode char(2)
			,	EDI_FreightTypeName varchar(50)
			,	PickupDateTime datetime
			)

			insert
				tempdb..Shippers
			(	EDI_ShipToName
			,	ShipperNumber
			,	ShipperStatus
			,	EDI_CarrierName
			,	EDI_TransportationCode
			,	EDI_FreightTypeName
			,	PickupDateTime
			)
			select
				EDI_ShipToName = st.ShipTo
			,	ShipperNumber = s.id
			,	ShipperStatus = s.status
			,	EDI_CarrierName = c.scac
			,	EDI_TransportationCode = tm.code
			,	EDI_FreightTypeName = ftd.type_name
			,	PickupDateTime = s.date_stamp
			from
				dbo.shipper s
				join dbo.edi_setups es
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
					on es.destination = s.destination
				join dbo.carrier c
					on c.scac = s.ship_via
				join dbo.trans_mode tm
					on tm.code = s.trans_mode
				join dbo.freight_type_definition ftd
					on s.freight_type = ftd.type_name
			where
				s.type is null
				and s.status in ('O', 'S')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Shipper Line data. */
		set @TocMsg = 'Build Shipper Line data.'
		begin
			if	object_id('tempdb..ShipperLines') is not null begin
				drop table
					tempdb..ShipperLines
			end

			create table tempdb..ShipperLines
			(	ShipperNumber int
			,	ScheduledQuantity decimal(20,6)
			,	EDI_PartName varchar(50)
			)

			insert
				tempdb..ShipperLines
			(	ShipperNumber
			,	ScheduledQuantity
			,	EDI_PartName
			)
			select
				ShipperNumber = s.id
			,	ScheduledQuantity = sd.qty_required
			,	EDI_PartName = sd.customer_part
			from
				dbo.shipper s
				join dbo.shipper_detail sd
					on sd.shipper = s.id
				join dbo.edi_setups es
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
					on es.destination = s.destination
				join dbo.carrier c
					on c.scac = s.ship_via
				join dbo.trans_mode tm
					on tm.code = s.trans_mode
				join dbo.freight_type_definition ftd
					on s.freight_type = ftd.type_name
			where
				s.type is null
				and s.status in ('O', 'S')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Build Shipper Object data. */
		set @TocMsg = 'Build Shipper Object data.'
		begin
			if	object_id('tempdb..ShipperObjects') is not null begin
				drop table
					tempdb..ShipperObjects
			end

			create table tempdb..ShipperObjects
			(	ShipperNumber int
			,	ParentSerial int
			,	SerialNumber int
			,	ObjectType char(1)
			,	EDI_PartName varchar(50)
			,	EDI_PackName varchar(50)
			,	ObjectQuantity decimal(20,6)
			)

			insert
				tempdb..ShipperObjects
			(	ShipperNumber
			,	ParentSerial
			,	SerialNumber
			,	ObjectType
			,	EDI_PartName
			,	EDI_PackName
			,	ObjectQuantity
			)
			select
				ShipperNumber = s.id
			,	ParentSerial = o.parent_serial
			,	SerialNumber = o.serial
			,	ObjectType = o.type
			,	EDI_PartName = sd.customer_part
			,	EDI_PackName = o.package_type
			,	ObjectQuantity = o.std_quantity
			from
				dbo.object o
				join dbo.shipper s
					on o.shipper = s.id
				join dbo.shipper_detail sd
					on sd.shipper = s.id
					and sd.part_original = o.part
				join dbo.edi_setups es
					join tempdb..ShipTos st
						on st.ShipTo = es.EDIShipToID
					on es.destination = s.destination
				join dbo.carrier c
					on c.scac = s.ship_via
				join dbo.trans_mode tm
					on tm.code = s.trans_mode
				join dbo.freight_type_definition ftd
					on s.freight_type = ftd.type_name
				--left join tempdb.dbo.Packs p
				--	on p.EDI_PackName = o.package_type
			where
				s.type is null
				and s.status in ('O', 'S')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = convert
				(	varchar(max)
				,	(	select
							[@TranDT] = @TranDT
						,	[@Result] = @Result
						,	[@DebugMsg] = @DebugMsg
						for xml raw			
					)
				)
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
		end
		--- </TIC/TOC END>

		---	<Return>
		set	@Result = 0
		return
			@Result
		--- </Return>
	end try
	begin catch
		declare
			@errorSeverity int
		,	@errorState int
		,	@errorMessage nvarchar(2048)
		,	@xact_state int
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state()

		execute FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			execute FXSYS.usp_LogError
		end

		raiserror(@errorMessage, @errorSeverity, @errorState)
	end catch
end

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
	@FinishedPart varchar(25) = 'ALC0598-HC02'
,	@ParentHeirarchID hierarchyid

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_BuildTempData
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = @ParentHeirarchID
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

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
