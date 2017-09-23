SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[EEP_Putaway_Reconciliation_3] (@arrival_date datetime, @shipper1 varchar(25), @shipper2 varchar(25), @shipper3 varchar(25), @shipper4 varchar(25), @shipper5 varchar(25))

as

declare @tran_locations table
			(	
				tran_location varchar(25)
			)

insert	@tran_locations
	select	distinct(to_loc) 
	from	audit_trail 
	where	shipper in (ISNULL(@shipper1,'x12f1f23'), ISNULL(@shipper2,'x12f1f23'), ISNULL(@shipper3,'x12f1f23'), ISNULL(@shipper4,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'))


-- 1. What was putaway:

select	NULL as CustomsEntryNo,
		NULL as ClientCode,
		NULL as Warehouse,
		NULL as Reference,
		@arrival_date as ArrivalDate,
		cross_ref as ProductCode,
		SUM(quantity) as Quantity,
		'EA' as QuantityUQ,
		NULL as Pallets,
		to_loc as Location, 
		NULL as Attribute1,
		NULL as Attribute2,
		NULL as Attribute3,
		NULL as ExpiryDate,
		NULL as PackingDate,
		NULL as CustomsEntryLineNo,
		NULL as CustomsEntryDate,
		NULL as CustomsAddInfo,
		NULL as CustomsQty,
		NULL as CustomsUQ,
		NULL as CtryofOrigin,
		NULL as ValueForDuty,
		NULL as BondedWhsQty,
		NULL as BondedWhsUQ,
		NULL as TILV
from audit_trail 
left join location on audit_trail.to_loc = location.code 
left join part on audit_trail.part = part.part 
where	date_stamp >= dateadd(d,-1,@arrival_date)  
	and date_stamp <= dateadd(d,+1,@arrival_date) 
	and audit_trail.type = 't' 
	and audit_trail.part <> 'PALLET' 
	and location.plant = 'EEP' 
	and from_loc in (select tran_location from @tran_locations)
group by to_loc, audit_trail.part, cross_ref
order by 1,2


GO
