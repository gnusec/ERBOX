import os
import strutils
import options

type PasswdEntry = tuple[username: string, password: string, uid: int,
                          gid: int, gecos: string, homeDir: string,
                          shell: string]

iterator passwdFileIterator(): PasswdEntry =
    let fp = open("/etc/passwd")
    var line = ""
    while true:
        try:
            line = readLine(fp)
        except EOFError:
            # echo "~~~~~~~~~~Error: unhandled exception: EOF reached [EOFError]"
            fp.close
            break
        # if line == "":
        #     break
        # todo
        # https://nim-lang.org/docs/strscans.html
        # 重写
        let fields = split(line, ':')
        yield (fields[0], fields[1], parseInt(fields[2]), parseInt(fields[3]),
               fields[4], fields[5], fields[6])

proc getUsernameFromUid(uid: int): Option[string] =
    for entry in passwdFileIterator():
        # echo entry
        if entry.uid == uid:
            return some(entry.username)

    # return none(string)

echo getUsernameFromUid(0).get
# 不存在的uid
if  getUsernameFromUid(1111).isSome : 
     echo getUsernameFromUid(1111).get


proc getUidFromUsername(username: string): Option[int] =
    for entry in passwdFileIterator():
        # echo entry
        if entry.username == username:
            return some(entry.uid)

if  getUidFromUsername("root").isSome:
    echo getUidFromUsername("root").get

if  getUidFromUsername("rosdsdsdsdsdsdsdot").isSome:
    echo getUidFromUsername("rosdsdsdsdsdsdsdot").get

#todo
#获取所有非nologin的shell的账户
# 快速排查被添加的用户