SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_FixFTZNo] (		@OldFTZNo 		varchar (50),
																@NewFTZNo		varchar(50),
																@OLDITNo		varchar(50),
																@NewITNo		varchar(50) )
as
Begin
	
	declare		@IntoFTZDate datetime
	
	Select @IntoFTZDate = min(date_stamp) from Audit_trail where type= 'Z' and custom4 = @OldFTZNo
	
		If exists (Select 1 from FTZIDs where twofourteenNO = @NewFTZNo or ITNO = @newITNo )
		Begin
			Select		audit_trail.serial,
					audit_trail.part,
					audit_trail.quantity,
					Custom3,
					Custom4
	from			audit_trail
	where		1=0
		RETURN		
	end
	
ELSE
	
	Select	@oldITNo = ITNO from FTZIDs where twofourteenNO = @OLDFTZNo
	
	Begin
	Insert	FTZIds
	Select @NewFTZNo,
				@oldITNo,
				getdate(),
				NULL,
				NULL,
				(CASE WHEN @NewITNo = '' or @NewITNo is NULL THEN NULL ELSE @newITNo END),
				(CASE WHEN @NewITNo = '' or @NewITNo is NULL THEN NULL ELSE getdate() END)
				
		Update FTZids
		set		newtwofourteenNO= @NewFTZno,
					datemodified = getdate(),
					NewITNo = @newITNo
				where	FTZids.twofourteenNo = @OLDFTZNo
	
	
	
	Create table #serialstofix
	(serial 		integer,
	FTZNo 		varchar (50),
	ITNo 		varchar(50))
	
	Insert	#serialstofix
	select 	serial,
				(CASE WHEN custom4 = @OLDFTZno THEN @NewFtzNo ELSE custom4 END),
				(CASE WHEN @NewITNo = '' or @NewITNo is NULL THEN custom3 ELSE @NewITNo END)
	from 	audit_trail where date_stamp> '2005/06/28' and 
				type in ( 'Z', 'B') and 
				custom4= @OldFTZNo 
	
	Update		object
	set			custom4 = FTZNo,
					custom3 = ITNo
	from			object,
					#serialstofix
	where		object.serial = #serialstofix.serial
					
	Update		audit_trail
	set			custom4 = FTZNo,
					custom3 = ITNo
	from			audit_trail,
					#serialstofix
	where		audit_trail.serial = #serialstofix.serial and
					audit_trail.date_stamp >= @IntoFTZDate
	
						
	
	Select		audit_trail.serial,
					audit_trail.part,
					audit_trail.quantity,
					Custom3,
					Custom4
	from			audit_trail
	join			#serialstofix on audit_trail.serial = #serialstofix.serial
	where		audit_trail.type = 'Z'  and
					audit_trail.part <> 'PALLET'
End
End


GO
