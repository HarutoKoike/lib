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
1. AACGM座標の計算で、[http://superdarn.thayer.dartmouth.edu/aacgm.html] を使用するため、ダウンロードする。
2. `background/aacgm_compile.pro`という関数があるので、１行目の`path=...`の部分を、ダウンロードしたディレクトリへのパスに変更する。

## memo 
* AACGMのパッケージはSpedasにも含まれているが、READMEに書かれているコンパイルするべき関数の一部が欠損しているので、直接dartmouthのページからダウンロードしてくる。


