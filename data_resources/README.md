# Data Resources

Smart Contract Library and dApp Library will be automatically updated by identifying and judging the latest Repo on Github.

* **Public Document of APTOS:**  Aptos public documentation, serving general knowledge.
* **Projects Library:** Project documentation, collecting Move projects with excellent code quality.
* **Smart Contract Library:** Aptos smart contract documentation, serving the development of smart contracts. dApp Library: Aptos dApp documentation, serving the development of dApps.

# `move_example_dataset`

Move Example Dataset is the dataset about [move-examples](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples) by the Public. Here are the cases that including in the dataset (which have `[√]` on the right side).

```
.
├── Cargo.toml
├── README.md
├── argument_example
│   ├── Move.toml
│   └── sources
│       └── arguments.move
├── cli-e2e-tests
│   ├── README.md
│   ├── common
│   │   └── sources
│   │       ├── cli_e2e_tests.move
│   │       └── cli_e2e_tests_script.move
│   ├── devnet
│   │   ├── Move.toml
│   │   └── sources -> ../common/sources/
│   ├── mainnet
│   │   ├── Move.toml
│   │   └── sources -> ../common/sources/
│   └── testnet
│       ├── Move.toml
│       └── sources -> ../common/sources/
├── cli_args
│   ├── Move.toml
│   ├── entry_function_arguments.json
│   ├── script_function_arguments.json
│   ├── scripts
│   │   └── set_vals.move
│   ├── sources
│   │   └── cli_args.move
│   └── view_function_arguments.json
├── common_account
│   ├── Move.toml
│   └── sources
│       └── common_account.move [√]
├── dao
│   └── nft_dao
│       ├── Move.toml
│       ├── README.md
│       ├── doc_images
│       │   └── Screenshot_2023-01-20_at_1.46.33_PM.png
│       └── sources
│           ├── bucket_table.move
│           ├── nft_dao.move
│           └── nft_dao_events.move
├── data_structures
│   ├── Move.toml
│   └── sources
│       └── iterable_table.move [√]
├── defi
│   ├── Move.toml
│   └── sources
│       └── locked_coins.move
├── fungible_asset
│   ├── README.md
│   ├── managed_fungible_asset
│   │   ├── Move.toml
│   │   └── sources
│   │       ├── coin_example.move
│   │       └── managed_fungible_asset.move
│   ├── managed_fungible_token
│   │   ├── Move.toml
│   │   └── sources
│   │       └── managed_fungible_token.move
│   ├── multisig_managed_coin
│   │   ├── Move.toml
│   │   └── sources
│   │       └── multisig_managed_coin.move
│   ├── preminted_managed_coin
│   │   ├── Move.toml
│   │   └── sources
│   │       └── preminted_managed_coin.move
│   └── simple_managed_coin
│       ├── Move.toml
│       └── sources
│           └── simple_managed_coin.move
├── governance
│   ├── Move.toml
│   ├── metadata-example.json
│   └── sources
│       ├── block_update_epoch_interval.move
│       ├── governance_update_voting_duration.move
│       ├── stake_update_min_max.move
│       ├── stake_update_recurring_lockup_time.move
│       ├── stake_update_rewards_rate.move
│       └── stake_update_voting_power_increase_limit.move
├── groth16_example
│   ├── Move.toml
│   └── sources
│       └── groth16.move
├── hello_blockchain
│   ├── Move.toml
│   ├── build
│   │   └── Examples
│   │       ├── BuildInfo.yaml
│   │       ├── bytecode_modules
│   │       ├── source_maps
│   │       └── sources
│   └── sources
│       ├── hello_blockchain.move [√]
│       └── hello_blockchain_test.move
├── hello_prover
│   ├── Move.toml
│   └── sources
│       └── prove.move [√]
├── marketplace
│   ├── Move.toml
│   ├── README.md
│   └── sources
│       ├── coin_listing.move
│       ├── collection_offer.move
│       ├── events.move
│       ├── fee_schedule.move
│       ├── listing.move
│       └── test_utils.move
├── message_board
│   ├── Move.toml
│   └── sources
│       ├── acl_message_board.move
│       ├── cap_message_board.move
│       └── offer.move
├── mint_nft
│   ├── 1-Create-NFT
│   │   ├── Move.toml
│   │   └── sources
│   │       └── create_nft.move
│   ├── 2-Using-Resource-Account
│   │   ├── Move.toml
│   │   └── sources
│   │       └── create_nft_with_resource_account.move
│   ├── 3-Adding-Admin
│   │   ├── Move.toml
│   │   └── sources
│   │       └── create_nft_with_resource_and_admin_accounts.move
│   ├── 4-Getting-Production-Ready
│   │   ├── Move.toml
│   │   └── sources
│   │       └── create_nft_getting_production_ready.move
│   └── README.md
├── moon_coin
│   ├── Move.toml
│   ├── scripts
│   │   └── register.move
│   └── sources
│       └── MoonCoin.move
├── move-tutorial
│   ├── README.md
│   ├── diagrams
│   │   ├── move_state.png
│   │   └── solidity_state.png
│   ├── step_1
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_2
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_2_sol
│   │   ├── basic_coin
│   │   │   ├── Move.toml
│   │   │   └── sources
│   │   └── solution_commands
│   ├── step_3
│   │   └── basic_coin.move
│   ├── step_4
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_4_sol
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_5
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_5_sol
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_6
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_7
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_8
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   ├── step_8_sol
│   │   └── basic_coin
│   │       ├── Move.toml
│   │       └── sources
│   └── test.sh
├── msg
│   ├── Move.toml
│   ├── build
│   │   └── msg
│   │       ├── BuildInfo.yaml
│   │       ├── bytecode_modules
│   │       ├── source_maps
│   │       └── sources
│   ├── sources
│   │   └── msg.move
│   └── tests
├── my_first_dapp
│   ├── client
│   │   ├── README.md
│   │   ├── package-lock.json
│   │   ├── package.json
│   │   ├── public
│   │   │   ├── favicon.ico
│   │   │   ├── index.html
│   │   │   ├── manifest.json
│   │   │   └── robots.txt
│   │   ├── src
│   │   │   ├── App.test.tsx
│   │   │   ├── App.tsx
│   │   │   ├── index.tsx
│   │   │   ├── react-app-env.d.ts
│   │   │   ├── reportWebVitals.ts
│   │   │   └── setupTests.ts
│   │   └── tsconfig.json
│   └── move
│       ├── Move.toml
│       └── sources
│           └── todolist.move
├── post_mint_reveal_nft
│   ├── Move.toml
│   └── sources
│       ├── big_vector.move
│       ├── bucket_table.move
│       ├── minting.move
│       └── whitelist.move
├── resource_account
│   ├── Move.toml
│   └── sources
│       └── simple_defi.move
├── resource_groups
│   ├── primary
│   │   ├── Move.toml
│   │   └── sources
│   │       └── primary.move
│   └── secondary
│       ├── Move.toml
│       └── sources
│           └── secondary.move
├── scripts
│   ├── minter
│   │   ├── Move.toml
│   │   ├── build
│   │   │   └── Minter
│   │   └── sources
│   │       └── minter.move
│   └── two_by_two_transfer
│       ├── Move.toml
│       └── sources
│           └── script.move
├── shared_account
│   ├── Move.toml
│   └── sources
│       └── shared_account.move
├── split_transfer
│   ├── Move.toml
│   └── sources
│       └── split_transfer.move
├── src
│   ├── lib.rs
│   └── main.rs
├── tests
│   ├── move_prover_tests.rs
│   └── move_unit_tests.rs
├── tic-tac-toe
│   ├── Move.toml
│   └── sources
│       └── TicTacToe.move
├── token_objects
│   ├── README.md
│   ├── ambassador
│   │   ├── Move.toml
│   │   └── sources
│   │       └── ambassador.move
│   ├── hero
│   │   ├── Move.toml
│   │   └── sources
│   │       └── hero.move
│   ├── knight
│   │   ├── Move.toml
│   │   └── sources
│   │       ├── food.move
│   │       └── knight.move
│   └── token_lockup
│       ├── Move.toml
│       └── sources
│           ├── token_lockup.move
│           └── unit_tests.move
└── upgrade_and_govern
    ├── README.md
    ├── genesis
    │   ├── Move.toml
    │   └── sources
    │       └── parameters.move
    └── upgrade
        ├── Move.toml
        ├── scripts
        │   ├── set_and_transfer.move
        │   └── set_only.move
        └── sources
            ├── parameters.move
            └── transfer.move
```

# How to slice Move Smart Contract into pieces and submit them to Dataset?

Now use GPT-4 to convert the contract into JSON format manually, and then upload it through the script.

The `Prompt` is as following:

````
You are a Move smart contract programmer, please slice the following code into Struct, Event(Event is struct which name including `Event`), Const, Function and Test parts, display slice fragments of code using Markdown syntax, and use the following json format on the overall output: {"struct": [code_slice_1, code_slice_2], "event": ...}. Attention that every part should NOT be `...`in the test but actually code.
Code:
```
-[The Smart Contract Code]-
```
````

Result: 

![image-20230705092556679](https://p.ipic.vip/sigrnh.png)

Then using the `EmbedbaseUploader` to submit them to the embedbase dataset.

> app/scaffold_aptos_based_on_ai/lib/scaffold_aptos_based_on_ai/embedbase_uploader.ex

