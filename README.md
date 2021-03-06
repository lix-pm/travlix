[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/lix-pm/Lobby)

# CI runner for lix

## Usage

```
yarn global add travlix
travlix run --haxe 3.2.1,3.4.2 --target js,node
```


Options:

- `--haxe`, `-h`: (Required) Haxe versions to test, comma separated.
- `--target`, `-t`: (Required) Targets to test, comma separated.
- `--lib`, `-l`: (Optional) Lib versions to test, comma separated, in lix format.

## Travis CI template

```yaml
sudo: required
dist: trusty

language: node_js
node_js: 6

os:
  - linux
  - osx
  
install:
  - npm install -g travlix

script:
  - travlix run --haxe 3.4.4 --target node
```
