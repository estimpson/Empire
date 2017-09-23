CREATE TABLE [FT].[CustReleasePlanDetailAuthorizations]
(
[RPDID] [int] NOT NULL,
[FabDate] [datetime] NULL,
[FabAccum] [numeric] (20, 6) NULL,
[RawDate] [datetime] NULL,
[RawAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanDetailAuthorizations] ADD CONSTRAINT [PK_CustReleasePlanDetailAuthorizations] PRIMARY KEY CLUSTERED  ([RPDID]) ON [PRIMARY]
GO
