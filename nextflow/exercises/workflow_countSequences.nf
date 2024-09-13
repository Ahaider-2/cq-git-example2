process countSequences {
publishDir "/root/cq-git-example2/nextflow/exercises", mode: 'copy', overwrite: true
output:
path "numseqs.txt"
"""
grep ">" batch1.fasta | wc -l > numseqs.txt
"""
}
workflow {
countSequences()
}