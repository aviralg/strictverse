DOWNLOAD_DIR := download
EXTRACT_DIR  := extract
SIGNATURE_DIR := signature
SUGAR_DIR := sugar
DESUGAR_DIR := desugar

DOCKER_RUN := docker run --rm -p 8000:8080 -v $(CURDIR):/home/aviral/strictverse -it --entrypoint /bin/bash aviralgoel/oopsla-2021-r-promisebreaker:latest -c

download:
	mkdir -p $(DOWNLOAD_DIR)
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/readr/readr_1.4.0.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/stringr/stringr_1.4.0.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/purrr/purrr_0.3.4.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_1.1.3.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.3.5.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.7.tar.gz
	#wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/tibble/tibble_3.1.2.tar.gz
	wget -P $(DOWNLOAD_DIR) https://cran.r-project.org/src/contrib/Archive/forcats/forcats_0.5.1.tar.gz

extract:
	mkdir -p $(EXTRACT_DIR)
	tar -zxvf $(DOWNLOAD_DIR)/*.tar.gz --directory $(EXTRACT_DIR)

signature:
	mkdir -p $(SIGNATURE_DIR)
	docker pull aviralgoel/oopsla-2021-r-promisebreaker:latest
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo readr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/readr ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo stringr > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/stringr ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo purrr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/purrr ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo tidyr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/tidyr ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo ggplot2 > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/ggplot2 ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo dplyr > experiment/profile/trace/index/corpus-small;   make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/dplyr ~/strictverse/$(SIGNATURE_DIR)"
	$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo tibble > experiment/profile/trace/index/corpus-small;  make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/tibble ~/strictverse/$(SIGNATURE_DIR)"
	#$(DOCKER_RUN) "cd ~/promisebreaker-experiment; echo forcats > experiment/profile/trace/index/corpus-small; make synthesize-signatures; cp experiment/profile/signature/signature+force+effect+reflection/forcats ~/strictverse/$(SIGNATURE_DIR)"

sugar:
	mkdir -p $(SUGAR_DIR)
	#sugar.R readr $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R stringr $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R purrr $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R tidyr $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R ggplot2 $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R dplyr $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	#sugar.R tibble $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)
	sugar.R forcats $(EXTRACT_DIR) $(SIGNATURE_DIR) $(SUGAR_DIR)

desugar:
	mkdir -p $(DESUGAR_DIR)
	#desugar.R readr $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R stringr $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R purrr $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R tidyr $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R ggplot2 $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R dplyr $(SUGAR_DIR) $(DESUGAR_DIR)
	#desugar.R tibble $(SUGAR_DIR) $(DESUGAR_DIR)
	desugar.R forcats $(SUGAR_DIR) $(DESUGAR_DIR)

.PHONY: download extract signature sugar desugar
