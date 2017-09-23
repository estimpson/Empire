SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create   PROCEDURE [dbo].[sub_auditoria_del_sistema]


--Inician parametros-- 
@aud_tabla varchar(250) = null ,
@aud_tipo varchar(1) = null ,
@aud_usuario varchar(50) = null ,
@aud_fecha datetime = null ,
@aud_registro varchar(500) = null 
As 


Set dateformat dmy

begin transaction

Insert into adm_aud_auditoria(aud_codigo,aud_tabla,aud_tipo,aud_usuario,aud_fecha,aud_registro)
select isnull(max(aud_codigo),0)+1,@aud_tabla,@aud_tipo,@aud_usuario,@aud_fecha,@aud_registro
from adm_aud_auditoria

commit transaction

GO
GRANT EXECUTE ON  [dbo].[sub_auditoria_del_sistema] TO [APPUser]
GO
