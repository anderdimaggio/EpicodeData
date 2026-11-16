# Python Epidemiological Data Analysis (COVID-19)

Progetto di Exploratory Data Analysis (EDA) e Data Visualization sviluppato in Python su dataset reali (*Our World in Data*) per analizzare l'andamento globale dei contagi e la pressione sui sistemi sanitari europei.

## Contenuto del Notebook
All'interno del file `.ipynb` ogni passaggio è commentato nel dettaglio e copre:
* **Data Understanding & Cleaning:** Esplorazione della struttura del dataset, verifica della natura delle variabili (stock vs flusso) e gestione dei valori nulli (`NaN`).
* **Analisi Globale:** Calcolo dei casi cumulativi e dell'incidenza percentuale per singolo continente rispetto al totale mondiale.
* **Analisi Temporale (Italia 2022):** Pulizia delle rilevazioni settimanali e visualizzazione dell'evoluzione dei casi totali e dei nuovi casi.
* **Confronto Terapie Intensive:** Analisi distributiva tramite boxplot dei pazienti ICU tra Italia, Germania e Francia (Mag 2022 – Apr 2023).
* **Audit Ospedalizzazioni (2021):** Confronto tra Italia, Germania, Francia e Spagna con valutazione critica e gestione dell'assenza totale di dati per la Germania.

## Strumenti Utilizzati
* **Python**
* **Pandas** (Data Manipulation & Cleaning)
* **Matplotlib & Seaborn** (Data Visualization)
