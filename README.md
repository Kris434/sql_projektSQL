# sql_projektSQL
Pliki [jezyk.txt, panstwa.txt, uzytkownicy.txt] to dane do projektu. Należy wykonać pięć zapytań do bazy danych, a następnie zapisać je jako widoki [V1, V2...].

[Arkusz](https://arkusze.pl/maturalne/informatyka-2020-czerwiec-matura-rozszerzona-2.pdf) - Link do arkusza z zadaniami

## zapytania

1. V1
```sql
SELECT jezyki.Rodzina AS Rodzina, COUNT(jezyki.Jezyk) AS Jezyk FROM jezyki GROUP BY Rodzina ORDER BY Jezyk DESC 
```

2. V2
```sql
SELECT COUNT(DISTINCT uzytkownicy.Jezyk) AS 'Liczba jezykow' FROM uzytkownicy WHERE uzytkownicy.jezyk NOT IN (SELECT uzytkownicy.Jezyk FROM uzytkownicy WHERE uzytkownicy.Urzedowy LIKE "tak") 
```
