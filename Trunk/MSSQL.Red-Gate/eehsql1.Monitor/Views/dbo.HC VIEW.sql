SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[HC VIEW] AS SELECT * FROM EEH.[dbo].[HC VIEW] WITH (READUNCOMMITTED)
GO