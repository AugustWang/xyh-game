.SUFFIXES:
.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<
ERL = erl -boot start_clean 

all:
	./rebar  compile

eunit:
	./rebar compile eunit

ctags:
	ctags -R .

start:
	erl -args_file vm.args

clean:	
	./rebar clean
