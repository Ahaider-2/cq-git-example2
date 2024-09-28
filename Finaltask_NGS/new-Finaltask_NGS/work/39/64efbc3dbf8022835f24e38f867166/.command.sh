#!/bin/bash -ue
trimal -automated1 -in aligned.fasta -out trimmed.fasta -htmlout trim_report.html
mv trimmed.fasta trim_seq_M21012.fasta
mv trim_report.html report_trim_seq_M21012.html
