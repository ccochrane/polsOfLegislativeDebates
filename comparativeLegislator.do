*Macbook
*use "/Users/chriscochrane/Dropbox/Projects/politics of Legislative *Debate/Final Submission/lipadParlinfoMerged_dayLevel.dta", clear


*PC
use "C:\Users\chris\Dropbox\Projects\politics of Legislative Debate\Final Submission\lipadParlinfoMerged_dayLevel.dta", clear

gen speechdate2 = substr(subinstr(speechdate, "-","",.), 1,8)
gen date = date(speechdate2, "YMD")
gen date2 = date
format date2 %td


*fixing incorrect birthday for Margeret Mitchell
replace birthdate = "1925-07-25" if birthdate == "1898-03-26"

*fixing incorrect birthday for John G. Williams
replace birthdate = "1946-12-31" if birthdate == "1907-10-07"



gen temp = substr(subinstr(birthdate, "-","",.), 1,8)
gen birthdate2 = date(temp, "YMD")
gen birthdate3 = birthdate2
format birthdate3 %td
drop temp

gen age = date2 - birthdate3
gen ageyrs = age/365.25

**************************
*Fixing party variable
**************************
*indicates error in ParlInfo or LIPAD, or dignitary (Total n=26))
drop if currentParty == "None Found in Search" 

gen originalParty = currentParty
replace currentParty = "Bloc Quebecois" if currentParty == "Bloc Quebecois "


*Erin Weir kicked from NDP caucus for Harrassment.  Changes his affiliation to
*an outdated party label, the precursor of the NDP.
replace currentParty = "Independent" if currentParty == "Co-operative Commonwealth Federation"


*GPQ and QD are the same party, just a different name for MPs who resigned from the BQ.
replace currentParty = "Quebec debout" if currentParty == "Groupe parlementaire quebecois "

replace currentParty = "Independent" if currentParty == "Independent Bloc Quebecois"
replace currentParty = "Independent" if currentParty == "Independent Canadian Alliance"
replace currentParty = "Independent" if currentParty == "Independent Liberal"
replace currentParty = "Independent" if currentParty == "Independent Reform"
replace currentParty = "Independent" if currentParty == "Independent Sovereignist"
replace currentParty = "Independent" if currentParty == "Independent Conservative"

replace currentParty = "Very Minor Party" if currentParty == "Liberal Democrat" ///
						                     |currentParty == "People's Party of Canada " ///
											 |currentParty == "Quebec debout" ///
											 |currentParty == "Strength in Democracy" ///
											 

replace currentParty = "Reform Alliance" if currentParty == "Canadian Reform Conservative Alliance" | currentParty == "Reform Party of Canada"



**************************
*Fixing PM Variable
**************************

replace primeMinister01 = 1 if Name=="Campbell, A. Kim" & date2>=date("25Jun1993", "DMY") ///
                             & date2<=date("14Dec1993", "DMY")



				
tab Gender, gen(Male)
gen Experience_2 = Experience^2


*Parliaments
gen parliament = .
replace parliament = 34 if date2 >= date("12dec1988", "DMY") ///
                         & date2 <= date("08sep1993", "DMY")

replace parliament = 35 if date2 > date("08sep1993", "DMY") ///
                         & date2 <= date("27apr1997", "DMY")

replace parliament = 36 if date2 > date("27apr1997", "DMY") ///
                         & date2 <= date("22oct2000", "DMY")

replace parliament = 37 if date2 > date("22oct2000", "DMY") ///
                         & date2 <= date("23may2004", "DMY")						 
						 
replace parliament = 38 if date2 > date("23may2004", "DMY") ///
                         & date2 <= date("29nov2005", "DMY")
						 
replace parliament = 39 if date2 > date("29nov2005", "DMY") ///
                         & date2 <= date("07sep2008", "DMY")						 
						 
replace parliament = 40 if date2 > date("07sep2008", "DMY") ///
                         & date2 <= date("26mar2011", "DMY")						 
						 
replace parliament = 41 if date2 > date("23may2011", "DMY") ///
                         & date2 <= date("02aug2015", "DMY")						 
						 
replace parliament = 42 if date2 > date("02aug2015", "DMY") ///
                         & date2 <= date("11sep2019", "DMY")						 
						 
						 

gen govtParty = .
replace govtParty = 1 if currentParty == "Progressive Conservative Party" ///
                                        & parliament==34
									
replace govtParty = 1 if currentParty == "Liberal Party of Canada" ///
                                        & parliament> 34 & parliament < 39

replace govtParty = 1 if currentParty == "Conservative Party of Canada" ///
                                        & parliament >=39 & parliament <42
										
replace govtParty = 1 if currentParty == "Liberal Party of Canada" ///
                                        & parliament==42

recode govtParty .=0


gen oppositionParty = .
replace oppositionParty = 1 if currentParty == "Liberal Party" ///
                                        & parliament==34
									
replace oppositionParty = 1 if currentParty == "Bloc Quebecois" ///
                                        & parliament==35

replace oppositionParty = 1 if currentParty == "Reform Alliance" ///
                                        & parliament ==36
										
