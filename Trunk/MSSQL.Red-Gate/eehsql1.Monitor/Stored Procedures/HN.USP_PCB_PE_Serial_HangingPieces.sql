SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 --exec HN.USP_PCB_PE_Serial_HangingPieces 8619362
 
CREATE proc [HN].[USP_PCB_PE_Serial_HangingPieces] (
	@WODID int)
AS 
BEGIN
	Declare @WODID_Interno int
	Set @WODID_Interno = @WODID
	SELECT T1.* 
		FROM (
			SELECT	id, PCB_Serial, CreateDT, IDLabelPart, EstacionPE, SerialProduced
				FROM	HN.PCB_PE_SERIAL 
			WHERE WODID =@WODID_Interno 
				AND SerialProduced =-1) T1 
	LEFT JOIN (
			SELECT	id, PCB_Serial, CreateDT, IDLabelPart, EstacionPE  , SerialProduced
				FROM	HN.PCB_PE_SERIAL 
			WHERE  WODID =@WODID_Interno 
				AND  SerialProduced >=0) T2 
	ON T1.PCB_Serial =T2.PCB_Serial 
	WHERE T2.PCB_Serial IS NULL
END
GO
