# cairo-workshop

Starknet Cairo contract workshop

## Cairo Bootcamp

* <https://starknetastro.xlog.app/cairosetup>
* <https://starknetastro.xlog.app/bootcamp_lesson2_deploy_erc20_to_starknet>

## Accounts

```sh
starkli signer keystore new ~/.starknet_accounts/key.json
export STARKNET_KEYSTORE=~/.starknet_accounts/key.json
starkli account oz init ~/.starknet_accounts/starkli.json
export STARKNET_RPC=https://starknet-testnet.public.blastapi.io
starkli balance xxx # get faucet
starkli account deploy ~/.starknet_accounts/starkli.json
export STARKNET_ACCOUNT=~/.starknet_accounts/starkli.json
```

## Public RPC

* [BLAST RPC](https://blastapi.io/public-api/starknet)

## Books

* [Cairo Book](https://book.cairo-lang.org/)
* [Starkli Book](https://book.starkli.rs/)

## Tools

* Wallet: Braavos
* [Scarb](https://docs.swmansion.com/scarb) - build toolcahin and package manager for cairo
* [Starkli](https://github.com/xJonathanLEI/starkli) - starknet chain operate tool
* [starknet-foundry](https://github.com/foundry-rs/starknet-foundry) - Foundry fork for cairo