replace oppositionParty = 1 if currentParty == "Reform Alliance" ///
                                        & parliament==37 ///
										| currentParty=="Conservative Party of Canada" ///
										& parliament==37

replace oppositionParty = 1 if currentParty == "Conservative Party of Canada" ///
                                        & parliament ==38
										
replace oppositionParty = 1 if currentParty == "Liberal Party of Canada" ///
                                        & parliament > 38 & parliament < 41		

replace oppositionParty = 1 if currentParty == "New Democratic Party" ///
                                        & parliament ==41
										
replace oppositionParty = 1 if currentParty == "Conservative Party of Canada" ///
                                        & parliament ==42
										
recode oppositionParty .=0



*Gendered speech count

*words by gender
/*
gen femaleWords = wordsToday if Gender=="F"
egen femaleWordsTotal = total(femaleWords)
egen wordsTotal = total(wordsToday)
gen femaleWordProportionTotal = femaleWordsTotal/wordsTotal

*words by gender and party (all parliaments)
bysort currentParty: gen femaleWordsParty = wordsToday if Gender=="F"
bysort currentParty: egen femaleWordsPartyTotal = total(femaleWordsParty)
bysort currentParty: egen wordsTotalParty = total(wordsToday)
bysort currentParty: gen femaleWordPartyProportion = femaleWordsPartyTotal/wordsTotalParty

*words by gender and party (42 parliament)
bysort currentParty: gen femaleWordsParty42p = wordsToday if Gender=="F" & parliament==42
bysort currentParty: egen femaleWordsPartyTotal42p = total(femaleWordsParty42p) if parliament==42
bysort currentParty: egen wordsPartyTotal42p = total(wordsToday) if parliament==42
bysort currentParty: gen femaleWordPartyProportion42p = femaleWordsPartyTotal42p/wordsPartyTotal42p

*speeches by gender
gen femaleSpeeches = speechesToday if Gender=="F"
egen femaleSpeechesTotal = total(femaleSpeeches)
egen speechesTotal = total(speechesToday)
gen femaleSpeechesProportionTotal = femaleSpeechesTotal/speechesTotal

*speeches by gender and party 
bysort currentParty: gen femaleSpeechesParty = speechesToday if Gender=="F"
bysort currentParty: egen femaleSpeechesPartyTotal = total(femaleSpeechesParty)
bysort currentParty: egen speechesPartyTotal = total(speechesToday)
bysort currentParty: gen femaleSpeechesPartyPropTotal = femaleSpeechesPartyTotal/speechesPartyTotal

*speeches by gender and party (42 parliament)

bysort currentParty: gen femaleSpeechesParty42 = speechesToday if Gender=="F" & parliament==42
bysort currentParty: egen femaleSpeechesPartyTotal42 = total(femaleSpeechesParty42)
gen speechesToday42 = speechesToday if parliament==42
bysort currentParty: egen speechesPartyTotal42 = total(speechesToday42)
bysort currentParty: gen femaleSpeechesPartyPropTotal42 = femaleSpeechesPartyTotal42/speechesPartyTotal42

*/


gen role = "NA"
replace role = "Prime Minister" if primeMinister01==1
replace role = "Minister" if minister01==1 & primeMinister01==0
replace role = "Parliamentary Secretary" if secretary01 == 1
replace role = "Government Backbencher" if govtParty==1 & minister01==0 & secretary01==0 & primeMinister01==0 & speaker01==0 & deputySpeaker01==0
replace role = "Opposition Leader" if oppositionLeader01==1
replace role = "Opposition Member" if oppositionParty==1 & oppositionLeader==0 & speaker01==0 & deputySpeaker01==0
replace role = "Other Party Member" if govtParty==0 & oppositionParty==0 & currentParty != "Independent" & speaker01==0 & deputySpeaker01==0 & primeMinister01==0
replace role = "Independent" if currentParty=="Independent" & speaker01==0 & deputySpeaker01==0
replace role = "Speaker" if speaker01==1 | deputySpeaker01==1
replace role = "Other Party Critic" if critic01==1 & speaker01==0 & deputySpeaker01==0 & oppositionLeader01==0 & oppositionParty==0 & leader01==0
replace role = "Opposition Critic" if critic01==1 & speaker01==0 & deputySpeaker01==0 & oppositionLeader01==0 & oppositionParty==1 
replace role = "Other Party Leader" if leader01==1 & oppositionLeader01==0 & primeMinister01==0



***************
* speeches by Role
***************


bysort pid: egen ministerSpeeches = mean(speechesToday) if role == "Minister"
bysort pid: egen primeMinisterSpeeches = mean(speechesToday) if role == "Prime Minister"
bysort pid: egen parlSecretarySpeeches = mean(speechesToday) if role == "Parliamentary Secretary"
bysort pid: egen backbencherSpeeches = mean(speechesToday) if role == "Government Backbencher"
bysort pid: egen leaderOppositionSpeeches = mean(speechesToday) if role == "Opposition Leader"
bysort pid: egen oppositionSpeeches = mean(speechesToday) if role == "Opposition Member"
bysort pid: egen otherPartiesSpeeches = mean(speechesToday) if role == "Other Party Member"
bysort pid: egen independentSpeeches = mean(speechesToday) if role == "Independent"
bysort pid: egen otherCriticSpeeches = mean(speechesToday) if role == "Other Party Critic"
bysort pid: egen oppositionCriticSpeeches = mean(speechesToday) if role == "Opposition Critic"
bysort pid: egen otherLeaderSpeeches = mean(speechesToday) if role == "Other Party Leader"

