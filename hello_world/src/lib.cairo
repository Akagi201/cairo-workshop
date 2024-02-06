mod fib;
mod add;
mod arr;
mod structs;

use fib::fibnacci;
use add::add_one;
use arr::pop_len;
use structs::Wallet;

fn main() {
    {
        let f = fibnacci(16);
        println!("fib(16) = {}", f);
    }
    {
        let mut x = 5;
        add_one(ref x);
        println!("add_one(5) = {}", x);
    }
    {
        let mut x = array![1, 2, 3];
        let y = pop_len(ref x);
        println!("x.len() = {}, y = {}", x.len(), y);
    }
    {
        let _w = Wallet { balance: 3, };
    }
}
