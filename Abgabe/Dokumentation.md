# Datenbankbeschreibung - Bank-Management-System

## Thema
Das Projekt behandelt die Entwicklung einer Datenbank für ein Bank-Management-System.  
Die Datenbank bildet die grundlegenden Abläufe und Strukturen einer Bank digital ab.

## Zweck der Datenbank
Die Datenbank dient dazu, alle wichtigen Informationen einer Bank zentral zu speichern, zu verwalten und strukturiert abzurufen. Sie unterstützt den täglichen Bankbetrieb und sorgt für Ordnung, Übersicht und Datensicherheit.

## Funktion
Die Datenbank ermöglicht:
- die Verwaltung von Bankkunden
- die Zuordnung von Konten zu Kunden
- die Speicherung von Geldbewegungen (Transaktionen)
- die Verwaltung von Krediten
- die Organisation von Mitarbeitern und Filialen

## Abgebildete Inhalte
In der Datenbank werden unter anderem folgende Bereiche abgebildet:
- persönliche Daten von Kunden
- Informationen zu Bankkonten und Kontoständen
- Ein- und Auszahlungen sowie Überweisungen
- laufende und abgeschlossene Kredite
- Mitarbeiter einer Bank und deren Filialzuordnung

## Einsatzbereich
Die Datenbank ist ein schulisches Projekt.
Sie dient als Grundlage, um das Zusammenspiel von Daten, Beziehungen und Funktionen in einer realitätsnahen Anwendung zu verstehen.

## Ziel des Projekts
Ziel des Schulprojekts ist es, grundlegende Kenntnisse im Bereich Datenbanken zu erwerben, insbesondere:
- strukturiertes Arbeiten mit Daten
- Verständnis für relationale Datenbanken

# ER Modell

![ER Modell](../Abgabe/Relationes%20Datenbankmodell/ERM.png)

---

# Relationales Modell

![Relationales Modell](../Abgabe/Relationes%20Datenbankmodell/BankManagementModell_v2.0.png)

# Relationales Modell – Feldbeschreibungen

## UserAccount
| Feld | Beschreibung |
|-----|-------------|
| UserAccountID | Eindeutige ID des Benutzerkontos (auto. Increase) |
| Email | E-Mail-Adresse für die Identifikation und Anmeldung |
| PasswordHash | Verschlüsselter Hash des Benutzerpassworts |
| IsActive | Gibt an, ob das Benutzerkonto aktiv ist |
| CreatedAt | Erstellungsdatum des Benutzerkontos |
| LastLoginAt | Datum der letzten Anmeldung |

---

## Role
| Feld | Beschreibung |
|-----|-------------|
| RoleID | Eindeutige ID der Rolle  (auto. Increase) |
| Name | Name der Rolle (zb. Kunde, Mitarbeiter) |
| Description | Beschreibung der Rolle |

---

## Customer
| Feld | Beschreibung |
|-----|-------------|
| CustomerID | Eindeutige ID des Kunden (auto. Increase) |
| FirstName | Vorname des Kunden |
| LastName | Nachname des Kunden |
| BirthDate | Geburtsdatum des Kunden |
| Phone | Telefonnummer des Kunden |
| Street | Strasse des Kunden |
| Postal | PLZ des Wohnorts |
| City | Wohnort (Stadt) des Kunden |
| Status | Aktueller Status des Kunden |
| fk_RoleID | FK auf die Rolle die der Benutzer hat |
| fk_UserAccountID | FK auf den User Account, welcher dem User gehört |

---

## Employee
| Feld | Beschreibung |
|-----|-------------|
| EmployeeID | Eindeutige ID des Mitarbeiters (auto. Increase) |
| FirstName | Vorname des Mitarbeiters |
| LastName | Nachname des Mitarbeiters |
| Email | E-Mail-Adresse des Mitarbeiters |
| JobTitle | Funktion oder Position im Unternehmen |
| HireDate | Einstellungsdatum des Mitarbeiters |
| IsActive | Gibt an, ob der Mitarbeiter aktiv ist |
| fk_RoleID | Fremdschlüssel auf die Rolle des Mitarbeites |

---

## AccountType
| Feld | Beschreibung |
|-----|-------------|
| AccountTypeID | Eindeutige ID des Kontotyps (auto. Increase) |
| Name | Bezeichnung des Kontotyps |
| Currency | Währung des Kontos (zb. CHF, EUR) |
| MonthlyFee | Monatliche Kontogebühr |