gen lastname = Name
split lastname, p(",")




egen iqrPrimeMinisterSpeeches = iqr(primeMinisterSpeeches) if role == "Prime Minister"
egen medianPrimeMinisterSpeeches = median(primeMinisterSpeeches) if role == "Prime Minister"
gen pmOutlier = lastname1 if abs(primeMinisterSpeeches-medianPrimeMinisterSpeeches) > 1.5*iqrPrimeMinisterSpeeches

egen iqrMinisterSpeeches = iqr(ministerSpeeches) if role=="Minister"
egen medianMinisterSpeeches = median(ministerSpeeches) if role=="Minister"
*just getting the most extreme
gen ministerOutlier = lastname1 if abs(ministerSpeeches-medianMinisterSpeeches) > 2.5*iqrMinisterSpeeches

egen iqrLeaderOppositionSpeeches = iqr(leaderOppositionSpeeches) if role=="Opposition Leader"
egen medianLeaderOppositionSpeeches = median(leaderOppositionSpeeches) if role=="Opposition Leader"
*just getting the most extreme
gen leaderOppositionOutlier = lastname1 if abs(leaderOppositionSpeeches-medianLeaderOppositionSpeeches) > 2.5*iqrMinisterSpeeches

egen iqrOtherPartiesSpeeches = iqr(otherPartiesSpeeches) if role=="Other Party Member"
egen medianOtherPartiesSpeeches = median(otherPartiesSpeeches) if role=="Other Party Member"
*just getting the most extreme
gen otherPartiesOutlier = lastname1 if abs(otherPartiesSpeeches-medianOtherPartiesSpeeches) > 6*iqrOtherPartiesSpeeches

egen iqrOppositionSpeeches = iqr(oppositionSpeeches) if role=="Opposition Member"
egen medianOppositionSpeeches = median(oppositionSpeeches) if role=="Opposition Member"
*just getting the most extreme
gen oppositionOutlier = lastname1 if abs(oppositionSpeeches-medianOppositionSpeeches) > 6*iqrOppositionSpeeches

egen iqrBackbencherSpeeches = iqr(backbencherSpeeches) if role == "Government Backbencher"
egen medianBackbencherSpeeches = median(backbencherSpeeches) if role == "Government Backbencher"
*just getting the most extreme
gen backbencherOutlier = lastname1 if abs(backbencherSpeeches-medianBackbencherSpeeches) > 17*iqrBackbencherSpeeches

egen iqrIndependentSpeeches = iqr(independentSpeeches) if role == "Independent"
egen medianIndependentSpeeches = median(independentSpeeches) if role == "Independent"
*just getting the most extreme
gen independentOutlier = lastname1 if abs(independentSpeeches-medianIndependentSpeeches) > 5*iqrIndependentSpeeches

egen iqrParlSecretarySpeeches = iqr(parlSecretarySpeeches) if role == "Parliamentary Secretary"
egen medianParlSecretarySpeeches = median(parlSecretarySpeeches) if role == "Parliamentary Secretary"
*just getting the most extreme
gen parlSecretaryOutlier = lastname1 if abs(parlSecretarySpeeches - medianParlSecretarySpeeches) > 4*iqrParlSecretarySpeeches


egen iqrOtherCriticSpeeches = iqr(otherCriticSpeeches) if role == "Other Party Critic"
egen medianCriticSpeeches = median(otherCriticSpeeches) if role == "Other Party Critic"
*just getting the most extreme
gen otherCriticOutlier = lastname1 if abs(otherCriticSpeeches - medianCriticSpeeches) > 4*iqrOtherCriticSpeeches

egen iqrOppositionCriticSpeeches = iqr(oppositionCriticSpeeches) if role == "Opposition Critic"
egen medianOppositionCriticSpeeches = median(oppositionCriticSpeeches) if role == "Opposition Critic"
*just getting the most extreme
gen oppositionCriticOutlier = lastname1 if abs(oppositionCriticSpeeches - medianOppositionCriticSpeeches) > 3*iqrOppositionCriticSpeeches


egen iqrOtherLeaderSpeeches = iqr(otherLeaderSpeeches) if role == "Other Party Leader"
egen medianOtherLeaderSpeeches = median(otherLeaderSpeeches) if role == "Other Party Leader"
*just getting the most extreme
gen otherLeaderOutlier = lastname1 if abs(otherLeaderSpeeches - medianOtherLeaderSpeeches) > 5*iqrOtherLeaderSpeeches

bysort pid: egen headSpeakerRole = max(speaker01)
bysort pid: egen deputySpeakerRole = max(deputySpeaker01)
bysort pid: gen anySpeakerRole = max(headSpeakerRole, deputySpeakerRole)




