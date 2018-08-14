.DEFAULT_GOAL = get-sources
.SECONDEXPANSION:

.PHONY: get-sources verify-sources clean clean-sources

SHELL := bash

UNTRUSTED_SUFF := .UNTRUSTED

FETCH_CMD := wget --no-use-server-timestamps -q -O

URLS := \
    https://releases.pagure.org/microcode_ctl/microcode_ctl-2.1-19.tar.xz

ALL_URLS := $(URLS)
ALL_FILES := $(notdir $(ALL_URLS))

ifneq ($(DISTFILES_MIRROR),)
ALL_URLS := $(addprefix $(DISTFILES_MIRROR),$(ALL_FILES))
endif

$(ALL_FILES): %: %.sha512
	@$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(filter %/$*,$(ALL_URLS))
	@sha512sum --status -c <(printf "$$(cat $<)  -\n") <$@$(UNTRUSTED_SUFF) || \
		{ echo "Wrong SHA512 checksum on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

get-sources: $(ALL_FILES)
	@true

verify-sources:
	@true

clean:
	@true

clean-sources:
	rm -f $(ALL_FILES) *$(UNTRUSTED_SUFF)
