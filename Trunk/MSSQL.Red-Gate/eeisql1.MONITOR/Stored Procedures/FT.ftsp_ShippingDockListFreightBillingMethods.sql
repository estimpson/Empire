SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListFreightBillingMethods]
as
select	type_name
from	freight_type_definition
GO
