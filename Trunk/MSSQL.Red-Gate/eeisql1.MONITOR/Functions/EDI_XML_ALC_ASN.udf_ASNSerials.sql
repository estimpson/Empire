SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [EDI_XML_ALC_ASN].[udf_ASNSerials]
(	@ShipperID INT,
	@CustomerPart varchar(50)
)
RETURNS @ASNSerials TABLE
(	SerialNumber VARCHAR(50),
	MasterSerial VARCHAR(50)
)
AS
BEGIN
--- <Body>

--- </Body>

INSERT
		@ASNSerials
		        ( SerialNumber,
					MasterSerial )
	SELECT
		at.serial,
		ISNULL( at.parent_serial, 0)
	FROM
		dbo.audit_trail at
	JOIN
		dbo.shipper_detail sd ON sd.shipper = @ShipperID 
		AND	sd.customer_part  = @CustomerPart
		AND sd.part_original  =  at.part        
	WHERE
		at.type = 'S'
		AND at.shipper = CONVERT(VARCHAR, @ShipperID)		

---	<Return>
	RETURN
END

GO
