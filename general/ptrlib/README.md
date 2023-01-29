# ptrlib


## 概要
ptrlibでは、変数名をキーとして変数をグローバルに共有するシステムを提供する。<br>
COMMONと同様の使い方ができる。変数自体がグローバル変数として定義されるわけではないので予想外のエラーが起こりにくく、COMMON文と比較してデバッグが容易になる。
実態は1つのシステム変数`!PTR`であり、この変数に、データの名前とデータへのポインターがセットになって保存されている。


## インストール
IDL8.5以上推奨
```
ipm, /install, 'https://github.com/HarutoKoike/ptrlib'
```


## 変数の保存
あるデータを`var1`という名前で保存する。
```
ptr->store, 'var1', data, description='This is var1'
```

## 変数の復元
```
var1 = ptr->get('var1')
```

## 格納されている変数のリストの表示
一覧を表示
```
ptr->list
```
格納された変数の数を取得。
```
ptr->list, count=count
```
格納された変数の名前のリストを取得
```
ptr->list, names=names
```


## 格納された変数の削除
```
ptr->delete, 'var1'
```


## 全ての変数の保存
変数自体ではなく、変数名とそのポインタの集合である!PTRを保存している。
```
ptr->save, filename='~/savefile.sav'
```