---

## Account
| Feld | Beschreibung |
|-----|-------------|
| AccountID | Eindeutige ID des Kontos (auto. Increase) |
| IBAN | Eindeutige Kontonummer |
| Balance | Aktueller Kontostand |
| Status | Status des Kontos |
| OpenedAt | Eröffnungsdatum des Kontos |
| ClosedAt | Schliessungsdatum des Kontos |
| fk_AccountType | FK des AccountTypes für den Account |

---

## Card
| Feld | Beschreibung |
|-----|-------------|
| CardID | Eindeutige ID der Karte (auto. Increase) |
| CardType | Typ der Karte (zb. Debit, Kredit) |
| ExpiryDate | Ablaufdatum der Karte |
| Status | Aktueller Status der Karte |
| DailyLimit | Maximales tägliches Limit was man ausgeben darf. |
| fk_AccountID | FK des Accounts welcher die Karte besitzt |

---

## TransactionType
| Feld | Beschreibung |
|-----|-------------|
| TransactionTypeID | Eindeutige ID des Transaktionstyps (auto. Increase) |
| Name | Bezeichnung der Transaktionsart |
| Direction | Richtung der Buchung (IN / OUT) |
| Description | Beschreibung des Transaktionstyps |

---

## Transaction
| Feld | Beschreibung |
|-----|-------------|
| TransactionID | Eindeutige ID der Transaktion (auto. Increase) |
| BookingDate | Buchungsdatum der Transaktion |
| Description | Beschreibung |
| fk_AccountID | Betroffenes Konto der Transaktion |
| fk_TransactionType | Art der Transaktion |

---

## CustomerAccount
| Feld | Beschreibung |
|-----|-------------|
| CustomerAccountID | Eindeutige ID der Zuordnung (auto. Increase) |
| fk_CustomerID | FK des verbundenen Kunde |
| fk_AccountID | Zugehöriges Konto |

# Test-Beschreibung

## 1. CreateAccount Stored Procedure Tests

### 1.1 Erfolgreiche Kontoerstellung

**Zweck:** Überprüfen, dass ein neues Konto erfolgreich für einen existierenden aktiven Kunden erstellt werden kann.

**Test-Beschreibung:**
Die Stored Procedure fügt einem existierenden Kunden einen persönlichen Account hinzu, welcher dann über die Zwischentabelle `CustomerAccount` verbunden ist. Die Prozedur benötigt mehrere Parameter und führt Validierungen durch, bevor das Konto erstellt wird.

**Parameter:**
- `@CustomerID`: Erster aktiver Kunde aus der Datenbank
- `@AccountTypeID`: Erster Kontotyp aus der Datenbank
- `@IBAN`: Zufällig generierte IBAN (Format: CH + 20 Ziffern)
- `@StartBalance`: 250.00 (Anfangsguthaben)

**Ablauf:**
1. Parameter werden überprüft (NULL-Checks)
2. Account wird in die `Account`-Tabelle eingefügt
3. Primary Key wird mit `SCOPE_IDENTITY()` gespeichert
4. Verbindungseintrag wird in der `CustomerAccount`-Tabelle erstellt
5. Anfangsguthaben wird gesetzt

**Validierungs-Abfragen:**
- Überprüfung der Kontoerstellung durch Suche nach der generierten IBAN
- Überprüfung der Kunden-Konto-Beziehung in der `CustomerAccount`-Tabelle

---

### 1.2 Fehlerfall: Kunde existiert nicht

**Zweck:** Überprüfen, dass die Prozedur korrekt reagiert, wenn versucht wird, ein Konto für einen nicht existierenden Kunden zu erstellen.

**Test-Beschreibung:**
Testet die Fehlerbehandlung bei Angabe einer ungültigen Kunden-ID.

**Parameter:**
- `@FailCustomerID`: 999999 (ungültige ID)
- `@FailAccountTypeID`: Erster Kontotyp aus der Datenbank
- `@FailIBAN`: Zufällig generierte Schweizer IBAN
- `@FailStartBalance`: 100.00

**Erwartetes Ergebnis:**
Fehlermeldung: "Kunde existiert nicht!"

---

## 2. CanWithDraw Funktion Tests

### 2.1 Erfolgreiche Konto abheben Überprüfung

**Zweck:** Überprüfen, dass die Funktion korrekt validiert, wann eine Abhebung erlaubt ist.

