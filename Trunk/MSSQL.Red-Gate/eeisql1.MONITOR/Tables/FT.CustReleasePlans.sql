CREATE TABLE [FT].[CustReleasePlans]
(
[RPID] [int] NOT NULL IDENTITY(1, 1),
[RPDate] [datetime] NOT NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlans] ADD CONSTRAINT [PK_CustReleasePlans] PRIMARY KEY CLUSTERED  ([RPID]) ON [PRIMARY]
GO
