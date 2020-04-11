/*Lendo a tabela sashelp.class e copida para o data myclass*/
data myclass;
	set sashelp.class;
run;

/*visualizando o data myclass no Results*/
proc print data=myclass;
run;

/*criando um data shoes na work utilizando a tabela shoes e criando um campo NetSales realizando a operação (Sales-Returns)
Não cria results apenas output data*/
data work.shoes;
	set sashelp.shoes;
	NetSales=Sales-Returns;
run;

proc print data=work.shoes;
run;

/*Criando uma visualização no Results, calculando a média e a soma da coluna NetSales (var)
agrupando por Region (class)*/
proc means data=work.shoes mean sum;
	var NetSales;
	*Coluna que será calculado a média e o total;
	class region;
	*Coluna de agrupamento;
run;

/*Descrevendo as propriedades da tabela*/
proc contents data=work.shoes;
run;

proc contents data="/folders/myfolders/EPG194/data/storm_summary.sas7bdat";
run;

/*Criando uma Library*/
libname pg1 "/folders/myfolders/EPG194/data";

/*
NOTE: Libref PG1 was successfully assigned as follows:
Engine:        V9
Physical Name: /folders/myfolders/EPG194/data
*/
libname outpath "/folders/myfolders/EPG194/output";

/*Criando uma tabela na work e na lib out*/
data class_copy1 out.class_copy2;
	set sashelp.class;
run;

/*Importando arquivo Excel*/
options validvarname=v7;
*realiza adequação do cabeçalho ao padrão SAS;
libname xlstorm xlsx "/folders/myfolders/EPG194/data/storm.xlsx";

proc contents data=xlstorm.storm_summary;
run;

libname xlstorm clear;
options validvarname=v7;
libname NP xlsx "/folders/myfolders/EPG194/data/np_info.xlsx";

proc contents data=NP.PARKS;
run;

libname NP clear;

/*Importando dados não estruturados*/
proc import datafile="/folders/myfolders/EPG194/data/class_birthdate.csv" 
		dbms=csv out=class_birthdate replace;
	*replace = se existir, substitui;
run;

proc contents data=class_birthdate;
run;

/*obs.:
XLSX engine, lê o  excel direto do local onde está armazenado, dados sempre atualizados
PROC IMPORT, faz uma cópia do arquivo excel, se houve alguma alteração a planilha precisa ser reimportada
*/
***********************************************************;
*  LESSON 2, PRACTICE 1                                   *;
*    a) Complete the PROC IMPORT step to read             *;
*       EU_SPORT_TRADE.XLSX. Create a SAS table named     *;
*       EU_SPORT_TRADE and replace the table              *;
*       if it exists.                                     *;
*    b) Modify the PROC CONTENTS code to display the      *;
*       descriptor portion of the EU_SPORT_TRADE table.   *;
*       Submit the program, and then view the output data *;
*       and the results.                                  *;
***********************************************************;
options validvarname=v7;

proc import datafile="/folders/myfolders/EPG194/data/eu_sport_trade.xlsx" 
		dbms=xlsx out=eu_sport_trade replace;
run;

proc contents data=eu_sport_trade;
run;

proc import datafile="/folders/myfolders/EPG194/data/np_traffic.csv" dbms=csv 
		out=traffic replace;
	guessingrows=max;
	*Evita que dados fiquem truncados;
run;

proc contents data=traffic;
run;

proc print data=work.traffic;
run;

/*Importando arquivo com delimitador*/
proc import datafile="/folders/myfolders/EPG194/data/np_traffic.dat" dbms=dlm 
		out=traffic2 replace;
	guessingrows=max;
	*Evita que dados fiquem truncados;
	delimiter="|";
run;

/**************************************************************
 *															  *
 *		Explorando e Validando dados						  *
 *															  *
 ***************************************************************/
*Selecionado os 10 primeiros registros da colunas especificadas no var;

proc print data=pg1.storm_summary (obs=10);
	*obs =top;
	var Season Name Basin MaxWindMPH MinPressure StartDate EndDate;
run;

*Resumo estatístico da tabela;

proc means data=pg1.storm_summary;
	var MaxWindMPH MinPressure;
run;

*Examinando os valores extremos;

proc univariate data=pg1.storm_summary;
	var MaxWindMPH MinPressure;
run;

*Lista valores unicos e frequencia;

proc freq data=pg1.storm_summary;
	tables Basin Type Season;
run;

