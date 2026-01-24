# cozy-pwsh

```plain
   ╭────────────────────────────────────────╮
   │   cozy‑pwsh — a warm little pwsh home  │
   ╰────────────────────────────────────────╯
                   (^-^)
                          ✧
                         ✧ ✧     Q(-_-q)
                       ✧  ✧  ✧
                         ✧ ✧
                          ✧
           (づ｡◕‿‿◕｡)づ
```

## tl;dr

Howdy y'all,

I owe you a lot more documentation; however, i'm busy right now sourcing this to saltstack and implimentation there

This is a system profile — but if you want it for local, switch the following two in the top level [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1)

- and let me know if it breaks. make an issue

```pwsh
$PROFILE.AllUsersCurrentHost
```

```pwsh
$PROFILE
```

## Paths

Here are expected paths, if not present it also checks the user ones

1. Tries system paths
2. Failover to user paths

### Ecxpected Paths

| item      |       path        |         fallback |
| :-------- | :---------------: | ---------------: |
| miniforge | C:\opt\miniforge3 | $HOME\miniforge3 |
| nvm       |    C:\opt\nvm     |    $env:NVM_HOME |
