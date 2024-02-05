pub fn fibnacci(mut n: felt252) -> felt252 {
    let mut a: felt252 = 0;
    let mut b: felt252 = 1;
    loop {
        if n == 0 {
            break a;
        }
        n = n - 1;
        let temp = b;
        b = a + b;
        a = temp;
    }
}

#[cfg(test)]
mod tests {
    use super::fibnacci;

    #[test]
    fn it_works() {
        assert(fibnacci(16) == 987, 'it works!');
    }
}
