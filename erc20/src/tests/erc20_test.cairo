use starknet::ContractAddress;

use starknet::contract_address_const;
use starknet::syscalls::deploy_syscall;
use starknet::testing;
use super::super::erc20::ERC20::{Approval, Transfer};
use super::super::erc20::ERC20;
use super::super::erc20::IERC20Dispatcher;
use super::super::erc20::IERC20DispatcherTrait;

// Constants
const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 18_u8;
const SUPPLY: u256 = 2000;
const VALUE: u256 = 300;

fn CALLER() -> ContractAddress {
    contract_address_const::<'CALLER'>()
}

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}
fn SPENDER() -> ContractAddress {
    contract_address_const::<'SPENDER'>()
}
fn ZERO() -> ContractAddress {
    contract_address_const::<0>()
}

// Utils
fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = deploy_syscall(
        contract_class_hash.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}
fn drop_event(address: ContractAddress) {
    testing::pop_log_raw(address);
}
trait SerializedAppend<T> {
    fn append_serde(ref self: Array<felt252>, value: T);
}

impl SerializedAppendImpl<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of SerializedAppend<T> {
    fn append_serde(ref self: Array<felt252>, value: T) {
        value.serialize(ref self);
    }
}
/// Pop the earliest unpopped logged event for the contract as the requested type
/// and checks there's no more keys or data left on the event, preventing unaccounted params.
///
/// This function also removes the first key from the event, to match the event
/// structure key params without the event ID.
///
/// This method doesn't currently work for components events that are not flattened
/// because an extra key is added, pushing the event ID key to the second position.
fn pop_log<T, +Drop<T>, +starknet::Event<T>>(address: ContractAddress) -> Option<T> {
    let (mut keys, mut data) = testing::pop_log_raw(address)?;

    // Remove the event ID from the keys
    keys.pop_front();

    let ret = starknet::Event::deserialize(ref keys, ref data);
    assert!(data.is_empty(), "Event has extra data");
    assert!(keys.is_empty(), "Event has extra keys");
    ret
}

/// Asserts that `expected_keys` exactly matches the indexed keys from `event`.
///
/// `expected_keys` must include all indexed event keys for `event` in the order
/// that they're defined.
fn assert_indexed_keys<T, +Drop<T>, +starknet::Event<T>>(event: T, expected_keys: Span<felt252>) {
    let mut keys = array![];
    let mut data = array![];

    event.append_keys_and_data(ref keys, ref data);
    assert!(expected_keys == keys.span());
}

fn assert_no_events_left(address: ContractAddress) {
    assert!(testing::pop_log_raw(address).is_none(), "Events remaining on queue");
}

fn assert_event_approval(
    contract: ContractAddress, owner: ContractAddress, spender: ContractAddress, value: u256
) {
    let event = pop_log::<Approval>(contract).unwrap();
    assert_eq!(event.owner, owner);
    assert_eq!(event.spender, spender);
    assert_eq!(event.value, value);

    // Check indexed keys
    let mut indexed_keys = array![];
    indexed_keys.append_serde(owner);
    indexed_keys.append_serde(spender);
    assert_indexed_keys(event, indexed_keys.span())
}

fn assert_only_event_approval(
    contract: ContractAddress, owner: ContractAddress, spender: ContractAddress, value: u256
) {
    assert_event_approval(contract, owner, spender, value);
    assert_no_events_left(contract);
}

fn assert_event_transfer(
    contract: ContractAddress, from: ContractAddress, to: ContractAddress, value: u256
) {
    let event = pop_log::<Transfer>(contract).unwrap();
    assert_eq!(event.from, from);
    assert_eq!(event.to, to);
    assert_eq!(event.value, value);

    // Check indexed keys
    let mut indexed_keys = array![];
    indexed_keys.append_serde(from);
    indexed_keys.append_serde(to);
    assert_indexed_keys(event, indexed_keys.span());
}

fn assert_only_event_transfer(
    contract: ContractAddress, from: ContractAddress, to: ContractAddress, value: u256
) {
    assert_event_transfer(contract, from, to, value);
    assert_no_events_left(contract);
}

// Setup
fn setup_dispatcher_with_event() -> IERC20Dispatcher {
    let mut calldata = array![];

    calldata.append_serde(NAME);
    calldata.append_serde(SYMBOL);
    calldata.append_serde(DECIMALS);
    calldata.append_serde(SUPPLY);

    let address = deploy(ERC20::TEST_CLASS_HASH, calldata);
    IERC20Dispatcher { contract_address: address, }
}

fn setup_dispatcher() -> IERC20Dispatcher {
    let dispatcher = setup_dispatcher_with_event();
    drop_event(dispatcher.contract_address);
    dispatcher
}

#[test]
fn test_constructor() {
    let mut dispatcher = setup_dispatcher_with_event();

    assert_eq!(dispatcher.name(), NAME);
    assert_eq!(dispatcher.symbol(), SYMBOL);
    assert_eq!(dispatcher.decimals(), DECIMALS);
    assert_eq!(dispatcher.total_supply(), SUPPLY);
}

#[test]
fn test_approve() {
    let mut dispatcher = setup_dispatcher();
    // let allowance = dispatcher.allowance(OWNER(), SPENDER());
    // assert!(allowance.is_zero());

    testing::set_contract_address(OWNER());
    assert!(dispatcher.approve(SPENDER(), VALUE));

    let allowance = dispatcher.allowance(OWNER(), SPENDER());
    assert_eq!(allowance, VALUE);

    assert_only_event_approval(dispatcher.contract_address, OWNER(), SPENDER(), VALUE);
}
