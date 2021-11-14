/* Polecenie tworzące bazę danych o nazwie 'projekt_Bicz' */
CREATE DATABASE projekt_Bicz;  

/* Polecenie USE powoduje zmianę bazy danych na której pracujemy */
USE projekt_Bicz;


/* 
    Utworzenie tabeli jezyki, zawierającej dwie kolumny. Użyty typ danych umożliwia wprowadzenie dowolnego ciągu znaków o maksymalnej długości 100 znaków.
    Kolumna Jezyk zostaje kluczem głównym
 */
CREATE TABLE jezyki (
    Jezyk VARCHAR(100) PRIMARY KEY,
    Rodzina VARCHAR(100)
);

/*
    Utworzenie tabeli panstwa, zawierającej trzy kolumny. Poza VARCHAR, użyty zostaje tutaj również FLOAT, pozwalający na wprowadzenie liczb zmiennoprzecinkowych.
    Kolumna Panstwo zostaje kluczem głównym
*/
CREATE TABLE panstwa (
    Panstwo VARCHAR(100) PRIMARY KEY,
    Kontynent VARCHAR(100),
    Populacja FLOAT
);

/*
    Utworzenie tabeli uzytkownicy, zawierającej cztery kolumny. Użyte typy danych to VARCHAR oraz FLOAT.
    Kolumny Panstwo oraz Jezyk zostaną kluczami obcymi, dlatego muszą mieć taki sam typ danych, jak ich odpowiedniki w innych tabelach 
*/
CREATE TABLE uzytkownicy (
    Panstwo VARCHAR(100),
    Jezyk VARCHAR(100),
    Uzytkownicy FLOAT,
    Urzedowy VARCHAR(3)
);

/* Utworzenie relacji pomiędzy tabelami panstwa oraz uzytkownicy */
ALTER TABLE uzytkownicy
ADD FOREIGN KEY (Panstwo) REFERENCES panstwa (Panstwo);

/* Utowrzenie relacji pomiędzy tabelami jezyki oraz uzytkownicy */
ALTER TABLE uzytkownicy
ADD FOREIGN KEY (Jezyk) REFERENCES jezyki (Jezyk);


/* Załadowanie danych z pliku o rozszerzeniu '.txt' do tabeli jezyki */
LOAD DATA INFILE 'G://Dane/jezyki.txt' INTO TABLE jezyki IGNORE 1 LINES;

/* Załadowanie danych z pliku o rozszerzeniu '.txt' do tabeli panstwa */
LOAD DATA INFILE 'G://Dane/panstwa.txt' INTO TABLE panstwa IGNORE 1 LINES;

/* Załadowanie danych z pliku o rozszerzeniu '.txt' do tabeli uzytkownicy. Dane do tej tabeli muszą zostać załadowane jako ostatnie, ponieważ znajdują się tutaj klucze obce */
LOAD DATA INFILE 'G://Dane/uzytkownicy.txt' INTO TABLE uzytkownicy IGNORE 1 LINES;


/* 
    Utworzenie widoku o nazwie V1. 
    Zestawienie podaje liczbę języków należących do danej rodziny języków, oraz sortuje je malejąco wg liczby języków
*/
CREATE VIEW V1 AS
    SELECT jezyki.Rodzina AS Rodzina, COUNT(jezyki.Jezyk) AS Jezyk 
    FROM jezyki 
    GROUP BY Rodzina 
    ORDER BY Jezyk DESC;

/*
    Utworzenie widoku o nazwie V2
    Zestawienie podaje liczbę języków, które nie są językami urzędowymi w żadnym państwie
*/
CREATE VIEW V2 AS
    SELECT COUNT(DISTINCT uzytkownicy.Jezyk) AS 'Liczba jezykow' 
    FROM uzytkownicy 
    WHERE uzytkownicy.jezyk NOT IN 
        (SELECT uzytkownicy.Jezyk FROM uzytkownicy WHERE uzytkownicy.Urzedowy LIKE "tak");


/*
    Utworzenie widoku o nazwie V3
    Zestawienie pokazuje języki, którymi posługują się ludzie na conajmniej czterech kontynentach
*/
CREATE VIEW V3 AS
    SELECT jezyki.Jezyk AS Jezyk, COUNT(DISTINCT panstwa.Kontynent) AS Kontynent 
    FROM jezyki JOIN uzytkownicy ON jezyki.Jezyk = uzytkownicy.Jezyk
    JOIN panstwa ON uzytkownicy.Panstwo = panstwa.Panstwo
    GROUP BY Jezyk
    HAVING Kontynent >= 4;


/*
    Utworzenie widoku o nazwie V4
    Zestawienie pokazuje 6 języków, którymi posługuje się łącznie najwięcej mieszkańców obu Ameryk
*/
CREATE VIEW V4 AS
    SELECT jezyki.Jezyk AS Jezyk, jezyki.Rodzina AS Rodzina, ROUND(SUM(uzytkownicy.Uzytkownicy), 1) AS Uzytkownicy
    FROM jezyki JOIN uzytkownicy ON jezyki.Jezyk = uzytkownicy.Jezyk
    JOIN panstwa ON panstwa.Panstwo = uzytkownicy.Panstwo
    WHERE panstwa.Kontynent LIKE "Ameryka Pol%" 
        AND jezyki.Rodzina NOT LIKE 'indo%'
    GROUP BY jezyki.Jezyk  
    ORDER BY `Uzytkownicy` DESC LIMIT 6;


/* 
    Utworzenie widoku o nazwie V5
    Zestawienie pokazuje państwa, w których conajmniej 30% populacji posługuje się językiem, który nie jest urzędowy
*/
CREATE VIEW V5 AS 
    SELECT panstwa.Panstwo AS Panstwo, jezyki.Jezyk AS Jezyk, ROUND(uzytkownicy.Uzytkownicy / panstwa.Populacja * 100, 2) AS Procent
    FROM panstwa JOIN uzytkownicy ON panstwa.Panstwo = uzytkownicy.Panstwo
    JOIN jezyki ON uzytkownicy.Jezyk = jezyki.Jezyk
    WHERE uzytkownicy.Urzedowy LIKE "nie" 
        AND ROUND(uzytkownicy.Uzytkownicy / panstwa.Populacja * 100, 2) >= 30
    ORDER BY `Procent`  DESC;