SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Andre S. Boulanger
-- Create date: 2016.08.24
-- Description:	Returns Order Heirarchy for x12 ASN
-- =============================================
CREATE FUNCTION [EDI_XML_NORPLAS_ASN].[OrderItemHeirarchy] 
(	@ShipperID Int,
	@CustomerPart varchar(50),
	@PackType varchar(25) = NULL,
	@PackQty Int = NULL,
	@Heirarchy varchar(5)
	
)
RETURNS int
AS
BEGIN

Declare @HeirarcyID int

	Declare @OrderPackDetails Table
		(	ShipperID Int,
			Customerpart varchar(50),
			PackType varchar(25),
			PackQty Int,
			PackCount Int,
			orderHID Int,
			OrderPHID Int,
			LineHID Int,
			LinePHID Int


		)

		Insert @OrderPackDetails
		
		
		Select	asnl.ShipperID,
		asnl.CustomerPart,
		PackType,
		packqty,
		packcount,

		CASE WHEN  Row_Number() over (partition by asnd.ShipperID order by asnd.customerpart)  = 1 
		THEN asnl.RowNumber
		ELSE ((asnd.RowNumber + Asnl.RowNumber)-2) - 1
		END as AsnOrderHerarchyID, 

		1 as AsnOrderParentHerarchyID, 
		
		CASE WHEN  Row_Number() over (partition by asnd.ShipperID order by asnd.customerpart)  = 1 
		THEN asnd.RowNumber 
		ELSE (asnd.RowNumber + Asnl.RowNumber) -2
		END as AsnLineHerarchyID,

		CASE WHEN  Row_Number() over (partition by asnd.ShipperID order by asnd.customerpart)  = 1 
		THEN asnl.RowNumber
		ELSE ((asnd.RowNumber + Asnl.RowNumber)-2) - 1
		END as AsnLineParentHerarchyID



from	EDI_XML_NORPLAS_ASN.ASNLines asnl
JOIN	[EDI_XML_NORPLAS_ASN].[Fn_ASNLinePackQtyDetails](@ShipperID, @CustomerPart)  asnd  on asnd.ShipperID = asnl.ShipperID and asnl.customerPart =  asnd.customerpart

where 
	asnl.ShipperID = @ShipperID
	
	
	If @Heirarchy IN ('O', 'OP')
	BEGIN
	Select @HeirarcyID = 
		(
		Select CASE WHEN @Heirarchy = 'O' THEN  min(orderHID)
					WHEN @Heirarchy = 'OP' THEN min(orderPHID)
					END
			from @OrderPackDetails
		Where 
			Customerpart =  @CustomerPart 
		)

		
	END

	If @Heirarchy IN ('I', 'IP')
	BEGIN
	Select @HeirarcyID = 
		(
		Select CASE WHEN @Heirarchy = 'I' THEN  min(LINEHID)
					WHEN @Heirarchy = 'IP' THEN min(LINEPHID)
					END
			from @OrderPackDetails
		Where 
			Customerpart =  @CustomerPart
			and PackQty =  @PackQty
			and PackType = @Packtype 
		)

		
	END

	Return @HeirarcyID

END



GO
