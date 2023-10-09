
-- Listing all the field
select * from Backup_Data_manupilation



--Let's clean the Data before any manipulation...................


--Create a date converted colunm from Date_de_creation

Alter Table Backup_Data_manupilation
add Date_converted Date

--fill the date_converted column
Update Backup_Data_manupilation
set Date_converted = convert(Date, Date_de_création)

--get the month as number from the Date_converted
Alter Table Backup_Data_manupilation
add Mois Int

update Backup_Data_manupilation
set Mois = Month(Date_converted)

--get the WeekDays from the Date_converted
Alter Table Backup_Data_manupilation
add Semaine nvarchar(255)

update Backup_Data_manupilation
set Semaine = DATENAME(WeekDay, Date_converted)

-- GET THE DAY OF THE URGENCE
Alter Table Backup_Data_manupilation
add Jour nvarchar(255)

update Backup_Data_manupilation
set Jour = DATENAME(Day, Date_converted)

-- lets work on the hour part of the Date_de_creation
-- GET THE hour OF THE URGENCE

Alter Table Backup_Data_manupilation
ADD  Heure int 

update Backup_Data_manupilation
set Heure =  DATENAME(HOUR, Date_de_création)

-- Get rid of the number in front of the department of localisation
Alter Table Backup_Data_manupilation
Add Departement nvarchar(255)

-- Get rid of numbers in front of the department_de_localisation
Alter Table Backup_Data_manupilation
drop column Departement

-- departement with no number in front
update Backup_Data_manupilation
Set Departement = 
CASE
    WHEN Département_de_localisation like '(01)%' THEN 'Ouest'
    WHEN Département_de_localisation like'(07)%' THEN 'Sud'
    WHEN Département_de_localisation like '(05)%' THEN 'Artibonite'
	WHEN Département_de_localisation like'(03)%' THEN 'Nord'
    WHEN Département_de_localisation like '(04)%' THEN 'Nord-Est'
	WHEN Département_de_localisation like '(09)%' THEN 'Nord-Ouest'
	WHEN Département_de_localisation like '(02)%' THEN 'Sud-Est'
	WHEN Département_de_localisation like'(06)%' THEN 'Centre'
	WHEN Département_de_localisation like '(10)%' THEN 'Nippes'
	WHEN Département_de_localisation like '(08)%' THEN 'Grand-Anse'
    ELSE NULL
END


-- Let  change all ""Autres"" in the ""Raison_de_appel"" column into something more specific.


update Backup_Data_manupilation
set Raison_de_l_appel = 'Urgence OBGYN'
where Motif_de_l_appel ='Accouchement'

update Backup_Data_manupilation
set Raison_de_l_appel = 'Urgence OBGYN'
 where Raison_de_l_appel='Autre' and Motif_de_l_appel like 'Cris%'

update Backup_Data_manupilation
set Raison_de_l_appel = 'Detresse Respiratoire'
where  Motif_de_l_appel like 'Gè%' 

update Backup_Data_manupilation
set Raison_de_l_appel = 'Detresse Respiratoire'
where Motif_de_l_appel ='Toux'

update Backup_Data_manupilation
set Raison_de_l_appel = 'D.thoracique'
where Motif_de_l_appel ='Douleur thoracique'

update Backup_Data_manupilation
set Raison_de_l_appel = 'Trouble neurologiques'
where Motif_de_l_appel in ('AVC', 'Poussée hypertensive')


update Backup_Data_manupilation
set Raison_de_l_appel = 'P. digestives'
where Motif_de_l_appel IN ( 'Diarrhée','Diarrhée / Vomissement', 'Vomissements')


update Backup_Data_manupilation
set Raison_de_l_appel = 'P. digestives'
where Motif_de_l_appel is not null and Motif_de_l_appel ='Douleur abdominale'
and Raison_de_l_appel ='Autre'

update Backup_Data_manupilation
set Raison_de_l_appel = 'Traumatisme'
where Deuxieme_algo like 'Trau%'

update Backup_Data_manupilation
set Raison_de_l_appel = 'Traumatisme'
where 
  Raison_de_l_appel='Autre' and ( Deuxieme_algo=  'Plaie grave' or  Motif_de_l_appel ='Plaie')  

 update Backup_Data_manupilation
set Raison_de_l_appel = 'Traumatisme'
where 
  Raison_de_l_appel='Autre' and ( Deuxieme_algo=  'Malaise grave' or  Motif_de_l_appel ='Malaise') 
 
update Backup_Data_manupilation
set Raison_de_l_appel = 'Traumatisme'
where  Motif_de_l_appel ='Palpitations' and Raison_de_l_appel ='Autre'


