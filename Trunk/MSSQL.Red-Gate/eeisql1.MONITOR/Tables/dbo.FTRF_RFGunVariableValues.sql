CREATE TABLE [dbo].[FTRF_RFGunVariableValues]
(
[ID] [int] NOT NULL,
[RFGunID] [int] NOT NULL,
[VariableID] [int] NOT NULL,
[VariableValue] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_RFGunVariableValues] ADD CONSTRAINT [PK__FTRF_RFGunVariab__5B78929E] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
