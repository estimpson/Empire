SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[VW_PCB_BinLabel] as
select setbin='L2C', setpanel='TJ1239-12', serial=0
GO
GRANT SELECT ON  [dbo].[VW_PCB_BinLabel] TO [APPUser]
GO
