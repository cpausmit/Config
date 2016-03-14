#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Example on how to pick out a single event from a given dataset.
#
#                                                              stolen from Chad Jarvis and improved
#--------------------------------------------------------------------------------------------------
# specify dataset
dataset=/Mu/Run2010A-PromptReco-v4/RECO

# specify event
  run=143827
 lumi=740
event=1011154107

filename=$(dbsql "find file where run=${run} and lumi=${lumi} and dataset=${dataset} and dataset.status=VALID" | grep store)

rm pickEventTmp.py

cat > pickEventTmp.py <<EOF
import FWCore.ParameterSet.Config as cms

process = cms.Process('PickEvent')
process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(-1)
)
process.source = cms.Source("PoolSource",
  fileNames = cms.untracked.vstring('${filename}'),
  eventsToProcess =
  cms.untracked.VEventRange(cms.untracked.EventRange(${run},${event},${run},${event}))
)
process.output = cms.OutputModule("PoolOutputModule",
  fileName = cms.untracked.string('pick-event_${run}_${event}.root'),
)
process.out_step = cms.EndPath(process.output)

EOF

cmsRun pickEventTmp.py
