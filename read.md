<u>**Dalai:**</u>
67: /data00/home/labspeech_intern/intern/liruyun/tf-kaldi-speaker/egs/voxceleb/ivector_no_music/run_ivector_plda.sh

trainset: data/train(train_no_music)
testset: data/test.dalai
i-vector: exp/ivectors_test.dalai exp/ivectors_train
PLDA score : /mnt/cephfs_new_wj/lab_speech/home/liry/WorkSpace/Voxceleb/ivector/scores_gmm_2048_ind_pooled

```
num_components=2048
ivector_dim=600
train i-vector : sid/train_ivector_extractor.sh

# create mean.vec, transform.mat, plda
plda score : local/plda_scoring_lry.sh
input arguments: (plda, enroll, test)
plda_data_dir=$1
enroll_data_dir=$2
test_data_dir=$3
plda_ivec_dir=$4
enroll_ivec_dir=$5
test_ivec_dir=$6
trials=$7
scores_dir=$8
output:
plda_ivec_dir/plda, transform.mat, mean.vec (current dir)

```
