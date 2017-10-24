SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [FT].[csp_FindMnemonicChange] ( @Month1 VARCHAR(15), @Month2 VARCHAR(15) )

AS
BEGIN

--Exec FT.csp_FindMnemonicChange '2014-03' , '2014-04'

DECLARE @Monthone VARCHAR(30),
		@monthTwo VARCHAR(30)

SELECT @Monthone = LEFT(@Month1,4) + RIGHT(@Month1,2)
SELECT @Monthtwo = LEFT(@Month2,4) + RIGHT(@Month2,2)


SELECT 	
	[@MonthOne].[Mnemonic-Vehicle/Plant] MonthOne, 
	[@MonthTwo].[Mnemonic-Vehicle/Plant] MonthTwo, 
	[@MonthTwo].Program   Program, 
	[@MonthTwo].Nameplate Namplate, 
	[@MonthTwo].Vehicle   Vehicle, 
	[@MonthTwo].Plant Plant 
FROM 
(SELECT * FROM EEIUser.acctg_csm_NAIHS WHERE Release_ID = @Month1) [@MonthOne]

FULL JOIN

	(SELECT * FROM EEIUser.acctg_csm_NAIHS WHERE Release_ID = @Month2 ) [@MonthTwo] ON  [@MonthTwo].Program = [@MonthOne].Program 
		AND [@MonthTwo].Nameplate = [@MonthOne].NamePlate 
		AND [@MonthTwo].Plant = [@MonthOne].Plant 
		AND [@MonthTwo].Vehicle = [@MonthOne].Vehicle
WHERE 

[@MonthTwo].[Mnemonic-Vehicle/Plant] != [@MonthOne].[Mnemonic-Vehicle/Plant]

End
GO
