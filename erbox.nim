import strutils, os, posix

type Command = proc(args: seq[string]): int

var commands: seq[(string, Command)] = @[]

proc registerCommand(name: string, cmd: Command) =
  commands.add((name, cmd))

proc runCommand(name: string, args: seq[string]): int =
  for cmd in commands:
    if cmd[0] == name:
      return cmd[1](args)
  echo "Command not found: ", name
  return 1

proc lsCommand(args: seq[string]): int =
  var dir: string = "."
  var relative: bool = false
  var checkDir: bool = false
  if args.len > 0:
    dir = args[0]
  for file in walkDir(dir, relative=relative, checkDir=checkDir):
    echo file.path
  return 0

proc whoamiCommand(args: seq[string]): int =
  echo getUid().int
  return 0

proc pwdCommand(args: seq[string]): int =
  echo getCurrentDir()
  return 0

registerCommand("ls", lsCommand)
registerCommand("whoami", whoamiCommand)
registerCommand("pwd", pwdCommand)

let args = commandLineParams()
if args.len > 0:
  var cmdArgs = args[0].splitWhitespace()
  var cmd = cmdArgs[0]
  if cmdArgs.len > 1:
    cmdArgs = cmdArgs[1..^0]
  else:
    cmdArgs = @[]
  
  let ret = runCommand(cmd, cmdArgs)
  if ret != 0:
    echo "Command failed with exit code: ", ret