***********************************************************;
*  LESSON 2, PRACTICE 1                                   *;
*    a) Complete the PROC PRINT statement to list the     *;
*       first 20 observations in PG1.NP_SUMMARY.          *;
*    b) Add a VAR statement to include only the following *;
*       variables: Reg, Type, ParkName, DayVisits,        *;
*       TentCampers, and RVCampers. Highlight the step    *;
*       and run the selected code.                        *;
*       Do you observe any possible inconsistencies in    *;
*       the data?                                         *;
*    c) Copy the PROC PRINT step and paste it at the end  *;
*       of the program. Change PRINT to MEANS and remove  *;
*       the OBS= data set option. Modify the VAR          *;
*       statement to calculate summary statistics for     *;
*       DayVisits, TentCampers, and RVCampers. Highlight  *;
*       the step and run the selected code.               *;
*       What is the minimum value for tent campers? Is    *;
*       that value unexpected?                            *;
*    d) Copy the PROC MEANS step and paste it at the end  *;
*       of the program. Change MEANS to UNIVARIATE.       *;
*       Highlight the step and run the selected code.     *;
*       Are there negative values for any of the columns? *;
*    e) Copy the PROC UNIVARIATE step and paste it at the *;
*       end of the program. Change UNIVARIATE to FREQ.    *;
*       Change the VAR statement to a TABLES statement to *;
*       produce frequency tables for Reg and Type.        *;
*       Highlight the step and run the selected code.     *;
*       Are there any lowercase codes? Are there any      *;
*       codes that occur only once in the table?          *;
*    f) Add comments before each step to document the     *;
*       program. Save the program as np_validate.sas in   *;
*       the output folder.                                *;
***********************************************************;

proc print data=pg1.np_summary (obs=20);
	var Reg Type ParkName DayVisits TentCampers RVCampers;
run;

proc means data=pg1.np_summary;
	var DayVisits TentCampers RVCampers;
run;

proc univariate data=pg1.np_summary;
	var DayVisits TentCampers RVCampers;
run;

proc freq data=pg1.np_summary;
	tables Reg Type;
run;

proc print data=pg1.eu_occ (obs=20);
run;

ODS TRACE ON;

proc univariate data=pg1.eu_occ;
	VAR Camp;
run;

ODS TRACE OFF;
ODS SELECT ExtremeObs;

proc univariate data=pg1.eu_occ nextrobs=10;
	VAR Camp;
run;

*Filtrando linhas com WHERE;

proc print data=pg1.storm_summary;
	where MaxWindMPH >=156;
run;

proc print data=pg1.storm_summary;
	where Basin="WP";
run;

proc print data=pg1.storm_summary;
	where Basin in ("SI" "NI");
run;

proc print data=pg1.storm_summary;
	where StartDate >="01jan2010"d;
run;

proc print data=pg1.storm_summary;
	where Type="TS" and Hem_EW="W";
run;

proc print data=pg1.storm_summary;
	where MaxWindMPH>156 and MinPressure<920;
run;

proc print data=pg1.storm_summary;
	where MaxWindMPH>156 or 0<MinPressure<920;
run;

*Neste exemplo SAS considera apenas o último where;

proc print data=pg1.storm_summary;
	where MaxWindMPH>156;
	where MinPressure>800 and MinPressure<920;
run;

*Aplicando o ALSO depois do 2 where SAS irá filtrar os dois where's;

proc print data=pg1.storm_summary;
	where MaxWindMPH>156;
	where Also MinPressure>800 and MinPressure<920;
run;

*UTILIZANDO MACRO VARIABLES;
%LET WindSpeed=156;
%let BasinCode=NA;
%let Date=01JAN2000;

proc print data=pg1.storm_summary;
	where MaxWindMPH>=&WindSpeed and Basin="&BasinCode" and StartDate>="&Date"d;
	var Basin Name StartDate EndDate MaxWindMPH;
run;

proc means data=pg1.storm_summary;
	where MaxWindMPH>=&WindSpeed and Basin="&BasinCode" and StartDate>="&Date"d;
	var MaxWindMPH MinPressure;
run;

*Level 1 Practice: Filtering Rows in a Listing Report Using Character Data;

proc print data=pg1.np_summary;
	var Type ParkName;
	where ParkName like "%Preserve%";
run;

proc print data=pg1.eu_occ;
	where Hotel is missing and ShortStay is missing and Camp is missing;
run;

proc print data=pg1.eu_occ;
	where Hotel > 40000000;
run;

*;

proc freq data=pg1.np_species;
	where Species_ID like "YOSE%" and Category eq "Mammal";
	tables Abundance Conservation_Status;
run;

%let ParkCode= YOSE;
%let SpeciesCat =Mammal;

proc print data=pg1.np_species;
	var Species_ID Category Scientific_Name Common_Names;
	where Species_ID like "&ParkCode%" and Category eq "&SpeciesCat";
run;

proc freq data=pg1.np_species;
	where Species_ID like "&ParkCode%" and Category eq "&SpeciesCat";
	tables Abundance Conservation_Status;
run;

/*
Open the pg1.np_traffic table. Notice that the case of Location values is inconsistent.


Write a PROC PRINT step that lists ParkName, Location, and Count. Print rows where Count is not equal to 0 and Location includes MAIN ENTRANCE. Submit the program. Use the log to confirm that 38 rows are listed.

Note: If you use double quotation marks in the WHERE statement, you receive a warning in the log. To eliminate the warning, use single quotation marks.


The UPCASE function can be used to eliminate case sensitivity in character WHERE expressions. Use the UPCASE function on the Location column to include any case of MAIN ENTRANCE. Submit the program and verify that 40 rows are listed.

UPCASE(column)

Note: The UPCASE function in a WHERE statement does not permanently convert the values of the column to uppercase.
*/
proc print data=pg1.np_traffic;
	var ParkName Location Count;
	where count^=0 and UPCASE(Location) like "%MAIN ENTRANCE%";
RUN;

