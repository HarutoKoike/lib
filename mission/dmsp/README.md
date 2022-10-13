# DMSP load procedure

## Usage
```
dmsp = dmsp_load(f, year, month, day, /tvar, /reload)
```
以下は全て整数型で与える。<br>
`f`: 衛星番号(16, 17, 18) <br>
`year`: 年 <br>
`month`: 月<br>
`day`: 日<br>


## preparation
### 外部パッケージの用意
1. AACGM座標の計算で、[http://superdarn.thayer.dartmouth.edu/aacgm.html] を使用するため、ダウンロードする。
2. 本パッケージの中に、`background/aacgm_compile.pro`という関数があるので、１行目の`path=...`の部分を、ダウンロードしたディレクトリへのパスに変更する。
3. 関数の一部にデータをspedasのtplot変数に変更する箇所がある。これらの関数を使用する場合は、spedasもダウンロードしておく。
### パスの設定
ダウンロードしたデータはsaveファイルとして保存される。保存先のディレクトリは、環境変数`$DATA_PATH`になるが、存在しない場合は`$SPEDAS_DATA_PATH`となる。<br>
これらの2つも存在しない場合、`$HOME`に保存される。

## memo 
* AACGMのパッケージはSpedasにも含まれているが、READMEに書かれているコンパイルするべき関数の一部が欠損しているので、直接dartmouthのページからダウンロードしてくる。


