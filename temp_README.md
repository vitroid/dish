# dish --- distributed shell
<img src="wheel.gif">

current version: %%VERSION%%

----

Dish is a distributed shell. It is designed to replace 'sh -c' command
used in GNU make. It enables us to execute
many procedures at a time over network-linked heterogeneous
workstation cluster.

Dish works just like 'sh -c' command, <i>ie</i> it gets command line 
arguments and executes them as Bourne shell script. Internally
the arguments are given to remote shell command, executed on remote
workstation, and the status of the remote execution is returned.

Dish is useful for the jobs in which hundreds of independent tasks must be
processed on the distributed hosts, e.g. making animations, converting
many sound files, compiling huge software like unix kernel, etc.

Remote host on which the commands are executed is chosen from 
given list. If you intend to make binary files which depend on the
system architecture, all the remote host in the list must be of the
same architecture.

Dish executes command on the remote directory where is the same with
local directory. It is required that both the remote and local machine
shares the directories and the tree topology of the directories on
both machine are the same. 

## command usage

   usage:  dish [options] foo [x] [bar [y] ... ] -c cmds
   Dish executes the specified command on one of the remote hosts.
	It distributes at most x jobs to the remote host foo and y jobs to bar.
	Default number of jobs is 1 if it is omitted.
	
	Options
	    -h, --help         Show this message.
	    -i, --interactive  By default, dish ignores any input from stdin.
	                       With this option, dish reads from stdin.
	    -v, --verbose      Display debug messages
	    -r, --refresh      Remove lock files and go.
	    -s, --ssh          Use ssh instead of ersh.
	    -g, --group GROUP  Get host list from $(HOME)/.dish_group/GROUP file
	                       instead of command line arguments.
	    -p, --pwd PATH     Specify current directory explicitly.
	                       dish usually gets current path from PWD environment 
	                       variable. However, some shells do not set PWD variable
	                       and dish tries to get it by pwd command, which only
	                       returns the absolute     path. Representation of current 
	                       absolute path sometimes differs between local and 
	                       remote host when the current path involves symbolic 
	                       link. 
	    -c     Terminator symbol of host list.
	    cmds   Bourne shell commands to be executed.

## Replacement of standard shell in Makefile

GNU make usually executes only one rule at a time. While specifying `-j`
option enables the parallel execution.
We utilize this facility of GNU make for cluster-wide command
execution.
With `-j` option, GNU make analyses the dependencies of the rules and
executes independent rules by standard shells in parallel manner. Each 
shell treats short "thread" of rules in the Makefile and return result
status code to GNU make.

We replace the standard shell with dish, which performs just like
`sh -c` command.
When `SHELL` variable in the Makefile is defined, each
rule-descripting line is executed by SHELL instead of `/bin/sh -c`.
Dish exports each threads to one of remote hosts and
report the result status to GNU make.

Max number of parallel jobs (which is specified with `-j` option) should 
be greater than sum of x (specified at the argument of dish). 
Dish controls the number of jobs by itself when it is invoked multiply.

To distribute "make" processes onto multiple hosts, type

    make -j 10 SHELL="dish host1 2 host2 host3 4"

Make executes 10 independent rules at a time. 2 of them are exported
to host1, 1 to host2, 4 to host3, and the rest 3 rules are suspended.

Dish works on the host workstation where GNU make command is
invoked. It is unsecessary to install anything on the remote
workstations.

(v1.21)When a `-g` option is given, dish looks up host list from `~/.dish_group/GROUPFILE` (`GROUPFILE` is the argument given with a `-g` option) instead of command line arguments. It is useful when you run dish on large-scale cluster.

For example, put the following text to the file ~/.dish_group/clients,

	c001 2
	c002 2
	c003 2

and run "make" using dish with -g option.

	make -j 6 all SHELL="dish -g clients"

## Note

Standard remote shell command ('rsh') does not return the status of
remote execution. In dish, ersh is used in place of standard rsh. Ersh 
is written by Maarten Litmaath in 1994. With -s option, dish also uses ssh(secure shell).
In this case, ssh server must be installed in the remote host.

This limitation will be avoided by using ssh in version 1.22.

On linux, make is GNU make. While in general make is not GNU
make. Please consult administrator whether your machine has GNU make
command.

Dish creates a work directory named .dish in your home directory for exclusive process control.

Dish behaves as "on" command when it is aliased.
## Bugs

Dish sometimes fails when the command line includes many quotation
marks. It will be limitation of shell script and I could not avoid
this. Rewrinting dish by C-language will solve this problem.

## Analogs

<a href="http://www3.informatik.tu-muenchen.de/~zimmerms/ppmake/">PVM Parallel Make (ppmake)</a>

## Change Log
<dl>
<dt>v1.22 Feb.6, 2013
<dd>Moved to GitHub. 
<dt>v1.21 Feb.19, 2003
<dd>-g|--group option is added.
</dl>
<h2>Acknowledgment</h2>
I'd like to thank to the following people who gave me a lot of valuable opinions, patches, and contributions.
<ul>
<li>Seisei Yamaguchi
</ul>
Any comments and questions to <a
href="mailto:%%MAIL%%">%%MAIL%%</a>.

----

# dish --- 分散シェル
<img src="wheel.gif">

current version: %%VERSION%%

---- 

dishはGNU makeの内部で使用されている`sh -c`の代わりとして設計されまし
た。dishを使えば、ネットワークで結合された不均質なワークステーションク
ラスタ上で、たくさんの手続きを同時にこなすことができます。

