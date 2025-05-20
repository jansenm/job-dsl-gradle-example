THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))

-include Makefile.config

DIFF ?= diff -r

ifndef VERBOSE
.SILENT:
endif

.DEFAULT_GOAL = test


##
## GENERATE JOBS
## ==========================================================================

## test                     ~# ./gradlew test
test: test-before test-do test-after
test-do:
	@echo "  ~# gradlew test"
	./gradlew test

## check                    ~# ./gradlew check
check: check-before check-do check-after
check-do:
	@echo "  ~# gradlew check"
	./gradlew check

## init                     run tests, on success update reference
init: init-before test checkpoint init-after

## init                     run tests, compare with reference
diff: diff-before test show-diff diff-after

## show diff                diff build/debug-xml and reference/
show-diff:
	$(DIFF) build/debug-xml/ reference/

## checkpoint               ~# cp build/debug.xml reference
checkpoint: checkpoint-before reference checkpoint-do checkpoint-after
checkpoint-do: reference
	@echo "  sync build-results to reference"
	rsync --verbose --archive build/debug-xml/. reference/.

##
## CLEANUP
## ==========================================================================

## clean                    clean build-results
clean: clean-before clean-do clean-after
clean-do:
	@echo "  ~# rm -rf build/"
	rm -rf build/

## very-clean               clean build-results and reference
very-clean: very-clean-before clean-do very-clean-do reference very-clean-after
very-clean-do:
	@echo "  ~# rm -rf reference/"
	rm -rf reference

## maintainer-clean         clean build-results, reference and cache
maintainer-clean: maintainer-clean-before clean-do very-clean-do maintainer-clean-do reference maintainer-clean-after
maintainer-clean-do:
	@echo "  ~# rm -rf .gradle/ target/"
	rm -rf .gradle/ target/

##
## HELPER
## ==========================================================================

## reference                ~# mkdir reference
reference:
	@echo "  ~# mkdir -p reference"
	mkdir -p reference

##
## ENVIRONMENT VARIABLES
## ==========================================================================

## VERBOSE                  If defined print all commands

##
## MISCELLANOUS
##

## help                     Show help for the Makefile
help:
	set -x ; \
	sed -n -e "s/^## \?\(.*\)/\1/p" "$(THIS_MAKEFILE)"

# HELPER
%-before:
	echo ".... making $*"
%-after:
	echo ".... finished $*"

