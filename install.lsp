;;Clozure CL Installation
;;install and wipe away the junk

;; Common Usage: cp "../../K Lambda/"* . && ccl -n -l install.lsp
;; Windows CLI Usage: copy "..\..\K Lambda"\*.* .
;;                    wx86cl -n -l install.lsp
;;
(IN-PACKAGE :CL-USER)

(SETF (READTABLE-CASE *READTABLE*) :PRESERVE)
(SETQ *language* "Common Lisp")
(SETQ *implementation* "ClozureCL")
(SETQ *release* "1.9")
(SETQ *port* 0.1)
(SETQ *porters* "Martial Boniou")
(SETQ *os* "Mac OS X")

(DEFUN ccl-install (File)
  (LET* ((Read (read-in-kl File))
         ;; ccl may not accept lisp filenames with multiple dots
         (Intermediate (FORMAT NIL "~A_intermed" (PATHNAME-NAME File)))
         (LispFile (FORMAT NIL "~A.lsp" Intermediate))
         (FaslFile (COMPILE-FILE-PATHNAME LispFile)))
    (write-out-kl Intermediate Read)
    (DELETE-FILE File)
    (boot Intermediate)
    (DELETE-FILE Intermediate)
    (COMPILE-FILE LispFile)
    (move-file LispFile)
    (LOAD FaslFile)
    (DELETE-FILE FaslFile)))

(DEFUN move-file (Lisp)
  (LET ((Rename (native-name Lisp)))
    (IF (PROBE-FILE Rename) (DELETE-FILE Rename))
    (RENAME-FILE Lisp Rename)))

(DEFUN native-name (Lisp)
  (FORMAT NIL "Native/~{~C~}.native"
          (nn-h (COERCE Lisp 'LIST))))

(DEFUN nn-h (Lisp)
  (IF (CHAR-EQUAL (CAR Lisp) #\_)
      NIL
      (CONS (CAR Lisp) (nn-h (CDR Lisp)))))

(DEFUN read-in-kl (File)
  (WITH-OPEN-FILE (In File :DIRECTION :INPUT)
    (kl-cycle (READ-CHAR In NIL NIL) In NIL 0)))

(DEFUN kl-cycle (Char In Chars State)
  (COND ((NULL Char) (REVERSE Chars))
        ((AND (MEMBER Char '(#\: #\; #\,) :TEST 'CHAR-EQUAL) (= State 0))
         (kl-cycle (READ-CHAR In NIL NIL) In (APPEND (LIST #\| #\\ Char #\\ #\| #\\) Chars) State))
        ((CHAR-EQUAL Char #\") (kl-cycle (READ-CHAR In NIL NIL) In (CONS Char Chars) (flip State)))
        (T (kl-cycle (READ-CHAR In NIL NIL) In (CONS Char Chars) State))))

(DEFUN flip (State)
  (IF (ZEROP State)
      1
      0))

(COMPILE 'read-in-kl)
(COMPILE 'kl-cycle)
(COMPILE 'flip)

(DEFUN write-out-kl (File Chars)
  (HANDLER-CASE (DELETE-FILE File)
    (ERROR (E) (DECLARE (IGNORABLE E))))
  (WITH-OPEN-FILE (Out File :DIRECTION :OUTPUT :IF-EXISTS :OVERWRITE :IF-DOES-NOT-EXIST :CREATE)
    (FORMAT Out "~{~C~}" Chars)))

(COMPILE 'write-out-kl)

(DEFUN compile-and-purge (File)
  (COMPILE-FILE File)
  (LET ((Fsl (COMPILE-FILE-PATHNAME File)))
    (LOAD Fsl)
    (DELETE-FILE Fsl)))

(COMPILE 'compile-and-purge)

(MAPC 'compile-and-purge '("primitives.lsp" "backend.lsp"))

(ENSURE-DIRECTORIES-EXIST "Native/")

(MAPC #'ccl-install '("toplevel.kl" "core.kl" "sys.kl" "sequent.kl"
                     "yacc.kl" "reader.kl" "prolog.kl" "track.kl"
                     "load.kl" "writer.kl" "macros.kl" "declarations.kl"
                     "types.kl" "t-star.kl"))

(compile-and-purge "overwrite.lsp")

(MAPC #'FMAKUNBOUND '(boot nn-h native-name move-file
                      compile-and-purge writefile openfile))

(CCL:SAVE-APPLICATION "Shen.exe" :TOPLEVEL-FUNCTION #'shen.byteloop :PREPEND-KERNEL T)
