SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[usp_UpdateEmpowerPOType] @PONumber varchar(25), @POType varchar(25)
as
begin

--	declare @ErrorString varchar (100)
--	select @ErrorString = 'Check PO Number - '		+ @PONumber + '  Check PO Type - ' + @POType
--		print @PONumber
--		print @POType
--	if @POType != 'EMPOWER' or @POType != 'MONITOR' or not exists(select 1 from dbo.po_headers where purchase_order = @PONumber)  
--	begin
--		RAISERROR (N'PO Type or PO Number Entered Incorrectly', -- Message text.
--           16, -- Severity,
--           1, -- State,
 --          @ErrorString
 --          )
 --         return -1
--		end


update 
	po_headers
set	
	po_type = @POType
where
	purchase_order = @PONumber
	
select 
	purchase_order,
	po_type,
	'PO Updated'
from
	po_headers
where
	purchase_order = @PONumber
	
end

GO
