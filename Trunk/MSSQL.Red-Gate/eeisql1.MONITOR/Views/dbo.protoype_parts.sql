SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[protoype_parts]
as
Select	part from part where 	part.class not in( 'O' , 'M')and
		part.type = 'F' and 
		part.part like '%[-]%'  and 
		part.part  like '%-PT%' 
GO
