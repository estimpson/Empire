SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE FUNCTION [FT].[fn_ReturnDestination]
(	@EdiShipToID VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
--- <Body>
/*	Returns Monitor Destination for EDIShipToID */
	DECLARE @Destination VARCHAR(50)

	SELECT @Destination
		=	(
				SELECT TOP 1 COALESCE(NULLIF(es.destination,''), 'EDIShipToNotDefined')
				FROM 
					dbo.edi_setups es
				WHERE
					(es.parent_destination = @EdiShipToID OR es.EDIShipToID = @EdiShipToID )
			)

		RETURN @Destination


END














GO