*Formatting Data Values in Results;
*format mmddyy10. = 08/25/2005;
*format mmddyy8. = 08/25/05;
*format mmddyy6. = 082505;

proc print data=pg1.storm_damage;
	format Date mmddyy8. Cost dollar14. Deaths comma5.;
run;

***********************************************************;
*  Activity 3.06                                          *;
*    1) Highlight the PROC PRINT step and run the         *;
*       selected code. Notice how the values of Lat, Lon, *;
*       StartDate, and EndDate are displayed in the       *;
*       report.                                           *;
*    2) Change the width of the DATE format to 7 and run  *;
*       the PROC PRINT step. How does the display of      *;
*       StartDate and EndDate change?                     *;
*    3) Change the width of the DATE format to 11 and run *;
*       the PROC PRINT step. How does the display of      *;
*       StartDate and EndDate change?                     *;
*    4) Highlight the PROC FREQ step and run the selected *;
*       code. Notice that the report includes the number  *;
*       of storms for each StartDate.                     *;
*    5) Add a FORMAT statement to apply the MONNAME.      *;
*       format to StartDate and run the PROC FREQ step.   *;
*       How many rows are in the report?                  *;
***********************************************************;

proc print data=pg1.storm_summary(obs=20);
	format Lat Lon 4. StartDate EndDate date9.;
run;

*17JUL1980 	18NOV1980;

proc print data=pg1.storm_summary(obs=20);
	format Lat Lon 4. StartDate EndDate date7.;
run;

*17JUL80 	18NOV80;

proc print data=pg1.storm_summary(obs=20);
	format Lat Lon 4. StartDate EndDate date11.;
run;

*7-JUL-1980 	18-NOV-1980;

proc freq data=pg1.storm_summary order=freq;
	tables StartDate;
	format startdate nonname.;
run;

*Sorting Data / removing duplicate key

Passo1:;

proc sort data=pg1.storm_detail out=storm_clean noduprecs dupout=storm_dups;
	by _all_;
run;

*storm_clean 107821 rows
storm_dups 214 rows;
*passo2;

proc sort data=pg1.storm_detail out=min_pressure;
	where Pressure is not missing and Name is not missing;
	by descending Season Basin Name Pressure;
run;

*passo3;

proc sort data=min_pressure nodupkey;
	by descending Season Basin Name;
run;

/*Level 1 Practice: Sorting Data and Creating an Output Table

Create the np_sort table that contains data for national parks. Sort the data by regional code and decreasing numbers of daily visitors.

Reminder: If you restarted your SAS session,you must recreate the PG1 library so you can access your practice files. In SAS Studio, open and submit the libname.sas program in the EPG194 folder. In Enterprise Guide, run the Autoexec process flow.

Open p103p08.sas from the practices folder.

Modify the PROC SORT step to read pg1.np_summary and create a temporary, sorted table named np_sort.
Add a BY statement to order the data by Reg and descending DayVisits values.
Add a WHERE statement to select Type equal to NP.
Submit the program and view the output data.


How many rows are included in the np_sort table?*/
proc sort data=pg1.np_summary out=np_sort;
	by descending Reg DayVisits;
	where Type eq "NP";
run;

/*Level 2 Practice: Sorting Data to Remove Duplicate Rows

The pg1.np_largeparks table contains gross acreage for large national parks. There are duplicate rows for some locations.

Reminder: If you restarted your SAS session,you must recreate the PG1 library so you can access your practice files. In SAS Studio, open and submit the libname.sas program in the EPG194 folder. In Enterprise Guide, run the Autoexec process flow.

Open and review the pg1.np_largeparks table. Notice that there are exact duplicate rows for some parks.


Create a new program.

Write a PROC SORT step that creates two tables (park_clean and park_dups), and removes the duplicate rows.
Submit the program and view the output data.


How many rows are included in the park_dups table?*/
proc sort data=pg1.np_largeparks out=park_clean dupout=park_dups noduprecs;
	by _all_;
run;

proc sort data=pg1.eu_occ out=contrylist nodupkey;
	by Geo Country;
run;

proc sort data=pg1.eu_occ(keep=geo country) out=contrylist nodupkey;
	by Geo Country;
run;

*Lendo Sas Table e criando um subconjunto de dados;

data myclass;
	set sashelp.class;
	where Age >=15;
	*keep Name Age Height;*Retorna apenas esses campos;
	drop Sex Weight;
	*Retorna todas as colunas exceto Sex e Weight;
run;

/*In your SAS software, open a new program window and perform the following tasks:

Write a DATA step that reads the pg1.storm_summary table and creates an output table named Storm_cat5. Note: If you are using SAS Studio, try creating storm_cat5 as a permanent table in the EPG194/output folder.

Include only Category 5 storms (MaxWindMPH greater than or equal to 156) with StartDate on or after 01JAN2000.

Add a statement to include the following columns in the output data: Season, Basin, Name, Type, and MaxWindMPH.

How many Category 5 storms have there been since January 1, 2000?
*/

data Storm_cat5;
	set pg1.storm_summary;
	where MaxWindMPH >= 156 and StartDate >= "01JAN2000"d   ;
	keep Season Basin Name Type MaxWindMPH ;
run;	

