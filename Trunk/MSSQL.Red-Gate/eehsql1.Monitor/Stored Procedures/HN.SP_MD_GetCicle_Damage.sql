SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [HN].[SP_MD_GetCicle_Damage] 
	@Mold  VARCHAR(25) 
AS
BEGIN


BEGIN TRY  
   SELECT	DanoID, Molde,Part,Turno,CreateDT,LastWODT
		,CiclosEntreDanos = Sistema.dbo.MD_GetCicle_BetweenDamage(LastWODT,CreateDT,MoldeID)
FROM (	Select  LastWODT = sistema.dbo.MD_PreviousWODT(DanosMoldes.DanoID,DanosMoldes.MoldeID)
			   ,DanosMoldes.DanoID
			   ,Molde = Mold.Nombre
			   ,DanosMoldes.CreateDT
			   ,DanosMoldes.Part 
			   ,DanosMoldes.Turno
			   ,DanosMoldes.MoldeID
		from Sistema.dbo.MD_DanosMoldes DanosMoldes INNER JOIN 
				Sistema.dbo.MD_Moldes Mold on DanosMoldes.MoldeID = Mold.MoldeID 
		where  Mold.Nombre= @Mold
			   and DanosMoldes.CreateDT > '2016-06-01'
	  ) Data  
END TRY  
BEGIN CATCH  
    SELECT ERROR_NUMBER() AS ErrorNumber ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH  
	
	
		
END
GO