dishはまるで`sh -c`コマンドのように動作します、つまり、コマンドライン
引数を読み込み、それをBourneシェルスクリプトと解釈して実行します。内部
では、引数は遠隔シェルコマンドrshに渡され、遠隔のワークステーションで
実行され、その結果をステータスとして返します。

アニメーションの製作や多数の音声ファイルの変換、巨大なソフトウェアの翻
訳などのように、数百の独立な処理を分散的に行わなければならない場合に役
に立ちます。

コマンドを実行する遠隔ホストは、与えられたリストの中から選択されます。
もし、システムのアーキテクチャに依存するようなバイナリファイルを作りた
い場合は、リストに含める遠隔ホストは同一のアーキテクチャでなければいけ
ません。

dishは、ローカルディレクトリと同一の遠隔ディレクトリでコマンドを実行し
ます。遠隔ホストとローカルホストがディレクトリを共有し、かつディレクト
リ樹の構造が同一である必要があります。

## コマンドの使い方

	usage:  dish [options] foo [x] [bar [y] ... ] -c cmds

dishは、与えられたホスト表のうちから1つを選んでcmdsを実行します。
最大x個のジョブがホストfooに、y個のジョブがホストbarに投入されます。
ジョブの数を省略した場合のデフォルトは1となります。
	
### オプション
	
	-h, --help         ヘルプを表示します。
	-i, --interactive  標準入力から読みこみます。
	                   通常dishは標準入力を無視します。
	-v, --verbose      デバッグメッセージを表示します。
	-r, --refresh      ロックファイルを消去してから実行します。
	-s, --ssh          ershの代わりにsshを使用する。
	-g, --group FILE   ホスト表をファイルから読みこみます。
	-p, --pwd PATH     現在のディレクトリを明示的に指定します。
	          通常、dishはPWD環境変数から現在のディレクトリを知りますが、
	          PWDシェル変数を設定しないシェルを使用している場合には、
	          dishはpwdコマンドを使用して現在のディレクトリの絶対パスを
	          入手します。しかし、現在のパスがシンボリックリンクを含む
	          場合には、現在の絶対パスの表現の仕方がローカルとリモートで異なる
	          ことがあります。
	-c     ホスト名リストの終わりを表わす。
	cmds   実行したいBourne shellコマンド.

## Makefileの中の標準シェルを置き換える

GNU makeは通常一度に1つの規則のみを解釈します。一方、`-j`オプションを与
えると、並列に実行します。私達は、このGNU makeの並列機能を、ワークステー
ションクラスタ全体でコマンドを実行するのに利用します。`-j`オプションがあ
ると、GNU makeは規則の依存性を解析し、独立な規則を標準シェルを使って並
列に実行します。それぞれのシェルはMakefile中の規則の短いスレッドを扱い、
終了ステータスコードをGNU makeに返します。

我々は標準シェルをdishでおきかえます。dishは`sh -c`とそっくりにふりま
います。予約変数SHELLがMakefile内で定義された場合、それぞれの規則定義
行は`/bin/sh -c`の代わりにdishで実行されます。dishはそれぞれのスレッド
を遠隔ホストの一つに送り出し、終了ステータスをGNU makeに報告します。

`-j`オプションで指定される、並列ジョブの最大数は、dishの引数で指定される
xの総和よりもおおきくなくてはいけません。dishは、複数同時に起動された
場合には、自らジョブの個数を制御します。

makeプロセスを複数のホスト上に分散するには、次のようにタイプして下さい。

	make -j 10 SHELL="dish host1 2 host2 host3 4"

makeは10個の独立な規則を同時に実行しようとします。2つはhost1に、1つは
host2に、4つはhost4に送り出され、残り3つは待ち状態になります。

dishはgmakeコマンドを実行しているホスト上で動作します。遠隔ホスト側に
は特に何もインストールする必要はありません。

(v1.21)-gオプションを与えた場合には、ホスト表をコマンドラインから読みこむかわりに、所定のファイル(`~/.dish_group/`以下に置く)から読みこみます。大規模クラスタでdishを使う場合に便利です。

たとえば、`~/.dish_group/clients`に以下のような内容を書いておき、

	c001 2
	c002 2
	c003 2

次のようなコマンドを実行すると、ホスト`c001`上で2つ、`c002`上で2つ、`c003`上で2つの計6つのプロセスを使って`all`をmakeすることができます。

	make -j 6 all SHELL="dish -g clients"

## 注意<

標準の遠隔シェルコマンド('rsh')は遠隔で実行した終了ステータスを正しく
返しません。dishでは、Maarten Litmaathによって1994年に書かれたershを代
わりに利用します。-sオプションを与えると、dishはershの代わりにsshを使いますが、この場合
遠隔ホストにsshのサーバが走っている必要があります。

Linuxでは、makeはGNU makeを意味しますが、一般にはmakeはGNU makeのこと
ではありません。あなたの計算機にGNU makeコマンドがあるかどうか管理者に
相談して下さい。

dishは、排他的プロセス制御のためにホームディレクトリに.dishという名前のワーク
ディレクトリを作成します。

おまけの機能として、dishをonという名前で実行すると、onコマンドの代わり
になります。

## Bugs

コマンドラインに引用符がたくさんある場合に、dishが上手く動かない場合が
あります。これはdishがシェルスクリプトで書かれていることに起因しており、
うまく回避するためにはc言語などでdishを書き直すしかないと思われます。

## 似たもの
<a href="http://www3.informatik.tu-muenchen.de/~zimmerms/ppmake/">PVM Parallel Make (ppmake)</a>

## 謝辞
以下の方々から有用な意見やpatch、貢献などをいただきました。ありがとうございました。(敬称略)

* 山口青星