***********************************************************;
*  LESSON 4, PRACTICE 1                                   *;
*    a) Open the PG1.EU_OCC table and examine the column  *;
*       names and values.                                 *;
*    b) Modify the code to create a temporary table named *;
*       EU_OCC2016 and read PG1.EU_OCC.                   *;
*    c) Complete the WHERE statement to select only the   *;
*       stays that were reported in 2016. Notice that     *;
*       YearMon is a character column and the first four  *;
*       positions represent the year.                     *;
*    d) Complete the FORMAT statement in the DATA step to *;
*       apply the COMMA17. format to the Hotel,           *;
*       ShortStay, and Camp columns.                      *;
*    e) Complete the DROP statement to exclude Geo from   *;
*       the output table.                                 *;
***********************************************************;

data eu_occ2016 ;
	set pg1.eu_occ ;
	where YearMon like "2016%" ;
	format Hotel ShortStay Camp COMMA17.;
	drop Geo;
run;

/*Create a new program.

Write a DATA step to read the pg1.np_species table and create a new table named fox.
Note: If you are using SAS Studio, try creating fox as a permanent table in the EPG194/output folder.

Include only the rows where Category is Mammal and Common_Names includes Fox in any case.

Exclude the Category, Record_Status, Occurrence, and Nativeness columns.

Submit the program.


Notice that Fox Squirrels are included in the output table. Add a condition in the WHERE statement to exclude rows that include Squirrel. Submit the program and verify the results.


Sort the fox table by Common_Names.


What is the value of Common_Names in row one?
*/

data fox;
set pg1.np_species;
where Category ='Mammal' and upcase(Common_Names) like '%FOX%' and upcase(Common_Names) not like '%SQUIRREL%';
Drop Category Record_Status Occurrence Nativeness;
run;

proc sort data=fox;
	by Common_Names;
run;	
/*
Write a new program that creates a temporary table named mammal that includes only the mammals from the pg1.np_species table. Do not include Abundance, Seasonality, or Conservation_Status in the output table.


Use PROC FREQ to determine how many mammal species there are for each unique value of Record_Status. Submit the program.


What percentage of mammal species have a Record_Status value of Approved?


Modify the program to use a macro variable in place of the value Mammal so you can analyze other values of Category. Change the macro variable value to Amphibian and run the program.


What is the overall frequency of Amphibian species and how many are approved?
*/

%let cat=Amphibian;
data mammal;
set  pg1.np_species;
Where Category ="&cat";
drop Abundance Seasonality Conservation_Status ;
run;

proc freq data=mammal;
	tables Record_Status;
run;


***********************************************************;
*  Activity 4.04                                          *;
*    1) Add an assignment statement to create StormLength *;
*       that represents the number of days between        *;
*       StartDate and EndDate.                            *;
*    2) Run the program. In 1980, how long did the storm  *;
*       named Agatha last?                                *;
***********************************************************;

data storm_length;
	set pg1.storm_summary;
	drop Hem_EW Hem_NS Lat Lon;
	StormLength= EndDate-StartDate;
run;

/*Common Numeric Functions
SUM (num1, num2, ...)
MEAN (num1, num2, ...)
MEDIAN (num1, num2, ...)
RANGE (num1, num2, ...)
MIN (num1, num2, ...)
MAX (num1, num2, ...)
N (num1, num2, ...)
NMISS (num1, num2, ...)
*/


***********************************************************;
*  Activity 4.05                                          *;
*    1) Open the PG1.STORM_RANGE table and examine the    *;
*       columns. Notice that each storm has four wind     *;
*       speed measurements.                               *;
*    2) Create a new column named WindAvg that is the     *;
*       mean of Wind1, Wind2, Wind3, and Wind4.           *;
*    3) Create a new column WindRange that is the range   *;
*       of Wind1, Wind2, Wind3, and Wind4.                *;
***********************************************************;

data storm_wingavg;
	set pg1.storm_range;
	WindAvg = MEAN (Wind1, Wind2, Wind3, Wind4);
	WindRange = RANGE (Wind1, Wind2, Wind3, Wind4);
run;

/*Common Character Functions for Creating Columns
Character Function	What it Does
UPCASE (char)
LOWCASE(char)	Changes letters in a character string to uppercase or lowercase
PROPCASE (char, <delimiters>)	Changes the first letter of each word to uppercase and other letters to lowercase
CATS (char1, char2, ...)
Concatenates character strings and removes leading and trailing blanks from each argument
SUBSTR (char, position, <length>)	Returns a substring from a character string
*/

***********************************************************;
*  Activity 4.06                                          *;
*    1) Add a WHERE statement that uses the SUBSTR        *;
*       function to include rows where the second letter  *;
*       of Basin is P (Pacific ocean storms).             *;
*    2) Run the program and view the log and data. How    *;
*       many storms were in the Pacific basin?            *;
***********************************************************;

data pacific;
	set pg1.storm_summary;
	drop Type Hem_EW Hem_NS MinPressure Lat Lon;
	where SUBSTR (Basin, 2,1)  ="P"; 
run;

