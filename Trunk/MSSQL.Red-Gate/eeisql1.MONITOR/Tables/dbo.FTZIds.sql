CREATE TABLE [dbo].[FTZIds]
(
[twofourteenNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ITNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[datecreated] [datetime] NULL CONSTRAINT [DF__FTZIds__datecrea__4589517F] DEFAULT (getdate()),
[newtwofourteenNO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[datemodified] [datetime] NULL,
[NewITNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewITCreateDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTZIds] ADD CONSTRAINT [PK__FTZIds__44952D46] PRIMARY KEY CLUSTERED  ([twofourteenNO]) ON [PRIMARY]
GO
