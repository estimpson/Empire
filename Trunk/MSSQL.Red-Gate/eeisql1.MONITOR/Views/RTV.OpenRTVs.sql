SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [RTV].[OpenRTVs]
as
select
	RTVShipper = s.id
,	PackingSlipPrinted = convert(bit,case when max(s.printed) = 'Y' then 1 else 0 end)
,	HN_RMA_Location = max(s.shipping_dock)
,	ProductLine = max(p.product_line)
,	SerialList = FX.ToList(sd.part_original + ': ' + so.SerialList)
from
	dbo.shipper s
		join dbo.shipper_detail sd
			join dbo.part p
				on p.part = sd.part_original
			 on sd.shipper = s.id
		outer apply
			(	select
					SerialList = FX.ToList(o.serial)
				from
					dbo.object o
				where
					o.part = sd.part_original
					and o.shipper = s.id
			) so
where
	s.type = 'V'
	and s.status in ('O', 'S')
group by
	s.id
GO
