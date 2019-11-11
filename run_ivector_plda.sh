#!/bin/bash

. ./cmd.sh
. ./path.sh

set -e
plpdir=`pwd`/plp
vaddir=`pwd`/plp
num_components=2048 # Larger than this doesn't make much of a difference.
ivector_dim=600
nj=24
root=/data00/home/labspeech_intern/intern/liruyun/tf-kaldi-speaker/egs/voxceleb/ivector_no_music
outdir=/mnt/cephfs_new_wj/lab_speech/home/liry/WorkSpace/Voxceleb/ivector
data=$root/data
trainset=train
testset=test.dalai
trials=$data/$testset/trials
#exp=$outdir/exp
exp=exp
mfccdir=$outdir/mfcc
vaddir=$outdir/mfcc
voxceleb1_trials=$$data/$testset.dalai/trials
# steps/make_plp.sh --nj $nj --cmd "$train_cmd" \
#   $data/$trainset $exp/make_plp $plpdir
# steps/make_plp.sh --nj $nj --cmd "$train_cmd" \
#   $data/$testset $exp/make_plp $plpdir
# echo "finish"
# for name in $trainset $testset; do
#   utils/fix_data_dir.sh data/${name}
# done
# 
# sid/compute_vad_decision.sh --nj $nj --cmd "$train_cmd" \
#   $data/$trainset $exp/make_vad $vaddir
# sid/compute_vad_decision.sh --nj $nj --cmd "$train_cmd" \
#   $data/$testset $exp/make_vad $vaddir
# 
# for name in $trainset $testset; do
#   utils/fix_data_dir.sh data/${name}
# done
# 
# # Train UBM and i-vector extractor.
# sid/train_diag_ubm.sh --cmd "$train_cmd" \
#   --nj $nj --num-threads $nj \
#   $data/$trainset $num_components \
#   $exp/diag_ubm_$num_components
# 
# sid/train_full_ubm.sh --nj $nj --remove-low-count-gaussians false \
#   --cmd "$train_cmd" $data/$trainset \
#   $exp/diag_ubm_$num_components $exp/full_ubm_$num_components
# 
# sid/train_ivector_extractor.sh --cmd "$train_cmd" --nj $nj --num-threads 1 --num-processes 1\
#   --ivector-dim 600 \
#   --num-iters 5 $exp/full_ubm_$num_components/final.ubm $data/$trainset \
#   $exp/extractor
# 
# # Extract i-vectors.
# sid/extract_ivectors.sh --cmd "$train_cmd" --nj $nj \
#   $exp/extractor $data/$trainset \
#   $exp/ivectors_${trainset}
# 
# sid/extract_ivectors.sh --cmd "$train_cmd" --nj $nj \
#   $exp/extractor $data/$testset \
#   $exp/ivectors_${testset}

## Create a PLDA model and do scoring.
local/plda_scoring_lry.sh $data/$trainset $data/$trainset $data/$testset \
  $exp/ivectors_${trainset} $exp/ivectors_${trainset} $exp/ivectors_${testset} $trials $outdir/scores_gmm_2048_ind_pooled

# GMM-2048 PLDA EER
# ind pooled: 2.26
# ind female: 2.33
# ind male:   2.05
# dep female: 2.30
# dep male:   1.59
# dep pooled: 2.00
echo "GMM-$num_components EER"
eer=`compute-eer <(python local/prepare_for_eer.py $trials $outdir/scores_gmm_2048_ind_pooled/plda_scores) 2> /dev/null`
echo $eer

