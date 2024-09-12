process downloadFile {
publishDir "/root/cq-git-example2/nextflow/exercises", mode: 'copy', overwrite: true
output:
path "blub.fasta"
//which of the things I made are important for others?
"""
wget https://tinyurl.com/cqbatch1 -O blub.fasta
"""
}

process countSequences {
publishDir "/root/cq-git-example2/nextflow/exercises", mode: 'copy', overwrite: true
input:
path infile
output:
path "numseqs.txt"
"""
grep ">" $infile | wc -l > numseqs.txt
"""
}
workflow {
downloadFile | countSequences
}
