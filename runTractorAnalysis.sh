#!bin/bash

analysisPath="./ukb_tractor_analysis/"
inputDataPath="./ukb_tractor_analysis/input_data/"
tractorStep2Res="./ukb_tractor_analysis/tractor_step2_results/"
tractorStep3Res="./ukb_tractor_analysis/tractor_step3_results/"

## Create conda environment and install dependencies
#conda create --name tractor_gwas --python=3.9
#conda activate tractor_gwas
#conda install numpy
#conda install pandas
#pip install statsmodel


## Prepare input genotype files
# Convert bgen to pgen
#./plink2 --bgen "$inputDataPath"ukb_hap_chr19_v2.bgen ref-first --oxford-single-chr 19 --sample "$analysisPath"ukb46341_imp_chr1_v3_s487203.sample --keep "$inputDataPath"admixed_samples_chr19_nomiss.txt --make-pgen --out "$inputDataPath"ukb_hap_chr19_v2_admixed_final

# Extract admixed individuals from ukb imputed (phased data) and generate vcf
#./plink2 --bgen "$inputDataPath"ukb_hap_chr19_v2.bgen ref-first --oxford-single-chr 19 --sample "$analysisPath"ukb46341_imp_chr1_v3_s487203.sample --keep "$inputDataPath"admixed_samples_chr19_nomiss.txt --export vcf vcf-dosage=DS --out "$inputDataPath"ukb_hap_chr19_v2_admixed_final

## Run Tractor Step 2: Extract local ancestry tracts 
#python Tractor/ExtractTracts.py --msp "$inputDataPath"pca.chr19.ukb_hap_admixed.mine --vcf "$inputDataPath"ukb_hap_chr19_v2_admixed_final --output-path "$tractorStep2Res"ukb_hap_chr19_v2_admixed_final --num-ancs 2

## Run Tractor Step 3: Ancestry-aware GWAS
#python Tractor/RunTractor.py --hapdose "$tractorStep2Res"ukb_hap_chr19_v2_admixed_final --phe "$inputDataPath"admixed_samples_chr19_nomiss_pheno_tractor.tsv --method linear --out "$tractorStep3"ukb_hap_chr19_v2_admixed_final_ancestry_tractor_gwas_results.txt

## Run GWAS on plink for comparison
#./plink2 --pfile "$inputDataPath"ukb_hap_chr19_v2_admixed_final --pheno "$inputDataPath"admixed_samples_chr19_nomiss_pheno_plink.txt --pheno-name LDL --glm allow-no-covars --out "$analysisPath"ukb_hap_chr19_v2_admixed_final_assoc_stats

## Run GWAS on ancestry-deconvolved genotype data
#./plink2 --vcf "$analysisPath"tractor_step2_results/ukb_hap_chr19_v2_admixed_final.anc0.vcf --vcf-half-call haploid --out "$analysisPath"ukb_hap_chr19_v2_admixed_final_afr --make-pgen --max-alleles 2
#./plink2 --pfile "$analysisPath"ukb_hap_chr19_v2_admixed_final_afr --pheno "$analysisPath"ukb_hap_admixed_ldl_pheno_final_plink_tractor.txt --pheno-name LDL --allow-no-sex --glm allow-no-covars --out "$analysisPath"ukb_hap_chr19_v2_admixed_final_afr --ci 0.95
#./plink2 --vcf "$analysisPath"tractor_step2_results/ukb_hap_chr19_v2_admixed_final.anc3.vcf --vcf-half-call haploid --out "$analysisPath"ukb_hap_chr19_v2_admixed_final_eur --make-pgen --max-alleles 2
#./plink2 --pfile "$analysisPath"ukb_hap_chr19_v2_admixed_final_eur --pheno "$analysisPath"ukb_hap_admixed_ldl_pheno_final_plink_tractor.txt --pheno-name LDL --allow-no-sex --glm allow-no-covars --out "$analysisPath"ukb_hap_chr19_v2_admixed_final_eur --ci 0.95