/*
Date Function	What it Does
MONTH (SAS-date)	Returns a number from 1 through 12 that represents the month
YEAR (SAS-date)	Returns the four-digit year
DAY (SAS-date)	Returns a number from 1 through 31 that represents the day of the month
WEEKDAY (SAS-date)	Returns a number from 1 through 7 that represents the day of the week (Sunday=1)
QTR (SAS-date)	Returns a number from 1 through 4 that represents the quarter
These functions enable you to create SAS date values from the arguments.

Date Function	What it Does
TODAY ()	Returns the current date as a numeric SAS date value (no argument is required because the function reads the system clock)
MDY (month, day, year)	Returns a SAS date value from numeric month, day, and year values
YRDIF (startdate, enddate, 'AGE')	Calculates a precise age between two dates

*/

***********************************************************;
*  LESSON 4, PRACTICE 4                                   *;
*    a) Create a new column named SqMiles by multiplying  *;
*       Acres by .0015625.                                *;
*    b) Create a new column named Camping as the sum of   *;
*       OtherCamping, TentCampers, RVCampers, and         *;
*       BackcountryCampers.                               *;
*    c) Format SqMiles and Camping to include commas and  *;
*       zero decimal places.                              *;
*    d) Modify the KEEP statement to include the new      *;
*       columns. Run the program.                         *;
***********************************************************;

data np_summary_update;
	set pg1.np_summary;
	keep Reg ParkName DayVisits OtherLodging Acres SqMiles Camping;	
	SqMiles = Acres *.0015625;
	Camping = sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers); 
	Format SqMiles comma6. Camping comma10.;
run;

/*

Write a DATA step to create a temporary table named eu_occ_total that is based on the pg1.eu_occ table.

Create the following new columns:
Year: the four-digit year extracted from YearMon
Month: the two-digit month extracted from YearMon
ReportDate: the first day of the reporting month
Note: Use the MDY function and the new Year and Month columns
Total: the total nights spent at any establishment
Format Hotel, ShortStay, Camp, and Total with commas. Format ReportDate to display the values in the form JAN2018.
Keep Country, Hotel, ShortStay, Camp, ReportDate, and Total in the new table.
Submit the program and view the output data.
*/

data eu_occ_total;
    set pg1.eu_occ;
    Year=substr(YearMon,1,4);
    Month=substr(YearMon,6,2);
    ReportDate=MDY(Month,1,Year);
    Total=sum(Hotel,ShortStay,Camp);
    format Hotel ShortStay Camp Total comma17.
           ReportDate monyy7.;
    keep Country Hotel ShortStay Camp ReportDate Total;
run;

/*

Create a new temporary table named np_summary2 that is based on pg1.np_summary.
Use the SCAN function to create a new column named ParkType that is the last word in the ParkName column. Use a negative number for the second argument to count words from right to left in the character string.
Keep Reg, Type, ParkName, and ParkType in the output table.
Submit the program and view the output data.

*/

data np_summary2;
    set pg1.np_summary;
    ParkType=scan(parkname,-1);
    keep Reg Type ParkName ParkType;
run;

***********************************************************;
*  Activity 4.07                                          *;
*    1) Add the ELSE keyword to test conditions           *;
*       sequentially until a true condition is met.       *;
*    2) Change the final IF-THEN statement to an ELSE     *;
*       statement.                                        *;
*    3) How many storms are in PressureGroup 1?           *;
***********************************************************;

data storm_cat;
	set pg1.storm_summary;
	keep Name Basin MinPressure StartDate PressureGroup;
	*add ELSE keyword and remove final condition;
	if MinPressure=. then PressureGroup=.;
	else if MinPressure<=920 then PressureGroup=1;
	else PressureGroup=0;
run;

proc freq data=storm_cat;
	tables PressureGroup;
run;

***********************************************************;
*  Activity 4.08                                          *;
*    1) Run the program and examine the results. Why is   *;
*       Ocean truncated? What value is assigned when      *;
*       Basin='na'?                                       *;
*    2) Modify the program to add a LENGTH statement to   *;
*       declare the name, type, and length of Ocean       *;
*       before the column is created.                     *;
*    3) Add an assignment statement after the KEEP        *;
*       statement to convert Basin to uppercase. Run the  *;
*       program.                                          *;
*    4) Move the LENGTH statement to the end of the DATA  *;
*       step. Run the program. Does it matter where the   *;
*       LENGTH statement is in the DATA step?             *;
***********************************************************;
*  Syntax                                                 *;
*       LENGTH char-column $ length;                      *;
***********************************************************;

data storm_summary2;
	set pg1.storm_summary;
	*Add a LENGTH statement;
	keep Basin Season Name MaxWindMPH Ocean;
	Basin = upcase(Basin);
	*Add assignment statement;
	Length Ocean $ 8; 
	OceanCode=substr(Basin,2,1);
	if OceanCode="I" then Ocean="Indian";
	else if OceanCode="A" then Ocean="Atlantic";
	else Ocean="Pacific";
run;

***********************************************************;
*  LESSON 4, PRACTICE 7                                   *;
*    a) Submit the program and view the generated output. *;
*    b) In the DATA step, use IF-THEN/ELSE statements to  *;
*       create a new column, ParkType, based on the value *;
*       of Type.                                          *;
*       NM -> Monument                                    *;
*       NP -> Park                                        *;
*       NPRE, PRE, or PRESERVE -> Preserve                *;
*       NS -> Seashore                                    *;
*       RVR or RIVERWAYS -> River                         *;
*    c) Modify the PROC FREQ step to generate a frequency *;
*       report for ParkType.                              *;
***********************************************************;