update Backup_Data_manupilation
set Raison_de_l_appel = 'Maladies Chroniques'
where 
  Raison_de_l_appel='Autre' and Motif_de_l_appel
  like 'Impossibilité%' or Motif_de_l_appel in('Convulsion', 'Mal de tête (Cephalée)', 'Fièvre','Intoxication'
  ,'Brulure'
 )

 -- For all OBGYN change gender is male
 update Backup_Data_manupilation
set Sexe_de_la_victime = 'Femme'
where 
Raison_de_l_appel = 'Urgence OBGYN' and Sexe_de_la_victime='Homme'
and N_de_fiche in(
'20230215-0060',
'20230117-0276',
'20230120-0017',
'20230121-0182',
'20230123-0124',
'20230206-0008',
'20230302-0022',
'20230318-0025',
'20230330-0004',
'20230412-0092',
'20230419-0114',
'20230509-0107',
'20230515-0036',
'20230517-0020',
'20230605-0035',
'20230613-0041',
'20230622-0017',
'20230703-0042',
'20230705-0019',
'20230710-0027',
'20230715-0019',
'20230721-0003',
'20230728-0005',
'20230807-0011',
'20230826-0001',
'20230908-0029',
'20230910-0008'
)

-- for all obgyn change sex is Inconnu to femme

update Backup_Data_manupilation
set Sexe_de_la_victime = 'Femme'
where 
Raison_de_l_appel like 'Urge%' and Sexe_de_la_victime='Inconnu'
and N_de_fiche in(
'20230125-0039',
'20230208-0040',
'20230225-0058'
)


-- Number of calls 
Select Type_d_appel,  count(Type_d_appel) as NumberOfCalls from Backup_Data_manupilation
group by Type_d_appel  


--Number of non-noisy calls
Select Type_d_appel,  count(Type_d_appel) as NumberOfNonNoisyCalls  from Backup_Data_manupilation
where Type_d_appel <>'Nuisible' and Type_d_appel<>'Info' and mois =9
group by Type_d_appel


--Number of Urgent cases
Select Type_d_appel,  count(Type_d_appel) from Backup_Data_manupilation
where Type_d_appel ='Urgence'
group by Type_d_appel

-- Gender distribution of patients
Select Sexe_de_la_victime,  count(Type_d_appel) as NumberOfSexPerPatient from Backup_Data_manupilation
where Type_d_appel ='Urgence' and Mois =9
group by Sexe_de_la_victime


--Age distribution of patients
Select Age_de_la_victime, count(Type_d_appel) as NumberOfAgePerPatient from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
group by Age_de_la_victime
order by Age_de_la_victime asc

-- Age distribution of women
Select Age_de_la_victime , count(Age_de_la_victime) as NumberOfAgePerWomen from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
and Sexe_de_la_victime='Femme'
group by Age_de_la_victime
order by Age_de_la_victime asc

-- Age distribution of men
Select Age_de_la_victime , count(Age_de_la_victime) as NumberOfAgePermen from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
and Sexe_de_la_victime='Homme'
group by Age_de_la_victime
order by Age_de_la_victime asc


-- Diagnosis of all emergencies
Select Raison_de_l_appel,  count(Type_d_appel) as NumberOfCases  from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
--and Sexe_de_la_victime='Homme'
group by Raison_de_l_appel
order by NumberOfCases desc


-- Diagnosis of all emergencies in adult women
Select Raison_de_l_appel, count(Type_d_appel) as qte_femmeAdult from Backup_Data_manupilation
where Type_d_appel  ='Urgence' 
and (Sexe_de_la_victime='Femme' and Age_de_la_victime>='16-25 ans'
and Age_de_la_victime<>'6-15 ans' and Age_de_la_victime<>'Non specifie' )
group by Raison_de_l_appel



-- Diagnosis of all emergencies by hospital
Select Raison_de_l_appel, Hopital_d_orientation_sélectionné_par_l_infirmier,
count(Hopital_d_orientation_sélectionné_par_l_infirmier) as qte_hopital from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
and Hopital_d_orientation_sélectionné_par_l_infirmier is not null
--and Raison_de_l_appel='Traumatisme'
--and ( Age_de_la_victime>='16-25 ans'
--and Age_de_la_victime<>'6-15 ans' and Age_de_la_victime<>'Non specifie' )
group by Raison_de_l_appel, Hopital_d_orientation_sélectionné_par_l_infirmier