**Test-Beschreibung:**
Testet die Funktion mit gültigen Parametern. Das Konto über genügend Guthaben verfügt und Tageslimits berücksichtigt werden.

**Parameter:**
- `@AccountID`: Erstes Konto mit Balance ≥ 200
- `@Amount`: 100 (oder angepasst an das Tageslimit, falls vorhanden)

**Logik:**
- Falls ein Tageslimit auf einer aktiven Karte existiert, wird der Betrag entsprechend angepasst
- Betrag wird auf 100 gesetzt, wenn kein Limit existiert oder das Limit dies erlaubt

**Validierungs-Abfragen:**
- Überprüfung des Funktions-Rückgabewerts (sollte 1 für erlaubt sein)
- Anzeige des Kontostands
- Anzeige der aktiven Kartendetails mit Tageslimit

---

### 2.2 Tests mit ungültigen Parametern

**Zweck:** Überprüfen, dass die Funktion ungültige Eingaben korrekt behandelt.

**Testfälle:**

1. **NULL Konto-ID**
   - Eingabe: `CanWithDraw(NULL, 100)`
   - Erwartet: Gibt 0 zurück (false)

2. **NULL Betrag**
   - Eingabe: `CanWithDraw(1, NULL)`
   - Erwartet: Gibt 0 zurück (false)

3. **Betrag gleich Null**
   - Eingabe: `CanWithDraw(1, 0)`
   - Erwartet: Gibt 0 zurück (false)

4. **Negativer Betrag**
   - Eingabe: `CanWithDraw(1, -10)`
   - Erwartet: Gibt 0 zurück (false)

---

## 3. TransferMoney Stored Procedure Tests

### 3.1 Erfolgreiche Überweisung

**Zweck:** Überprüfen, dass Geld erfolgreich zwischen zwei Konten überwiesen werden kann.

**Test-Beschreibung:**
Testet eine vollständige Überweisungstransaktion zwischen zwei gültigen Konten mit ausreichendem Guthaben.

**Parameter:**
- `@FromAccountID`: Erstes Konto mit Balance ≥ 200
- `@ToAccountID`: Erstes Konto, das sich vom Quellkonto unterscheidet
- `@AmountTransfer`: 50

**Ablauf:**
1. Anzeige der Kontostände vor der Überweisung
2. Ausführung der TransferMoney Prozedur
3. Anzeige der Kontostände nach der Überweisung

**Erwartete Ergebnisse:**
- Erstkonto-Guthaben um 50 verringert
- Zielkonto-Guthaben um 50 erhöhen

---

### 3.2 Fehlerfall: Ungültiger Betrag

**Zweck:** Überprüfen, dass die Prozedur ungültige Überweisungsbeträge korrekt ablehnt.

**Test-Beschreibung:**
Testet die Fehlerbehandlung, wenn ein Betrag von 0 angegeben wird.

**Parameter:**
- `@FailFromAccountID`: Erstes Konto aus der Datenbank
- `@FailToAccountID`: Zweites Konto aus der Datenbank
- `@Amount`: 0 (ungültig)

**Erwartetes Ergebnis:**
Fehlermeldung: "Der Amount hat einen Wert von unter 0"

---

## Hinweise / Nützliche Infos

- Alle Tests verwenden Daten aus vorhandenen Datenbankeinträgen
- IBANs werden mit `NEWID()` und `CHECKSUM()` generiert, um Eindeutige IBANs zu garantieren
- Tests beinhalten "Vorher"- und "Nachher"- Ausgaben

# Beschreibung der Stored Procedure und Functions

## 1. CreateAccount - Stored Procedure

### Zweck
Erstellt ein neues Bankkonto für einen existierenden Kunden und verknüpft dieses mit dem Kunden über die Zwischentabelle `CustomerAccount`.

### Parameter

| Parameter | Typ | Beschreibung |
|-----------|-----|--------------|
| `@CustomerID` | INT | ID des Kunden, für den das Konto erstellt werden soll |
| `@StartBalance` | DECIMAL(6,2) | Anfangsguthaben des Kontos |
| `@IBAN` | VARCHAR(50) | Eindeutige IBAN für das neue Konto |
| `@AccountTypeID` | INT | ID des Kontotyps (z.B. Sparkonto, Girokonto) |

### Funktionsweise

1. **Validierung der Kundenexistenz**
   - Überprüft, ob der Kunde mit der angegebenen ID existiert
   - Falls nicht: Fehler "Kunde existiert nicht!"

