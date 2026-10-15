// 对照组：语义相同，只是把 "先 None 再赋值" 改成 "构造时直接给值"。编译器正确拒绝 (E0597)。
struct Q<'a: 'static>(Option<&'a String>);
impl<'a: 'static> Drop for Q<'a> {
    fn drop(&mut self) {}
}
fn main() {
    let l = String::from("hello");
    let _q = Q(Some(&l));
}
