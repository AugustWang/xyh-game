#!/bin/sh
# @author Rolong<rolong@vip.qq.com>

ulimit -n 524288
erl -args_file vm.args
