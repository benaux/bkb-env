---
generator: 'MediaWiki 1.16.4'
title: 'Using Gambit with External Libraries - Gambit wiki'
---



Using Gambit with External Libraries {#firstHeading .firstHeading}
====================================




+-----------------------------------------------------------------------+
| <div id="toctitle">                                                   |
|                                                                       |
| Contents                                                              |
| --------                                                              |
|                                                                       |
| </div>                                                                |
|                                                                       |
| -   [[1]{.tocnumber} [The return strategy required by Gambit apps on  |
|     Scheme-&gt;C-&gt;Scheme                                           |
|     calls]{.toctext}](#The_return_strategy_required_by_Gambit_apps_on |
| _Scheme-.3EC-.3EScheme_calls)                                         |
| -   [[2]{.tocnumber} [Ensuring singlethreaded                         |
|     behaviour]{.toctext}](#Ensuring_singlethreaded_behaviour)         |
| -   [[3]{.tocnumber} [Export and import C                             |
|     symbols]{.toctext}](#Export_and_import_C_symbols)                 |
| -   [[4]{.tocnumber} [Using gsc to compile and link a dynamically     |
|     loadable object file that uses external                           |
|     libraries]{.toctext}](#Using_gsc_to_compile_and_link_a_dynamicall |
| y_loadable_object_file_that_uses_external_libraries)                  |
| -   [[5]{.tocnumber} [Accessing Scheme vectors within a C             |
|     function]{.toctext}](#Accessing_Scheme_vectors_within_a_C_functio |
| n)                                                                    |
| -   [[6]{.tocnumber} [Practices in FFI                                |
|     development]{.toctext}](#Practices_in_FFI_development)            |
| -   [[7]{.tocnumber} [Garbage collect foreign c                       |
|     objects]{.toctext}](#Garbage_collect_foreign_c_objects)           |
+-----------------------------------------------------------------------+

[ The return strategy required by Gambit apps on Scheme-&gt;C-&gt;Scheme calls ]{#The_return_strategy_required_by_Gambit_apps_on_Scheme-.3EC-.3EScheme_calls .mw-headline}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

How Gambit integrates the Scheme heap with the C stack is described in
the section "19.7 Continuations and the C-interface" in the manual, and
also in section 3 of the paper [A Portable Implementation of First-Class
Continuations for Unrestricted Interoperaibility with C in a
Multithreaded
Scheme](http://www.iro.umontreal.ca/~feeley/papers/FeeleySW00.pdf){.external
.text}. Here is a clarification though, which was detailed 28 march 2011
on the mailing list:

If you have several C stack frames (produced by a Scheme-&gt;C call
which made a C-&gt;Scheme call that made a Scheme-&gt;C call in turn) at
the same time, you must return them in the same sequence as you'd have
needed to do ordinarily in C, i.e. from the last to the first in
sequence.

I.e., if you have the Scheme procedures A, C, E and G, and the C
procedures b, d and f, and they invoke each other A -&gt; b -&gt; C
-&gt; d -&gt; E -&gt; f -&gt; G, then you must ensure that G will return
to f, f to E, E to d, d to C, C to b and b to A.

If you return them in another order - i.e. for example G to d etc. -
there will be a runtime error, which terminates the application
silently.

Note that anytime during a program's execution in the Scheme world,
Gambit's thread multitasker may switch the running thread. If several
threads do Scheme-&gt;C-&gt;Scheme calls at the same time, then in the
ordinary case, thread switching may happen such that the C stack is
rewinded invalidly (i.e. in another order than as described above),
which at some point (not necessarily on the first invalid return) will
cause the abovementioned runtime error. You can fix this by

-   keeping all Scheme-&gt;C-&gt;Scheme calls in your app to one thread
    in total,
-   by rewriting your code to do what you wanted to achieve through
    making a C-&gt;Scheme call some other way instead (for instance by
    using advanced C programming techniques that are beyond the scope of
    this document),
-   or by going with the "Ensuring singlethreaded behavior" described
    below.

(Advanced note: Actually Gambit allows you to skip returning procedures,
i.e. A -&gt; b -&gt; C -&gt; d -&gt; E, and then E returns directly to
b, works. On the call to b, d's C stack frame is rewinded though, and
returning to d would cause the abovementioned runtime error. This works
because Gambit on the call to b makes a longjump that simply disposes of
d's stack frame. This strategy could cause stack memory leaks though. If
you by any reason explore how use of this side of the FFI can be made
use of, please document it here and on the mailing list.)

[ Ensuring singlethreaded behaviour ]{#Ensuring_singlethreaded_behaviour .mw-headline}
--------------------------------------------------------------------------------------

In certain situations, it's vital to ensure a single thread of
execution.

One way may be to create one thread to which you send closures
containing code to be executed, and which returns the responses through
a mailbox mechanism, there's an example implementation in the Gambit
manual.

Ways to get Gambit execute completely single-threaded is:

-   Use (thread-quantum-set! (current-thread) +inf.0)

<!-- -->

-   Use (\#\#disable-interrupts) and (\#\#enable-interrupts) in Scheme
    or \_\_\_EXT(\_\_\_disable\_interrupts)() and
    \_\_\_EXT(\_\_\_enable\_interrupts)() from C.

Please note that Gambit's I/O system makes use of the scheduler, and
threading routines do this also, so don't do read, write, thread-sleep!,
thread-yield! etc. in code you intended to execute single-threaded.

[ Export and import C symbols ]{#Export_and_import_C_symbols .mw-headline}
--------------------------------------------------------------------------

Gambit's gambit.h provides helper macros for exporting functions and
variables. They are \_\_\_EXPORT\_FUNC(type,name) and
\_\_\_EXPORT\_DATA(type,name), and are used like
\_\_\_EXPORT\_FUNC(int,five) () { return 5; } . Grep lib/\*.c of the
Gambit sources for EXP\_FUNC and EXP\_DATA to see examples.

On Windows, exporting and importing functions and variables from C code
may be particularly tricky. Check out the Microsoft-provided
\_\_declspec(dllexport) and \_\_declspec(dllimport).

[ Using gsc to compile and link a dynamically loadable object file that uses external libraries ]{#Using_gsc_to_compile_and_link_a_dynamically_loadable_object_file_that_uses_external_libraries .mw-headline}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Here is an example of building a dynamically loadable Gambit object file
that uses [FFTW](http://www.fftw.org){.external .text}. This example is
on Red Hat Enterprise Linux 4.2 on x86-64.

The program uses the FFTW version 2 API, so we downloaded
fftw-2.1.5.tar.gz, untarred it and configured it with

    ./configure --enable-shared --prefix=/export/users/lucier/local/fftw-2.1.5

You need the `--enable-shared` option because shared Gambit modules must
be linked to shared external libraries. I set the `--prefix` to install
the final FFTW libraries and header files in my home directory.

The file `fftbasics.scm` provides the basic interface between the Scheme
code and FFTW; it is as follows:

    (c-declare
    "
    #include \"fftw.h\"

    fftwnd_plan p;

    ")

    (define fftw2d_create_plan_backward
      (c-lambda ()
                void
                "p = fftw2d_create_plan(64,
                                        64,
                                        FFTW_BACKWARD,
                                        FFTW_ESTIMATE | FFTW_IN_PLACE);
                "))

    (define fftw2d_create_plan_forward
      (c-lambda ()
                void
                "p = fftw2d_create_plan(64,
                                        64,
                                        FFTW_FORWARD,
                                        FFTW_ESTIMATE | FFTW_IN_PLACE);
                "))

    ;;; Both forward and backward ffts, depends on which way the plan was created.

    (define fftwc
      (c-lambda (scheme-object)
                void
                "
    int j; double *fp = (double *)((___WORD)___BODY_AS(___arg1,___tSUBTYPED));
      fftwnd_one(p,
                 (fftw_complex *)(fp),
                 NULL);
      for (j = 0; j < 64 * 64 * 2; j++)
        fp[j] *= .015625;
    "))

We need to pass special options to gsc to compile this file, namely

    gsc -cc-options "-I/export/users/lucier/local/fftw-2.1.5/include" \
        -ld-options "-L/export/users/lucier/local/fftw-2.1.5/lib/ -Wl,-rpath,/export/users/lucier/local/fftw-2.1.5/lib/ -lfftw" fftbasic.scm

The first option (`-I/export/users/lucier/local/fftw-2.1.5/include`)
tells gcc where to find the header file `fftw.h` at compile time. The
second option (`-L/export/users/lucier/local/fftw-2.1.5/lib/`) tells the
linker where to find the FFTW library (`-lfftw`) at link time (i.e.,
when building the file `fftwbasic.o1` from `fftwbasic.o`), and the third
option (`-Wl,-rpath,/export/users/lucier/local/fftw-2.1.5/lib/`) tells
the dynamic loader `ldd` where to find the FFTW library when
`fftwbasic.o1` is loaded into gsc.

**Aside**: Note that if the headers and libraries are in a standard
place known to gcc, and the location of the shared library is already in
the path of the dynamic loader, then these options may not be necessary.
In many GNU/Linux systems, for examples, nearly all packages are
installed in `/usr/{bin,include,lib}`, and you may not need to pass
these special options to gsc.

Then we can do

    euler-316% gsc
    Gambit v4.2.8

    > (load "fftbasic")
    "/export/users/lucier/programs/gambc-v4_2_8/test-load-options/fftbasic.o1"
    > fftwc
    #<procedure #2 fftwc>
    >
    *** EOF again to exit

We can check that `fftbasic.o1` links to the right libraries:

    euler-317% ldd fftbasic.o1
            libfftw.so.2 => /export/users/lucier/local/fftw-2.1.5/lib/libfftw.so.2 (0x0000002a9565a000)
            libc.so.6 => /lib64/tls/libc.so.6 (0x0000002a957aa000)
            libm.so.6 => /lib64/tls/libm.so.6 (0x0000002a959df000)
            /lib64/ld-linux-x86-64.so.2 (0x000000552aaaa000)

Finally, recall from the the [Gambit
manual](http://www.iro.umontreal.ca/~gambit/doc/gambit-c.html#SEC21){.external
.text} that anything you can do with gsc on the command line you can do
with one of the gsc-specific scheme procedures `compile-file`,
`compile-file-to-c`, `link-incremental`, or `link-flat`. Thus, one could
build `fftbasic.o1` by

    euler-352% gsc
    Gambit v4.2.8

    > (compile-file "fftbasic.scm" cc-options: "-I/export/users/lucier/local/fftw-2.1.5/include"
     ld-options: "-L/export/users/lucier/local/fftw-2.1.5/lib/ -Wl,-rpath,/export/users/lucier/local/fftw-2.1.5/lib/ -lfftw")
    #t
    > (load "fftbasic")
    "/export/users/lucier/programs/gambc-v4_2_8/test-load-options/fftbasic.o1"
    > fftwc
    #<procedure #2 fftwc>

\

[ Accessing Scheme vectors within a C function ]{#Accessing_Scheme_vectors_within_a_C_function .mw-headline}
------------------------------------------------------------------------------------------------------------

Example. Get the pointer to the beginning of a u8vector Scheme object:

    (define ffi-with-scheme-vectors
      (c-lambda (scheme-object int) ; scheme-object : the vector , int : the vector size
                void
                "
    //void *u8vectorptr = ___CAST(void*,&___FETCH_U8(___BODY(___arg1),___INT(0)));
    //void *u8vectorptr = ___CAST(void*,&___FETCH_U8(___arg1,0));
    //void *u8vectorptr = ___CAST(void*,___BODY(___arg1));
    //void *u8vectorptr = ___CAST(___U8*,___BODY_AS(___arg1,___tSUBTYPED));

    // Of course, you can cast directly to uchar* if you plan to work with that
    unsigned char *u8vectorptr = ___CAST(___U8*,___BODY_AS(___arg1,___tSUBTYPED));

    /* Then here do your work with *u8vectorptr, you have its size as the ___arg2 argument */
                "))

(Note: There are macros also to get vector length. Note that some of the
vector-related deal with vector size in bytes not elements, and that
they may return the length as a Gambit fixnum so you need to run it
through the \_\_\_INT macro to get it in C int format.)

Look for examples in "gambit.h"

Caveat: the C compiler does not know that the GC might move objects, so
the C code must be written to avoid calling the GC either directly or
indirectly. Remember that the pointer is only to be kept until the next
return to Scheme.

[ Practices in FFI development ]{#Practices_in_FFI_development .mw-headline}
----------------------------------------------------------------------------

(There are a couple of posts from September 2008 in the mailing list
archive on this subject. Someone please cut and paste them over here.)

      https://mercure.iro.umontreal.ca/pipermail/gambit-list/2008-September/002572.html

[ Garbage collect foreign c objects ]{#Garbage_collect_foreign_c_objects .mw-headline}
--------------------------------------------------------------------------------------

For more information see Wills in section Weak references from the
gambit [user
documentation](http://www.iro.umontreal.ca/~gambit/doc/gambit-c.html#Weak-references){.external
.text}.

Here is a self-explanatory and simple example, using malloc and free
functions letting the gambit to control the lifetime.

In a file:

    ;; gc-ffi.scm

    (c-declare "#include <stdlib.h>")
    (define malloc (c-lambda (int) (pointer void) "malloc"))
    (define free (c-lambda ((pointer void)) void "free"))

    (define (make-memory bytes)
      (let ((mem (malloc bytes)))
        (make-will mem (lambda (obj) (display "free function called\n") (free obj)))
        mem))

\
in gsc:

    > (compile-file "gc-ffi")
    #t
    > (load "gc-ffi")        
    "/home/user/gc-ffi.o1"
    > (define x (make-memory 10))
    > (##gc) ;; Make the garbage collection run
    > (define x 'other-thing)
    > (##gc)                 
    free function called

The most important function here is **make-will**, it enables to call a
function when some object is not more strongly referenced.


Retrieved from
"<http://gambitscheme.org/wiki/index.php/Using_Gambit_with_External_Libraries>"

