-- Creazione del database
CREATE DATABASE IF NOT EXISTS CaseStudy;
USE CaseStudy;

-- 1. Creazione delle tabelle INDIPENDENTI 
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE Region (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL
);

-- 2. Creazione delle tabelle di PRIMO LIVELLO (che dipendono dalle tabelle indipendenti)

-- Product ha una relazione 1 a molti con Category (quindi riceve CategoryID)
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    CONSTRAINT FK_Product_Category 
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- State ha una relazione 1 a molti con Region (quindi riceve RegionID)
CREATE TABLE State (
    StateID INT AUTO_INCREMENT PRIMARY KEY,
    StateName VARCHAR(100) NOT NULL,
    RegionID INT,
    CONSTRAINT FK_State_Region 
	FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

-- 3. Creazione delle tabelle che dipendono da altre tabelle con FK)

-- Sale ha relazioni 1 a molti sia con Product che con State
CREATE TABLE Sale (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL, -- Uso DECIMAL per i prezzi (10 cifre totali, 2 decimali)
    ProductID INT,
    StateID INT,
    CONSTRAINT FK_Sale_Product 
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
,
    CONSTRAINT FK_Sale_State 
	FOREIGN KEY (StateID) REFERENCES State(StateID)
);






-- 1. Inserimento Categorie (Tabella Indipendente)
INSERT INTO Category (CategoryName) VALUES
('Action Figures'),
('Board Games'),
('Educational');

-- 2. Inserimento Regioni (Tabella Indipendente)
INSERT INTO Region (RegionName) VALUES
('West Europe'),
('South Europe'),
('North America');

-- 3. Inserimento Prodotti (Dipende da Category)
INSERT INTO Product (ProductID, ProductName, CategoryID) VALUES
(101, 'Spider-Man Hero', 1),
(102, 'Batman Deluxe', 1),
(103, 'Monopoly Classic', 2),
(104, 'Risk Junior', 2),
(105, 'Coding Robot Kit', 3),
(106, 'Chemistry Set', 3);

-- 4. Inserimento Stati (Dipende da Region)
-- I RegionID sono stati messi in base al continente nella tabella region
INSERT INTO State (StateID, StateName, RegionID) VALUES
(10, 'France', 1),
(11, 'Germany', 1),
(12, 'Italy', 2),
(13, 'Greece', 2),
(14, 'Usa', 3);

-- 5. Inserimento Vendite (Dipende da Product e State)
INSERT INTO Sale (Date, Quantity, UnitPrice, ProductID, StateID) VALUES
('2023-05-10', 2, 25.00, 101, 12),
('2023-05-15', 1, 45.00, 102, 10),
('2024-01-20', 5, 30.00, 103, 12),
('2024-02-10', 10, 85.00, 105, 14),
('2024-06-10', 1, 25.00, 101, 11),
('2024-08-15', 3, 20.00, 104, 11),
('2024-09-10', 2, 85.00, 105, 13),
('2024-10-05', 4, 30.00, 103, 12),
('2024-11-12', 1, 45.00, 102, 10),
('2024-12-11', 8, 85.00, 105, 14);

/*PARTIAMO CON L'ESERCIZIO 1
Verificare che i campi definiti come PK siano univoci.
 In altre parole, scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata).*/
 
CREATE VIEW Esercizio1_Category AS
SELECT CategoryID, COUNT(*) AS ControlloPK
FROM Category
GROUP BY CategoryID
HAVING COUNT(*) > 1;

CREATE VIEW Esercizio1_Region AS
SELECT RegionID, COUNT(*) AS ControlloPK
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;

CREATE VIEW Esercizio1_Product AS
SELECT ProductID, COUNT(*) AS ControlloPK
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

CREATE VIEW Esercizio1_State AS
SELECT StateID, COUNT(*) AS ControlloPK
FROM State
GROUP BY StateID
HAVING COUNT(*) > 1;

CREATE VIEW Esercizio1_Sale AS
SELECT SaleID, COUNT(*) AS ControlloPK
FROM Sale
GROUP BY SaleID
HAVING COUNT(*) > 1;

/*ESERCIZIO 2
Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, la categoria del prodotto,
il nome dello stato, il nome della regione di vendita e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno
 (>180 -> True, <= 180 -> False) */
 
