set pagination off
set disable-randomization on
set language c
define d2
  printf "=== pc=%p rbp=%p rbx=%p\n", $pc, $rbp, $rbx
  x/5gx $rbp-0x28
  x/gx (long*)(0x555555554000+0x56228)
end
break *(0x555555554000+0x13e05)
break *(0x555555554000+0x13e0d)
break *(0x555555554000+0x13e15)
break *(0x555555554000+0x13e2d)
break *(0x555555554000+0x13e3c)
break *(0x555555554000+0x13e56)
run
d2
x/4gx *(long*)($rbp-0x18)
continue
d2
x/4gx *(long*)($rbp-0x18)
continue
d2
x/4gx *(long*)($rbp-0x18)
continue
d2
x/4gx *(long*)($rbp-0x18)
continue
d2
x/4gx *(long*)($rbp-0x18)
continue
d2
x/s *(long*)($rbp-0x18)
continue
