#! /usr/bin/env bash
#!/bin/sh -l


#
# Description: Script to consolidate all configuration type settings for quasar pipeline and any tools contained within
# 	Just needs to be sourced within a script to acquire all variables stored within
#
# Usage: . ./config.sh
#
# Output location: No output created
#
# Modules required: None
#
# v1.0.1 (1/17/2020)
#
# Created by Nick Vlachos (nvx4@cdc.gov)
#

# Get hostname to help determine if certain tools can be run and how to specifically get others to run with the right options
hostname=$(hostname -f)
host=$(echo ${hostname} | cut -d'.' -f1)

############# General Options #############

#shortcut to processed samples folder
output_dir="/raid5/MiSeqAnalysisFiles"
# Locations of all scripts and necessary accessory files
src="$(pwd)"
# Local databases that are necessary for pipeline...ANI, BUSCO, star, adapters, phiX
local_DBs="/raid5/Quaisar_databases"
# Scicomp databases that are necessary for pipeline...eventually refseq, kraken, gottcha,

# Number of processors requested by numerous applications within the pipeline
#--------------------Check on how BEST to use ---------------------------------#
procs=12 # Number of processors

# Phred scoring scale to be used (33 or 64)
phred=33


############# Application Specific Options #############

#####BBDUK specific config options #####
#requested memory size block
bbduk_mem=Xmx20g
#Kmer length (1-31). Larger Kmer size results in greater specificity
bbduk_k=31
#hamming distance
bbduk_hdist=1
#location of phiX sequences
phiX_location="${local_DBs}/phiX.fasta"

#####Trimmomatic specific config options #####
#Tells trimmomatic to use single or paired ends
#trim_ends=SE
trim_endtype=PE

#Which scoring scale to use
trim_phred="phred$phred"

#Location of the Adapter FASTA file used for trimming
trim_adapter_location="${local_DBs}/adapters.fasta"

#Seeding mismatches
trim_seed_mismatch=2
#palindrome clip threshold
trim_palindrome_clip_threshold=30
#simple clip threshold
trim_simple_clip_threshold=10
#Minimum adapter length (in palindrome)
trim_min_adapt_length=8
#Keeps read if complete forward and reverse sequences are palindromes
trim_complete_palindrome=TRUE
#Window Size
trim_window_size=20
#Window quality
trim_window_qual=30
#Specifies minimum quality to keep a read
trim_leading=20
#Specifies minimum quality to keep a read
trim_trailing=20
#Specifies minimum length to keep a read
trim_min_length=50

##### SPAdes specific options #####
#Phred quality offset based on scoring used
spades_phred_offset=$phred
#Max memory in Gbs
spades_max_memory=32
#Coverage threshold (positive float, off or auto)
spades_cov_cutoff="auto"

##### ANI specific options #####
#Max number of samples to be kept (not including source sample) when creating the mash tree
max_ani_samples=20

##### c-SSTAR identity options #####
csstar_perfect=100
csstar_ultrahigh=99
csstar_high=98
csstar_medium=95
csstar_low=80
# Change to your liking
csstar_other=40

