SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [EDI_XML_HELLA_ASN].[udf_OrderSerials]
(	@ShipperID INT
,	@CustomerPart VARCHAR(30)
,	@packType VARCHAR(25)
,	@PackQty VARCHAR(25)
)
RETURNS XML
AS
BEGIN
--- <Body>
	DECLARE
		@xmlOutput XML = ''

	DECLARE serialREFs CURSOR LOCAL FOR
	SELECT
		EDI_XML_VD07A.SEG_GIN('ML', ao.SerialNumber)
	FROM
		 [EDI_XML_HELLA_ASN].[ASNPackSerials] AO
		 WHERE 
			ShipperID =  @ShipperID AND
			CustomerPart = 	@CustomerPart AND
			PackageType = @packType and
			 PackageQty = @PackQty
	

	OPEN serialREFs

	WHILE
		1 = 1 BEGIN

		DECLARE @segREF XML

		FETCH
			serialREFs
		INTO
			@segREF

		IF	@@FETCH_STATUS != 0 BEGIN
			BREAK
		END

		SET	@xmlOutput = CONVERT(VARCHAR(MAX), @xmlOutput) + CONVERT(VARCHAR(MAX), @segREF)
	END
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END



GO
