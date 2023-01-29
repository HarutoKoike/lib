# IO

## io::write_ascii.pro
同じ要素数の複数の配列(15個まで）を引数とし、それらを　ASCIIファイルに書き込む。 <br>
書き込み時に、変数の数、読み込みフォーマット、ヘッダーなども同時に入力できる。<br>
これらの読み込みに必要な情報は、ファイルに直接書き込まれるため、読み取り時に読み込みの方法を指定しなくても、自動的に適当な形式で読み込まれる。
```
io->write_ascii, 'mydata.dat', [0, 1], ['aaa', 'bbb'], format='(I02, 1x, A3)'
```

## io::read_ascii.pro
`io::write_ascii.pro`で作成されたASCIIファイルを読み込む。2つ目の引数に、読み込んだ結果が格納される。
```
io->read_ascii, 'mydata.dat', result
```
