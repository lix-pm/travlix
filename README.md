# CI runner for lix

## Usage

```
yarn global add travlix
travlix --haxe 3.2.1,3.4.2 --target js,node
```


Options:

- `--haxe`, `-h`: (Required) Haxe versions to test, comma separated.
- `--target`, `-t`: (Required) Targets to test, comma separated.
- `--lib`, `-l`: (Optional) Lib versions to test, comma separated, in lix format.
