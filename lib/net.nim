import os
import strutils
import parseutils
import posix
import re


# Decoding the data in /proc/net/tcp:

# Linux 5.x  /proc/net/tcp
# Linux 6.x  /proc/PID/net/tcp


type
  NetInfo* = ref object of RootObj
      netInterface: string
      address: string
      txQueue: int
      rxQueue: int
      localAddress: string
      localPort: int
      remoteAddress: string
      remotePort: int
      state: string #tcp status
      uid: int # system user id
      inode: int  #socket inode
      socketRefCount: int
      socketLocation: string
      # processid: int # process id #TODO
      # process: string # process name
      # username: string # owner


#Convert hex string to normal ip format
import  algorithm,sequtils
proc hex2ip(ip:string):string =
  ip.findAll(re"(\w{2})").reversed.mapIt(parseHexInt($it)).join(".")

# Tcp状态码转换
type TcpStatus = enum
  TCP_ESTABLISHED = 1
  TCP_SYN_SENT = 2
  TCP_SYN_RECV = 3
  TCP_FIN_WAIT1 = 4
  TCP_FIN_WAIT2 = 5
  TCP_TIME_WAIT = 6
  TCP_CLOSE = 7
  TCP_CLOSE_WAIT = 8
  TCP_LAST_ACL = 9
  TCP_LISTEN = 10
  TCP_CLOSING = 11

proc getTcpStatus(num: int): string =
  case (cast[TcpStatus](num)):
    of TcpStatus.TCP_ESTABLISHED: return "TCP_ESTABLISHED"
    of TcpStatus.TCP_SYN_SENT: return "TCP_SYN_SENT"
    of TcpStatus.TCP_SYN_RECV: return "TCP_SYN_RECV"
    of TcpStatus.TCP_FIN_WAIT1: return "TCP_FIN_WAIT1"
    of TcpStatus.TCP_FIN_WAIT2: return "TCP_FIN_WAIT2"
    of TcpStatus.TCP_TIME_WAIT: return "TCP_TIME_WAIT"
    of TcpStatus.TCP_CLOSE: return "TCP_CLOSE"
    of TcpStatus.TCP_CLOSE_WAIT: return "TCP_CLOSE_WAIT"
    of TcpStatus.TCP_LAST_ACL: return "TCP_LAST_ACL"
    of TcpStatus.TCP_LISTEN: return "TCP_LISTEN"
    of TcpStatus.TCP_CLOSING: return "TCP_CLOSING"
    else: return "Invalid TcpStatus=>num"


import system
proc getNetInfo(): seq[NetInfo] =
  var result: seq[NetInfo] = @[]
  for line in readFile("/proc/net/tcp").splitLines:
    echo line
    if line.strip().startswith("sl"):
      # echo line
      continue
    echo "~~~~~~~~~~~~~~~"
    var tmp:seq[string]
    var parts = split( line,  re"\s+")
    echo "parts=>", parts
    if parts.len > 0 :
      tmp =  parts[2].split(":")
      var localAddr: string  = hex2ip(tmp[0])
      
      echo "localAddr=>", localAddr

      var localPort: int = parseHexInt(tmp[1])
      # if parseHex(tmp[1],localPort) == 0:
      #   localPort = -1

      tmp = parts[3].split(":")
      var remoteAddr:string =hex2ip(tmp[0])
      echo "remoteAddr=> ",remoteAddr


      echo "->parseHexInt remotePort"
      var remotePort: int = parseHexInt(tmp[1])
      # if parseHex(tmp[1],remotePort) == 0:
      #   remotePort = -1
      echo "->parseHexint state"
      var state = getTcpStatus(parseHexInt(parts[4]))
      echo "state->",state
      tmp = parts[5].split(":")

      echo "->parseInt txQueue"
      var txQueue:int = parseHexInt( tmp[0])
    
      echo "->parseInt rxQueue"
      var rxQueue:int = parseHexInt( tmp[1])


      echo "->parseInt uid"
      var uid:int = parseInt(parts[8])
      
      echo "->parseInt inode"
      var inode:int = parseInt(parts[10])
      


      echo "->parseInt socketRefCount"
      var socketRefCount:int = parseInt(parts[11])

      echo "->parseInt socketLocation"
      # var socketLocation:int = parseHexInt(parts[12])
      var socketLocation:string =  parts[12]

      echo "->parseInt End"


      var netInterface = ""
      # for link in os.walkFiles("/proc/self/fd"):
      #   try:
      #     if os.expandSymlink("/proc/self/fd/" & link) == "/proc/net/tcp":
      #       netInterface = os.expandSymlink("/proc/self/fd/" & link).split("/")[-2]
      #       break
      #   except:
      #     continue
      # result.add(NetInfo(netInterface:netInterface, address:parts[1], txQueue: parseInt(txQueue) , rxQueue:parseInt(rxQueue), localAddress:localAddr, localPort: parseInt(localPort, 16), remoteAddress: remoteAddr, parseInt(remotePort, 16), state: state))
      result.add(NetInfo(netInterface: netInterface, address: parts[1], txQueue:  txQueue, rxQueue: rxQueue, 
      localAddress: localAddr, localPort: localPort,   remoteAddress: remoteAddr, remotePort:  remotePort, 
      state: state, uid:uid, inode:inode , socketRefCount:socketRefCount, socketLocation:socketLocation))
      echo  "result.len=>",result.len
  return result
    # echo repr(result)
    # result.add(NetInfo())
  # for net in result:
  #   echo "IP: ", net.localAddress, ", Port: ", net.localPort
  #   echo "IP: ", net.localAddress, ", Port: ", net.remotePort



var r = getNetInfo()
echo r.len
echo repr(r[^1])
# for x in r:
#   echo "~~~~~~~++++++++++++~~~~~~~"
#   echo repr(x)
