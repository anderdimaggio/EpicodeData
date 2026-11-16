# Database Relazionale Vendite Retail & Analisi Business Intelligence (MySQL)

## Panoramica del Progetto 
Questo progetto riguarda la progettazione, l'implementazione e l'interrogazione analitica di un database relazionale per un'azienda retail specializzata in giocattoli e kit educativi, realizzato con **MySQL**.

Partendo dalla modellazione concettuale e logica, il database è stato strutturato per tracciare il catalogo prodotti, i mercati geografici (Stati e Regioni) e le transazioni di vendita, automatizzando la reportistica aziendale tramite Viste SQL (`VIEW`).

---

## Architettura del Database e Schema
Il database (`CaseStudy`) segue una struttura relazionale normalizzata (Schema a Fiocco di Neve / Snowflake) composta da **5 tabelle collegate** con vincoli di Chiave Primaria (`PRIMARY KEY`) ed Esterna (`FOREIGN KEY`):

* **`Category`**: Categorie merceologiche (*Action Figures, Board Games, Educational*).
* **`Product`**: Anagrafica prodotti collegata a `Category`.
* **`Region`**: Macro-aree geografiche (*West Europe, South Europe, North America*).
* **`State`**: Dettaglio dei singoli mercati nazionali collegati a `Region`.
* **`Sale`**: Tabella dei fatti contenente data della transazione, quantità venduta, prezzo unitario e chiavi esterne verso `Product` e `State`.

*(I dettagli completi della modellazione sono consultabili nei file `01-er-diagram-conceptual-schema.png` e `02-logical-schema-documentation.xlsx`).*

---

## Query Analitiche e Competenze SQL Dimostrate
Lo script SQL (`03-retail-sales-queries-and-views.sql`) comprende la creazione delle tabelle, il popolamento dei dati e **9 Viste analitiche** progettate per rispondere a specifiche domande di business:

1. **Verifica Integrità e Univocità delle Chiavi Primarie:** Query di controllo automatico (`GROUP BY` + `HAVING COUNT(*) > 1`) per garantire l'assenza di duplicati sulle PK di tutte le tabelle.
2. **Reportistica Completa delle Transazioni:** `JOIN` multi-tabella tra vendite, prodotti, categorie e aree geografiche, con calcolo dinamico (`DATEDIFF`) per segnalare le transazioni effettuate da oltre 180 giorni.
3. **Analisi Prodotti Sopra la Media:** Subquery annidate (`HAVING SUM(Quantity) > AVG(...)`) per individuare i prodotti con volumi di vendita superiori alla media dell'ultimo anno censito.
4. **Fatturato Annuo per Prodotto:** Aggregazione temporale dei ricavi (`EXTRACT(YEAR)`, `SUM(Quantity * UnitPrice)`) per ciascun articolo venduto.
5. **Ripartizione Geografica del Fatturato:** Analisi del fatturato annuo per singolo Stato, ordinata cronologicamente e per ricavi decrescenti.
6. **Identificazione della Categoria Più Richiesta:** Analisi della domanda di mercato per individuare la categoria con il maggior volume di unità vendute.
7. **Rilevamento Prodotti Invenduti (Doppio Approccio):** Individuazione degli articoli a zero vendite tramite due tecniche SQL distinte: `LEFT JOIN ... WHERE IS NULL` e filtraggio con subquery `NOT IN`.
8. **Viste Denormalizzate per Business Intelligence:** Creazione di viste dimensionali pulite (`Esercizio8` ed `Esercizio9`) pronte per essere collegate a strumenti di visualizzazione come Power BI o Looker Studio.

---

