CREATE TABLE Customer (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Gender VARCHAR(10),
    SeniorCitizen BIGINT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10)
);

INSERT INTO Customer (CustomerID, Gender, SeniorCitizen, Partner, Dependents)
SELECT customerID, Gender, SeniorCitizen, Partner, Dependents
FROM Telco_cc;

CREATE TABLE Service (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    PhoneService VARCHAR(3),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20)
);

INSERT INTO Service (PhoneService, 
					MultipleLines, 
					InternetService, 
					OnlineSecurity, 
					OnlineBackup, 
					DeviceProtection, 
					TechSupport, 
					StreamingTV, 
					StreamingMovies)
SELECT PhoneService, 
	MultipleLines, 
	InternetService, 
	OnlineSecurity, 
	OnlineBackup, 
	DeviceProtection, 
	TechSupport, 
	StreamingTV, 
	StreamingMovies
FROM Telco_cc;

CREATE TABLE Contract (
    ContractID INT PRIMARY KEY IDENTITY(1,1),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(3),
    PaymentMethod VARCHAR(50)
);

INSERT INTO Contract (Contract, PaperlessBilling, PaymentMethod)
SELECT Contract, PaperlessBilling, PaymentMethod
FROM Telco_cc;

CREATE TABLE FactChurn (
    ChurnID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID VARCHAR(50),
    ServiceID INT,
    ContractID INT,
    Tenure INT,
    MonthlyCharges FLOAT,
    TotalCharges FLOAT,
    Churn VARCHAR(3),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    FOREIGN KEY (ContractID) REFERENCES Contract(ContractID)
);

INSERT INTO FactChurn (CustomerID, ServiceID, ContractID, Tenure, MonthlyCharges, TotalCharges, Churn)
SELECT 
    c.CustomerID,
    s.ServiceID,
    ct.ContractID,
    tc.Tenure,
    tc.MonthlyCharges,
    tc.TotalCharges,
    tc.Churn
FROM Telco_cc AS tc
JOIN Customer AS c ON tc.customerID = c.CustomerID
JOIN Service AS s ON s.PhoneService = tc.PhoneService AND s.MultipleLines = tc.MultipleLines 
    -- Add all other conditions based on service match
JOIN Contract AS ct ON ct.Contract = tc.Contract AND ct.PaymentMethod = tc.PaymentMethod;