data park_type;
	set pg1.np_summary;
	Length ParkType $20.;
	
	if Type = "NM" then ParkType = "Monument";
	else if Type = "NP" then ParkType = "Park";
	else if Type in ("NPRE" "PRE" "PRESERVE") then ParkType = "Preserve";
	else if Type = "NS" then ParkType = "Seashore";
	else if Type in ("RVR" "RIVERWAYS" ) then ParkType = "River";
	
run;

proc freq data=park_type;
	tables ParkType;
run;


/*
Write a DATA step to create two temporary tables, named parks and monuments, that are based on the pg1.np_summary table. Read only national parks or monuments from the input table. (Type is either NP or NM.)


Create a new column named Campers that is the sum of all columns that contain counts of campers. Format the column to include commas.


When Type is NP, create a new column named ParkType that is equal to Park, and write the row to the parks table. When Type is NM, assign ParkType as Monument and write the row to the monuments table.


Keep Reg, ParkName, DayVisits, OtherLodging, Campers, and ParkType in both output tables. Submit the program and view the output data.


How many rows are in each table?
*/


data parks monuments;
    set pg1.np_summary;
    where type in ('NM', 'NP');
    Campers=sum(OtherCamping, TentCampers, RVCampers,
                BackcountryCampers);
    format Campers comma17.;
    if Type = "NP" then do;
    ParkType  = "Park";
    output parks;
    end;
    else if Type = "NM" then do;
     ParkType  = "Monument ";
    output monuments;
    end;
    keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;

title "Storm Analysis";
title2 "Summary Statistics for MaxWind and MinPressure";
proc means data=pg1.storm_final;
	var MaxWindMPH MinPressure;
run;

title2 " Frequency Report for Basin";
proc freq data=pg1.storm_final;
	tables BasinName;
run;

***********************************************************;
*  Activity 5.03                                          *;
*    1) This code creates a macro variable named oc that  *;
*       stores the text string Pacific. The oc macro      *;
*       variable is then used in the WHERE statement to   *;
*       subset the data.                                  *;
*    2) Update the TITLE2 statement to use the macro      *;
*       variable. Run the program.                        *;
*    3) Change the value of the macro variable to         *;
*       Atlantic and run the program again.               *;
***********************************************************;

%let oc=Atlantic;
ods noproctitle;
title 'Storm Analysis';
title2 "&oc Ocean";

proc means data=pg1.storm_final;
	where Ocean="&oc";
	var MaxWindMPH MinPressure;
run;

ods proctitle;
title;
***********************************************************;
*  Activity 5.04                                          *;
*    1) Modify the LABEL statement in the DATA step to    *;
*       label the Invoice column as Invoice Price.        *;
*    2) Run the program. Why do the labels appear in the  *;
*       PROC MEANS report but not in the PROC PRINT       *;
*       report? Fix the program and run it again.         *;
***********************************************************;

data cars_update; *cria data set;
    set sashelp.cars; *origem dos dados;
	keep Make Model MSRP Invoice AvgMPG; *determina as coluna;
	AvgMPG=mean(MPG_Highway, MPG_City); *cria nova coluna aplicando a média;
	label MSRP="Manufacturer Suggested Retail Price" 
          AvgMPG="Average Miles per Gallon"
          Invoice = "Invoice Price"; *alterando o label;
run;

proc means data=cars_update min mean max;
    var MSRP Invoice;
run;

proc print data=cars_update label; *label força a exibição do label alterado;
    var Make Model MSRP Invoice AvgMPG;
run;


*Creating Frequency Reports and Graphs;

proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName Season / nocum; *nocum remove a coluna acumulado;
run;

ods graphics on; 
ods noproctitle; *desabilita title;
title "Frequency Report for Basin and Storm Month";
proc freq data=pg1.storm_final order=freq nlevels;
	tables BasinName StartDate / nocum plots=freqplot(orient=horizontal scale=percent);  * criar grafico para cada tables;
	format StartDate monname.; *formata data para nome do mes;
	label BasinName = "Basin"
	StartDate = "Storm Month";
run;
title;
ods proctitle;

*Criando freq cruzando duas colunas;
proc freq data=pg1.storm_final ;
	tables BasinName*StartDate / norow nocol nopercent; *removendo ;
	format StartDate monname.; 
	label BasinName = "Basin"
	StartDate = "Storm Month";
run;

proc freq data=pg1.storm_final ;
	tables BasinName*StartDate / crosslist; *tipo da tabela;
	format StartDate monname.; 
	label BasinName = "Basin"
	StartDate = "Storm Month";
run;

proc freq data=pg1.storm_final ;
	tables BasinName*StartDate / list norow nocol nopercent ; *tipo da tabela retirando colunas ;
	format StartDate monname.; 
	label BasinName = "Basin"
	StartDate = "Storm Month";
run;

