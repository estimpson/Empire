CREATE TABLE [FT].[CustReleasePlanRaw]
(
[RPID] [int] NOT NULL,
[RPDocument] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanRaw] ADD CONSTRAINT [PK_CustReleasePlanRaw_1] PRIMARY KEY CLUSTERED  ([RPID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanRaw] ADD CONSTRAINT [FK_CustReleasePlanRaw_CustReleasePlans] FOREIGN KEY ([RPID]) REFERENCES [FT].[CustReleasePlans] ([RPID])
GO
