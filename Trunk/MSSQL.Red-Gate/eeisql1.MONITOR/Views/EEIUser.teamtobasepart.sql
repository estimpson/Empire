SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[teamtobasepart]
(	basepart,
	team )
as
(select (CASE WHEN patindex('%-%', part_eecustom.part) 
                      = 8 THEN Substring(part_eecustom.part, 1, (patindex('%-%', part_eecustom.part) - 1)) ELSE part_eecustom.part END), max(team_no) from part_eecustom, sales_2 where (CASE WHEN patindex('%-%', part_eecustom.part) 
                      = 8 THEN Substring(part_eecustom.part, 1, (patindex('%-%', part_eecustom.part) - 1)) ELSE part_eecustom.part END) = base_part group by part_eecustom.part)
GO
