-- NIVEL 2 
/*Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en 
si las últimas tres transacciones fueron declinadas y genera la siguiente consulta:*/

USE sprint4;


/*SELECT t.card_id,
    CASE -- crear una tabla temporal condicional para ver cuantas son activas y cuantas no 
        WHEN SUM(t.declined)=3 THEN 'inactiva'
	ELSE 'Activa' -- si no se cumple la primera condicion entonces si son tarjetas activas 
    END AS card_status
FROM transaction t
group by 1;

-- Necesitamos saber las ultimas 3 transacciones para eso usamos una funcion ventana 
-- Gracias a la compañera Maria que me explico como agregar las funciones ventana
SELECT card_id, declined, timestamp,
        ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num 
FROM transaction 
WHERE declined <=3;*/

CREATE TABLE credit_card_status AS  -- crear la tabla nueva desde una query 
SELECT tt.card_id,
    CASE -- crear una tabla temporal 
        WHEN SUM(tt.declined)=3 THEN 'inactiva'
		ELSE 'Activa' -- si no se cumple la primera condicion entonces si son tarjetas activas 
    END AS card_status
		FROM (SELECT card_id, declined,
			  ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num 
              FROM transaction) AS tt

WHERE tt.row_num <=3 -- filtramos la ventana ya que solo queremos 3 o menos 
GROUP BY tt.card_id;

ALTER TABLE credit_card_status ADD PRIMARY KEY (card_id);
ALTER TABLE credit_card_status ADD FOREIGN KEY (card_id) references credit_card(id);  


-- Ejercicio 1 ¿Cuántas tarjetas están activas?

SELECT COUNT(card_status)
FROM credit_card_status
WHERE card_status ='activa';