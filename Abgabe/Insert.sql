USE BankManagement
GO

-- DELETE INSERTED DATA

BEGIN TRAN;

DELETE FROM CustomerAccount;
DELETE FROM [Transaction];
DELETE FROM [Card];
DELETE FROM Customer;
DELETE FROM Employee;
DELETE FROM Account;
DELETE FROM TransactionType;
DELETE FROM AccountType;
DELETE FROM [Role];
DELETE FROM UserAccount;

DBCC CHECKIDENT ('dbo.CustomerAccount', RESEED, 0);
DBCC CHECKIDENT ('dbo.Transaction', RESEED, 0);
DBCC CHECKIDENT ('dbo.[Card]', RESEED, 0);
DBCC CHECKIDENT ('dbo.Customer', RESEED, 0);
DBCC CHECKIDENT ('dbo.Employee', RESEED, 0);
DBCC CHECKIDENT ('dbo.Account', RESEED, 0);
DBCC CHECKIDENT ('dbo.TransactionType', RESEED, 0);
DBCC CHECKIDENT ('dbo.AccountType', RESEED, 0);
DBCC CHECKIDENT ('dbo.[Role]', RESEED, 0);
DBCC CHECKIDENT ('dbo.UserAccount', RESEED, 0);

COMMIT;
GO

-- CREATE INSERTS FOR ALL TABLES

INSERT INTO UserAccount (Email, PasswordHash, IsActive, CreatedAt, LastLoginAt) VALUES
('anna.mueller@gmail.com',        '$2b$12$A9fEwQJZ8x9mYz7k3pZK2uQe6N4y8LwQZpJr9cFq8mV0Y2dS1Hq', 1, '2022-03-14', '2026-01-09'),
('luca.rossi@hotmail.com',        '$2b$12$kQ9YpZ8Ew2X4FJrC1N6mL7D0ZV3A5H8S9TqUeBfR0aWc',        1, '2022-05-02', '2026-01-10'),
('sara.meier@outlook.com',        '$2b$12$RZ7wFQ9c3H2A6kS8X4pLJ0B1YVdUeT5mMZCqNf',            1, '2022-06-18', '2025-12-28'),
('noah.keller@gmail.com',         '$2b$12$ZQmA9D7FJk8L4Xc2EwS1V6pR5B0U3YHfTn',                1, '2022-08-01', '2026-01-11'),
('mia.schmid@yahoo.com',          '$2b$12$YwR3pQFJ9mA8ZC6E2kL0S4H5X1D7VnTBU',                0, '2022-09-10', '2025-06-30'),
('tim.weber@gmail.com',           '$2b$12$F9LQ2ZkR7Jp3A0D6mS1VYH4T8EwXU5cBn',                1, '2022-10-22', '2026-01-08'),
('laura.fischer@bluewin.ch',      '$2b$12$J0kFQH7m4E8pD9ZL3R2Y6A1wX5SVCnTU',                1, '2023-01-05', '2025-11-19'),
('jan.huber@icloud.com',          '$2b$12$A3Y0Z7XkE5F2LJ4C6mD9H8QpR1nVTUwS',                1, '2023-02-17', '2026-01-07'),
('nina.brunner@gmail.com',        '$2b$12$E9pQZ0D2m7X5F4C8R3YJ6kL1nBTSAHVU',                0, '2023-03-09', '2025-05-14'),
('leo.baumann@outlook.com',       '$2b$12$R8Zp7JX0QF2C6DkA9L4m5Y3H1VwEUnS',                1, '2023-04-21', '2026-01-10'),
('emilia.stein@gmail.com',        '$2b$12$0A7kZ9pJX8Y5F2LQ6C1mE3R4DHSVnUw',                1, '2023-06-02', '2025-12-03'),
('paul.graf@proton.me',           '$2b$12$Q9ZC7p0X2kA6L4YJ5R8E1D3FVmHSnw',                1, '2023-07-14', '2026-01-06'),
('lena.vogel@gmail.com',          '$2b$12$8YkL2JZp0Q7C6A4F1m5R9XEHDSV3Un',                1, '2023-08-26', '2025-10-12'),
('max.locher@outlook.com',        '$2b$12$Q0FZk6X2J9R8C7A4D5pYH1m3LSEVUn',                0, '2023-09-30', '2025-08-02'),
('zoe.peter@gmail.com',           '$2b$12$ZQ2A6k4J5pX7F9D0C8L3Y1RSHVmEUw',                1, '2023-11-11', '2026-01-05'),
('fabian.moser@bluewin.ch',       '$2b$12$4QZJ2Xk0A7C8YF6R9D5p1m3EHLSVn',                1, '2024-01-08', '2025-12-21'),
('alina.roth@gmail.com',          '$2b$12$C7kZpQ2X8A6R9FJ0L4D1Y5m3HSVEn',                1, '2024-02-19', '2026-01-04'),
('jonas.wild@icloud.com',         '$2b$12$9ZQXk2pJ8C0A7R5F4Y6D1L3mHESVn',                1, '2024-04-03', '2025-11-29'),
('melina.koch@gmail.com',         '$2b$12$Z8Q0Xk9C2pA7F6R5Y4D1LJm3HESVn',                0, '2024-06-17', '2025-07-06'),
('daniel.egli@protonmail.com',    '$2b$12$QZk2X9C8A7F6R5Y4D1LJ0p3mHESVn',                1, '2024-09-01', '2026-01-11');


