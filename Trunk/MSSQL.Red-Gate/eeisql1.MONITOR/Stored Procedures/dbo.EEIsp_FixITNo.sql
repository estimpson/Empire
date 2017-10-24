SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_FixITNo] (			@OLDITNo		varchar(50),
																@NewITNo		varchar(50),
																@TwoFourteenNo varchar(50) )
as
Begin
	
	If exists (Select 1 from FTZIDs where ITNO = @newITNo )
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
	Begin	
		
		
	
	Create table #serialstofix
	(serial 		integer,
	NewITNo 		varchar(50),
	TwoFourteenNo	varchar(50))
	
	Insert	#serialstofix
	select 	serial,
				@newITNo,
				custom4
from 	audit_trail where date_stamp> '2005/06/05' and 
				type in ( 'Z', 'B') and 
				custom3= @OldITNo
				
	Select  @twofourteenNo= (Select max(TwoFourteenNo) from #serialstoFix)
	
	Update		FTZIds 
	set 			newITNO = @NewITNo,
					newITCreateDate = getdate() 
	where 		twofourteenNo = @twofourteenNo
	
	Update		object
	set			custom3 = NewITNo
	from			object,
					#serialstofix
	where		object.serial = #serialstofix.serial
					
	Update		audit_trail
	set			custom3 = NewITNo
	from			audit_trail,
					#serialstofix
	where		audit_trail.serial = #serialstofix.serial
	
						
	
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
