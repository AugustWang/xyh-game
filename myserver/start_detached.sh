#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

ulimit -n 524288
erl -detached -pa ebin -smp enable -config rel/files/sys -args_file rel/files/vm.args -s myserver start
