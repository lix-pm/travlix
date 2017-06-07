```
lixtest --haxe 3.2.1,3.4.2 --target js,node --lib haxelib:tink_core#1.11.0,haxelib:tink_core#1.12.0
```

```
switchx use 3.2.1
lix install haxelib:tink_core#1.11.0
travix js
travix node
lix install haxelib:tink_core#1.12.0
travix js
travix node
switchx use 3.4.2
lix install haxelib:tink_core#1.11.0
travix js
travix node
lix install haxelib:tink_core#1.12.0
travix js
travix node
```