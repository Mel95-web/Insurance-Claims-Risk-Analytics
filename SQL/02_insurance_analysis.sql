-- Insurance Claims & Risk Analytics | PostgreSQL
-- Analysen nach dem Import der Originaldatensätze ausführen.
-- Hinweis: idpol wird in insurance_frequency als Text gespeichert,
-- damit die Schreibweise der IDs aus der Quelldatei erhalten bleibt.
-- Eine mögliche Rundung wissenschaftlich notierter IDs muss vor
-- weiterführenden Verknüpfungen gesondert geprüft werden.

-- Datenimport kontrollieren
SELECT COUNT(*) AS anzahl_vertraege FROM insurance_frequency;
SELECT COUNT(*) AS anzahl_schadenbetraege FROM insurance_severity;

-- Versicherungskennzahlen berechnen
SELECT
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency;


-- Schadenhöhen und Gesamtschadenkosten analysieren
SELECT
    COUNT(*) AS anzahl_schadenbetraege,
    ROUND(AVG(claimamount), 2) AS durchschnittliche_schadenhoehe,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY claimamount)::NUMERIC,
        2
    ) AS mediane_schadenhoehe,
    ROUND(SUM(claimamount), 2) AS gesamte_schadenkosten,
    MAX(claimamount) AS hoechster_schaden
FROM insurance_severity;


-- Übereinstimmung der Vertrags-IDs zwischen beiden Tabellen prüfen
SELECT
    COUNT(*) AS anzahl_schadenbetraege,
    COUNT(f.idpol) AS zugeordnete_schadenbetraege,
    COUNT(*) - COUNT(f.idpol) AS nicht_zugeordnete_schadenbetraege
FROM insurance_severity s
LEFT JOIN insurance_frequency f
    ON s.idpol::TEXT = f.idpol;


-- Schadenkosten je Versicherungsvertrag berechnen
WITH kosten_pro_vertrag AS (
    SELECT
        idpol,
        SUM(claimamount) AS schadenkosten
    FROM insurance_severity
    GROUP BY idpol
)
SELECT
    f.idpol,
    f.claimnb,
    f.exposure,
    COALESCE(k.schadenkosten, 0) AS schadenkosten
FROM insurance_frequency f
LEFT JOIN kosten_pro_vertrag k
    ON f.idpol = k.idpol::TEXT
ORDER BY schadenkosten DESC
LIMIT 10;


-- Regionale Schadenhäufigkeit analysieren
SELECT
    region,
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency
GROUP BY region
ORDER BY schadenhaeufigkeit_prozent DESC;


-- Schadenhäufigkeit nach Altersgruppen der Fahrer
SELECT
    CASE
        WHEN drivage < 25 THEN 'Unter 25'
        WHEN drivage BETWEEN 25 AND 34 THEN '25-34'
        WHEN drivage BETWEEN 35 AND 44 THEN '35-44'
        WHEN drivage BETWEEN 45 AND 54 THEN '45-54'
        WHEN drivage BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65 und älter'
    END AS altersgruppe,
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency
GROUP BY altersgruppe
ORDER BY schadenhaeufigkeit_prozent DESC;



-- Schadenhäufigkeit nach Fahrzeugleistung analysieren
SELECT
    vehpower,
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency
GROUP BY vehpower
ORDER BY vehpower;


-- Schadenhäufigkeit nach Bonus-Malus-Gruppen
SELECT
    CASE
        WHEN bonusmalus < 100 THEN 'Unter 100'
        WHEN bonusmalus = 100 THEN '100'
        ELSE 'Über 100'
    END AS bonusmalus_gruppe,
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency
GROUP BY bonusmalus_gruppe
ORDER BY schadenhaeufigkeit_prozent DESC;



-- Schadenhäufigkeit nach Kraftstoffart analysieren
SELECT
    vehgas,
    COUNT(*) AS anzahl_vertraege,
    SUM(claimnb) AS anzahl_schaeden,
    ROUND(SUM(exposure)::NUMERIC, 2) AS gesamte_exposition,
    ROUND(
        SUM(claimnb)::NUMERIC
        / NULLIF(SUM(exposure), 0)::NUMERIC * 100,
        2
    ) AS schadenhaeufigkeit_prozent
FROM insurance_frequency
GROUP BY vehgas
ORDER BY schadenhaeufigkeit_prozent DESC;


-- Schadenkosten mit und ohne Vertragszuordnung vergleichen
SELECT
    COUNT(*) AS anzahl_schadenbetraege,
    COUNT(f.idpol) AS zugeordnete_schaeden,
    COUNT(*) - COUNT(f.idpol) AS nicht_zugeordnete_schaeden,
    ROUND(SUM(s.claimamount), 2) AS gesamte_schadenkosten,
    ROUND(
        SUM(s.claimamount) FILTER (WHERE f.idpol IS NOT NULL),
        2
    ) AS zugeordnete_schadenkosten
FROM insurance_severity s
LEFT JOIN insurance_frequency f
    ON s.idpol::TEXT = f.idpol;


