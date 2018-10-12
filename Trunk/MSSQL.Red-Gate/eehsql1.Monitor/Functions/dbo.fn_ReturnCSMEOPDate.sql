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
	(	CASE WHEN LEFT(@CSMEOP,3) = '12/' THEN Convert(datetime, SUBSTRING(@CSMEOP,4,4) + '-01' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Feb' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-02' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Mar' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-03' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Apr' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-04' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'May' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-05' +'-01')  
		WHEN LEFT(@CSMEOP,3) = 'Jun' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-06' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Jul' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-07' +'-01')  
		WHEN LEFT(@CSMEOP,3) = 'Aug' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-08' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Sep' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-09' +'-01') 
		WHEN LEFT(@CSMEOP,3) = 'Oct' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-10' +'-01')  
		WHEN LEFT(@CSMEOP,3) = 'Nov' THEN Convert(datetime,SUBSTRING(@CSMEOP,4,4) + '-11' +'-01')  ELSE  Convert(datetime,SUBSTRING(@CSMEOP,1,4) + '-12' +'-01')  END)
		
	return @ReturnDT
end

GO
