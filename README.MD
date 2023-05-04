# Emergency Response Box
## Auth
winger(耘峥)


### Build
`nim c --passL:-static --passL:-no-pie -d:release erbox.nim`

### TODO
- create **kit** sub dir （netstat kill ...）
- cretae **playbook** sub dir
- create playbook demo
  - security baseline scan
  - backdoor scan (like:ssh pam backdoor)
  - kernel mode backdoor detection

### Plane
>Temporarily not considering using DSL and other dynamic code execution methods to work with *erbox*, although that would be very flexible, it might not be suitable for systems currently infected with viruses.