##### c-SSTAR standard settings #####
#argannot_srst2=$(find ${local_DBs}/star/argannot_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
#echo "ARG Summary found: ${argannot_srst2}"
#resFinder_srst2=$(find ${local_DBs}/star/resFinder_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
#echo "RES Summary found: ${resFinder_srst2}"
#resGANNOT_srst2=$(find ${local_DBs}/star/ResGANNOT_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
#resGANNOT_previous_srst2=$(find ${local_DBs}/star/ResGANNOT_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 2 | tail -n 1)
#echo "ResGANNOT Summary found: ${resGANNOT_srst2}"
ResGANNCBI_srst2=$(find ${local_DBs}/star/ResGANNCBI_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
ResGANNCBI_previous_srst2=$(find ${local_DBs}/star/ResGANNCBI_*_srst2.fasta -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 2 | tail -n 1)
#echo "ResGANNOT Summary found: ${ResGANNCBI_srst2}"
#argannot_srst2_filename=$(echo "${argannot_srst2}" | rev | cut -d'/' -f1 | rev | cut -d'_' -f1,2)
#resFinder_srst2_filename=$(echo "${resFinder_srst2}" | rev | cut -d'/' -f1 | rev | cut -d'_' -f1,2)
#ResGANNOT_srst2_filename=$(echo "${resGANNOT_srst2}" | rev | cut -d'/' -f1 | rev | cut -d'_' -f1,2)
#echo "${ResGANNCBI_srst2}"
ResGANNCBI_srst2_filename=$(echo "${ResGANNCBI_srst2}" | rev | cut -d'/' -f1 | rev | cut -d'_' -f1,2)
#echo "${ResGANNCBI_srst2_filename}"
# gapped (g) versus ungapped(u)
csstar_gapping="g"
# Identity % 100(p), 99(u), 98(h), 95(m), 80(low)
csstar_identity="h"
csstar_plasmid_identity="o"

##### kraken unclassified threshold ######
# Will throw a warning flag during run summary if percent of unclassified reads are above this value
unclass_flag=30
# MiniKraken DB (smaller, but effective option)
kraken_mini_db="${local_DBs}/minikrakenDB/"
#kraken_mini_db="/scicomp/agave/execution/database/public/references/organizations/CDC/NCEZID/kraken/cdc-20171227"
#--------------------Check on how to use ---------------------------------#
kraken_full_db="${scicomp_DBs}/kraken/1.0.0/kraken_db/"
# MiniKraken DB (smaller, but effective option)
kraken2_mini_db="${local_DBs}/minikraken2DB/"
#kraken_mini_db="/scicomp/agave/execution/database/public/references/organizations/CDC/NCEZID/kraken/cdc-20171227"
#--------------------Check on how to use ---------------------------------#
kraken2_full_db="${scicomp_DBs}/kraken/2.0.0/kraken_db/"
### MOVE THESE TO SHARE/DBS
# Kraken normal, specially made by Tom with bacteria,archae, and viruses
# kraken_db="/scicomp/groups/OID/NCEZID/DHQP/CEMB/databases/kraken_BAV_17/"
# alternate one with bacteria, fungus, and viruses
# kraken_db="/scicomp/groups/OID/NCEZID/DHQP/CEMB/databases/kraken_BVF_16/"
contamination_threshold=25

##### gottcha #####
# gottcha DB
gottcha_db="${local_DBs}/gottcha/GOTTCHA_BACTERIA_c4937_k24_u30.species"

##### plasmidFinder ######
#percent identity to match
plasmidFinder_identity=95.00
#percent length minimum (although not found in command line version, yet)
plasmidFinder_length=60
#DB
#plasmidFinder_all_DB=$(find ${local_DBs}/plasmidFinder_DB/all_*.fsa -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
#plasmidFinder_entero_DB=$(find ${local_DBs}/plasmidFinder_DB/enterobacteriaceae_*.fsa -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)
#plasmidFinder_gpos_DB=$(find ${local_DBs}/plasmidFinder_DB/gram_positive_*.fsa -maxdepth 1 -type f -printf '%p\n' | sort -k2,2 -rt '_' -n | head -n 1)


########## Settings used by downstream scripts ##########

##### Project Parser (run_csstar_MLST_project_parser.sh) #####
# Cutoff values when consolidating csstar hits from sets of samples (projects)
# Minimum % length required to be included in report, otherwise gets placed in rejects file
project_parser_Percent_length=90
# Minimum % identity required to be included in report, otherwise gets placed in rejects file
project_parser_Percent_identity=98
# Minimum % length required to be included in report when looking at plasmid assembly, typically more leeway is given to plasmid only hits, otherwise gets placed in rejects file
project_parser_plasmid_Percent_identity=40

if [[ ! -f "./config.sh" ]]; then
	cp ./config_template.sh ./config.sh
fi
