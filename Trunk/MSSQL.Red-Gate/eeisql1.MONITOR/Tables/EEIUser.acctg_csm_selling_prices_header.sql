CREATE TABLE [EEIUser].[acctg_csm_selling_prices_header]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Row_ID] [int] NOT NULL,
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BasePart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Inclusion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RolledForward] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_selling_prices_header] ADD CONSTRAINT [PK_acctg_csm_selling_prices_header] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
