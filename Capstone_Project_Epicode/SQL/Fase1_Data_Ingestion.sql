-- ==============================================================================
-- PROGETTO: Smart Inventory Management (Fashion & Retail)
-- FASE 1: Data Ingestion & Modeling (Star Schema)
-- DATASET: H&M Kaggle Dataset (Articles, Customers, Transactions)
-- ==============================================================================

-- 1. INIZIALIZZAZIONE DEL DATABASE
-- Creazione del contenitore principale per il progetto
CREATE DATABASE IF NOT EXISTS hm_retail_db;
USE hm_retail_db;

-- ==============================================================================
-- 2. CREAZIONE DELLE DIMENSION TABLES (Tabelle Anagrafiche)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- A. TABELLA ARTICOLI (Catalogo Prodotti)
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS articles;

CREATE TABLE articles (
    article_id INT PRIMARY KEY,
    product_code VARCHAR(50),
    prod_name VARCHAR(255),
    product_type_name VARCHAR(100),
    index_group_name VARCHAR(100)
);

-- Importazione massiva file articoli
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/articles.csv' 
INTO TABLE articles 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- ------------------------------------------------------------------------------
-- B. TABELLA CLIENTI (Anagrafica Customers)
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    FN VARCHAR(10),
    Active VARCHAR(10),
    club_member_status VARCHAR(50),
    fashion_news_frequency VARCHAR(50),
    age VARCHAR(10),       -- Impostato come VARCHAR per gestire i valori nulli originari ('')
    postal_code VARCHAR(150)
);

-- Importazione massiva file clienti
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- ==============================================================================
-- 3. CREAZIONE DELLA FACT TABLE (Tabella dei Fatti)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- C. TABELLA TRANSAZIONI (Storico Vendite - ~31 Milioni di righe)
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    t_dat DATE,
    customer_id VARCHAR(100),
    article_id INT,
    price DECIMAL(10, 4),  -- Arrotondamento a 4 decimali per ottimizzazione memoria
    sales_channel_id INT
);

-- Importazione massiva file transazioni (Richiede timeout esteso su Workbench)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions_train.csv' 
INTO TABLE transactions 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- ==============================================================================
-- FINE SCRIPT DATA INGESTION
-- ==============================================================================



-- Adesso puliamo di milioni di dati la tabella transactions

USE hm_retail_db;

--  Creiamo la nuova tabella "snella" popolandola direttamente con i calcoli
CREATE TABLE daily_sales AS
SELECT 
    t_dat,                                 -- Raggruppa per Giorno
    article_id,                            -- Raggruppa per ID Articolo
    COUNT(article_id) AS total_pieces,     -- Conta quanti pezzi sono stati venduti
    SUM(price) AS total_revenue            -- Somma il fatturato incassato
FROM 
    transactions
GROUP BY 
    t_dat, 
    article_id;
    
    
    
    -- . Creiamo la nuova tabella per il marketing
CREATE TABLE customer_insights AS
SELECT 
    t.customer_id,                       -- Manteniamo l'ID del cliente
    c.age,                               -- Peschiamo l'età dalla tabella Customers
    c.club_member_status,                -- Peschiamo lo status dalla tabella Customers
    COUNT(t.article_id) AS total_items,  -- Contiamo quanti articoli ha comprato in totale nella sua vita
    SUM(t.price) AS total_spent          -- Sommiamo quanti soldi ha speso in totale
FROM 
    transactions t
JOIN 
    customers c ON t.customer_id = c.customer_id  --  Uniamo le due tabelle usando l'ID come ponte
GROUP BY 
    t.customer_id, 
    c.age, 
    c.club_member_status;