INSERT INTO [Role] ([Name], [Description]) VALUES
('Customer', 'Privatkunde mit Zugriff auf eigene Konten, Transaktionen und Auszge.'),
('PremiumCustomer', 'Privatkunde mit erweiterten Limits, zustzlichen Services und Prioritts-Support.'),
('BusinessCustomer', 'Geschftskunde mit Firmenkonten, mehreren Nutzern und Zahlungsfreigaben.'),
('Advisor', 'Kundenberater mit Zugriff auf zugewiesene Kundenprofile und Beratungsflle.'),
('BranchManager', 'Filialleitung mit Einsicht in Filialkennzahlen und Berechtigungen fr Mitarbeitende.'),
('SupportAgent', 'Support-Mitarbeiter fr Ticketbearbeitung, Kontosperrungen und Identittsprfungen.'),
('ComplianceOfficer', 'Compliance/Risk: berwacht Aufflligkeiten, fhrt Prfungen und Freigaben durch.'),
('Auditor', 'Revisor mit Lesezugriff auf Protokolle, Reports und revisionsrelevante Daten.'),
('FraudAnalyst', 'Betrugsanalyse: Prft Alarme, setzt Sperren und erstellt Ermittlungsnotizen.'),
('Admin', 'Systemadministrator mit Vollzugriff auf Konfiguration, Benutzer und Rollen.');


INSERT INTO Customer
(FirstName, LastName, BirthDate, Phone, Street, Postal, City, [Status], fk_RoleID, fk_UserAccountID)
VALUES
('Anna','Mueller','2001-07-12','+41791234567','Bahnhofstrasse 12','8001','Zuerich','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='anna.mueller@gmail.com')),

('Luca','Rossi','1998-11-03','+41792345678','Seestrasse 45','8002','Zuerich','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='PremiumCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='luca.rossi@hotmail.com')),

('Sara','Meier','2003-02-25','+41793456789','Pilatusstrasse 8','6003','Luzern','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='sara.meier@outlook.com')),

('Noah','Keller','1997-05-19','+41794567890','Bundesgasse 7','3003','Bern','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='BusinessCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='noah.keller@gmail.com')),

('Mia','Schmid','2002-09-01','+41795678901','Rue du Rhone 18','1204','Geneve','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='PremiumCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='mia.schmid@yahoo.com')),