--Qte Diagnostique sur l'ensemble des urgences chez les femmes adultes
--Select count(Type_d_appel) as qte_femmeAdult from Backup_Data_manupilation
--where Type_d_appel  ='Urgence'
--and (Sexe_de_la_victime='Femme' and Age_de_la_victime>='16-25 ans'
--and Age_de_la_victime<>'6-15 ans' and Age_de_la_victime<>'Non specifie' )
--group by Age_de_la_victime,Raison_de_l_appel


--Diagnostique sur l'ensemble des urgences chez les hommes adultes
Select Raison_de_l_appel, count(Type_d_appel) as qte_hommeAdult from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
and (Sexe_de_la_victime='Homme' and Age_de_la_victime>='16-25 ans'
and Age_de_la_victime<>'6-15 ans' and Age_de_la_victime<>'Non specifie' )
group by Raison_de_l_appel


-- Diagnosis on all emergencies in fenates less than 5 years old
Select Raison_de_l_appel, count(Type_d_appel) as qte_enfant_moins_5ans from Backup_Data_manupilation
where Type_d_appel  ='Urgence'
and  Age_de_la_victime ='0-5 ans'
group by Raison_de_l_appel



-- Hourly call distribution
Select Type_d_appel, Heure from Backup_Data_manupilation
group by Type_d_appel, Heure


-- Hourly call distribution 
Select Heure, count(Heure) from Backup_Data_manupilation
--where Type_d_appel='Urgence'
group by  Heure

-- Hourly call distribution urgence
--Select Heure, count(Heure) as qteAppelUrgence from Backup_Data_manupilation
--where Type_d_appel='Urgence'
--group by  Heure

-- Hourly call distribution urgence
Select Heure, count(Type_d_appel) as qteAppelUrgence from Backup_Data_manupilation
where Type_d_appel='Urgence'
group by  Heure



-- Weekly call distribution urgence
Select Mois, count(Type_d_appel) as qteAppelUrgence from Backup_Data_manupilation
where Type_d_appel='Urgence'
group by  Mois
order by Mois asc


-- yaerly call distribution urgence in AM
Select heure, count(Type_d_appel) as qteAppelUrgence from Backup_Data_manupilation
where Type_d_appel='Urgence' and Heure between 0 and 12
group by  heure
order by qteAppelUrgence desc

-- yaerly call distribution urgence in PM

Select heure, count(Type_d_appel) as qteAppelUrgence from Backup_Data_manupilation
where Type_d_appel='Urgence' and Heure between 13 and 23
group by  heure
order by qteAppelUrgence desc


-- Weekly Noisy call distribution 
Select Heure, count(Type_d_appel) as qteAppelUrgence from Backup_Data_manupilation
where Type_d_appel='Nuisible'
group by  Heure
order by Heure desc ,qteAppelUrgence desc



-- weekly call distribution for urgence
--Select  Age_de_la_victime, count(Type_d_appel) AS QtAppelNuisible from Backup_Data_manupilation
--where Type_d_appel='Nuisible'
--group by  Age_de_la_victime
--order by QtAppelNuisible desc 



Select  semaine, count(Type_d_appel) AS qtWeek from Backup_Data_manupilation
where Type_d_appel='Urgence'
group by  semaine, Type_d_appel
order by qtWeek desc 


--Select count(Type_d_appel) as qte_femmeAdult from Backup_Data_manupilation
--where Type_d_appel  ='Urgence'
--and (Sexe_de_la_victime='Homme' and Age_de_la_victime>='16-25 ans'
--and Age_de_la_victime<>'6-15 ans' and Age_de_la_victime<>'Non specifie' )
--group by Age_de_la_victime,Raison_de_l_appel




--Lets copy this d to a backup one


--select * into backup_manipulation2
--from Backup_Data_manupilation


--select Département_de_localisation, type_d_appel,


--CASE
--    WHEN Département_de_localisation like '(01)%' THEN 'Ouest'
--    WHEN Département_de_localisation like'(07)%' THEN 'Sud'
--    WHEN Département_de_localisation like '(05)%' THEN 'Artibonite'
--	WHEN Département_de_localisation like'(03)%' THEN 'Nord'
--    WHEN Département_de_localisation like '(04)%' THEN 'Nord-Est'
--	WHEN Département_de_localisation like '(09)%' THEN 'Nord-Ouest'
--	WHEN Département_de_localisation like '(02)%' THEN 'Sud-Est'
--	WHEN Département_de_localisation like'(06)%' THEN 'Centre'
--	WHEN Département_de_localisation like '(10)%' THEN 'Nippes'
--	WHEN Département_de_localisation like '(08)%' THEN 'Grand-Anse'
--    ELSE NULL
--END
--from sql_data_manipulation_portfolio 



select Date_urgence , DATENAME(HOUR, Date_urgence) from oeust_portfolio
