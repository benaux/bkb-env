An FFI example gambit scheme/c
==============================

from: https://gist.github.com/ncweinhold/991905


 main.c
#include <stdio.h>

#define ___VERSION 406001
#include "gambit.h"

#include "somescheme.h"

#define SCHEME_LIBRARY_LINKER ____20_somescheme__

___BEGIN_C_LINKAGE
extern ___mod_or_lnk SCHEME_LIBRARY_LINKER (___global_state_struct*);
___END_C_LINKAGE


int main(int argc, char** argv) {
  printf("Hello World, this is from C\n");

  ___setup_params_struct setup_params;
  ___setup_params_reset (&setup_params);

  setup_params.version = ___VERSION;
  setup_params.linker = SCHEME_LIBRARY_LINKER;

  ___setup (&setup_params);

  hello_from_scheme();

  ___cleanup();
  
  return 0;
}
Raw
 somescheme.h
extern void hello_from_scheme(void);
Raw
 somescheme.scm
(c-define (hello) () void "hello_from_scheme" "extern"
	  (write "Hello From Scheme")
	  (newline))
