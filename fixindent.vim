:%s/\n//g
:%s/;/;/g
:%s/}/}/g
:%s/{/{/g
gg=G
:%s/\s\+$//g
:%s/^\(package\) \(.\+\)$/\1 \2/g
:%s/^\(.\+ class .\+\)$/\1/g
:%s/\(if\|for\|while\)\s*(\(.\+\))$/\1#`start#\2#`end#/g
:%s/\(if\|for\|while\)\s*(\(.\+\))\s*\(.\+;\)$/\1#`start#\2#`end#{\3}/g
gg=G
:%s/^\(.\+)\)$/\1/g
:%s/\(if\|for\|while\)#`start#\(.\+\)#`end#$/\1 (\2)/g 
:%s/\(if\|for\|while\)\(\s*(.\+)\n\)\(\s*{\)\n\s*\(.\+\)\n\s*\(}\)/\1\2\3 \4 \5/g
gg=G
:wq
:q!
