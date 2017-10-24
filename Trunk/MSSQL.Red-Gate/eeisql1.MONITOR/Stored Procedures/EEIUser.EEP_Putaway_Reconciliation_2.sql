SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec eeiuser.eep_putaway_reconciliation_2 '2011-09-08','COSN1M081794','EEH-12512','EEH-12513','EEH-12514','none','none'

CREATE procedure [EEIUser].[EEP_Putaway_Reconciliation_2] (@arrival_date datetime, @bill_of_lading varchar(25), @shipper1 varchar(25), @shipper2 varchar(25), @shipper3 varchar(25), @shipper4 varchar(25), @shipper5 varchar(25))

as

declare @tran_locations table
			(	
				tran_location varchar(25)
			)

insert	@tran_locations
	select	distinct(to_loc) 
	from	audit_trail 
	where	shipper in (ISNULL(@shipper1,'x12f1f23'), ISNULL(@shipper2,'x12f1f23'), ISNULL(@shipper3,'x12f1f23'), ISNULL(@shipper4,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'))

--select * from @tran_locations
-- 1. Compare what was shipped vs what was received:

select	*, 
		ISNULL(b.quantity,0)-ISNULL(a.quantity,0) as variance 
from 

		(	select	audit_trail.part, 
					cross_ref, 
					sum(quantity) as quantity,
					@bill_of_lading as bill_of_lading, 
					shipper
			from	audit_trail 
				left join part on audit_trail.part = part.part 
			where	shipper in (ISNULL(@shipper1,'x12f1f23'), ISNULL(@shipper2,'x12f1f23'), ISNULL(@shipper3,'x12f1f23'), ISNULL(@shipper4,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'))
				and audit_trail.type = 'R' 
			group by audit_trail.part, cross_ref, shipper
		)a

		full outer join

		(	select  audit_trail.part, 
					part.cross_ref, 
					sum(audit_trail.quantity) as quantity,
					at2.shipper
			from	audit_trail 
				left join audit_trail at2 on audit_trail.serial = at2.serial and at2.type = 'R'
				left join location on audit_trail.to_loc = location.code 
				left join part on audit_trail.part = part.part 
			where	audit_trail.date_stamp >= dateadd(d,-1,@arrival_date)  
				and audit_trail.date_stamp <= dateadd(d,+1,@arrival_date)
				and audit_trail.type = 't' 
				and audit_trail.part <> 'PALLET' 
				and location.plant = 'EEP' 
				and audit_trail.from_loc in (select tran_location from @tran_locations)
			group by audit_trail.part, part.cross_ref, at2.shipper
		) b

		on a.part = b.part

order by ISNULL(a.part,b.part)



GO
