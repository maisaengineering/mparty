!function(t){"use strict";t.extend(t.fn.select2.defaults,{formatNoMatches:function(){return"Inga tr\xe4ffar"},formatInputTooShort:function(t,n){var r=n-t.length;return"Var god skriv in "+r+(r>1?" till tecken":" tecken till")},formatInputTooLong:function(t,n){var r=t.length-n;return"Var god sudda ut "+r+" tecken"},formatSelectionTooBig:function(t){return"Du kan max v\xe4lja "+t+" element"},formatLoadMore:function(){return"Laddar fler resultat..."},formatSearching:function(){return"S\xf6ker..."}})}(jQuery);