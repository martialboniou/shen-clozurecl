These files must be used with the current [Shen](http://shenlanguage.org) implementation by Mark Tarver in respect of the [Shen license](http://shenlanguage.org/license.html). The code provides an *alpha* port of Shen for [ClozureCL](http://ccl.clozure.com/) (a free Common Lisp implementation).

Read the instructions carefully:

* First ensure you've got a recent binary and image of ClozureCL (1.9 or more) in your OS command line path;
* Download the [Shen Sources](shenlanguage.org/download_form.html) archive;
* Unzip the archive `Shen.zip`;
* Go to the `Platforms/` subdirectory via your OS command line;
* `git clone git@github.com:martialboniou/shen-clozurecl.git` in this directory;
* Go to the `shen-clozurecl` folder and copy the files from `../../K\ Lambda` in it, then run the installation script (`install.lsp`).

On POSIX shell (OSX/Linux/BSD/Cygwin):

    $ cp "../../K Lambda/"* . && ccl -n -l install.lsp

On Windows:

    > copy "..\..\K Lambda"\*.* .
    > wx86cl -n -l install.lsp

The Shen executable is `Shen.exe`. You may use a 64-bit image (compile `ccl64` on OSX).

Testing Shen
============

Run `Shen.exe` from the previous directory and type the following code:

    (cd "../../Test Programs")
    (load "README.shen")
    (load "tests.shen")

Theory
======

Shen is a portable functional programming language that offers

* pattern matching,
* λ calculus consistency,
* macros,
* optional lazy evaluation,
* static type checking,
* an integrated fully functional Prolog,
* and an inbuilt compiler-compiler.

Shen has one of the most powerful type systems within functional programming. Shen runs under a reduced instruction Lisp and is designed for portability. The word ‘Shen’ is Chinese for spirit and our motto reflects our desire to liberate our work to live under many platforms. Shen includes sources and is absolutely free for commercial use. It currently runs under CLisp and SBCL, Clojure, Scheme, Ruby, Python, the JVM and Javascript.

More words
==========

Don't be afraid by the minimalist REPL. This program is a programming system kernel  For a better experience, you may run Shen with [`rlwrap`](http://utopia.knoware.nl/~hlub/rlwrap/) or command the image with a [modern editor](https://github.com/eschulte/shen-mode).

Other implementations exist. The native one is made for GNU `CLisp`. The SBCL one implements threading. [Javascript](https://github.com/gravicappa/shen-js) and [Ruby](https://github.com/gregspurrier/shen-ruby) are generally up-to-date. This port is *experimental*.

Libraries are available [here](http://shenlanguage.org/library.html).

A book is available; a second edition is coming soon.

Beware
======

Clozure characters support NFD Unicode (using UTF32 internal representation). `string->n` may not behave like on other implementations.
