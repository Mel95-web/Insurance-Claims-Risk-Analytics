-- Insurance Claims & Risk Analytics | PostgreSQL
-- Tabellen für die unveränderten CSV-Quelldaten erstellen.
-- Dieses Skript nur einmal in einer neuen, leeren Datenbank ausführen.

-- Tabelle für Versicherungsverträge und Schadenhäufigkeit
CREATE TABLE insurance_frequency (
    idpol VARCHAR(50) PRIMARY KEY,
    claimnb INTEGER,
    exposure DOUBLE PRECISION,
    vehpower INTEGER,
    vehage INTEGER,
    drivage INTEGER,
    bonusmalus INTEGER,
    vehbrand VARCHAR(20),
    vehgas VARCHAR(20),
    area VARCHAR(5),
    density INTEGER,
    region VARCHAR(100)
);

-- Tabelle für einzelne Schadenbeträge
CREATE TABLE insurance_severity (
    claim_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idpol BIGINT,
    claimamount NUMERIC(15, 2)
);

-- Importhinweise:
-- insurance_frequency: CSV mit Kopfzeile, Trennzeichen Komma (,).
-- insurance_severity: CSV mit Kopfzeile, Trennzeichen Semikolon (;).
-- Für insurance_severity nur (idpol, claimamount) importieren;
-- claim_id wird automatisch erzeugt.
-- Keine Fremdschlüsselbedingung auf insurance_severity.idpol:
-- 195 Schadenbeträge besitzen keine Zuordnung in insurance_frequency.
