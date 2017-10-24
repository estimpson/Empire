SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[msp_insert_m_in_release_plan3] 
as
BEGIN
BEGIN TRANSACTION
Delete fd5_830_releases
COMMIT TRANSACTION
execute msp_process_in_release_plan
Select "message" from log
END
GO
