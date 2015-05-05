{XRegExp} = require 'xregexp'
linterPath = atom.packages.getLoadedPackage('linter').path
Linter = require "#{linterPath}/lib/linter"
{log, warn} = require "#{linterPath}/lib/utils"


class LinterGHCMod extends Linter
  @syntax: 'source.haskell' # fits all *.hs-files

  linterName: 'ghcmod'

  regex: '.+?:(?<line>\\d+):(?<col>\\d+):\\s+\
          ((?<error>Error)|(?<warning>Warning)|(?<error>parse error)):\\s*\
          (?<message>.*)'
  regexFlags: 'gms'

  constructor: (editor) ->
    super(editor)
    atom.config.observe 'linter-ghcmod.ghcmodExecutablePath', =>
      @executablePath = atom.config.get 'linter-ghcmod.ghcmodExecutablePath' + ' check'

  processMessage: (message, callback) ->
    console.log message
    if message == ""
      return []
    messages = []
    regex = XRegExp @regex, @regexFlags
    for msg in message.split(/\r?\n\r?\n/)
      console.log msg
      XRegExp.forEach msg, regex, (match, i) =>
        messages.push(@createMessage(match))
      , this
    callback messages


  createMessage:(match) ->
    super(match)

module.exports = LinterGHCMod
