SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[msp_form_release](@po_number varchar(15))
as
BEGIN
SELECT
        vendor.contact,
        po_header.po_number ,
        po_header.release_no,
        vendor.buyer,
        po_detail.part_number ,
        po_detail.description ,
        po_detail.balance ,
        po_detail.date_due ,
        destination.name,
        destination.destination ,
        destination.address_1 ,
        destination.address_2 ,
        destination.address_3 ,
        destination.address_4,
        destination.address_5,  
        parameters.company_name ,
        parameters.address_1 ,
        parameters.address_2 ,
        parameters.address_3 ,
        po_header.vendor_code ,
        vendor.name ,
        po_header.ship_to_destination ,
        vendor.contact ,
        po_detail.unit_of_measure ,
        vendor.address_1 ,
        vendor.address_2 ,
        vendor.address_3 ,
        vendor.address_4,
        vendor.address_5,  
        po_detail.notes ,
        po_header.notes     

FROM 
        po_header
        join po_detail
			on po_header.po_number = po_detail.po_number
        join vendor
			on vendor.code = po_header.vendor_code
        left join destination
			on po_header.ship_to_destination = destination.destination
        cross join parameters
        
where	( ( convert(varchar (15),po_header.po_number) = @po_number ) )   

END
GO
