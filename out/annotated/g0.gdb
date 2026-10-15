set pagination off
set language c
set disable-randomization on
define dump0
  printf "rbp=%p\n", $rbp
  x/3gx $rbp-0xa0
  x/gx $rbp-0x88
  x/3gx $rbp-0x80
  x/gx (long*)&_RNvCscU8Vk5KhzgW_4demo4KEPT
end
break *(0x555555554000+0x14dae)
break *(0x555555554000+0x14dc7)
break *(0x555555554000+0x14dd3)
break *(0x555555554000+0x14e00)
break *(0x555555554000+0x14e19)
break *(0x555555554000+0x14e98)
run
printf "=== stop 1 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
printf "=== stop 2 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
printf "=== stop 3 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
printf "=== stop 4 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
printf "=== stop 5 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
printf "=== stop 6 pc=%p\n", $pc
dump0
printf "heap(l.ptr): "
x/4gx *(long*)($rbp-0x98)
continue
