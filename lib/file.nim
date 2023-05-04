
# FileInfo = object
#   id*: tuple[device: DeviceId, file: FileId] ## Device and file id.
#   kind*: PathComponent       ## Kind of file object - directory, symlink, etc.
#   size*: BiggestInt          ## Size of file.
#   permissions*: set[FilePermission] ## File permissions
#   linkCount*: BiggestInt     ## Number of hard links the file object has.
#   lastAccessTime*: times.Time ## Time file was last accessed.
#   lastWriteTime*: times.Time ## Time file was last modified/written to.
#   creationTime*: times.Time  ## Time file was created. Not supported on all systems!
#   blockSize*: int            ## Preferred I/O block size for this object.
#                              ## In some filesystems, this may vary from file to file.
  
import os
type
  fileinfo = object
    fileInfo: FileInfo
    file:File
    inode: int
    filename: string
    permissions: string
    owner: string
    filetype: string
    created: string
    modified: string

# proc getFileInfo(filename: string): FileInfo =
#   var
#     info: FileInfo
#     statbuf: Stat
#   if stat(filename, statbuf) == 0:
#     info.inode = statbuf.st_ino
#     info.filename = filename
#     info.permissions = getPermissions(filename)
#     info.owner = getOwner(filename)
#     info.filetype = getFileType(filename)
#     info.created = getTimeString(statbuf.st_ctime)
#     info.modified = getTimeString(statbuf.st_mtime)
#   return info

# proc getPermissions(filename: string): string =
#   # implementation to get file permissions

# proc getOwner(filename: string): string =
#   # implementation to get file owner
