test:
	./test.sh

tap:
	./test.sh --tap

cleanbats:
	$(RM) spec/.bats -rf

.PHONY: test cleanbats
