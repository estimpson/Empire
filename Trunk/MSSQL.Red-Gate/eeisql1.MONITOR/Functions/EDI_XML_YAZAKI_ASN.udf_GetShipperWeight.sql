SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_YAZAKI_ASN].[udf_GetShipperWeight]
(	@ShipperID int
,	@WeightType char(1)
)
returns int
as
begin
--- <Body>
	declare
		@weight int

	select
		@weight =
			case
				when @WeightType = 'N' then s.staged_objs * 6
				when @WeightType = 'G' then s.staged_objs * 6 + count(distinct at.parent_serial) * 10
				when @WeightType = 'T' then count(distinct at.parent_serial) * 10
			end
	from
		dbo.audit_trail at
		join dbo.shipper s
			on s.id = @ShipperID
	where
		at.shipper = convert(varchar, @ShipperID)
	group by
		at.shipper
	,	s.id
	,	s.staged_objs
--- </Body>

---	<Return>
	return
		@weight
end
GO