proc freq data=pg1.storm_final noprint; *nao exibe no result;
	tables BasinName*StartDate / out= stormcounts ; *direncionando result para um dataset;
	format StartDate monname.; 
	label BasinName = "Basin"
	StartDate = "Storm Month";
run;

***********************************************************;
*  Activity 5.05                                          *;
*    1) Create an output table named STORM_COUNT by       *;
*       completing the OUT= option in the TABLES          *;
*       statement.                                        *;
*    2) Run the program. Which data values are included   *;
*       in the output table? Which statistics are         *;
*       included?                                         *;
*    3) Put StartDate and BasinName in separate TABLES    *;
*       statements. Add the OUT= option in each           *;
*       statement, and name the tables MONTH_COUNT and    *;
*       BASIN_COUNT.                                      *;
*    4) Run the program and examine the two tables. Which *;
*       month has the highest number of storms?           *;
***********************************************************;

title "Frequency Report for Basin and Storm Month";

proc freq data=pg1.storm_final order=freq noprint;
	tables StartDate  / out=MonthCounts  ;
	tables BasinName  / out=BasinCounts  ;
	format StartDate monname.;
run;

/*
Write a PROC FREQ step to analyze rows from pg1.np_species.

Use the TABLES statement to generate a frequency table for Category.
Use the NOCUM option to suppress the cumulative columns.
Use the ORDER=FREQ option in the PROC FREQ statement to sort the results by descending frequency.
Use Categories of Reported Species as the report title.
Submit the program and review the results.


What percent of the species are Fungi?


Modify the PROC FREQ step to make the following changes:

Include only the rows where Species_ID starts with EVER and Category is not Vascular Plant.
Note: EVER represents Everglades National Park.
Turn on ODS Graphics before the PROC FREQ step and turn off the procedure title.
Add the PLOTS=FREQPLOT option to display frequency plots.
Add in the Everglades as a second title.
Submit the program and review the results.


Which Category value has the smallest frequency?

*/
ods noproctitle;
ods graphics on;
title "Categories of Reported Species";
title2 "n the Everglades";
proc freq data= pg1.np_species order=freq;
	tables Category / nocum plots=freqplot;
	where Species_ID like 'EVER%' and Category <> 'Vascular Plant';
run;

/*
Create a new program. Write a PROC FREQ step to analyze rows from pg1.np_codelookup.

Generate a two-way frequency table for Type by Region.
Exclude any park type that contains the word Other.
The levels with the most rows should come first in the order.
Suppress the display of column percentages.
Use Park Types by Region as the report title.
Submit the program and review the results.


What are the top three park types based on total frequency count?

Note: Statistics labels appear in the main table in Enterprise Guide if SAS Report is the output format.


Modify the PROC FREQ step to make the following changes:

Limit the park types to the three that were determined in the previous step.
In addition to suppressing the display of column percentages, use the CROSSLIST option to display the table.
Add a frequency plot that groups the bars by the row variable, displays row percentages, and has a horizontal orientation.
Note: Use SAS documentation to learn how the GROUPBY=, SCALE=, and ORIENT= options can be used to control the appearance of the plot.
Use Selected Park Types by Region as the report title.
Submit the program and review the results.


Which Region has the highest Row Percent value?
*/

title1 'Park Types by Region';
proc freq data=pg1.np_codelookup order=freq;
    tables Type*Region / nocol;
    where Type not like '%Other%';
run;

title1 'Selected Park Types by Region';
ods graphics on;
proc freq data=pg1.np_codelookup order=freq;
    tables Type*Region /  nocol crosslist 
           plots=freqplot(groupby=row scale=grouppercent orient=horizontal);
    where Type in ('National Historic Site', 'National Monument', 'National Park');
run;
title;


*Creating Summary Statistics Reports;


proc means data=pg1.storm_final mean median min max maxdec=0;
var MaxWindMPH;
class BasinName StormType; * separando por grupo;
ways 0 1 2; *separa a exibição. 0 mostra todos, 1, mostra as class e 2 mostra a combinação entre as class;
run;

***********************************************************;
*  Activity 5.06                                          *;
*    1) Add options to include N (count), MEAN, and MIN   *;
*       statistics. Round each statistic to the nearest   *;
*       integer.                                          *;
*    2) Add a CLASS statement to group the data by Season *;
*       and Ocean. Run the program.                       *;
*    3) Modify the program to add the WAYS statement so   *;
*       that separate reports are created for Season and  *;
*       Ocean statistics. Run the program.                *;
*       Which ocean had the lowest mean for minimum       *;
*       pressure?                                         *;
*       Which season had the lowest mean for minimum      *;
*       pressure?                                         *;
***********************************************************;

proc means data=pg1.storm_final maxdec=0 n mean min;
	var MinPressure;
	class Season Ocean;
	where Season >=2010;
	ways 1;
run;


***********************************************************;
*  Activity 5.07                                          *;
*    1) Run the PROC MEANS step and compare the report    *;
*       and the wind_stats table. Are the same statistics *;
*       in the report and table? What do the first five   *;
*       rows in the table represent?                      *;
*    2) Uncomment the WAYS statement. Delete the          *;
*       statistics listed in the PROC MEANS statement and *;
*       add the NOPRINT option. Run the program. Notice   *;
*       that a report is not generated and the first five *;
*       rows from the previous table are excluded.        *;
*    3) Add the following options in the OUTPUT statement *;
*       and run the program again. How many rows are in   *;
*       the output table?                                 *;
*         output out=wind_stats mean=AvgWind max=MaxWind; *;
***********************************************************;

