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

#compile: ${FILES:%=%.beam}
#	@echo "-OK-"
#

start:
	# ulimit -n 524288
	erl -pa ebin -smp enable -config rel/files/sys -args_file rel/files/vm.args -s myserver start -mnesia dir mnesia

# download data
# (c)7900-ffa
# ssh-copy-id -i /root/.ssh/rolong_rsa.pub root@42.121.111.191
# ssh -i /root/.ssh/rolong_rsa 'root@42.121.111.191'
# dl:
# 	scp -i ~/work/mystore/key/rolong_rsa root@42.121.111.191:/data/myserver/src/data/* src/data/
# 	@echo "Download data ok!"
# 

send:
	scp -i ~/.ssh/turbotech_dev_rsa ./src/ root@10.160.23.182:~
	@echo "Send data ok!"

clean:	
	./rebar clean
