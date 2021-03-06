SELECT      SingerNationality,
            EventCity,
            EventProvince,
            EventRegion,
            ROUND(SUM(Revenues)/SUM(NumberOfTickets), 2) AS AvgTicketRevenue,
            ROUND(SUM(Revenues)/SUM(SUM(Revenues))
                OVER (PARTITION BY SingerNationality, EventProvince) * 100
                , 2) AS PercentageOverProvince,
            ROUND(SUM(Revenues)/SUM(SUM(Revenues))
                OVER (PARTITION BY SingerNationality, EventRegion) * 100
                , 2) AS PercentageOverRegion
FROM        F_TICKETSALES TS, D_EVENTDATE ED,
            D_TOUR T, D_EVENTLOCATION EL
WHERE       TS.PurchaseDate_ID = PD.PurchaseDate_ID
AND         TS.EventDate_ID = ED.EventDate_ID
AND         TS.Tour_ID = T.Tour_ID
AND         TS.EventLocation_ID = EL.EventLocation_ID
AND         EventYear = 2017
GROUP BY    SingerNationality, EventCity, EventProvince, EventRegion
ORDER BY    SingerNationality, EventCity, EventProvince, EventRegion;
