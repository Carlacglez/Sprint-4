CREATE DATABASE sprint4;
USE sprint4;

CREATE TABLE user (
        id VARCHAR(100) PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255));
        
ALTER TABLE transaction add foreign key (user_id) references user(id);        
        
CREATE TABLE product (
  id VARCHAR(100) PRIMARY KEY,
  product_name VARCHAR(100),
  price VARCHAR(100), 
  colour VARCHAR(100),
  weight VARCHAR(100),
  warehouse_id VARCHAR(100)
);


ALTER TABLE transaction add foreign key (product_id) references product(id);     

CREATE TABLE credit_card (
  id VARCHAR(100) PRIMARY KEY,
  user_id VARCHAR(100),
  iban VARCHAR(50),
  pan VARCHAR(50),
  pin VARCHAR(4),
  cvv INT,
  track1 VARCHAR(100),
  track2 VARCHAR(100),
  expiring_date VARCHAR(20)
 
);

ALTER TABLE transaction add foreign key (card_id) references credit_card(id);    

CREATE TABLE companies (
  company_id VARCHAR(100) PRIMARY KEY,
  company_name VARCHAR(255),
  phone VARCHAR(15),
  email VARCHAR(100),
  country VARCHAR(100),
  website VARCHAR(255)

);

ALTER TABLE transaction add foreign key (business_id) references companies(company_id);    

CREATE TABLE transaction (
  id VARCHAR(255) PRIMARY KEY,
  card_id VARCHAR(100),
  business_id VARCHAR(100),
  timestamp TIMESTAMP,
  amount DECIMAL(10,2),
  declined VARCHAR(3),
  product_id VARCHAR(100),
  user_id VARCHAR(100),
  lat VARCHAR(20),
  longitude VARCHAR(20)
);

-- Identifico cuales son las fk en la tabla de hechos (transaction)
-- user_id fk de id en user
-- product_id es la fk de id en product
-- card_id fk de id en credit_card
-- business_id fk de companies_id 

-- añado las FK para obtener la relacion 1:N 
ALTER TABLE transaction add foreign key (user_id) references user(id); 
-- finalmente no puede ser una fk en product ya que los datos de product estan separados por ',' 
ALTER TABLE transaction add foreign key (card_id) references credit_card(id);   
ALTER TABLE transaction add foreign key (business_id) references companies(company_id);  


 -- Con ayuda del compañero Diego logró desbloquear las restricciones al subir datos 
 SET GLOBAL local_infile = 1;
 
LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/users_ca.csv"
INTO TABLE user 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- 75 rows cargadas

LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/users_uk.csv"
INTO TABLE user 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- 50 rows cargadas 

LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/users_usa.csv"
INTO TABLE user 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- 150 rows cargadas 

LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/credit_cards.csv"
INTO TABLE credit_card 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/products.csv"
INTO TABLE product 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



LOAD DATA LOCAL INFILE "C:/Users/Carla/Curso_reskilling_Data/Sprint-4/transactions.csv"
INTO TABLE transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
 



-- Ejercicio 1 

-- Realiza una subconsulta que muestre todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.

/*SELECT u.name, u.surname, COUNT(t.user_id) AS recuento_usuarios 
FROM user u LEFT JOIN transaction t ON u.id=t.user_id
GROUP BY 1,2
HAVING recuento_usuarios > 30
order by recuento_usuarios DESC;*/

SELECT u.name, u.surname
FROM user u LEFT JOIN (SELECT t.user_id, COUNT(t.user_id) as recuento
					   FROM transaction t
                       GROUP BY 1) as t ON u.id = t.user_id
WHERE recuento > 30
ORDER BY recuento desc;




-- Ejercicio 2 

-- Muestra la media de amount por IBAN de las tarjetas de crédito a la compañía Donec Ltd, utiliza al menos 2 tablas."

SELECT  cc.iban, c.company_name, round(avg(t.amount),2) media_iban
FROM credit_card cc 
LEFT JOIN transaction t ON cc.id = t.card_id
LEFT JOIN companies c ON t.business_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY 1;
