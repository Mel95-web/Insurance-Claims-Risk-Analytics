# Insurance Claims & Risk Analytics

## Projektübersicht

Dieses Projekt untersucht Schadenhäufigkeiten, Schadenhöhen und Risikofaktoren in der französischen Kfz-Versicherung. Ziel ist es, mithilfe von Python, SQL und statistischer Modellierung relevante Risikomuster zu identifizieren und die Schadenanzahl vorherzusagen.

Der Schwerpunkt liegt auf einem nachvollziehbaren End-to-End-Workflow von der Datenaufbereitung über die explorative Analyse bis zur Modellbewertung.

## Verwendete Technologien

- **Python:** Pandas, NumPy, Matplotlib, Seaborn, Statsmodels, Scikit-learn
- **SQL:** PostgreSQL, pgAdmin
- **Statistik:** Poisson-Regression, Überdispersionsanalyse, Modellvalidierung
- **Entwicklungsumgebung:** Jupyter Notebook

## Datengrundlage

Verwendet werden die öffentlich verfügbaren Datensätze `freMTPL2freq` und `freMTPL2sev` zur französischen Kfz-Versicherung.

| Datensatz | Umfang | Inhalt |
|---|---:|---|
| freMTPL2freq | 678.013 Verträge | Vertragsmerkmale, Exposition und Schadenanzahl |
| freMTPL2sev | 26.639 Einträge | Dokumentierte Schadenbeträge |

## Projektstruktur

```text
Insurance/
├── data_raw/
│   ├── freMTPL2freq.csv
│   └── freMTPL2sev.csv
├── notebooks/
│   └── Insurance Claims & Risk Analytics.ipynb
├── sql/
│   ├── 01_create_tables.sql
│   └── 02_insurance_analysis.sql
└── README.md
```

## Methodik

### 1. Datenverständnis und Datenqualität

Untersuchung der Datenstruktur, fehlender Werte, Wertebereiche und Konsistenz der Versicherungsdaten.

### 2. Explorative Datenanalyse

Analyse der Verteilung von Schadenanzahl, Exposition, Schadenhöhe und relevanten Versicherungsmerkmalen.

### 3. Schaden- und Risikoanalyse

Berechnung versicherungstechnischer Kennzahlen sowie Untersuchung von Risikosegmenten und Großschäden.

### 4. SQL und PostgreSQL

Import der Versicherungsdaten in PostgreSQL, Berechnung zentraler Kennzahlen und Analyse von Risikogruppen mittels SQL-Abfragen.

### 5. Statistische Risikomodellierung

Entwicklung und Bewertung einer Poisson-Regression zur Prognose der Schadenanzahl unter Berücksichtigung der Versicherungsexposition.

## Zentrale Ergebnisse

- Die gesamte Schadenhäufigkeit beträgt rund **10,07 Schäden je 100 Expositionsjahre**.
- Die durchschnittliche dokumentierte Schadenhöhe liegt bei **2.278,54 €**.
- Die teuersten **1 % der Schäden verursachen rund 37,96 %** der dokumentierten Gesamtschadenkosten.
- Die Schadenhäufigkeit unterscheidet sich zwischen verschiedenen Alters-, Bonus-Malus- und Fahrzeuggruppen.
- Die Poisson-Regression verbessert die Vorhersage gegenüber einer einfachen Baseline geringfügig:
  - MAE: **0,0989** gegenüber **0,1000**
  - Mean Poisson Deviance: **0,3217** gegenüber **0,3314**
- Die festgestellte Überdispersion zeigt Grenzen des klassischen Poisson-Modells auf.

## Einschränkungen

Die Datensätze enthalten keine Prämieninformationen. Daher ist keine Berechnung einer tatsächlichen Loss Ratio möglich.

Außerdem lassen sich nicht alle dokumentierten Schadenbeträge eindeutig den Versicherungsverträgen zuordnen.

## Reproduzierbarkeit

1. Repository herunterladen oder klonen.
2. Python-Umgebung mit den benötigten Bibliotheken vorbereiten.
3. Die beiden CSV-Dateien im Ordner `data_raw` bereitstellen.
4. Das Jupyter Notebook im Ordner `notebooks` öffnen und ausführen.
5. Für die SQL-Analysen PostgreSQL verwenden und zunächst `01_create_tables.sql`, anschließend `02_insurance_analysis.sql` ausführen. Die CSV-Daten müssen nach Erstellung der Tabellen in PostgreSQL importiert werden.

## Projektziel

Das Projekt demonstriert praktische Kompetenzen in Data Analytics, SQL, statistischer Modellierung und der Interpretation versicherungstechnischer Kennzahlen.