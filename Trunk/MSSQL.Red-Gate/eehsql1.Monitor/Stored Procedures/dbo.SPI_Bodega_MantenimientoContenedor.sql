SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Ferid Bonilla>
-- Create date: <09/08/2016>
-- Description:	<Inserta los ccontenedores>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_Bodega_MantenimientoContenedor]
	-- Add the parameters for the stored procedure here
	(@NombreContenedor varchar(50),@FechaRecibo date,@FechaCreacion date,@UltimaModificacion date,@CreadoPor varchar(50),@Tipo int,@Estado int)
AS



    Begin Tran Tadd

    Begin Try
	INSERT INTO [dbo].[SPI_Bodega_Contenedor]
           ([ContenedorNombre]
           ,[FechaRecibo]
           ,[FechaCreacion]
		   ,[UtimaModificacion]
           ,[CreadoPor]
           ,[Tipo]
		   ,[Estado])
     VALUES
           (@NombreContenedor
           ,@FechaRecibo
           ,@FechaCreacion
		   ,@UltimaModificacion
           ,@CreadoPor
           ,@Tipo
		   ,@Estado
           )
        COMMIT TRAN Tadd
    End try
    Begin Catch

        Rollback TRAN Tadd

    End Catch
GO
