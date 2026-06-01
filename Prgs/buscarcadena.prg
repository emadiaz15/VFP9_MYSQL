*buscar cadena dentro de otra
variable=allt("BMX")
SELE * FROM CLIENTES;
WHERE cli_nomb LIKE "%"+variable+"%"
select * from clientes where cli_nomb like "%"+variable+"%"