2. **Validierung des Kundenstatus**
   - Überprüft, ob der Kunde den Status 'active' hat
   - Falls nicht: Fehler "Kunde ist nicht aktiviert"

3. **Kontoerstellung**
   - Fügt einen neuen Eintrag in die `Account`-Tabelle ein
   - Initialisiert das Konto mit Balance = 0 und Status = 'active'
   - Setzt das Eröffnungsdatum auf das aktuelle Datum (`GETDATE()`)

4. **Speicherung der neuen Konto-ID**
   - Verwendet `SCOPE_IDENTITY()` um die automatisch generierte AccountID zu erfassen

5. **Verknüpfung Kunde-Konto**
   - Erstellt einen Eintrag in der `CustomerAccount`-Zwischentabelle
   - Verknüpft den Kunden mit dem neu erstellten Konto

6. **Validierung des Startguthabens**
   - Überprüft, ob `@StartBalance` nicht negativ ist
   - Falls negativ: Fehler "StartBalance darf nicht unter 0 sein."

7. **Setzen des Startguthabens**
   - Aktualisiert die Balance des neuen Kontos auf den angegebenen Wert

### Anwendungsbeispiel

```sql
EXEC CreateAccount
    @CustomerID = 5,
    @StartBalance = 1000.00,
    @IBAN = 'CH9300762011623852957',
    @AccountTypeID = 1;
```

### Anwendungsfälle
- Eröffnung eines neuen Kontos für bestehende Kunden
- Einrichtung von Zusatzkonten (Sparkonto, Fremdwährungskonto)
- Automatisierte Kontoerstellung bei Kundenonboarding

---

## 2. CanWithDraw - Function

### Zweck
Überprüft, ob eine Abhebung von einem bestimmten Konto möglich ist, basierend auf Kontostand, Tageslimit und verschiedenen Validierungen.

### Parameter

| Parameter | Typ | Beschreibung |
|-----------|-----|--------------|
| `@AccountID` | INT | ID des Kontos, von dem abgehoben werden soll |
| `@Amount` | INT | Betrag, der abgehoben werden soll |

### Rückgabewert
- **BIT**: `1` (TRUE) wenn Abhebung erlaubt ist, `0` (FALSE) wenn nicht

### Funktionsweise

1. **Initialisierung**
   - Setzt `@Result` auf 0 (nicht erlaubt als Standard)
   - Deklariert Variablen für Balance und DailyLimit

2. **Validierung der Eingabeparameter**
   - Überprüft, ob `@AccountID` nicht NULL ist
   - Überprüft, ob `@Amount` nicht NULL ist
   - Überprüft, ob `@Amount` größer als 0 ist
   - Bei Fehlschlag: Rückgabe 0

3. **Validierung der Kontoexistenz**
   - Überprüft, ob das Konto in der Datenbank existiert
   - Bei Fehlschlag: Rückgabe 0

4. **Überprüfung des Kontostands**
   - Holt den aktuellen Kontostand des Kontos
   - Vergleicht Balance mit dem gewünschten Abhebungsbetrag
   - Bei unzureichendem Guthaben: Rückgabe 0

5. **Überprüfung des Tageslimits**
   - Sucht nach einer aktiven Karte für das Konto
   - Holt das DailyLimit der Karte (falls vorhanden)
   - Vergleicht den Abhebungsbetrag mit dem Tageslimit
   - Bei Überschreitung: Rückgabe 0

6. **Erfolgreiche Validierung**
   - Wenn alle Prüfungen bestanden sind: Setzt `@Result` auf 1
   - Rückgabe 1 (Abhebung erlaubt)

### Anwendungsbeispiel

```sql
-- Prüfen ob 500 CHF abgehoben werden können
DECLARE @CanDo BIT = dbo.CanWithDraw(12, 500);

IF @CanDo = 1
    PRINT 'Abhebung erlaubt';
ELSE
    PRINT 'Abhebung nicht möglich';
```

### Anwendungsfälle
- Validierung vor Geldautomaten-Transaktionen
- Überprüfung vor Online-Banking-Abhebungen
- Integration in andere Stored Procedures (z.B. TransferMoney)
- Echtzeitprüfung der Abhebungsmöglichkeit

---

## 3. TransferMoney - Stored Procedure

### Zweck
Führt eine Geldüberweisung zwischen zwei Konten durch, inklusive vollständiger Validierung, Transaktionsverwaltung und Buchungsprotokollierung.

### Parameter

