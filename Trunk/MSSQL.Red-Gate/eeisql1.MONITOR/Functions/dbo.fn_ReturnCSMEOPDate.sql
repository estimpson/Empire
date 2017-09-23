SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [dbo].[fn_ReturnCSMEOPDate]
(	@CSMEOP varchar(25) )
returns	Datetime
begin
	declare	@ReturnDT Datetime
	
Set	@ReturnDT = 
	(CASE WHEN LEFT(@CSMEOP,3) in( '01/', 'Jan') THEN Convert(datetime, SUBSTRING(@CSMEOP,4,4) + '-12' +'-01') 
		WHEN LEFT(@CSMEOP,3) in ('02/', 'Feb') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-02' +'-01') 
		WHEN LEFT(@CSMEOP,3) in( '03/','Mar') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-03' +'-01') 
		WHEN LEFT(@CSMEOP,3) in( '04/','Apr') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-04' +'-01') 
		WHEN LEFT(@CSMEOP,3) in ('05/','May') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-05' +'-01')  
		WHEN LEFT(@CSMEOP,3) in ( '06/', 'Jun') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-06' +'-01') 
		WHEN LEFT(@CSMEOP,3) in ('Jul','07/') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-07' +'-01')  
		WHEN LEFT(@CSMEOP,3) in ('Aug', '08/')THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-08' +'-01') 
		WHEN LEFT(@CSMEOP,3) in ('Sep', '09/')THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-09' +'-01') 
		WHEN LEFT(@CSMEOP,3) in ('Oct', '10/') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-10' +'-01')  
		WHEN LEFT(@CSMEOP,3) in ('Nov', '11/') THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-11' +'-01')  
		ELSE  Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-12' +'-01')  END)
		
	return @ReturnDT
end

GO
