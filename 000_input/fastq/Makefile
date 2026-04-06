# Docker command for SRA Toolkit (fasterq-dump)
SRA := docker run --rm -u $(id -u):$(id -g) \
	-v $(PWD):/trans -w /trans/000_input/fastq \
	ncbi/sra-tools:3.0.0

# Optional: prefetch (recommended for stability)
PREFETCH := docker run --rm -u $(id -u):$(id -g) \
	-v $(PWD):/trans -w /trans/000_input/fastq \
	ncbi/sra-tools:3.0.0 prefetch

# Output fastq files (paired-end assumed)
%_1.fastq %_2.fastq: sample_names.txt
	$(PREFETCH) $*
	$(SRA) fasterq-dump --split-files $* --outdir .

# Rule to trigger all downloads
SAMPLES := $(shell cat sample_names.txt)

download: $(SAMPLES:%=%_1.fastq)
