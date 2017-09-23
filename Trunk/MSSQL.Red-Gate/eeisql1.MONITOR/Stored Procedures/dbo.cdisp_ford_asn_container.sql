SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[cdisp_ford_asn_container] (@shipper int) as
BEGIN

SELECT	DISTINCT
       	 'RC'  ,
        	a.package_type,
        	count (a.serial) ,
       	 0,
        	'NONE',
        	shipper.id
FROM    	audit_trail as a,
        	shipper,
        	package_materials
WHERE   	a.type = 'S' and
        	a.shipper = convert(varchar(35),@shipper) and
        	shipper.id = @shipper
        	and package_materials.returnable = 'Y' and
        	a.package_type = package_materials.code and
        	a.part <> 'PALLET'
GROUP BY  a.package_type,   shipper.id                        
UNION

SELECT	DISTINCT
       	 'RC'  ,
        	p.package_type,
        	count (p.serial) ,
       	 0,
        	'NONE',
        	shipper.id
FROM    	audit_trail as p,
        	shipper,
        	package_materials
WHERE   	p.type = 'S' and
        	p.shipper = convert(varchar(35),@shipper) and
        	shipper.id = @shipper
        	and package_materials.returnable = 'Y' and
        	p.package_type = package_materials.code and
        	p.part = 'PALLET'
GROUP BY  p.package_type,   shipper.id
UNION                       
SELECT	DISTINCT
   	'RC' ,
    	substring(c.package_type,patindex('%*%', c.package_type)+1,datalength(c.package_type)-patindex('%*%',c.package_type)),
     	count (c.serial) ,
      	0,
    	 'NONE',
      	shipper.id
FROM  	audit_trail as c,
    	shipper,
     	package_materials

WHERE 	c.type = 'S' and
      	c.shipper = convert(varchar(35),@shipper) and
      	shipper.id = @shipper and 
      	package_materials.returnable = 'Y' and
      	c.package_type = package_materials.code and
      	c.part = 'PALLET' and  patindex('%*%', c.package_type) >0
GROUP BY c.package_type, shipper.id
UNION 
SELECT 	DISTINCT
       	'RC' ,
      	substring(b.package_type,1,(patindex('%*%', b.package_type)-1)),
    	count (b.serial) ,
       	 0,
        	'NONE',
        	shipper.id
FROM    	audit_trail as b,
        	shipper,
        	package_materials 
WHERE   	b.type = 'S' and
        	b.shipper = convert(varchar(35),@shipper) and
        	shipper.id = @shipper
        	and package_materials.returnable = 'Y' and
        	b.package_type = package_materials.code and
        	b.part = 'PALLET' and patindex('%*%', b.package_type)>0
GROUP BY b.package_type, shipper.id


END

GO
GRANT EXECUTE ON  [dbo].[cdisp_ford_asn_container] TO [public]
GO
