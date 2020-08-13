CREATE OR REPLACE VIEW zim_wash_5w_googlesheet_cumulative_final_province AS
SELECT province,reporting_period,assisted,girls_assisted,boys_assisted,female_assisted,male_assisted,
string_agg(DISTINCT lead_org, ',') AS lead_agency,
COUNT(DISTINCT(lead_org)) AS agencies,
string_agg(DISTINCT imp_partner, ',') AS implementing_partner,
COUNT(DISTINCT(imp_partner)) AS no_ips,
string_agg(DISTINCT status_1, ',') AS status,
string_agg(DISTINCT beneficiary_type, ',') AS bene_type,
string_agg(DISTINCT district, ',') AS district,
string_agg(DISTINCT ward, ',') AS ward,
string_agg(DISTINCT modality_type, ',') AS delivery_modality,
string_agg(DISTINCT funding_source, ',') AS donor,
SUM(no_girls_targ) as girls_targeted,
SUM(no_male_targ) as male_targeted,
SUM(no_female_targ) as female_targeted,
SUM(no_boys_targ) as boys_targeted,
SUM(CAST(people_targ AS INTEGER)) as targeted,
string_agg(DISTINCT comments_1, ',') AS comments,
indicator

FROM(
SELECT indicator, province, reporting_period,lead_org,imp_partner,status as status_1,beneficiary_type,district,ward,modality_type,funding_source,no_girls_targ, no_male_targ,
no_female_targ,no_boys_targ,people_targ,comments as comments_1,
SUM(people_reached) over (partition by province ORDER BY reporting_period) as assisted,
SUM(no_girls_reached) over (partition by province ORDER BY reporting_period) as girls_assisted,
SUM(no_boys_reached) over (partition by province ORDER BY reporting_period) as boys_assisted,
SUM(no_female_reached) over (partition by province ORDER BY reporting_period) as female_assisted,
SUM(no_male_reached) over (partition by province ORDER BY reporting_period) as male_assisted

FROM zim_wash_5w_googlesheet_cumulative) as foo
WHERE reporting_period IS NOT NULL and province IS NOT NULL and indicator = '# of people with access to safe drinking water'
GROUP BY province,reporting_period,assisted,girls_assisted,boys_assisted,female_assisted,male_assisted,indicator
ORDER BY reporting_period