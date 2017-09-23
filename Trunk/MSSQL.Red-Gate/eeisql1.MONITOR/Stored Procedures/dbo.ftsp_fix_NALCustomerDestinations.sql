SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ftsp_fix_NALCustomerDestinations]
AS
Begin
--Fix Shippers that have shipped
UPDATE	dbo.shipper
SET			customer = 'ES3NAL',
				destination =  'ES3'+destination
--SELECT	*
--FROM		shipper
WHERE	shipper.id IN  (48521,48523,48524)

--Fix audit_trail for fixed shippers
UPDATE	dbo.audit_trail
SET			to_loc = SUBSTRING(shipper.destination,1,10),
					customer = shipper.customer
--SELECT	serial, dbo.audit_trail.customer, shipper.customer, to_loc, shipper.destination
FROM		dbo.audit_trail
JOIN		shipper ON audit_trail.shipper = CONVERT(VARCHAR(20), shipper.id)
WHERE	shipper.id IN (48521,48523,48524) AND
				dbo.audit_trail.type = 'S'
				
--Fix sales orders FOR shippers that were fixed
UPDATE dbo.order_header
SET			destination = shipper.destination,
				customer = shipper.customer
				
--SELECT	*		
FROM		dbo.order_header
JOIN		shipper_detail ON dbo.order_header.order_no = dbo.shipper_detail.order_no
JOIN		shipper ON dbo.shipper_detail.shipper = dbo.shipper.id
WHERE	shipper.id IN   (48521,48523,48524)

END




GO
