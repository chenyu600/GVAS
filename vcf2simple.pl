#! /usr/bin/perl

my ($vcf, $outfile) = @ARGV;

open OT, "> $outfile" or die $!;

print OT "##fileformat=VCFv4.0\n";

open VCF, "$vcf" or die $!;
while(<VCF>){
    chomp;
    next if /^##/;
    print OT "$_\n" if /^#/;
    next if /^#/;
    my ($chr, $pos, $rs, $ref, $alt, $qua, $filter, $info, $format, @sample_infos) = (split /\t/);
    $chr =~ s/chr//;
    my $sample_info = (join "\t", @sample_infos);
    foreach my $allele (split /,/, $alt){
        print OT "chr$chr\t$pos\t$rs\t$ref\t$allele\t$qua\t$filter\tALT=$alt;$info\t$format\t$sample_info\n";
    }
}
close VCF;