proc means data=pg1.storm_final mean median max noprint;
	var MaxWindMPH;
	class BasinName;
	ways 1;
	output out=wind_stats;
run;

*Create a new program. Write a PROC MEANS step to analyze rows from pg1.np_westweather with the following specifications:

Generate the mean, minimum, and maximum statistics for the Precip, Snow, TempMin, and TempMax columns.
Use the MAXDEC= option to display the values with a maximum of two decimal positions.
Use the CLASS statement to group the data by Year and Name.
Use Weather Statistics by Year and Park as the report title.
Submit the program and review the results.
;

title "Weather Statistics by Year and Park";
proc means data = pg1.np_westweather mean min max maxdec=2;
var Precip Snow TempMin TempMax;
class Year Name;

run;

*Exporting Data;
proc export data=PG1.STORM_FINAL 
outfile= "/folders/myfolders/STORM_FINAL.csv"
dbms=csv replace;
run;  

libname xlout xlsx "/folders/myfolders/STORM_FINAL.xlsx";

proc means data= PG1.STORM_FINAL;
class Season;
output out=xlout.STORM_FINAL_MEANS;
run;

libname xlout clear;

*Gerando gráfico de Histograma;
proc sgplot data= pg1.STORM_FINAL;
histogram MaxWindMPH;
density MaxWindMPH;
run;

*Consultando Styles ;
proc template;
list styles;
run;

*Add ODS statement;

ods excel file="/folders/myfolders/pressure.xlsx" style=analysis;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

*Add ODS statement;

ods proctitle;
ods excel close;


*ODS PowerPoint;


ods powerpoint file="/folders/myfolders/pressure.pptx" style=powerpointlight;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

ods powerpoint close;

*ODS Word;


ods rtf file="/folders/myfolders/pressure.rtf" style=sapphire startpage= no;

title "Minimum Pressure Statistics by Basin";
ods noproctitle;
proc means data=pg1.storm_final mean median min maxdec=0;
    class BasinName;
    var MinPressure;
run;

title "Correlation of Minimum Pressure and Maximum Wind";
proc sgscatter data=pg1.storm_final;
	plot minpressure*maxwindmph;
run;
title;  

ods rtf close;


ods excel file="&outpath/StormStats.xlsx"
    style=snow
    options(sheet_name='South Pacific Summary');
ods noproctitle;

proc means data=pg1.storm_detail maxdec=0 median max;
    class Season;
    var Wind;
    where Basin='SP' and Season in (2014,2015,2016);
run;

ods excel options(sheet_name='Detail');

proc print data=pg1.storm_detail noobs;
    where Basin='SP' and Season in (2014,2015,2016);
    by Season;
run;

ods excel close;
ods proctitle;


ods rtf file="&outpath/ParkReport.rtf" style=Journal startpage=no;

ods noproctitle;
options nodate;

title "US National Park Regional Usage Summary";

proc freq data=pg1.np_final;
    tables Region /nocum;
run;

proc means data=pg1.np_final mean median max nonobs maxdec=0;
    class Region;
    var DayVisits Campers;
run;

ods rtf style=SASDocPrinter;

title2 'Day Vists vs. Camping';
proc sgplot data=pg1.np_final;
    vbar  Region / response=DayVisits;
    vline Region / response=Campers;
run;
title;

ods proctitle;
ods rtf close;
options date;



options orientation=landscape;
ods pdf file="&outpath/StormSummary.PDF" style=Journal nobookmarkgen;

title1 "2016 Northern Atlantic Storms";

ods layout gridded columns=2 rows=1;
ods region;

proc sgmap plotdata=pg1.storm_final;
    *openstreetmap;
    esrimap url='http://services.arcgisonline.com/arcgis/rest/services/World_Physical_Map';
    bubble x=lon y=lat size=maxwindmph / datalabel=name datalabelattrs=(color=red size=8);
    where Basin='NA' and Season=2016;
    keylegend 'wind';
run;

ods region;
proc print data=pg1.storm_final noobs;
    var name StartDate MaxWindMPH StormLength;
    where Basin="NA" and Season=2016;
    format StartDate monyy7.;
run;

ods layout end;
ods pdf close;
options orientation=portrait;


*SQL

title "PROC PRINT Output";
proc print data=pg1.class_birthdate; *Exibi a coluna OBS que o proc sql abaixo nao mostra;
	var Name Age Height Birthdate;
	format Birthdate date9.;
run;

title "PROC SQL Output";
proc sql;
select Name, Age, Height*2.54 as HeightCM format=5.1, Birthdate format=date9.
    from pg1.class_birthdate;
quit;

title;

proc sql;
create table top_damage as
select Event, 
       Date format=monyy7.,
       Cost format=dollar16.
       from pg1.storm_damage
       order by Cost desc;
title "Top 10 Storms by Damage Cost";
    select *
        from top_damage(obs=10);
quit;

























