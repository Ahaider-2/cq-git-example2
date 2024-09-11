nextflow.enable.dsl=2
process downloadFile {
// What should the worker do?
"""

wget https://tinyurl.com/cqbatch1 -O batch1.fasta
"""
}
workflow {
downloadFile()
}