SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select * from object where serial=7884723

--exec HN.HCSP_Inv_FindObject 0,'serial=7884723'

CREATE PROC [HN].[HCSP_Inv_FindObject] (@strTipo int, @strFiltro varchar(250), @OrderBy AS varchar(250) = NULL)
AS
BEGIN
	DECLARE @SQLDetails varchar(2000)



	SET @SQLDetails = 'SELECT	object.serial, object.part, p.name, object.location, object.operator, On_Hand=object.std_quantity, warehousefreightlot, Lot=lot,Field1, Notes=object.note, '
	SET @SQLDetails = @SQLDetails + 'object.last_date, object.status, object.user_defined_status, pi.standard_unit,object.parent_serial, '
	SET @SQLDetails = @SQLDetails + 'pi.unit_weight,Grommets = null, '
	SET @SQLDetails = @SQLDetails + 'object.start_date FROM object left JOIN part p ON p.part = object.part '
	SET @SQLDetails = @SQLDetails + 'left JOIN part_inventory pi ON pi.part =object.part WHERE isnull(object.std_quantity,1)>0 and '
	IF @strtipo=0 BEGIN
						if ISNULL(@OrderBy,'')='' begin
							EXEC (@SQLDetails + @strFiltro)	         	
						end else begin
							EXEC (@SQLDetails + @strFiltro + ' ORDER BY '+ @OrderBy)	         	
						end
						
						
	             END
		
	ELSE IF @strTipo=1 BEGIN
						SELECT	object.Part, Name=p.name, 
								OnHand = isnull(sum(CASE WHEN status='A' THEN std_quantity END),0),
								OnHold = isnull(sum(CASE WHEN status='H' THEN std_quantity END),0)
						FROM	object left JOIN part p ON p.part = object.part
						WHERE	isnull(std_quantity,1)>0 AND object.part LIKE '%'+ @strFiltro + '%' 
						group BY object.part, p.name
						ORDER BY object.part

	END
	
	ELSE IF @strTipo=2 BEGIN
			
		SELECT Data.Location, Data.OnHand, Data.OnHold FROM (	
		SELECT	Location = location,
				OnHand = isnull(sum(CASE WHEN status='A' THEN std_quantity END),0),
				OnHold = isnull(sum(CASE WHEN status='H' THEN std_quantity END),0),
				Posicion =1
		FROM	object
		WHERE	isnull(std_quantity,1)>0 AND part = @strFiltro
		group BY location		
		UNION ALL
		SELECT	Location = 'Sub Total',
				OnHand = isnull(sum(CASE WHEN status='A' THEN std_quantity END),0),
				OnHold = isnull(sum(CASE WHEN status='H' THEN std_quantity END),0),
				Posicion =2
		FROM	object
		WHERE	isnull(std_quantity,1)>0 AND part = @strFiltro) Data
		ORDER BY Data.Posicion end
		
			

END
GO
GRANT EXECUTE ON  [HN].[HCSP_Inv_FindObject] TO [APPUser]
GO
