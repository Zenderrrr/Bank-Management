USE master;
GO

IF DB_ID('BankManagement') IS NOT NULL
BEGIN
    ALTER DATABASE BankManagement SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BankManagement;
END
GO

-- CREATE DATABASE

CREATE DATABASE BankManagement;
GO

USE BankManagement;
GO

-- CREATE TABLES

CREATE TABLE UserAccount(
UserAccountID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL,
PasswordHash VARCHAR(300) NOT NULL,
IsActive BIT DEFAULT 1 NOT NULL,
CreatedAt DATE NOT NULL,
LastLoginAt DATE NOT NULL,
);

CREATE TABLE [Role](
RoleID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Name] VARCHAR(40) NOT NULL,
[Description] VARCHAR(300) NULL
);

CREATE TABLE Customer(
CustomerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(40) NOT NULL,
BirthDate DATE NOT NULL,
Phone VARCHAR(15) UNIQUE NOT NULL,
Street VARCHAR(40) NOT NULL,
Postal VARCHAR(20) NOT NULL,
City VARCHAR(20) NOT NULL,
[Status] VARCHAR(20) NOT NULL,
fk_RoleID INT NOT NULL,
fk_UserAccountID INT NOT NULL

FOREIGN KEY(fk_RoleID) REFERENCES [Role](RoleID),
FOREIGN KEY(fk_UserAccountID) REFERENCES UserAccount(UserAccountID)
);

CREATE TABLE Employee(
EmployeeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(40) NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL,
JobTitle VARCHAR(50) NOT NULL,
HireDate DATE NOT NULL,
IsActive BIT DEFAULT 1 NOT NULL,
fk_RoleID INT NOT NULL,

FOREIGN KEY(fk_RoleID) REFERENCES [Role](RoleID)
);



CREATE TABLE AccountType(
AccountTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Name] VARCHAR(20) NOT NULL,
Currency VARCHAR(3) NOT NULL,
MonthlyFee INT NOT NULL
);

CREATE TABLE Account(
AccountID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
IBAN VARCHAR(50) UNIQUE NOT NULL,
Balance NUMERIC(10,2) NOT NULL,
[Status] VARCHAR(20)  NOT NULL,
OpenedAt DATE NOT NULL,
ClosedAt DATE NULL,
fk_AccountType INT NOT NULL,

FOREIGN KEY(fk_AccountType) REFERENCES AccountType(AccountTypeID)
);

