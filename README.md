<div align="center"><h2>
  <a href="https://github.com/z-shell/zi">
    <img src="https://github.com/z-shell/zi/raw/main/docs/images/logo.svg" alt="Logo" width="80" height="80" />
  </a>
❮ ZI ❯ Service - Py3HTTP
</h2></div>

<div align="center">

This **Zsh** service-plugin will serve given directory _(plugin's directory by default)_ using **Python's 3 HTTP server**.

</div>

## Install with ❮ [ZI](https://github.com/z-shell/zi/) ❯

The service-plugin supports loading single plugin instance per all active Zsh sessions, in background.

```shell title="~/.zshrc"
zi ice service'py3http'
zi light z-shell/zservice-py3http
```

## Explanation of Zsh-spawned services

First Zsh instance that will gain a lock will spawn the service.

Other Zsh instances will wait. When you close the initial Zsh session, another Zsh will gain lock and resume the service.
