CREATE TABLE [dbo].[PrintQueue]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateStamp] [datetime] NOT NULL CONSTRAINT [DF_PrintQueue_DateStamp] DEFAULT (getdate()),
[SerialNumber] [int] NOT NULL,
[PrintServer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Printed] [int] NOT NULL CONSTRAINT [DF_PrintQueue_Printed] DEFAULT ((0)),
[LabelFormat] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[EEITR_UPDATE_LABELFORMAT] ON [dbo].[PrintQueue]
FOR INSERT
AS
BEGIN
    update PRINTQUEUE set  LABELFORMAT='RAWZEBRA'
     where PRINTQUEUE.SERIALNUMBER in(Select inserted.SERIALNUMBER from inserted where PrintServer = 'LBLSRV' )
END

GO
GRANT SELECT ON  [dbo].[PrintQueue] TO [APPUser]
GO
