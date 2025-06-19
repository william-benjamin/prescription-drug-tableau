WITH drugs_by_zip AS (
       SELECT   nppes_provider_zip5 AS zip, drug_name, 
                SUM(total_claim_count) AS total_prescriptions
       FROM     prescriber
       JOIN     prescription
          USING(npi)
       GROUP BY zip, drug_name
       ORDER BY zip, drug_name
),
    counts_per_zip AS 
	   (SELECT drugs_by_zip.*,
              (CASE WHEN opioid_drug_flag = 'Y' THEN total_prescriptions
	           ELSE NULL END) AS opioid_count,
	          (CASE WHEN long_acting_opioid_drug_flag = 'Y' THEN total_prescriptions
	           ELSE NULL END) AS long_acting_opioid_count,
              (CASE WHEN antibiotic_drug_flag = 'Y' THEN total_prescriptions
	           ELSE NULL END) AS antibiotic_count,
	          (CASE WHEN antipsychotic_drug_flag = 'Y' THEN total_prescriptions
	           ELSE NULL END) AS antipsychotic_count
               FROM   drug
               JOIN   drugs_by_zip
                 USING(drug_name)
)
SELECT   zip, SUM(total_prescriptions) AS prescriptions,
         SUM(opioid_count) AS opiods, SUM(antibiotic_count) AS antibiotics,
		 SUM(long_acting_opioid_count) AS long_acting_opiods
		 SUM(antipsychotic_count) AS antipsychotics
FROM     counts_per_zip
GROUP BY zip
;
