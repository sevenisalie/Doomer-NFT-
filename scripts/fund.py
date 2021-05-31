from brownie import AdvancedCollectible, accounts, config, interface
import os

def fund_contract(nft_contract):
    devaccount = accounts.add(os.getenv("PRIVATE_KEY"))
    link_token = interface.LinkTokenInterface(config['networks']['rinkeby']['link_token'])
    link_token.transfer(
        nft_contract,
        1 * 10 ** 18,
        {"from": devaccount}
    )
    