CREATE VIEW Esercizio2 AS
SELECT 
s.SaleID AS CodiceDocumento,
s.Date AS DataVendita,
p.ProductName AS NomeProdotto,
c.CategoryName AS CategoriaProdotto,
st.StateName AS NomeStato,
r.RegionName AS NomeRegione,
IF(DATEDIFF(CURRENT_DATE, s.Date) > 180, 'True', 'False') AS giornipassati180
FROM Sale s
JOIN Product p ON s.ProductID = p.ProductID
JOIN Category c ON p.CategoryID = c.CategoryID
JOIN State st ON s.StateID = st.StateID
JOIN Region r ON st.RegionID = r.RegionID;

/*ESERCIZIO 3
3)	Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito.
 (ogni valore della condizione deve risultare da una query e non deve essere inserito a mano).
 Nel result set devono comparire solo il codice prodotto e il totale venduto. */

CREATE VIEW Esercizio3 AS
SELECT 
ProductID AS CodiceProdotto, 
SUM(Quantity) AS TotaleVenduto
FROM 
Sale
GROUP BY 
ProductID
HAVING 
SUM(Quantity) > (
-- Sottoquery 1: Calcola la media delle quantità vendute
SELECT AVG(Quantity)
FROM Sale
WHERE YEAR(Date) = (
-- Sottoquery 2: ...solo per l'ultimo anno presente in tabella
SELECT MAX(YEAR(Date)) 
FROM Sale
)
);

/*ESERCIZIO 4
4)	Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. */

CREATE VIEW Esercizio4 AS
SELECT 
p.ProductID AS CodiceProdotto,
p.ProductName AS NomeProdotto,
EXTRACT(YEAR FROM s.Date) AS AnnoVendita,
SUM(s.Quantity * s.UnitPrice) AS FatturatoTotale
FROM 
Sale s
JOIN 
Product p ON s.ProductID = p.ProductID
GROUP BY 
p.ProductID, 
p.ProductName, 
EXTRACT(YEAR FROM s.Date)
ORDER BY 
p.ProductID, 
AnnoVendita;

/* ESERCIZIO 5
Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.*/

CREATE VIEW Esercizio5 AS
SELECT 
st.StateName AS NomeStato,
EXTRACT(YEAR FROM s.Date) AS AnnoVendita,
SUM(s.Quantity * s.UnitPrice) AS FatturatoTotale
FROM 
Sale s
JOIN 
State st ON s.StateID = st.StateID
GROUP BY 
st.StateName,
EXTRACT(YEAR FROM s.Date)
ORDER BY 
AnnoVendita ASC, 
FatturatoTotale DESC;

/*ESERCIZIO 6
Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?*/

CREATE VIEW Esercizio6 AS
SELECT 
c.CategoryName AS Categoria,
SUM(s.Quantity) AS QuantitaTotaleVenduta
FROM 
Sale s
JOIN 
Product p ON s.ProductID = p.ProductID
JOIN 
Category c ON p.CategoryID = c.CategoryID
GROUP BY 
c.CategoryName
ORDER BY 
QuantitaTotaleVenduta DESC
LIMIT 1; -- dopo aver ordinato decrescente partirà dal più venduto e quindi mettendo limit 1 posso prendermi solo il dato della categoria che ha venduto di più

/*ESERCIZIO 7
Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti. */

CREATE VIEW Esercizio7_Metodo1 AS
SELECT 
p.ProductID AS CodiceProdotto,
p.ProductName AS NomeProdotto
FROM 
Product p
LEFT JOIN 
Sale s ON p.ProductID = s.ProductID
WHERE 
s.SaleID IS NULL;


CREATE VIEW Esercizio7_Metodo2 AS
SELECT 
ProductID AS CodiceProdotto,
ProductName AS NomeProdotto
FROM 
Product
WHERE 
ProductID NOT IN (
SELECT ProductID 
FROM Sale
);


/*ESERCIZIO 8
Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili (codice prodotto, nome prodotto, nome categoria).*/

CREATE VIEW Esercizio8 AS
SELECT 
p.ProductID AS CodiceProdotto,
p.ProductName AS NomeProdotto,
c.CategoryName AS NomeCategoria
FROM 
Product p
JOIN 
Category c ON p.CategoryID = c.CategoryID;

/*ESERCIZIO 9
Creare una vista per le informazioni geografiche. */

CREATE VIEW Esercizio9 AS
SELECT 
s.StateID AS CodiceStato,
s.StateName AS NomeStato,
r.RegionName AS NomeContinente
FROM 
State s
JOIN 
Region r ON s.RegionID = r.RegionID;