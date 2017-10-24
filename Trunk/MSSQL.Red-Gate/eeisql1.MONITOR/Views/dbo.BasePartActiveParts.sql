SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BasePartActiveParts]
as
select
	acvssf.BasePart
,	ActiveOrderPartEEH = max(coalesce(xr1.ChildPart, acvssf.ActiveOrderPart))
,	CurrentRevLevelEEH = max(coalesce(xr2.ChildPart, acvssf.CurrentRevLevel))
,	LastShippedPartEEH = max(coalesce(xr3.ChildPart, acvssf.LastShippedPart))
,	ActiveOrderPart = max(coalesce(xr1.TopPart, acvssf.ActiveOrderPart))
,	CurrentRevLevel = max(coalesce(xr2.TopPart, acvssf.CurrentRevLevel))
,	LastShippedPart = max(coalesce(xr3.TopPart, acvssf.LastShippedPart))
from
	(	select
			BasePart = acvssf.base_part
		,	ActiveOrderPart = max(ohActive.blanket_part)
		,	CurrentRevLevel = max(pe.part)
		,	LastShippedPart = max(lastShip.part)
		from
			MONITOR.eeiuser.acctg_csm_vw_select_sales_forecast acvssf
			left join MONITOR.dbo.order_header ohActive
				on ohActive.status = 'A'
				and left(ohActive.blanket_part, 7) = acvssf.base_part
			left join MONITOR.dbo.part_eecustom pe
				on pe.CurrentRevLevel = 'Y'
				and left(pe.part, 7) = acvssf.base_part
			outer apply
				(	select top 1
						part = sd.part_original
					from
						MONITOR.dbo.shipper_detail sd
					where
						left(sd.part_original, 7) = acvssf.base_part
						and sd.part_original not like acvssf.base_part + '-PT%'
						and sd.date_shipped is not null
					order by
						sd.date_shipped desc
				) lastShip
		group by
			acvssf.base_part
	) acvssf
	left join Monitor.FT.XRt xr1
		join Monitor.dbo.po_header ph1
			on ph1.blanket_part = xr1.ChildPart
			and ph1.vendor_code = 'EEH'
		on xr1.TopPart = acvssf.ActiveOrderPart
		and xr1.TopPart != xr1.ChildPart
	left join Monitor.FT.XRt xr2
		join Monitor.dbo.po_header ph2
			on ph2.blanket_part = xr2.ChildPart
			and ph2.vendor_code = 'EEH'
		on xr2.TopPart = acvssf.CurrentRevLevel
		and xr2.TopPart != xr2.ChildPart
	left join Monitor.FT.XRt xr3
		join Monitor.dbo.po_header ph3
			on ph3.blanket_part = xr3.ChildPart
			and ph3.vendor_code = 'EEH'
		on xr3.TopPart = acvssf.LastShippedPart
		and xr3.TopPart != xr3.ChildPart
group by
	acvssf.BasePart
GO