***************
* words by Role
***************


bysort pid: egen ministerWords = mean(wordsToday) if role=="Minister"
bysort pid: egen primeMinisterWords = mean(wordsToday) if role == "Prime Minister"
bysort pid: egen parlSecretaryWords = mean(wordsToday) if role == "Parliamentary Secretary"
bysort pid: egen backbencherWords = mean(wordsToday) if role == "Government Backbencher"
bysort pid: egen leaderOppositionWords = mean(wordsToday) if role == "Opposition Leader"
bysort pid: egen oppositionWords = mean(wordsToday) if role == "Opposition Member"
bysort pid: egen otherPartiesWords = mean(wordsToday) if role=="Other Party Member"
bysort pid: egen independentWords = mean(wordsToday) if role == "Independent"
bysort pid: egen otherCriticWords = mean(wordsToday) if role == "Other Party Critic"
bysort pid: egen oppositionCriticWords = mean(wordsToday) if role == "Opposition Critic"
bysort pid: egen otherLeaderWords = mean(wordsToday) if role == "Other Party Leader"

***************
* Word Outliers by Role
***************

egen iqrPrimeMinisterWords = iqr(primeMinisterWords) if role == "Prime Minister"
egen medianPrimeMinisterWords = median(primeMinisterWords) if role == "Prime Minister"
gen pmOutlierWords = lastname1 if abs(primeMinisterWords-medianPrimeMinisterWords) > 1.5*iqrPrimeMinisterWords


egen iqrLeaderOppositionWords = iqr(leaderOppositionWords) if role=="Opposition Leader"
egen medianLeaderOppositionWords = median(leaderOppositionWords) if role=="Opposition Leader"
*just getting the most extreme
gen leaderOppositionOutlierWords = lastname1 if abs(leaderOppositionWords-medianLeaderOppositionWords) > 2.5*iqrLeaderOppositionWords



egen iqrMinisterWords = iqr(ministerWords) if role=="Minister"
egen medianMinisterWords = median(ministerWords) if role=="Minister"
*just getting the most extreme
gen ministerOutlierWords = lastname1 if abs(ministerWords-medianMinisterWords) > 3*iqrMinisterWords


egen iqrOtherPartiesWords = iqr(otherPartiesWords) if role=="Other Party Member"
egen medianOtherPartiesWords = median(otherPartiesWords) if role=="Other Party Member"
*just getting the most extreme
gen otherPartiesOutlierWords = lastname1 if abs(otherPartiesWords-medianOtherPartiesWords) > 3*iqrOtherPartiesWords


egen iqrOppositionWords = iqr(oppositionWords) if role == "Opposition Member"
egen medianOppositionWords = median(oppositionWords) if role == "Opposition Member"
*just getting the most extreme
gen oppositionOutlierWords = lastname1 if abs(oppositionWords-medianOppositionWords) > 4*iqrOppositionWords


egen iqrBackbencherWords = iqr(backbencherWords) if role == "Government Backbencher"
egen medianBackbencherWords = median(backbencherWords) if role == "Government Backbencher"
*just getting the most extreme
gen backbencherOutlierWords = lastname1 if abs(backbencherWords-medianBackbencherWords) > 6*iqrBackbencherWords


egen iqrIndependentWords = iqr(independentWords) if role == "Independent"
egen medianIndependentWords = median(independentWords) if role == "Independent"
*just getting the most extreme
gen independentOutlierWords = lastname1 if abs(independentWords-medianIndependentWords) > 5*iqrIndependentWords


egen iqrParlSecretaryWords = iqr(parlSecretaryWords) if role == "Parliamentary Secretary"
egen medianParlSecretaryWords = median(parlSecretaryWords) if role == "Parliamentary Secretary"
*just getting the most extreme
gen parlSecretaryOutlierWords = lastname1 if abs(parlSecretaryWords-medianParlSecretaryWords) > 3.5*iqrParlSecretaryWords


egen iqrOtherCriticWords = iqr(otherCriticWords) if role == "Other Party Critic"
egen medianOtherCriticWords = median(otherCriticWords) if role == "Other Party Critic"
*just getting the most extreme
gen otherCriticOutlierWords = lastname1 if abs(otherCriticWords-medianOtherCriticWords) > 3.5*iqrOtherCriticWords

egen iqrOppositionCriticWords = iqr(oppositionCriticWords) if role == "Opposition Critic"
egen medianOppositionCriticWords = median(oppositionCriticWords) if role == "Opposition Critic"
*just getting the most extreme
gen oppositionCriticOutlierWords = lastname1 if abs(oppositionCriticWords-medianOppositionCriticWords) > 3*iqrOppositionCriticWords

egen iqrOtherLeaderWords = iqr(otherLeaderWords) if role == "Other Party Leader"
egen medianOtherLeaderWords = median(otherLeaderWords) if role == "Other Party Leader"
*just getting the most extreme
gen otherLeaderOutlierWords = lastname1 if abs(otherLeaderWords-medianOtherLeaderWords) > 3*iqrOtherLeaderWords



