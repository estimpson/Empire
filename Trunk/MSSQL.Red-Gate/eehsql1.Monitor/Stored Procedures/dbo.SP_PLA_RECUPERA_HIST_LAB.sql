SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_PLA_RECUPERA_HIST_LAB] 
     @VI_EMPRESA VARCHAR(4),  
     @VI_PERSONAL VARCHAR(6), 
     @VI_NUM_SEC VARCHAR(2),
     @VO_NUEVO_CODIGO VARCHAR(6),
     @VI_CARGO VARCHAR(3),
     @VI_CATEGORIA VARCHAR(2)
      
AS  
 
   
INSERT INTO [PLA_PERSONAL]
           ([COD_EMPRESA]
           ,[COD_PERSONAL]
           ,[COD_AUXILIAR]
           ,[COD_ALTERNO]
           ,[APE_PATERNO]
           ,[APE_MATERNO]
           ,[NOM_TRABAJADOR]
           ,[FEC_NACIMIENTO]
           ,[TIP_SEXO]
           ,[TIP_ESTADO_CIVIL]
           ,[NUM_HIJOS]
           ,[BMP_FOTO]
           ,[COD_PROFESION]
           ,[TIP_GRADO_INSTRUC]
           ,[FEC_INGRESO]
           ,[COD_TIPO_PLANILLA]
           ,[NUM_VER_C_COSTOS]
           ,[COD_C_COSTOS]
           ,[IND_ADELA_QUINCENAL]
           ,[TIP_ESTADO]
           ,[TIP_PAGO]
           ,[COD_MONEDA_PAGO]
           ,[TIP_CUENTA_BANCO_PAGO]
           ,[NUM_CUENTA_BANCO_PAGO]
           ,[COD_AUXILIAR_BANCO_PAGO]
           ,[COD_CATEGORIA]
           ,[COD_CARGO]
           ,[COD_SEGURO_SOCIAL]
           ,[COD_ZONA]
           ,[FEC_CESADO]
           ,[DES_MOTIVO_CESE]
           ,[IND_OFICINA]
           ,[IND_EVENTUAL]
           ,[IND_RATIFICADO]
           ,[FEC_RATIFICACION]
           ,[FEC_ULT_COBRO]
           ,[NUM_ITEM]
           ,[COD_MONEDA]
           ,[IMP_SUELDO]
           ,[NUM_MES_DEDUCCION_ISR]
           ,[COD_USER_ACTUAL]
           ,[FEC_ACTUALIZA]
           ,[des_email]
           ,[TIP_RELACION_LABORAL]
           ,[COD_AFP]
           ,[NUM_AFILIACION_AFP])
             
    SELECT [COD_EMPRESA]
           ,@VO_NUEVO_CODIGO
           ,[COD_AUXILIAR]
           ,[COD_ALTERNO]
           ,[APE_PATERNO]
           ,[APE_MATERNO]
           ,[NOM_TRABAJADOR]
           ,[FEC_NACIMIENTO]
           ,[TIP_SEXO]
           ,[TIP_ESTADO_CIVIL]
           ,[NUM_HIJOS]
           ,[BMP_FOTO]
           ,[COD_PROFESION]
           ,[TIP_GRADO_INSTRUC]
           ,[FEC_INGRESO]
           ,[COD_TIPO_PLANILLA]
           ,[NUM_VER_C_COSTOS]
           ,[COD_C_COSTOS]
           ,[IND_ADELA_QUINCENAL]
           ,'AC'
           ,[TIP_PAGO]
           ,[COD_MONEDA_PAGO]
           ,[TIP_CUENTA_BANCO_PAGO]
           ,[NUM_CUENTA_BANCO_PAGO]
           ,[COD_AUXILIAR_BANCO_PAGO]
           ,[COD_CATEGORIA]
           ,[COD_CARGO]
           ,[COD_SEGURO_SOCIAL]
           ,[COD_ZONA]
           ,[FEC_CESADO]
           ,[DES_MOTIVO_CESE]
           ,[IND_OFICINA]
           ,[IND_EVENTUAL]
           ,[IND_RATIFICADO]
           ,[FEC_RATIFICACION]
           ,[FEC_ULT_COBRO]
           ,[NUM_ITEM]
           ,[COD_MONEDA]
           ,[IMP_SUELDO]
           ,[NUM_MES_DEDUCCION_ISR]
           ,[COD_USER_ACTUAL]
           ,[FEC_ACTUALIZA]
           ,[des_email]
           ,[TIP_RELACION_LABORAL]
           ,[COD_AFP]
           ,[NUM_AFILIACION_AFP]
  FROM [dbo].[PLA_PERSONAL]
  WHERE cod_personal=@VI_PERSONAL and cod_empresa=@VI_EMPRESA