('Tim','Weber','1995-12-14','+41796789012','Freiestrasse 22','8032','Zuerich','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='tim.weber@gmail.com')),

('Laura','Fischer','2004-03-30','+41797890123','Bahnhofplatz 5','9000','St.Gallen','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='laura.fischer@bluewin.ch')),

('Jonas','Wild','1996-10-10','+41790123456','Industriestrasse 9','6300','Zug','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='BusinessCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='jonas.wild@icloud.com')),

('Nina','Brunner','2000-01-21','+41799012345','Aeschenplatz 3','4052','Basel','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='PremiumCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='nina.brunner@gmail.com')),

('Jan','Huber','1999-06-08','+41798901234','Hauptstrasse 31','4051','Basel','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='jan.huber@icloud.com')),

('Leo','Baumann','1994-04-02','+41790345678','Marktgasse 12','3011','Bern','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='PremiumCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='leo.baumann@outlook.com')),

('Emilia','Stein','2001-11-26','+41790456789','Rue de Bourg 15','1003','Lausanne','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='emilia.stein@gmail.com')),

('Paul','Graf','1998-02-09','+41790567890','Via Nassa 11','6900','Lugano','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='BusinessCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='paul.graf@proton.me')),

('Lena','Vogel','2002-06-27','+41790678901','Rorschacher Strasse 120','9000','St.Gallen','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='PremiumCustomer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='lena.vogel@gmail.com')),

('Zoe','Peter','2003-08-17','+41790234567','Rue de Lausanne 40','1003','Lausanne','active',
 (SELECT RoleID FROM [Role] WHERE [Name]='Customer'),
 (SELECT UserAccountID FROM UserAccount WHERE Email='zoe.peter@gmail.com'));



INSERT INTO Employee
(FirstName, LastName, Email, JobTitle, HireDate, IsActive, fk_RoleID)
VALUES
('David','Hartmann','david.hartmann@bank.ch',
 'Customer Advisor','2019-04-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Advisor')),

('Sabrina','Kunz','sabrina.kunz@bank.ch',
 'Branch Manager','2016-09-15',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='BranchManager')),

('Marco','Gisler','marco.gisler@bank.ch',
 'Support Agent','2020-02-10',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='SupportAgent')),

('Nadine','Hofmann','nadine.hofmann@bank.ch',
 'Compliance Officer','2018-06-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='ComplianceOfficer')),

('Patrick','Loosli','patrick.loosli@bank.ch',
 'Auditor','2017-01-09',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Auditor')),

('Alina','Bachmann','alina.bachmann@bank.ch',
 'Fraud Analyst','2021-03-15',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='FraudAnalyst')),

('Jan','Widmer','jan.widmer@bank.ch',
 'System Administrator','2015-11-02',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Admin')),

('Selina','Koch','selina.koch@bank.ch',
 'Customer Advisor','2022-05-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Advisor')),

('Fabian','Brunner','fabian.brunner@bank.ch',
 'Support Agent','2019-08-12',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='SupportAgent')),

('Melanie','Keller','melanie.keller@bank.ch',
 'Compliance Officer','2020-10-05',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='ComplianceOfficer')),

