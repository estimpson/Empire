SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[ftsp_UpdateTRWCumsAndPOs]
as
Begin
--To be called (SQL Agent Sceduled Job) on October 2nd 2011 to update the Cums and Customer POS


update dbo.order_header
set		our_cum = 0
where	destination in ( 'TRW-AUTO', 'TRWSAFETY' ) 
			and exists ( select 1 from dbo.TRWPOCrossReference where OldPO = customer_po and CustomerPart =customer_part )
			
		

update	dbo.order_header
set		customer_po = NewPO
from		dbo.order_header
join		TRWPOCrossReference on dbo.order_header.customer_po = OldPO and order_header.customer_part = CustomerPart
where	destination in ( 'TRW-AUTO', 'TRWSAFETY' )

update	dbo.edi_setups
set		parent_destination = '626A',
			asn_overlay_group = 'TR1',
			trading_partner_code = 'TRWAUTOCHS',
			auto_create_asn = 'Y',
			supplier_code = '157550'
where	destination = 'TRW-AUTO'

update	dbo.edi_setups
set		parent_destination = '434A',
			asn_overlay_group = 'TR1',
			trading_partner_code = 'TRWAUTOCHI',
			auto_create_asn = 'Y',
			supplier_code = '157550'
where	destination = 'TRWSAFETY'

drop table TRWPOCrossReference

end



GO