INSERT INTO [dbo].[MAE_AUXILIAR]
      ([COD_EMPRESA]
      ,[COD_AUXILIAR]
      ,[DES_AUXILIAR]
      ,[TIP_DOC_IDENTIDAD]
      ,[NUM_DOC_IDENTIDAD]
      ,[NUM_RUC]
      ,[NUM_TELEFONO]
      ,[NUM_FAX]
      ,[NUM_EMAIL]
      ,[DES_DIRECCION]
      ,[COD_PAIS]
      ,[COD_DEPARTAMENTO]
      ,[COD_DISTRITO]
      ,[COD_PROVINCIA]
      ,[TIP_PERSONERIA]
      ,[IND_SUCURSAL]
      ,[COD_SUCURSAL]
      ,[IND_GRUPO]
      ,[COD_GRUPO]
      ,[COD_USER_ACTUAL]
      ,[FEC_ACTUALIZA])
SELECT [COD_EMPRESA]
      ,@VO_NUEVO_CODIGO
      ,[DES_AUXILIAR]
      ,[TIP_DOC_IDENTIDAD]
      ,[NUM_DOC_IDENTIDAD]
      ,[NUM_RUC]
      ,[NUM_TELEFONO]
      ,[NUM_FAX]
      ,[NUM_EMAIL]
      ,[DES_DIRECCION]
      ,[COD_PAIS]
      ,[COD_DEPARTAMENTO]
      ,[COD_DISTRITO]
      ,[COD_PROVINCIA]
      ,[TIP_PERSONERIA]
      ,[IND_SUCURSAL]
      ,[COD_SUCURSAL]
      ,[IND_GRUPO]
      ,[COD_GRUPO]
      ,[COD_USER_ACTUAL]
      ,[FEC_ACTUALIZA]
  FROM [dbo].[MAE_AUXILIAR]
  WHERE cod_auxiliar=@VI_PERSONAL and cod_empresa=@VI_EMPRESA




   
   INSERT INTO [PLA_PERS_HISTORIA_LABORAL]
      ([COD_EMPRESA]
      ,[NUM_SEC_HIST_LAB]
      ,[COD_PERSONAL]
      ,[TIP_EVENTO]
      ,[FEC_EVENTO]
      ,[COD_CATEGORIA]
      ,[COD_CARGO]
      ,[DES_OBSERVACION])
   
   SELECT [COD_EMPRESA]
      ,[NUM_SEC_HIST_LAB]
      ,@VO_NUEVO_CODIGO
      ,[TIP_EVENTO]
      ,[FEC_EVENTO]
      ,[COD_CATEGORIA]
      ,[COD_CARGO]
      ,[DES_OBSERVACION]
  FROM [dbo].[PLA_PERS_HISTORIA_LABORAL]
   WHERE COD_EMPRESA=@VI_EMPRESA and COD_PERSONAL=@VI_PERSONAL
   
   
   DECLARE @MAX_SECUENCIA VARCHAR(2)
   SELECT @MAX_SECUENCIA=(SELECT MAX(NUM_SEC_HIST_LAB) + 1 FROM PLA_PERS_HISTORIA_LABORAL WHERE COD_PERSONAL=@VI_PERSONAL)
   SELECT @MAX_SECUENCIA = right('00'+@MAX_SECUENCIA,2)
   INSERT INTO [PLA_PERS_HISTORIA_LABORAL]
      ([COD_EMPRESA]
      ,[NUM_SEC_HIST_LAB]
      ,[COD_PERSONAL]
      ,[TIP_EVENTO]
      ,[FEC_EVENTO]
      ,[COD_CATEGORIA]
      ,[COD_CARGO]
      ,[DES_OBSERVACION])
      VALUES(@VI_EMPRESA,@MAX_SECUENCIA,@VO_NUEVO_CODIGO,'RN',GETDATE(), @VI_CATEGORIA,@VI_CARGO,'REINGRESO CON NUEVO CODIGO')
GO
