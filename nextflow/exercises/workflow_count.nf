process downloadFile {
publishDir "/root/cq-git-example2/nextflow/exercises", mode: 'copy', overwrite: true
output:
path "batch1.fasta"
//which of the things I made are important for others?
"""
wget https://tinyurl.com/cqbatch1 -O batch1.fasta
"""
}

process countSequences {
publishDir "/root/cq-git-example2/nextflow/exercises", mode: 'copy', overwrite: true
output:
path "numseqs.txt"
"""
grep ">" batch1.fasta | wc -l > numseqs.txt
"""
}
workflow {
downloadFile()
countSequences()
}