('Simon','Imhof','simon.imhof@bank.ch',
 'Branch Manager','2014-03-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='BranchManager')),

('Chiara','Frei','chiara.frei@bank.ch',
 'Auditor','2022-01-10',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Auditor')),

('Thomas','Ruckstuhl','thomas.ruckstuhl@bank.ch',
 'Fraud Analyst','2019-12-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='FraudAnalyst')),

('Laura','Scherrer','laura.scherrer@bank.ch',
 'System Administrator','2023-02-01',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Admin')),

('Yannick','Studer','yannick.studer@bank.ch',
 'Customer Advisor','2021-09-20',1,
 (SELECT RoleID FROM [Role] WHERE [Name]='Advisor'));


INSERT INTO AccountType ([Name], Currency, MonthlyFee) VALUES
('Private',  'CHF', 0),
('Savings',  'CHF', 0),
('Student',  'CHF', 0),
('Premium',  'CHF', 12),
('Business', 'CHF', 25),
('EUR',      'EUR', 5),
('USD',      'USD', 5);

INSERT INTO Account (IBAN, Balance, [Status], OpenedAt, ClosedAt, fk_AccountType)
VALUES
('CH9300762011623852957',  12500, 'active',   '2022-03-20', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private')),

('CH5604835012345678009',   3200, 'active',   '2022-05-10', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Savings')),

('CH1200201200012345678',  54000, 'active',   '2022-06-25', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Premium')),

('CH4403199123456789012',    800, 'active',   '2022-08-05', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Student')),

('CH6509000000123456789',      0, 'frozen',   '2022-09-18', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private')),

('CH1800239000012345670',  15750, 'active',   '2022-10-30', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private')),

('CH7800212012345678901',   9800, 'active',   '2023-01-12', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Savings')),

('CH2108307000012345672',  22000, 'active',   '2023-02-25', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Business')),

('CH3408702000012345673',    250, 'active',   '2023-03-15', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Student')),

('CH9907612012345678904',  41000, 'active',   '2023-04-29', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Premium')),

('CH1709000000012345675',   6000, 'active',   '2023-06-10', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='EUR')),

('CH8609000000012345676',   7400, 'active',   '2023-07-22', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='USD')),

('CH2500201200098765432',  16000, 'active',   '2023-08-28', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private')),

('CH4104835010098765431',   1300, 'inactive', '2023-09-30', '2025-04-01',
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Savings')),

('CH7403199000098765430',   5000, 'active',   '2023-11-12', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Savings')),

('CH9200762010098765429', 120000, 'active',   '2024-01-20', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Business')),

('CH0608702000098765428',   2200, 'active',   '2024-02-29', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private')),

('CH3508307000098765427',    900, 'active',   '2024-04-05', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Student')),

('CH2700239000098765426',  18500, 'active',   '2024-06-18', NULL,
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Premium')),

('CH5800212000098765425',      0, 'Inactive', '2024-09-02', '2025-12-15',
 (SELECT AccountTypeID FROM AccountType WHERE [Name]='Private'));


INSERT INTO [Card] (CardType, ExpiryDate, [Status], DailyLimit, fk_AccountID)
VALUES
('Debit',  '2028-03-31', 'active',   2000, (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957')),
('Debit',  '2027-05-31', 'active',   1500, (SELECT AccountID FROM Account WHERE IBAN='CH5604835012345678009')),
('Credit', '2029-06-30', 'active',   8000, (SELECT AccountID FROM Account WHERE IBAN='CH1200201200012345678')),
('Debit',  '2027-08-31', 'active',   1000, (SELECT AccountID FROM Account WHERE IBAN='CH4403199123456789012')),
('Debit',  '2026-09-30', 'frozen',    500, (SELECT AccountID FROM Account WHERE IBAN='CH6509000000123456789')),
('Debit',  '2028-10-31', 'active',   2500, (SELECT AccountID FROM Account WHERE IBAN='CH1800239000012345670')),
('Debit',  '2029-01-31', 'active',   2000, (SELECT AccountID FROM Account WHERE IBAN='CH7800212012345678901')),
('Credit', '2027-02-28', 'active',   5000, (SELECT AccountID FROM Account WHERE IBAN='CH2108307000012345672')),
('Debit',  '2026-03-31', 'expired',  1000, (SELECT AccountID FROM Account WHERE IBAN='CH3408702000012345673')),
('Credit', '2029-04-30', 'active',  10000, (SELECT AccountID FROM Account WHERE IBAN='CH9907612012345678904')),
('Credit', '2027-12-31', 'active',   4000, (SELECT AccountID FROM Account WHERE IBAN='CH1709000000012345675')),
('Credit', '2028-12-31', 'active',   4000, (SELECT AccountID FROM Account WHERE IBAN='CH8609000000012345676')),
('Debit',  '2028-08-31', 'active',   2000, (SELECT AccountID FROM Account WHERE IBAN='CH2500201200098765432')),
('Debit',  '2025-09-30', 'cancelled',1000, (SELECT AccountID FROM Account WHERE IBAN='CH4104835010098765431')),
('Debit',  '2028-11-30', 'active',   1500, (SELECT AccountID FROM Account WHERE IBAN='CH7403199000098765430')),
('Credit', '2030-01-31', 'active',  12000, (SELECT AccountID FROM Account WHERE IBAN='CH9200762010098765429')),
('Debit',  '2027-04-30', 'active',   2000, (SELECT AccountID FROM Account WHERE IBAN='CH0608702000098765428')),
('Debit',  '2027-06-30', 'active',   1500, (SELECT AccountID FROM Account WHERE IBAN='CH3508307000098765427')),
('Credit', '2029-07-31', 'frozen',   3000, (SELECT AccountID FROM Account WHERE IBAN='CH2700239000098765426')),
('Debit',  '2026-12-31', 'cancelled',1000, (SELECT AccountID FROM Account WHERE IBAN='CH5800212000098765425'));


INSERT INTO TransactionType ([Name], Direction, [Description]) VALUES
('CardPayment',   'DB', 'Kartenzahlung im Handel oder online'),
('CashWithdraw','DB', 'Bargeldbezug am Bancomat'),
('TransferOut',   'DB', 'berweisung/Payment an ein anderes Konto'),
('TransferIn',    'CR', 'Eingehende berweisung von einem anderen Konto'),
('Salary',        'CR', 'Lohn-/Gehaltseingang'),
('Interest',      'CR', 'Zinsgutschrift auf dem Konto'),
('Fee',           'DB', 'Bankgebhr'),
('Refund',        'CR', 'Rckerstattung/Storno einer Belastung'),
('StandingOrder', 'DB', 'Dauerauftrag'),
('DirectDebit',   'DB', 'Lastschrift/Einzugsermchtigung'),
('FXExchange',    'DB', 'Devisen-/Wechselkursbelastung');

INSERT INTO [Transaction] (BookingDate, [Description], fk_AccountID, fk_TransactionType)
VALUES
('2025-12-28','Lohnzahlung December 2025',
 (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='Salary')),

('2025-12-29','Kartenzahlung COOP Luzern',
 (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CardPayment')),

('2025-12-30','Bargeldbezug Bancomat SBB Zuerich',
 (SELECT AccountID FROM Account WHERE IBAN='CH5604835012345678009'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CashWithdraw')),

('2025-12-30','Ueberweisung an Miete: ImmoVerwaltung AG',
 (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='TransferOut')),

('2025-12-31','Eingang Ueberweisung von Luca Rossi',
 (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='TransferIn')),

('2025-12-31','Kontofuehrungsgebuehr Dezember',
 (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='Fee')),

('2026-01-02','Kartenzahlung Digitec Galaxus',
 (SELECT AccountID FROM Account WHERE IBAN='CH1200201200012345678'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CardPayment')),

('2026-01-02','Rueckerstattung Kartenzahlung (Storno) Digitec Galaxus',
 (SELECT AccountID FROM Account WHERE IBAN='CH1200201200012345678'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='Refund')),

('2026-01-03','Dauerauftrag: Krankenkasse CSS',
 (SELECT AccountID FROM Account WHERE IBAN='CH1800239000012345670'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='StandingOrder')),

('2026-01-03','Lastschrift: Swisscom Mobile Abo',
 (SELECT AccountID FROM Account WHERE IBAN='CH1800239000012345670'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='DirectDebit')),

('2026-01-04','Zinsgutschrift Sparkonto Q4/2025',
 (SELECT AccountID FROM Account WHERE IBAN='CH7800212012345678901'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='Interest')),

('2026-01-04','Kartenzahlung SBB Mobile Ticket',
 (SELECT AccountID FROM Account WHERE IBAN='CH4403199123456789012'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CardPayment')),

('2026-01-05','Ueberweisung an Kreditkarte (Ausgleich)',
 (SELECT AccountID FROM Account WHERE IBAN='CH9907612012345678904'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='TransferOut')),

('2026-01-05','Eingang Ueberweisung: Rueckerstattung Steueramt',
 (SELECT AccountID FROM Account WHERE IBAN='CH2500201200098765432'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='TransferIn')),

('2026-01-06','Devisenwechsel: EUR Kauf (Reise)',
 (SELECT AccountID FROM Account WHERE IBAN='CH1709000000012345675'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='FXExchange')),

('2026-01-06','Kartenzahlung Amazon Marketplace',
 (SELECT AccountID FROM Account WHERE IBAN='CH1709000000012345675'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CardPayment')),

('2026-01-08','Kartenzahlung Migros Zuerich Limmatplatz',
 (SELECT AccountID FROM Account WHERE IBAN='CH7403199000098765430'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CardPayment')),

('2026-01-09','Bargeldbezug Bancomat Bahnhof Bern',
 (SELECT AccountID FROM Account WHERE IBAN='CH7403199000098765430'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='CashWithdraw')),

('2026-01-11','Kontofuehrungsgebuehr Januar',
 (SELECT AccountID FROM Account WHERE IBAN='CH2108307000012345672'),
 (SELECT TransactionTypeID FROM TransactionType WHERE [Name]='Fee'));


INSERT INTO CustomerAccount (fk_CustomerID, fk_AccountID)
VALUES
((SELECT CustomerID FROM Customer WHERE Phone='+41791234567'), (SELECT AccountID FROM Account WHERE IBAN='CH9300762011623852957')),
((SELECT CustomerID FROM Customer WHERE Phone='+41791234567'), (SELECT AccountID FROM Account WHERE IBAN='CH7800212012345678901')),

((SELECT CustomerID FROM Customer WHERE Phone='+41792345678'), (SELECT AccountID FROM Account WHERE IBAN='CH1200201200012345678')),
((SELECT CustomerID FROM Customer WHERE Phone='+41792345678'), (SELECT AccountID FROM Account WHERE IBAN='CH1709000000012345675')),

((SELECT CustomerID FROM Customer WHERE Phone='+41793456789'), (SELECT AccountID FROM Account WHERE IBAN='CH4403199123456789012')),

((SELECT CustomerID FROM Customer WHERE Phone='+41794567890'), (SELECT AccountID FROM Account WHERE IBAN='CH5604835012345678009')),
((SELECT CustomerID FROM Customer WHERE Phone='+41794567890'), (SELECT AccountID FROM Account WHERE IBAN='CH8609000000012345676')),

((SELECT CustomerID FROM Customer WHERE Phone='+41795678901'), (SELECT AccountID FROM Account WHERE IBAN='CH6509000000123456789')),

((SELECT CustomerID FROM Customer WHERE Phone='+41796789012'), (SELECT AccountID FROM Account WHERE IBAN='CH1800239000012345670')),

((SELECT CustomerID FROM Customer WHERE Phone='+41797890123'), (SELECT AccountID FROM Account WHERE IBAN='CH2500201200098765432')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790123456'), (SELECT AccountID FROM Account WHERE IBAN='CH2108307000012345672')),
((SELECT CustomerID FROM Customer WHERE Phone='+41790123456'), (SELECT AccountID FROM Account WHERE IBAN='CH9200762010098765429')),

((SELECT CustomerID FROM Customer WHERE Phone='+41799012345'), (SELECT AccountID FROM Account WHERE IBAN='CH3408702000012345673')),

((SELECT CustomerID FROM Customer WHERE Phone='+41798901234'), (SELECT AccountID FROM Account WHERE IBAN='CH9907612012345678904')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790345678'), (SELECT AccountID FROM Account WHERE IBAN='CH7403199000098765430')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790456789'), (SELECT AccountID FROM Account WHERE IBAN='CH0608702000098765428')),
((SELECT CustomerID FROM Customer WHERE Phone='+41790456789'), (SELECT AccountID FROM Account WHERE IBAN='CH8609000000012345676')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790567890'), (SELECT AccountID FROM Account WHERE IBAN='CH3508307000098765427')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790678901'), (SELECT AccountID FROM Account WHERE IBAN='CH5800212000098765425')),

((SELECT CustomerID FROM Customer WHERE Phone='+41790234567'), (SELECT AccountID FROM Account WHERE IBAN='CH1709000000012345675'));
