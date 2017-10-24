SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[ftvw_label_NALPlex]
as
Select * from [dbo].[fn_LabelNALPlex]()
GO
