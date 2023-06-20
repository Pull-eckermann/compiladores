%{
#include "posfixo.tab.h"
%}

%%

[\n\t ]  

\+    { return MAIS; }
\-    { return MENOS; }
\*    { return ASTERISCO;  }
\/    { return DIV;  }
a     { return IDENTA;   }
b     { return IDENTB;   }
or    { return OR;  }
and    { return AND;  }

%%

