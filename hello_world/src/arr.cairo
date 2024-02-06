pub fn pop_len(ref arr: Array<felt252>) -> felt252 {
    match arr.pop_front() {
        Option::Some(current_value) => { current_value },
        Option::None => { 0 }
    }
}