CREATE TABLE [Card](
CardID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
CardType VARCHAR(20) NOT NULL,
ExpiryDate DATE NOT NULL,
[Status] VARCHAR(20) NOT NULL,
DailyLimit INT NULL, 
fk_AccountID INT NOT NULL,

FOREIGN KEY(fk_AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE TransactionType(
TransactionTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Name] VARCHAR(20) NOT NULL,
Direction VARCHAR(2) NOT NULL,
[Description] VARCHAR(300) NULL
);

CREATE TABLE [Transaction](
TransactionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
BookingDate DATE NOT NULL,
[Description] VARCHAR(300) NULL,
fk_AccountID INT NOT NULL,
fk_TransactionType INT NOT NULL,

FOREIGN KEY(fk_AccountID) REFERENCES Account(AccountID),
FOREIGN KEY(fk_TransactionType) REFERENCES TransactionType(TransactionTypeID)
);

CREATE TABLE CustomerAccount(
CustomerAccountID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
fk_CustomerID INT NOT NULL,
fk_AccountID INT NOT NULL,

FOREIGN KEY(fk_CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY(fk_AccountID) REFERENCES Account(AccountID)
);

-- CREATE FUNCTIONS AND STORED PROCEDURE

GO
DROP PROCEDURE IF EXISTS CreateAccount
GO
CREATE PROCEDURE CreateAccount
	@CustomerID INT,
	@StartBalance NUMERIC(10,2),
	@IBAN VARCHAR(50),
	@AccountTypeID INT
AS
BEGIN
	IF NOT EXISTS(
		SELECT 1 FROM Customer
		WHERE Customer.CustomerID = @CustomerID
	)
	BEGIN 
		RAISERROR('Kunde existiert nicht!', 16, 1);
		RETURN;
	END

	IF NOT EXISTS(
		SELECT 1 FROM Customer
		WHERE Customer.CustomerID = @CustomerID AND LOWER(Customer.[Status]) = 'active'
	)
	BEGIN
		RAISERROR('Kunde ist nicht aktiviert', 16, 1);
		RETURN;
	END

	INSERT INTO Account (IBAN, Balance, [Status], OpenedAt, fk_AccountType)
	VALUES (@IBAN, 0, 'active', GETDATE(), @AccountTypeID)

	DECLARE @NewAccountID INT = SCOPE_IDENTITY();

	INSERT INTO CustomerAccount (fk_CustomerID, fk_AccountID)
	VALUES (@CustomerID, @NewAccountID)

	IF (@StartBalance < 0)
	BEGIN
		RAISERROR('StartBalance darf nicht unter 0 sein.', 16, 1);
		RETURN;
	END;

	UPDATE Account SET Balance = @StartBalance
	WHERE Account.AccountID = @NewAccountID

	RETURN @@ROWCOUNT;
END;	
GO


CREATE FUNCTION dbo.CanWithDraw
(
    @AccountID INT,
    @Amount NUMERIC(10,2)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
    DECLARE @Balance INT;
    DECLARE @DailyLimit INT;

    -- Validate input parameters
    IF @AccountID IS NULL OR @Amount IS NULL OR @Amount <= 0
        RETURN 0;

    -- Check whether the account exists
    IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountID = @AccountID)
        RETURN 0;

    -- Get current account balance
    SELECT @Balance = Balance
    FROM Account
    WHERE AccountID = @AccountID;

    -- Check whether sufficient balance is available
    IF @Balance < @Amount
        RETURN 0;

    -- Get daily limit of the active card (if available)
    SELECT TOP 1 @DailyLimit = DailyLimit
    FROM [Card]
    WHERE fk_AccountID = @AccountID
      AND [Status] = 'Active';

    -- Check daily limit
    IF @DailyLimit IS NOT NULL AND @Amount > @DailyLimit
        RETURN 0;

    -- All checks passed -> withdrawal allowed
    SET @Result = 1;
    RETURN @Result;
END;
GO

CREATE PROCEDURE dbo.TransferMoney
(
    @FromAccountID INT,  -- Source account
    @ToAccountID   INT,  -- Target account
    @Amount        NUMERIC(10,2)   -- Transfer amount
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input parameters
	IF @FromAccountID IS NULL
	BEGIN
		RAISERROR('Parameter @FromAccountID ist null', 16, 1);
        RETURN;
	END;

	IF @ToAccountID IS NULL
	BEGIN
		RAISERROR('Parameter @ToAccountID ist null', 16, 1);
        RETURN;
	END;

	IF @Amount IS NULL
	BEGIN
		RAISERROR('Parameter @Amount ist null', 16, 1);
        RETURN;
	END;

	IF @Amount <= 0
	BEGIN
		RAISERROR('Der Amount hat einen Wert von unter 0', 16, 1);
        RETURN;
	END;

    -- Check whether the source account exists
    IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountID = @FromAccountID)
    BEGIN
        RAISERROR('Quellkonto existiert nicht.', 16, 1);
        RETURN;
    END;

    -- Check whether the target account exists
    IF NOT EXISTS (SELECT 1 FROM Account WHERE AccountID = @ToAccountID)
    BEGIN
        RAISERROR('Zielkonto existiert nicht.', 16, 1);
        RETURN;
    END;

    -- Check whether the amount can be withdrawn from the source account
    IF dbo.CanWithDraw(@FromAccountID, @Amount) = 0
    BEGIN
        RAISERROR('Abheben nicht mglich! (ungengend viel Geld oder Tageslimit berstiegen).', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Deduct amount from the source account
        UPDATE Account
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        -- Credit amount to the target account
        UPDATE Account
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        -- Transaction entry for the source account (debit)
        INSERT INTO [Transaction] (BookingDate, [Description], fk_AccountID, fk_TransactionType)
        VALUES (GETDATE(), 'bertrag auf anderes Konto', @FromAccountID, 3); -- TransferOut

        -- Transaction entry for the target account (credit)
        INSERT INTO [Transaction] (BookingDate, [Description], fk_AccountID, fk_TransactionType)
        VALUES (GETDATE(), 'bertrag von einem anderen Konto', @ToAccountID, 4); -- TransferIn

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- On error: rollback transaction and raise error message
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