*PC
cd "C:\Users\chris\Dropbox\Projects\politics of Legislative Debate\Final Submission\"

*Macbook
*cd "/Users/chriscochrane/Dropbox/Projects/politics of Legislative Debate/Final Submission/"


preserve

drop if role=="Speaker"

bysort pid role: sample 1, count
**Taking one for each pid and role for boxplot.  To prevent multiple counting
**in the boxplot, setting all speechCounts to NA except for those counting format
**for that role!

replace primeMinisterSpeeches = . if role ~= "Prime Minister"
replace pmOutlier = "" if role ~= "Prime Minister"
replace ministerSpeeches = . if role ~= "Minister"
replace ministerOutlier = "" if role ~= "Minister"
replace parlSecretarySpeeches = . if role ~= "Parliamentary Secretary"
replace parlSecretaryOutlier = "" if role ~= "Parliamentary Secretary"
replace backbencherSpeeches = . if role ~= "Government Backbencher"
replace backbencherOutlier = "" if role ~= "Government Backbencher"
replace leaderOppositionSpeeches = . if role ~= "Opposition Leader"
replace oppositionSpeeches = . if role ~= "Opposition Member"
replace oppositionOutlier = "" if role ~= "Opposition Member"
replace otherPartiesSpeeches = . if role ~= "Other Party Member"
replace otherPartiesOutlier = "" if role ~= "Other Party Member"
replace independentSpeeches = . if role ~= "Independent"
replace independentOutlier = "" if role ~= "Independent"
replace otherCriticSpeeches = . if role ~= "Other Party Critic"
replace otherCriticOutlier = "" if role ~= "Other Party Critic"
replace oppositionCriticSpeeches = . if role ~= "Opposition Critic"
replace oppositionCriticOutlier = "" if role ~= "Opposition Critic"
replace otherLeaderSpeeches = . if role ~= "Other Party Leader"
replace otherLeaderOutlier = "" if role ~= "Other Party Leader"



replace primeMinisterWords = . if role ~= "Prime Minister"
replace pmOutlierWords = "" if role ~= "Prime Minister"
replace ministerWords = . if role ~= "Minister"
replace ministerOutlierWords = "" if role ~= "Minister"
replace parlSecretaryWords = . if role ~= "Parliamentary Secretary"
replace parlSecretaryOutlierWords = "" if role ~= "Parliamentary Secretary"
replace backbencherWords = . if role ~= "Government Backbencher"
replace backbencherOutlierWords = "" if role ~= "Government Backbencher"
replace leaderOppositionWords = . if role ~= "Opposition Leader"
replace oppositionWords = . if role ~= "Opposition Member"
replace oppositionOutlierWords = "" if role ~= "Opposition Member"
replace otherPartiesWords = . if role ~= "Other Party Member"
replace otherPartiesOutlierWords = "" if role ~= "Other Party Member"
replace independentWords = . if role ~= "Independent"
replace independentOutlierWords = "" if role ~= "Independent"
replace otherCriticWords = . if role ~= "Other Party Critic"
replace otherCriticOutlierWords = "" if role ~= "Other Party Critic"
replace oppositionCriticWords = . if role ~= "Opposition Critic"
replace oppositionCriticOutlierWords = "" if role ~= "Opposition Critic"
replace otherLeaderWords = . if role ~= "Other Party Leader"
replace otherLeaderOutlierWords = "" if role ~= "Other Party Leader"


outsheet pid role Gender Experience lastname1 ministerSpeeches primeMinisterSpeeches parlSecretarySpeeches backbencherSpeeches leaderOppositionSpeeches oppositionSpeeches otherPartiesSpeeches independentSpeeches otherCriticSpeeches oppositionCriticSpeeches otherLeaderSpeeches pmOutlier ministerOutlier otherPartiesOutlier oppositionOutlier backbencherOutlier independentOutlier parlSecretaryOutlier otherCriticOutlier oppositionCriticOutlier otherLeaderOutlier ministerWords primeMinisterWords parlSecretaryWords backbencherWords leaderOppositionWords oppositionWords otherPartiesWords independentWords otherCriticWords oppositionCriticWords otherLeaderWords pmOutlierWords  ministerOutlierWords otherPartiesOutlierWords oppositionOutlierWords backbencherOutlierWords independentOutlierWords parlSecretaryOutlierWords otherCriticOutlierWords oppositionCriticOutlierWords otherLeaderOutlierWords anySpeakerRole using "rolesData.csv", comma replace
restore




**Gendered Speech Count, Major Parties

encode(currentParty), gen(party3)
recode party3 (7=2) (8=2) (1=.) (3=.) (4=.) (9=.)


*Gendered speech count

*words by gender

gen femaleWords = wordsToday if Gender=="F"
egen femaleWordsTotal = total(femaleWords)
egen wordsTotal = total(wordsToday)
gen femaleWordProportionTotal = femaleWordsTotal/wordsTotal

