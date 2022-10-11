# path

## path::save_format.pro
ある特定のクラス`class`に対して、そのクラスのファイル名を規定するフォーマットを保存する。 <br>
フォーマットは、`!package_path/naming_format/(class name)_format.sav'に保存されるが、`format_file`キーワードに任意に指定することができる。
```
path->save_format, 'class_name', '%pre_%c_%sc_%suf_%Y%m', root_dir='~/data/%c', subdir_format=['%Y', '%m']
```

## path::filename.pro
フォーマットファイルに保存されたフォーマットをもとに、ファイル名を自動で命名する。
```
filename = path->file_name(class='class_name',  subclass='subclass_name', julday=julday(1, 1, 2000), extension='.txt', /mkdir
```
キーワード`class`が指定されている場合には、`class_format.sav`フォーマットファイルを自動で検索してくる。指定しない場合、`format_file`キーワードによって明示する必要がある。


## path::format_list.pro
