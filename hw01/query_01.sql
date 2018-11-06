SELECT      TO_CHAR(PurchaseYear, 'YYYY') AS PurchaseYear,
            TO_CHAR(PurchaseMonth, 'MM-YYYY') AS PurchaseMonth,
            PurchaseMode,
            ROUND(SUM(Revenues)/EXTRACT(DAY FROM LAST_DAY(PurchaseMonth))
                , 2) AS AvgDailyRevenue,
            SUM(SUM(Revenues)) OVER (
                PARTITION BY PurchaseYear
                ORDER BY PurchaseMonth, PurchaseMode
                ROWS UNBOUNDED PRECEDING
                ) AS RevenueFromBeginningOfYear,
            ROUND(SUM(NumberOfTickets)/SUM(SUM(NumberOfTickets))
                OVER (PARTITION BY PurchaseMonth) * 100
                , 2) AS PercentageOverMonth
FROM        F_TICKETSALES TS, D_PURCHASEDATE PD
WHERE       TS.PurchaseDate_ID = PD.PurchaseDate_ID
GROUP BY    PurchaseMode, PurchaseMonth, PurchaseYear
ORDER BY    PurchaseYear, PurchaseMonth, PurchaseMode;