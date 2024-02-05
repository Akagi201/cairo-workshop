mod fib;
use fib::fibnacci;

fn main() -> felt252 {
    let f = fibnacci(16);
    println!("fib(16) = {}", f);
    f
}
