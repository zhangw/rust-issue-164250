#!/usr/bin/env bash
# 在 numa_dev 上运行：编译 / 运行 / 导出汇编、MIR
set -u
cd "$(dirname "$0")"
export PATH=$HOME/.cargo/bin:$PATH
mkdir -p out
rustc -V
for opt in 0 2; do
  for src in issue_original demo; do
    b=out/${src}_O${opt}
    rustc --edition 2021 -C opt-level=$opt -g -C debuginfo=2 -C force-frame-pointers=yes \
      --emit=link=$b,asm=$b.s,mir=$b.mir src/$src.rs -o $b || exit 1
    objdump -d -M intel --no-show-raw-insn -C $b > $b.objdump
    printf '%-24s => ' "$b"; ./$b
  done
done
echo "--- rejected.rs（对照组，预期编译失败）---"
rustc --edition 2021 rejected/rejected.rs -o out/rejected 2>&1 | sed 's/^/    /'
echo "--- ASan（stable + RUSTC_BOOTSTRAP 打开 -Zsanitizer）---"
RUSTC_BOOTSTRAP=1 rustc --edition 2021 -g -Zsanitizer=address src/issue_original.rs -o out/issue_asan 2>&1 | tail -3
[ -x out/issue_asan ] && ./out/issue_asan 2>&1 | head -30
