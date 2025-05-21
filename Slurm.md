#!/bin/bash
#
#SBATCH -J train
#SBATCH -N 1
#SBATCH --gres=gpu:7g.94gb:1
#SBATCH --cpus-per-task=10
#SBATCH --mem=32GB
#SBATCH -p production   
#SBATCH --mail-type=ALL
#SBATCH --mail-user=shail.jadav@tuwien.ac.at
 
cd /home/sjadav/projects/ARL_LLM_FINETUNE/
conda activate llm_finetune
conda activate llm_finetune
python3 test_GRPO_3.py --args 0


https://phabricator.ict.tuwien.ac.at/w/ict_servicesandinfrastructure/ict_ml_server/



