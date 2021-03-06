# sql_projektSQL
Pliki [jezyk.txt, panstwa.txt, uzytkownicy.txt] to dane do projektu. Należy wykonać pięć zapytań do bazy danych, a następnie zapisać je jako widoki [V1, V2...].

[Arkusz](https://arkusze.pl/maturalne/informatyka-2020-czerwiec-matura-rozszerzona-2.pdf) - Link do arkusza z zadaniami

## zapytania

1. V1
```sql
SELECT jezyki.Rodzina AS Rodzina, COUNT(jezyki.Jezyk) AS Jezyk 
FROM jezyki 
GROUP BY Rodzina 
ORDER BY Jezyk DESC 
```

2. V2
```sql
SELECT COUNT(DISTINCT uzytkownicy.Jezyk) AS 'Liczba jezykow' 
FROM uzytkownicy WHERE uzytkownicy.jezyk NOT IN 
(SELECT uzytkownicy.Jezyk FROM uzytkownicy WHERE uzytkownicy.Urzedowy LIKE "tak") 
```

3. V3
```sql
SELECT jezyki.Jezyk AS Jezyk, COUNT(DISTINCT panstwa.Kontynent) AS Kontynent 
FROM jezyki JOIN uzytkownicy
ON jezyki.Jezyk = uzytkownicy.Jezyk
JOIN panstwa 
ON uzytkownicy.Panstwo = panstwa.Panstwo
GROUP BY Jezyk
HAVING Kontynent >= 4
```

4. V4
```sql
SELECT jezyki.Jezyk AS Jezyk, jezyki.Rodzina AS Rodzina, ROUND(SUM(uzytkownicy.Uzytkownicy), 1) AS Uzytkownicy
FROM jezyki JOIN uzytkownicy
ON jezyki.Jezyk = uzytkownicy.Jezyk
JOIN panstwa ON panstwa.Panstwo = uzytkownicy.Panstwo
WHERE panstwa.Kontynent LIKE "Ameryka Pol%" 
	AND jezyki.Rodzina NOT LIKE 'indoeuropejska'
GROUP BY jezyki.Jezyk  
ORDER BY `Uzytkownicy`  DESC LIMIT 6
```

5. V5
```sql
SELECT panstwa.Panstwo AS Panstwo, jezyki.Jezyk AS Jezyk, ROUND(uzytkownicy.Uzytkownicy / panstwa.Populacja * 100, 2) AS Procent
FROM panstwa JOIN uzytkownicy ON panstwa.Panstwo = uzytkownicy.Panstwo
JOIN jezyki ON uzytkownicy.Jezyk = jezyki.Jezyk
WHERE uzytkownicy.Urzedowy LIKE "nie" 
	AND ROUND(uzytkownicy.Uzytkownicy / panstwa.Populacja * 100, 2) >= 30
ORDER BY `Procent`  DESC;
```
