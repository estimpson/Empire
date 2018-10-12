SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [FT].[usp_UpdateAPHeadersDirectDeposit] @CheckSelectionID varchar(25),  @direct_deposit varchar(1)
as
Begin

update
	dbo.ap_headers
set
	direct_deposit = @direct_deposit
where
	check_selection_identifier =  isnull(@CheckSelectionID,9999999999)
	
update 
	ap_check_selection_identifiers 
set 
	direct_deposit = @direct_deposit
where 
	check_selection_identifier = isnull(@CheckSelectionID,9999999999)

update
	ap_applications
set 
	direct_deposit = @direct_deposit 
where 
	check_selection_identifier = isnull(@CheckSelectionID,9999999999)


select 
	check_selection_identifier,
	pay_vendor,
	invoice_cm,
	direct_deposit		
from
	ap_headers
where
	check_selection_identifier = @CheckSelectionID

end



GO
