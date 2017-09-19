#! /bin/bash
vcf=$1
config=$2
sampledb=$3
outdir=$4
outfile=$5

export PERL5LIB=${PERL5LIB}
export PATH=${PATH}

perl="/path/to/perl"
vcf2simple="vcf2simple.pl"
vep="/path/to/vep"
vep_cache="/path/to/cache"
screening="/path/to/vcfscreen.pl"

md5vcf=`md5sum $vcf | /bin/awk '{print $1}'`
echo "transfer vcf to site.vcf"
$perl $vcf2simple $vcf $md5vcf.vcf
echo "VEP annotated"
$perl $vep -i $md5vcf.vcf -o $md5vcf.VEP.vcf --offline --dir_cache $vep_cache --vcf --force_overwrite --quiet --fork 10 --hgvs --assembly GRCh37 --everything
echo "screening..."
$perl $screening $md5vcf.VEP.vcf $config $sampledb $outdir $outfile
