DOWNLOAD_DIR := download
EXTRACT_DIR  := extract
SIGNATURE_DIR := signature
SUGAR_DIR := sugar
DESUGAR_DIR := desugar
RESULT_DIR := result
PACKAGES := readr stringr purrr tidyr ggplot2 dplyr tibble forcats

DOCKER_RUN := docker run --rm -p 8000:8080 -v $(CURDIR):/home/aviral/strictverse -it --entrypoint /bin/bash aviralgoel/oopsla-2021-r-promisebreaker:latest -c

R := R
R_VANILLA := ~/promisebreaker-experiment/dependency/R-vanilla/bin/R

download:
	mkdir -p $(DOWNLOAD_DIR)
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/readr/readr_1.4.0.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/stringr/stringr_1.4.0.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/purrr/purrr_0.3.4.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_1.1.3.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.3.5.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.7.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/tibble/tibble_3.1.2.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/forcats/forcats_0.5.1.tar.gz

extract:
	mkdir -p $(EXTRACT_DIR)
	for f in `ls $(DOWNLOAD_DIR)/*.tar.gz`; do tar -zxvf "$$f" --directory $(EXTRACT_DIR); done

signature:
	mkdir -p $(SIGNATURE_DIR)
	docker pull aviralgoel/oopsla-2021-r-promisebreaker:latest
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo readr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/readr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo stringr > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/stringr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo purrr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/purrr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo tidyr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/tidyr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo ggplot2 > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/ggplot2 ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo dplyr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/dplyr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo tibble > experiment/profile/trace/index/corpus-small;  make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/tibble ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo forcats > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/forcats ~/strictverse/$(SIGNATURE_DIR)"

sugar:
	mkdir -p $(SUGAR_DIR)
	for package in $(PACKAGES); do \
		$(R) --file=sugar.R --args $$package $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR); \
	done;

desugar:
	mkdir -p $(DESUGAR_DIR)
	for package in $(PACKAGES); do \
		$(R) --file=desugar.R --args $$package $(SUGAR_DIR) $(DESUGAR_DIR); \
	done;

test:
	#$(DOCKER_RUN) "$(R_VANILLA) -e 'install.packages(\"decor\");'"
	mkdir -p $(RESULT_DIR)
	for package in $(PACKAGES); do \
		$(DOCKER_RUN) "$(R_VANILLA) --file=/home/aviral/strictverse/test.R --args /home/aviral/strictverse/$(EXTRACT_DIR) /home/aviral/strictverse/$(RESULT_DIR) $$package lazy.fst"; \
		$(DOCKER_RUN) "$(R_VANILLA) --file=/home/aviral/strictverse/test.R --args /home/aviral/strictverse/$(DESUGAR_DIR) /home/aviral/strictverse/$(RESULT_DIR) $$package strict.fst"; \
	done;

analyze:
	analyze.R $(RESULT_DIR)

.PHONY: download extract signature sugar desugar test analyze
