SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[msp_insert_m_in_release_plan1] 
as
BEGIN
BEGIN TRANSACTION
insert m_in_release_plan
        select  rtrim(customer_part),
                rtrim(ship_to),
                '',
                '',
                '',
                'A',
                convert(decimal(20,6),cum_qty),
                'S',
                convert(datetime, date1)
        from    fd5_830_releases
        where   date_indicator ='W'

COMMIT TRANSACTION 
SELECT 1
END








GO
