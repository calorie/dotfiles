# frozen_string_literal: true

require 'irb/completion'
require 'rubygems'
require 'wirble'
require 'pp'
require 'readline'

Readline.vi_editing_mode
IRB.conf[:SAVE_HISTORY] = 50_000
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

# start wirble (with color)
Wirble.init
Wirble.colorize
