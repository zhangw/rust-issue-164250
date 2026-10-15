// rust-lang/rust#164250 的精简版：去掉 dyn Any / Vec<Box<..>>，只保留缺陷本体，
// 让汇编短到能逐行读。
use std::sync::atomic::{AtomicPtr, Ordering};

// 一个全局槽位，存放 "&'static String"（用裸指针存，读时还原成 &'static String）
static KEPT: AtomicPtr<String> = AtomicPtr::new(std::ptr::null_mut());

// 结构体声明：'a 必须 >= 'static。也就是说 Q<'a> 里的引用"保证"活到程序结束
struct Q<'a: 'static>(Option<&'a String>);

impl<'a: 'static> Drop for Q<'a> {
    #[inline(never)]
    fn drop(&mut self) {
        if let Some(s) = self.0 {
            // 在 impl 的 where 子句 'a: 'static 下，这一行类型完全正确：&'a String -> &'static String
            let s: &'static String = s;
            KEPT.store(s as *const String as *mut String, Ordering::Relaxed);
        }
    }
}

#[inline(never)]
fn read_kept() -> &'static String {
    unsafe { &*KEPT.load(Ordering::Relaxed) } // 这里的 unsafe 只是把 Drop 里合法存入的 &'static 取回来
}

fn main() {
    {
        let l = String::from("hello world, this is long enough"); // 32 字节堆内存
        let mut q = Q(None);          // q : Q<'?0>
        q.0 = Some(&l);               // 关键：通过"字段赋值"把短命引用塞进去，编译器没拦
    } // <- 析构顺序：先 q（Drop::drop 把 &l 当作 &'static 存走），再 l（释放堆内存、栈槽失效）

    let z = String::from("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); // 同样 32 字节
    let s: &'static String = read_kept();
    println!("{}", s);               // 读的是已死的 l
    drop(z);
}
