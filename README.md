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
starkli -vV # get rpc version
export STARKNET_RPC=https://starknet-testnet.public.blastapi.io/rpc/v0_6
starkli balance xxx # get faucet
starkli account deploy ~/.starknet_accounts/starkli.json
export STARKNET_ACCOUNT=~/.starknet_accounts/starkli.json
```

## Public RPC

* [BLAST RPC](https://blastapi.io/public-api/starknet)

## Books

* [Starknet Book](https://book.starknet.io/title-page.html)
* [Cairo Book](https://book.cairo-lang.org/)
* [Starkli Book](https://book.starkli.rs/)
* [zkSecurity Starknet Book](https://zksecurity.github.io/stark-book/introduction.html)
* <https://starklings.app/>

## Nice Libs

* <https://github.com/OpenZeppelin/cairo-contracts>
* <https://github.com/keep-starknet-strange/alexandria>

## Tools

* Wallet: Braavos
* [Scarb](https://docs.swmansion.com/scarb) - build toolchain and package manager for cairo
* [Starkli](https://github.com/xJonathanLEI/starkli) - starknet chain operate tool
* [starknet-foundry](https://github.com/foundry-rs/starknet-foundry) - Foundry fork for cairo
* <https://starkscan.co/> - explorer
* <https://stark-utils.vercel.app/converter> <https://www.stark-utils.xyz/converter>