*words by gender and party (all parliaments)
bysort party3: gen femaleWordsParty = wordsToday if Gender=="F"
bysort party3: egen femaleWordsPartyTotal = total(femaleWordsParty)
bysort party3: egen wordsTotalParty = total(wordsToday)
bysort party3: gen femaleWordPartyProportion = femaleWordsPartyTotal/wordsTotalParty

*words by gender and party (42 parliament)
bysort party3: gen femaleWordsParty42p = wordsToday if Gender=="F" & parliament==42
bysort party3: egen femaleWordsPartyTotal42p = total(femaleWordsParty42p)
bysort party3: egen wordsPartyTotal42p = total(wordsToday) if parliament==42
bysort party3: gen femaleWordPartyProportion42p = femaleWordsPartyTotal42p/wordsPartyTotal42p

*speeches by gender
gen femaleSpeeches = speechesToday if Gender=="F"
egen femaleSpeechesTotal = total(femaleSpeeches)
egen speechesTotal = total(speechesToday)
gen femaleSpeechesProportionTotal = femaleSpeechesTotal/speechesTotal

*speeches by gender and party 
bysort party3: gen femaleSpeechesParty = speechesToday if Gender=="F"
bysort party3: egen femaleSpeechesPartyTotal = total(femaleSpeechesParty)
bysort party3: egen speechesPartyTotal = total(speechesToday)
bysort party3: gen femaleSpeechesPartyPropTotal = femaleSpeechesPartyTotal/speechesPartyTotal

*speeches by gender and party (42 parliament)

bysort party3: gen femaleSpeechesParty42 = speechesToday if Gender=="F" & parliament==42
bysort party3: egen femaleSpeechesPartyTotal42 = total(femaleSpeechesParty42)
gen speechesToday42 = speechesToday if parliament==42
bysort party3: egen speechesPartyTotal42 = total(speechesToday42)
bysort party3: gen femaleSpeechesPartyPropTotal42 = femaleSpeechesPartyTotal42/speechesPartyTotal42


encode(Gender), gen(Female)
recode Female 2=0
label define fem2 1 "Female" 0 "Male", replace
label values Female fem2

bysort party3: egen femaleProp = mean(Female)
gen female42 = Female if parliament==42
bysort party3: egen femaleProp42 = mean(female42)




preserve
**
*reshaping data for bargraph in ggplot2.  
*creating long data, for gender, indicators, and parliaments, for facet bar graph
drop if party3 == . 
drop if parliament ~= 42
bysort party3: sample 6, count
bysort party3: egen counter = seq(), f(1) t(6)
gen femValueIndicator = ""
gen femValue = .
gen parliamentIndicator = ""

replace parliamentIndicator = "34th-42nd Parliament (1988-2019)" if counter <4
replace parliamentIndicator = "42nd Parliament (2015-2019)" if counter >3

replace femValue = femaleWordPartyProportion if counter==1
replace femValueIndicator = " % Words by Females " if counter==1
replace femValue = femaleSpeechesPartyPropTotal if counter==2
replace femValueIndicator = " % Speeches by Females " if counter==2
replace femValue = femaleProp if counter==3
replace femValueIndicator = " % Female MPs " if counter==3

replace femValue = femaleWordPartyProportion42p if counter==4
replace femValueIndicator = " % Words by Females " if counter==4
replace femValue = femaleSpeechesPartyPropTotal42 if counter==5
replace femValueIndicator = " % Speeches by Females " if counter==5
replace femValue = femaleProp42 if counter==6
replace femValueIndicator = " % Female MPs " if counter==6


outsheet party3 femValue femValueIndicator parliamentIndicator using "femaleData.csv", comma replace

restore




preserve
drop if role == "Speaker"
bysort pid date2: sample 1, count
outsheet currentParty Gender role Experience wordsToday speechesToday anySpeakerRole using "fullData.csv", comma replace
restore


bysort pid: egen maxExperience = max(Experience)
bysort date2 currentParty: egen partySize = count(pid)





***************************************************
***************************************************
** Multivariate Analysis
***************************************************
***************************************************


encode pid, gen(id)
tsset id date2

encode role, gen(roleShort)
recode roleShort (5=1) (4=1) (11=2) (3=2) (6=3) (1=4) (7/8=5) (9=6) (2=7) (10=8) (12=9)

label define roleShort2 1 "Opposition Frontbencher" ///
                        2 "Government Frontbencher" ///
						3 "Opposition Backbencher" ///
						4 "Government Backbencher" ///
						5 "Other Party Frontbencher" ///
						6 "Other Party Backbencher" ///
						7 "Independent" ///
						8 "Parliamentary Secretary" ///
						9 "Speaker", replace
 						


label values roleShort roleShort2


gen partyFamily = .

replace partyFamily = 1 if currentParty == "New Democratic Party"

replace partyFamily = 2 if currentParty == "Green Party of Canada"

replace partyFamily = 3 if currentParty == "Bloc Quebecois"

replace partyFamily = 4 if currentParty == "Liberal Party of Canada"

replace partyFamily = 5 if currentParty== "Conservative Party of Canada" | ///
                           currentParty=="Progressive Conservative Party" | ///
						   currentParty=="Reform Alliance"

