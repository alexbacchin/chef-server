DEPS = deps/amqp_client \
       deps/ejson \
       deps/gen_bunny \
       deps/gen_server2 \
       deps/meck \
       deps/mochiweb \
       deps/neotoma \
       deps/rabbit_common

all: compile eunit dialyzer

clean:
	@rebar clean
	@rm -rf ebin_dialyzer

distclean: clean
	@rm -rf deps

compile: $(DEPS)
	@rebar compile

# There is no easy way to filter out warnings for uncooperative
# modules. Here we provide an ugly hack that allows us to regularly
# run Dialyzer and ignore the warnings that come from neotoma
# generated code. We run dialyzer against the ebin_dialyzer directory
# which is created anew for each run and has the problem modules
# (those generated by neotoma) removed.
dialyzer:
	@rm -rf ebin_dialyzer
	@mkdir -p ebin_dialyzer
	@cp ebin/* ebin_dialyzer
	@rm ebin_dialyzer/*lucene*.beam
        ## added -nn which seems to speed up the analysis
	@dialyzer -Wrace_conditions -Wunderspecs -nn -r ebin_dialyzer

$(DEPS):
	@rebar get-deps

eunit: compile
	@rebar skip_deps=true eunit

test: eunit

lucene: compile
	@rm src/lucene_*.erl
	@priv/build_grammars
