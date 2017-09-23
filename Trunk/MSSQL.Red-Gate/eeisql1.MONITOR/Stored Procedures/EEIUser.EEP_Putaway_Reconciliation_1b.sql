SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec eeiuser.eep_putaway_reconciliation_1b '12494','12495','12496', NULL, NULL

CREATE procedure [EEIUser].[EEP_Putaway_Reconciliation_1b] (@shipper1 varchar(25), @shipper2 varchar(25), @shipper3 varchar(25), @shipper4 varchar(25), @shipper5 varchar(25))

as

declare @tran_locations table
			(	
				tran_location varchar(25)
			)

insert	@tran_locations
	select	distinct(to_loc) 
	from	audit_trail 
	where	shipper in (ISNULL(@shipper1,'x12f1f23'), ISNULL(@shipper2,'x12f1f23'), ISNULL(@shipper3,'x12f1f23'), ISNULL(@shipper4,'x12f1f23'), ISNULL(@shipper5,'x12f1f23'))


select * from @tran_locations

---- What is still in container location that hasn't been putaway:

--select	serial
--	   ,object.part
--	   ,cross_ref
--	   ,quantity
--	   ,location
--	   ,parent_serial 
--from	object
--	join part on object.part = part.part
--where	location in (select tran_location from @tran_locations)
--	and object.part <> 'PALLET'	 
--order by 6,2,1



GO