replace partyFamily = 6 if currentParty == "Very Minor Party" | ///
                           currentParty == "Independent"


label define partyFamily 1 "Soc.Dem." ///
                         2 "Green" ///
						 3 "Regional" ///
						 4 "Liberal" ///
						 5 "Conservative" ///
						 6 "Other/None", replace
						 

label values partyFamily partyFamily
                       						   
tab partyFamily, gen(partyFamily)						   

rename partyFamily1 SocialDemocratic
rename partyFamily2 Green			
rename partyFamily3 Regional
rename partyFamily4 Liberal
rename partyFamily5 Conservative
rename partyFamily6 OtherNone			   
						   
label variable SocialDemocratic "Social Democratic"
label variable Green "Green"
label variable Regional "Regional"
label variable Liberal "Liberal"
label variable Conservative "Conservative"
label variable OtherNone "Other/None"

gen Experience2 = Experience^2
gen Experience3 = Experience^3

tab roleShort, gen(roleShort)

rename roleShort1 oppositionFront
rename roleShort2 govtFront
rename roleShort3 oppositionBack
rename roleShort4 govtBack
rename roleShort5 otherPartyFront
rename roleShort6 otherPartyBack
rename roleShort7 independent
rename roleShort8 parlSecretary


***SPEECHES


gen ageyrs2 = ageyrs^2
gen ExperienceLog = ln(Experience)

nbreg speechesToday Male1 ageyrs ageyrs2 ExperienceLog govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize SocialDemocratic Green Regional Conservative OtherNone if role~="Speaker", cluster(pid)

nbreg speechesToday Male1 ageyrs ageyrs2 ExperienceLog govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize if e(sample), cluster(pid)

nbreg speechesToday Male1 ageyrs ageyrs2 ExperienceLog govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary if e(sample), cluster(pid)

nbreg speechesToday Male1 ageyrs ageyrs2 ExperienceLog if e(sample), cluster(pid)

nbreg speechesToday Male1 ageyrs ageyrs2 if e(sample), cluster(pid)



*****WORDS



* (May 18) Request to change DV to ratio of number of words spoken divided by 
* number of days in the legislature.  CC NOTE: Our data are structured to count
* words spoken by each MP each day, and to assign a 0 to all days where the MP
* is elible to be in the house, and yet does not speak.  Therefore, the ratio of
* words spoken over days in the house is the sum of words spoken divided bysort
* the number of days in the house, or, in other  words, the average number of 
* words spoken for each MP each day. CC suggests averaging across categories
* of the key IV.  

bysort pid roleShort partyFamily: egen wordsAvg = mean(wordsToday)

* Asked to drop exposure (ExperienceLog)

reg wordsAvg Male1 ageyrs ageyrs2 govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize SocialDemocratic Green Regional Conservative OtherNone if role~="Speaker", cluster(pid)

reg wordsAvg Male1 ageyrs ageyrs2 govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize if e(sample), cluster(pid)

reg wordsAvg Male1 ageyrs ageyrs2 govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary if e(sample), cluster(pid)

reg wordsAvg Male1 ageyrs ageyrs2 if e(sample), cluster(pid)

reg wordsAvg Male1 ageyrs ageyrs2 if e(sample), cluster(pid)


****Setting variable labels to match what's called below

gen gender = Male1
label define genderLab 0 "Male" 1 "Female"
label values gender genderLab

clonevar party_family = partyFamily
encode pid, gen(MP_ID)

gen Speeches = speechesToday 
gen Words = wordsToday


*Convert Seniority to Years
gen Seniority = floor(Experience/365.25)


**The Politics of Legislative Debates**
**November 2019**
**jorge.fernandes@ics.ulisboa.pt**

*Please read carefully what follows:
*We strongly suggest that you run the do-file using Stata 16, not least because we use frames (equivalent to objects in R). This will make your life much easier. Note that you can, of course, run the figures using Stata 15, as long as you prepare the data matrix manually.
*Before producing the figures, please run the following command to install coefplot
ssc install coefplot, replace
*Please use the font file that we have sent you via email. Just click in the file named 'minionpro-subh.otf' Both in Windows and iOs it will automatically make the font available in Stata.
*After having installed the font, run the following command
graph set window fontface MinionPro-Subh

*The next step is to set the working directory. Please set yours
*Next, put the scheme file that I have sent via email in the working directory and then run the following command
* Scheme
*cd "/Users/chriscochrane/Dropbox/Projects/politics of Legislative Debate/Final Submission/"

*PC
cd "C:\Users\chris\Dropbox\Projects\politics of Legislative Debate\Final Submission\"

run "scheme.do"

preserve

