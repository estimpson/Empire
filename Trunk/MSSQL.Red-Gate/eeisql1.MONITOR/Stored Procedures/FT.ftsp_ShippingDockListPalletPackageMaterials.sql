SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [FT].[ftsp_ShippingDockListPalletPackageMaterials]
as
select	code,   
	name  
from	package_materials  
where	type = 'P'    
order by
	code
GO
