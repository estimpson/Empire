SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [HN].[RLSP_BF_AuditTrail] ( @Condition AS varchar(1000) = NULL,
@OrderBy AS varchar(1000) = NULL )						 
as	 
DECLARE @SQLMain AS varchar(2000)

SET @SQLMain = 'SELECT	serial AS Serial, 
						date_stamp AS Date,
						part AS Part,
						type AS Type, 
						Remarks AS Remarks,
						quantity AS Quantity,
						unit AS Unit, 
						operator AS Operator,
						on_hand AS [ON Hand],
						to_loc AS [TO],
						from_loc AS [FROM],
						customer AS Customer, 
						vendor AS Vendor, 
						po_number AS PO_Number,
						status AS Status, 
						custom1, 
						custom2, 
						custom3,
						notes, 
						parent_serial, 
						part_name,
						shipper
				FROM	Audit_Trail'

--
--SET @SQLMain = @SQLMain + ' WHERE ' + @Condition
--EXEC (@SQLMain)



IF (@Condition IS null AND @OrderBy IS NULL)
	BEGIN
		EXEC (@SQLMain)	
	END
	
ELSE
	IF (@Condition IS null AND isnull(@OrderBy, '' ) <> '')
		BEGIN
			SET @SQLMain = @SQLMain + ' ORDER BY ' + @OrderBy
			EXEC (@SQLMain)
		end
	ELSE
		IF (@Condition IS NOT null AND isnull(@OrderBy, '' ) = '')
			BEGIN
				SET @SQLMain = @SQLMain + ' WHERE ' + @Condition
				EXEC (@SQLMain)
			end
		ELSE
		BEGIN
				SET @SQLMain = @SQLMain+ ' WHERE ' + @Condition + ' ORDER BY ' + @OrderBy
				EXEC (@SQLMain)
			end
		

GO
GRANT EXECUTE ON  [HN].[RLSP_BF_AuditTrail] TO [APPUser]
GO
