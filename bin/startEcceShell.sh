
singularity shell \
   --bind /condor \
   --bind /etc/condor \
   --bind /etc/passwd \
   --bind /cvmfs \
  /cvmfs/eic.opensciencegrid.org/singularity/rhic_sl7_ext.simg
