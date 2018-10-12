SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[BF_Motive_Use_Regrind] AS
select	Regrind.*, Motivo = Pregunta from EEh.HN.BF_Motive_Use_Regrind Regrind
join Sistema.dbo.sa_preguntas Preguntas on Regrind.QuestionID = Preguntas.ID
GO
