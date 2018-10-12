SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [FT].[fn_CSM_ActiveFinishedPart]()
RETURNS @ActiveParts table
(	BasePart char(7) primary key
,	ActiveOrderPart varchar(25)
,	CurrentRevLevel varchar(25)
,	LastShippedPart varchar(25)
,	LastHN varchar(25)
,	LastPT varchar(25)
,	ActiveOrderPart1 varchar(25)
,	CurrentRevLevel1 varchar(25)
,	LastShippedPart1 varchar(25)
)
AS
BEGIN 




insert
	@ActiveParts
(	BasePart
,	ActiveOrderPart
,	CurrentRevLevel
,	LastShippedPart
,	LastHN
,	LastPT
,	ActiveOrderPart1
,	CurrentRevLevel1
,	LastShippedPart1
)
select
	ap.BasePart
,	(	select
 			max(BOM.TopPart)
 		from
 			dbo.vw_RawQtyPerFinPart BOM
		where
			BOM.TopPart like
				case
					when ap.ActiveOrderPart like '___[A-Z]___' then left(ap.ActiveOrderPart, 3) + '%' + right(ap.ActiveOrderPart, len(ap.ActiveOrderPart)-4)
					else ap.ActiveOrderPart
				end
 	)
,	(	select
 			max(BOM.TopPart)
 		from
 			dbo.vw_RawQtyPerFinPart BOM
		where
			BOM.TopPart like
				case
					when ap.CurrentRevLevel like '___[A-Z]___' then left(ap.CurrentRevLevel, 3) + '%' + right(ap.CurrentRevLevel, len(ap.CurrentRevLevel)-4)
					else ap.CurrentRevLevel
				end
 	)
,	(	select
 			max(BOM.TopPart)
 		from
 			dbo.vw_RawQtyPerFinPart BOM
		where
			BOM.TopPart like
				case
					when ap.LastShippedPart like '___[A-Z]___' then left(ap.LastShippedPart, 3) + '%' + right(ap.LastShippedPart, len(ap.LastShippedPart)-4)
					else ap.LastShippedPart
				end
 	)
,	(	select
 			max(BOM.TopPart)
 		from
 			dbo.vw_RawQtyPerFinPart BOM
		where
			BOM.TopPart like
				case
					when ap.BasePart like '___[A-Z]___' then left(ap.BasePart, 3) + '%' + right(ap.BasePart, 3)
					else ap.BasePart
				end + '%-H%'
 	)
,	(	select
 			max(BOM.TopPart)
 		from
 			dbo.vw_RawQtyPerFinPart BOM
		where
			BOM.TopPart like
				case
					when ap.BasePart like '___[A-Z]___' then left(ap.BasePart, 3) + '%' + right(ap.BasePart, 3)
					else ap.BasePart
				end + '%-PT%'
 	)
,	(ap.ActiveOrderPart)
,	(ap.CurrentRevLevel)
,	(ap.LastShippedPart)
from
	openquery
		(	EEISQL1
		,	'

select
	acvssf.BasePart
,	ActiveOrderPart = max(coalesce(xr1.ChildPart, acvssf.ActiveOrderPart))
,	CurrentRevLevel = max(coalesce(xr2.ChildPart, acvssf.CurrentRevLevel))
,	LastShippedPart = max(coalesce(xr3.ChildPart, acvssf.LastShippedPart))
from
	(	select
			BasePart = acvssf.base_part
		,	ActiveOrderPart = max(ohActive.blanket_part)
		,	CurrentRevLevel = max(pe.part)
		,	LastShippedPart = max(lastShip.part)
		from
			MONITOR.eeiuser.acctg_csm_vw_select_sales_forecast acvssf
			left join MONITOR.dbo.order_header ohActive
				on ohActive.status = ''A''
				and left(ohActive.blanket_part, 7) = acvssf.base_part
			left join MONITOR.dbo.part_eecustom pe
				on pe.CurrentRevLevel = ''Y''
				and left(pe.part, 7) = acvssf.base_part
			outer apply
				(	select top 1
						part = sd.part_original
					from
						MONITOR.dbo.shipper_detail sd
					where
						left(sd.part_original, 7) = acvssf.base_part
						and sd.date_shipped is not null
						and sd.part_original not like ''%-PT%''
					order by
						sd.date_shipped desc
				) lastShip
		group by
			acvssf.base_part
	) acvssf
	left join Monitor.FT.XRt xr1
		join Monitor.dbo.po_header ph1
			on ph1.blanket_part = xr1.ChildPart
			and ph1.vendor_code = ''EEH''
		on xr1.TopPart = acvssf.ActiveOrderPart
		and xr1.TopPart != xr1.ChildPart
	left join Monitor.FT.XRt xr2
		join Monitor.dbo.po_header ph2
			on ph2.blanket_part = xr2.ChildPart
			and ph2.vendor_code = ''EEH''
		on xr2.TopPart = acvssf.CurrentRevLevel
		and xr2.TopPart != xr2.ChildPart
	left join Monitor.FT.XRt xr3
		join Monitor.dbo.po_header ph3
			on ph3.blanket_part = xr3.ChildPart
			and ph3.vendor_code = ''EEH''
		on xr3.TopPart = acvssf.LastShippedPart
		and xr3.TopPart != xr3.ChildPart
group by
	acvssf.BasePart

		'
		) ap





	RETURN
END

GO
