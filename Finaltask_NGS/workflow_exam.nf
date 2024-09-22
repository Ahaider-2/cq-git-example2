nextflow.enable.dsl = 2

// Define parameters

params.accession = "M21012" 
params.out = "${launchDir}/results_${params.accession}"
params.in = "${launchDir}/input_fasta"


process download_reference {
  publishDir "${params.out}", mode: 'copy', overwrite: true
  input:
    val params.accession

  output:
    path "${params.accession}.fasta"

  script:
    """
    wget "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${params.accession}&rettype=fasta&retmode=text" -O ${params.accession}.fasta 
    """
}

// Combine FASTA files
process combine_fasta {
  publishDir "${params.out}", mode: 'copy', overwrite: true
  input:
    path infiles

  output:
    path "combined.fasta"

  script:
    """
    cat ${infiles} > combined.fasta
    """
}

// Align genomes using MAFFT
process align {
  container "https://depot.galaxyproject.org/singularity/mafft%3A7.525--h031d066_0"
  publishDir "${params.out}", mode: 'copy', overwrite: true
  input:
  
    path infile

  output:
    path "aligned.fasta"

  script:
    """
    mafft --quiet --auto ${infile} > aligned.fasta
    """
}

// Trim alignment with trimal

process trimAlignment {
  publishDir "${params.out}", mode: 'copy', overwrite: true
  
  input:
  path infile
  
  output:
    path "trim_seq_${params.accession}.fasta"
    path "report_trim_seq_${params.accession}.html"

  container "https://depot.galaxyproject.org/singularity/trimal%3A1.4.1--h4ac6f70_9"
    
  script:
    """
    trimal -automated1 -in ${infile} -out trimmed.fasta -htmlout trim_report.html
    mv trimmed.fasta trim_seq_${params.accession}.fasta
    mv trim_report.html report_trim_seq_${params.accession}.html
    """
}


workflow {
   
    download_channel = download_reference(params.accession)

    input_channel = Channel.fromPath("${params.in}/*.fasta")
	
    combined_channel = download_channel.concat(input_channel)
	
    combine_fasta(combined_channel) | align | trimAlignment
}