**Figure 1**
* Gender Participation in Legislative Debates
* Prepare data
frame put _all, into(party_gender)
frame party_gender{
	collapse (count) MP_ID (sum) Speeches Words, by(party_family gender)

	reshape wide MP_ID Speeches Words, i(party_family) j(gender)
	rename (MP_ID0 Speeches0 Words0) (men Speeches_men Words_men)
	rename (MP_ID1 Speeches1 Words1) (women Speeches_women Words_women)

	egen mp = rowtotal(men women)
	egen speeches_total = rowtotal(Speeches_*)
	replace men = men / mp
	replace women = women / mp
	replace Speeches_men = Speeches_men / speeches_total
	replace Speeches_women = Speeches_women / speeches_total

	egen words_total = rowtotal(Words_*)
	replace Words_women = Words_women / words_total
    
	bysort party_family: sum  Speeches_women Words_women women
	
	* Figure 1
	graph bar Speeches_women Words_women women, over(party_family) ///
		legend(order(1 "% Speeches" 2 "% Words" 3 "% of Women in Legislative Party") row(1)) ///
		ytitle("Percentage") ///
		bar(1, `baropt') bar(2, `baropt') bar(3, `baropt') ///
		b1title("Party family") plotregion(margin(medium))
}

frame drop party_gender

restore




preserve
bysort pid speechdate: sample 1, count
**Before 42
tab Gender if parliament < 42

**Current ParlInfo
tab Gender if parliament ==42
bysort currentParty: tab Gender if parliament ==42

**All Parliaments
bysort currentParty: tab Gender
restore


** Seniority and Participation in Legislative Debates
* Prepare data
frame put gender Speeches Seniority, into(part_seniority)
frame part_seniority{
	gen c = "."
	replace c = "0" if(Seniority == 0)
	replace c = "1" if(Seniority == 1)
	replace c = "2" if(Seniority == 2)
	replace c = "3" if(Seniority == 3)
	replace c = "4+" if(Seniority >= 4)

	collapse (mean) Speeches, by(c gender)
	reshape wide Speeches, i(c) j(gender)
	rename (Speeches0 Speeches1) (Men Women)
	
	
	bysort c: sum Men Women

	* Figure 2
	graph bar (sum) Men Women, ///
	legend(order(1 "Men" 2 "Women")) ///
	over(c) plotregion(margin(medium)) b1title("Seniority") ///
	bar(1, `baropt') bar(2, bstyle(p3bar) fcolor("70 70 70") `baropt')
}

frame drop part_seniority

*** Analysis***
grstyle set color black
local display msize(medsmall) lwidth(vvthin) grid(none) ylabel(, noticks)
local ci ciopts(lwidth(vthin medthin) lcolor(black%50 black%100)) citop

**IMPORTANT: the following analysis contains covariates that are meant to be used as an example. Please the covariates according to the general document of instructions that we have provided previously**


** Negative Binomial Regression
*nbreg Speeches gender electoral_position government leader_PPG comchair i.party_family, *cluster(MP_ID)



nbreg speechesToday gender ageyrs ageyrs2 ExperienceLog govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize SocialDemocratic Green Regional Conservative OtherNone if role~="Speaker", cluster(pid)


coefplot, ci(99 95) aspect(1) drop(_cons) xline(0, lpattern(shortdash) lcolor(black)) rename( /// 
	gender  = "Gender" ///
	ageyrs = "Age" ///
	ageyrs2 = "Age^2" ///
	ExperienceLog = "Seniority (Log)" ///
	partySize = "Electoral Position" ///
	govtFront = "Government Frontbencher" ///
	oppositionFront = "Opposition Frontbencher" ///
	oppositionBack = "Opposition Backbencher" ///
	otherPartyFront = "Other Party Frontbencher" ///
	otherPartyBack = "Other Party Backbencher" ///
	independent = "Independent" ///
	parlSecretary = "Parliamentary Secretary" ///
	SocialDemocratic = "Social Democratic" ///
	Green = "Green" ///
	Regional = "Regional" ///
	Conservative = "Conservative" ///
	OtherNone = "Other Party" ///
	) `display' `ci'
	
est store nbreg
graph save "Figure 3A - Speeches Coefs", replace

** OLS*
*reg Words gender electoral_position government leader_PPG comchair i.party_family, cluster(MP_ID)

reg wordsAvg gender ageyrs ageyrs2 govtFront oppositionFront  oppositionBack otherPartyFront otherPartyBack independent parlSecretary partySize SocialDemocratic Green Regional Conservative OtherNone if role~="Speaker", cluster(pid)


coefplot, ci(99 95) aspect(1) drop(_cons) xline(0, lpattern(shortdash) lcolor(black)) rename( /// 
	gender  = "Gender" ///
	ageyrs = "Age" ///
	ageyrs2 = "Age^2" ///
	ExperienceLog = "Seniority (Log)" ///
	partySize = "Electoral Position" ///
	govtFront = "Government Frontbencher" ///
	oppositionFront = "Opposition Frontbencher" ///
	oppositionBack = "Opposition Backbencher" ///
	otherPartyFront = "Other Party Frontbencher" ///
	otherPartyBack = "Other Party Backbencher" ///
	independent = "Independent" ///
	parlSecretary = "Parliamentary Secretary" ///
	SocialDemocratic = "Social Democratic" ///
	Green = "Green" ///
	Regional = "Regional" ///
	Conservative = "Conservative" ///
	OtherNone = "Other Party" ///
	) `display' `ci'
est store ols
graph save "Figure 3B - Words Coefs.gph", replace







