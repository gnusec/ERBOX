
import os
import strutils
import sequtils
import options
include ./base.nim

type
  ProcessInfo = object
    pid: int
    name: string

  # for proc_item in walkPattern("/proc/*").filterIt(it.isDir and it.name.isInt):
  #   var pid = proc_item.name.parseInt()
  #   echo(pid)

# let paths = toSeq(walkPattern("/proc/*"))
# echo repr(paths)




# for item in toSeq(walkPattern("/proc/*")).filterIt(it.dirExists and isNumber(it.extractFilename)):
#     echo item
#     var pid = item.extractFilename.parseInt()
#     # echo(pid)
#     if pid == 0:
#       continue
#     var name = ""
#     try:
#       name = open("/proc/" & $pid & "/comm").readAll().strip()
#     except:
#       continue
#     echo(name)
#     # if (pid == procNameOrId) or (name == procNameOrId):
#     #   result.add(ProcessInfo(pid: pid, name: name))


# for proc_item in walkPattern("/proc/*").filterIt(it.isDir and it.name.isInt):
#     var pid = proc_item.name.parseInt()
#     echo(pid)



proc getProcessIDbyName(procName: string): seq[int] =
  var result: seq[int] = @[]
  for item in toSeq(walkPattern("/proc/*")).filterIt(it.dirExists and isNumber(it.extractFilename)):
      # echo item
      var pid = item.extractFilename.parseInt()
      # echo(pid)
      if pid == 0:
        continue
      var name = ""
      try:
        name = open("/proc/" & $pid & "/comm").readAll().strip()
      except:
        continue
      # echo(name)
      # if(isNumber(procNameOrId)):
      #   if(pid == procNameOrId.parseInt()):
      #     result.add(pid)
      if(name == procName):
          # echo "Fucking->",name,pid
          result.add(pid)

      # if (pid == procNameOrId) or (name == procNameOrId):
      #   result.add(ProcessInfo(pid: pid, name: name))
  return result


# test
echo getProcessIDbyName("bash")


proc getProcessNamebyID(procID: int): Option[seq[string]] =
    var result:seq[string]
    try:
        # Open the file for reading
        # var file = open("filename.txt")
        var file = open("/proc/" & $procID & "/cmdline")
        # var name:string  = open("/proc/" & $procID & "/cmdline").readAll()
        # return some(name)
        # Check if the file was opened successfully
        if file != nil:
            # Read the contents of the file into a string
            var contents = file.readAll()

            # Close the file
            file.close()

            # Split the contents of the file by the null character ('\0')
            var lines = contents.split('\0')

            # Print each line of the file
            for line in lines:
                # echo line
                result.add(line)
        else:
            echo "Failed to open file"

        return some(result)
    except CatchableError:
        return none(seq[string])

if getProcessNamebyID(14738).isSome:
    echo getProcessNamebyID(14738).get


if getProcessNamebyID(2759).isSome:
    echo getProcessNamebyID(2759).get



