
/* Test CreateAccount - Funktionierender Fall
	Die Stored Function fgt dem existierendem Customer einen persnlichem Account hinzu, welcher dann ber die Zwischentabelle CustomerAccount verbunden ist.
	Dafr braucht man mehrere Startparameter, welche benutzt werden mssen, wie die CustomerID ber welche gefiltert wird. Dann das Startkapital, das direkt der Account nicht bei 0 starten muss.
	Die IBAN, welche UNIQUE sein muss. Dann ist noch der Account zu einem bestimmten Typ zugeordnet, welcher auch angegeben werden muss ber den FK.

	Am Anfang werden die parameter gescheckt, ob sie nicht NULL sind. Wenn schon dann kommt eine Fehlermeldung.
	Danach wird der Insert im Account gemacht und der Primary Key wird gespeichert, danach wird dieser Verwendet um die Zwischentabelle zu erweitern fr die Verbindung der beiden Tabellen.

	Am Schluss wird noch der Anfang Balance gesetzt.
*/

-- Parameter werden deklariert 
DECLARE @CustomerID INT =
(
	-- Existierender Account wird fr den Test verwendet (erstes Element)
    SELECT TOP 1 CustomerID
    FROM Customer
    WHERE LOWER([Status]) = 'active'
    ORDER BY CustomerID
);

DECLARE @AccountTypeID INT =
(
	-- Existierender Type wird fr den Test verwendet (erstes Element)
    SELECT TOP 1 AccountTypeID
    FROM AccountType
    ORDER BY AccountTypeID
);

-- Beispiel ID wird generiert 
DECLARE @IBAN VARCHAR(50) = CONCAT('CH', RIGHT('00000000000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)), 20));
-- gltige Start Balance
DECLARE @StartBalance DECIMAL(6,2) = 250.00;

-- CreateAccount wird ausgefhrt
EXEC CreateAccount
    @CustomerID = @CustomerID,
    @StartBalance = @StartBalance,
    @IBAN = @IBAN,
    @AccountTypeID = @AccountTypeID;

-- Kontrolle: Account + Zuordnung + Balance
-- wird nach generiertem IBAN gefiltert
-- schecken ob der Account erstellt wurde
SELECT TOP 1 a.*
FROM Account a
WHERE a.IBAN = @IBAN;

-- schecken ob der Account verbunden ist mit dem Customer
SELECT TOP 1 cai.*
FROM CustomerAccount cai
LEFT JOIN Account a ON a.AccountID = cai.fk_AccountID
WHERE a.IBAN = @IBAN;

--------------------------------------------------------------

/* Test CreateAccount bei Fehlerfall: Kunde existiert nicht */

DECLARE @FailCustomerID INT = 999999; -- ungltige ID setzen, um Fehlermeldung zu erhalten

-- AccountType wird das erste Element der Tabelle benutzt
DECLARE @FailAccountTypeID INT =
(
    SELECT TOP 1 AccountTypeID
    FROM AccountType
    ORDER BY AccountTypeID
);

-- Beispiel IBAN setzen
DECLARE @FailIBAN VARCHAR(50) = CONCAT('CH', RIGHT('00000000000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)), 20));

-- gltige Start Balance
DECLARE @FailStartBalance DECIMAL(6,2) = 100.00;

-- ausfhren der Stored Function
EXEC CreateAccount
    @CustomerID = @FailCustomerID,
    @StartBalance = @FailStartBalance,
    @IBAN = @FailIBAN,
    @AccountTypeID = @FailAccountTypeID;

--------------------------------------------------------------

/* Test CanWithDraw - Funktionierender Fall: Auszahlung erlaubt */

DECLARE @AccountID INT =
(
    SELECT TOP 1 AccountID
    FROM Account
    WHERE Balance >= 200
    ORDER BY AccountID
);

-- Falls es ein DailyLimit gibt, nimm einen Betrag <= Limit
DECLARE @DailyLimit INT =
(
    SELECT TOP 1 DailyLimit
    FROM [Card]
    WHERE fk_AccountID = @AccountID AND [Status] = 'Active'
    ORDER BY CardID
);

DECLARE @Amount INT = CASE WHEN @DailyLimit IS NULL THEN 100 ELSE IIF(@DailyLimit >= 100, 100, @DailyLimit) END;

SELECT dbo.CanWithDraw(@AccountID, @Amount) AS CanWithDrawResult;
SELECT AccountID, Balance FROM Account WHERE AccountID = @AccountID;
SELECT TOP 1 * FROM [Card] WHERE fk_AccountID = @AccountID AND [Status] = 'Active';

--------------------------------------------------------------

/* Test CanWithDraw - Ungltig 4 Tests: ungltige Parameter */

SELECT dbo.CanWithDraw(NULL, 100) AS NullAccount;
SELECT dbo.CanWithDraw(1, NULL)   AS NullAmount;
SELECT dbo.CanWithDraw(1, 0)      AS ZeroAmount;
SELECT dbo.CanWithDraw(1, -10)    AS NegativeAmount;

--------------------------------------------------------------

/* Test TransferMoney - Normalfall: gltiger Transfer */

DECLARE @FromAccountID INT =
(
    SELECT TOP 1 AccountID
    FROM Account
    WHERE Balance >= 200
    ORDER BY AccountID
);

DECLARE @ToAccountID INT =
(
    SELECT TOP 1 AccountID
    FROM Account
    WHERE AccountID != @FromAccountID
    ORDER BY AccountID
);

DECLARE @AmountTransfer INT = 50;

-- Vorher
SELECT AccountID, Balance
FROM Account
WHERE AccountID = @FromAccountID OR AccountID = @ToAccountID

EXEC dbo.TransferMoney
    @FromAccountID = @FromAccountID,
    @ToAccountID = @ToAccountID,
    @Amount = @AmountTransfer;

-- Nachher
SELECT AccountID, Balance
FROM Account
WHERE AccountID = @FromAccountID OR AccountID = @ToAccountID

--------------------------------------------------------------

/* Test TransferMoney Ungltiger Amount: ungltiger Betrag */

DECLARE @FailFromAccountID INT =
(
    SELECT TOP 1 AccountID
    FROM Account
    ORDER BY AccountID
);

DECLARE @FailToAccountID INT =
(
    SELECT TOP 1 AccountID
    FROM Account
    WHERE AccountID != @FailFromAccountID
    ORDER BY AccountID
);

EXEC dbo.TransferMoney
    @FromAccountID = @FailFromAccountID,
    @ToAccountID = @FailToAccountID,
    @Amount = 0; -- sollte eine Fehlermedlung ausgeben
