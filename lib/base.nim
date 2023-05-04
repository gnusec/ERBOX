import strutils

proc isNumber(x: string): bool =
  try:
    discard parseInt(x)
    result = true
  except ValueError:
    result = false