| Parameter | Typ | Beschreibung |
|-----------|-----|--------------|
| `@FromAccountID` | INT | ID des Quellkontos (von dem Geld abgebucht wird) |
| `@ToAccountID` | INT | ID des Zielkontos (auf das Geld überwiesen wird) |
| `@Amount` | INT | Überweisungsbetrag |

### Funktionsweise

#### Phase 1: Validierung der Parameter

1. **NULL-Überprüfungen**
   - Prüft ob `@FromAccountID` NULL ist → Fehler
   - Prüft ob `@ToAccountID` NULL ist → Fehler
   - Prüft ob `@Amount` NULL ist → Fehler

2. **Betragsvalidierung**
   - Überprüft ob `@Amount` größer als 0 ist
   - Falls `@Amount` ≤ 0: Fehler "Der Amount hat einen Wert von unter 0"

#### Phase 2: Validierung der Konten

3. **Existenz des Quellkontos**
   - Überprüft ob das Quellkonto existiert
   - Falls nicht: Fehler "Quellkonto existiert nicht."

4. **Existenz des Zielkontos**
   - Überprüft ob das Zielkonto existiert
   - Falls nicht: Fehler "Zielkonto existiert nicht."

#### Phase 3: Abhebungsvalidierung

5. **CanWithDraw-Prüfung**
   - Ruft die `CanWithDraw`-Funktion auf
   - Überprüft Balance, Tageslimit und weitere Bedingungen
   - Falls nicht erlaubt: Fehler "Abheben nicht möglich! (ungenügend viel Geld oder Tageslimit überstiegen)."

#### Phase 4: Transaktionsdurchführung

6. **Transaktionsbeginn**
   - Startet eine Datenbanktransaktion mit `BEGIN TRANSACTION`

7. **Abbuchung vom Quellkonto**
   - Reduziert die Balance des Quellkontos um `@Amount`
   - `UPDATE Account SET Balance = Balance - @Amount`

8. **Gutschrift auf Zielkonto**
   - Erhöht die Balance des Zielkontos um `@Amount`
   - `UPDATE Account SET Balance = Balance + @Amount`

9. **Buchungsprotokollierung - Quellkonto**
   - Erstellt einen Transaction-Eintrag für das Quellkonto
   - TransactionType: 3 (TransferOut)
   - Beschreibung: "Übertrag auf anderes Konto"
   - Buchungsdatum: Aktuelles Datum

10. **Buchungsprotokollierung - Zielkonto**
    - Erstellt einen Transaction-Eintrag für das Zielkonto
    - TransactionType: 4 (TransferIn)
    - Beschreibung: "Übertrag von einem anderen Konto"
    - Buchungsdatum: Aktuelles Datum

11. **Transaktionsabschluss**
    - Bei Erfolg: `COMMIT TRANSACTION`
    - Alle Änderungen werden dauerhaft gespeichert

#### Phase 5: Fehlerbehandlung

12. **Rollback bei Fehler**
    - `BEGIN CATCH` fängt alle Fehler ab
    - `ROLLBACK TRANSACTION` macht alle Änderungen rückgängig
    - Fehlermeldung wird mit `RAISERROR` weitergegeben
    - Garantiert Datenintegrität

### Anwendungsbeispiel

```sql
-- Überweisung von 250 CHF von Konto 10 auf Konto 15
EXEC dbo.TransferMoney
    @FromAccountID = 10,
    @ToAccountID = 15,
    @Amount = 250;
```

### Anwendungsfälle
- Überweisungen zwischen Kundenkonten
- Interne Umbuchungen
- Automatische Zahlungen (z.B. Daueraufträge)
- Integration in Online-Banking-Systeme
- Mobile Banking-Transaktionen

---

## Interaktion der Funktionen

### Workflow: Komplette Geldüberweisung

```
1. Kunde macht eine Überweisung
2. TransferMoney wird aufgerufen
3. Parameter werden validiert
4. CanWithDraw prüft Abhebungsmöglichkeit
5. Bei Erfolg: Transaktion wird durchgeführt
6. Buchungen werden in beiden Konten geloggt
7. Transaktion wird committed
8. Kunde erhält Bestätigung
```

### Workflow: Neue Kontoeröffnung

```
1. Kunde fordert ein neues Konto
2. System validiert Kundenstatus
3. CreateAccount wird aufgerufen
4. Konto wird erstellt und verknüpft
5. Startguthaben wird gesetzt
6. Kunde kann Konto nutzen
```
