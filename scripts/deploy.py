from brownie import *
import os
from scripts.fund import *

def main():
    devaccount = accounts.add(os.getenv('PRIVATE_KEY'))
    publish_source = False
    vrfcoord = config['networks']['rinkeby']['vrf_coordinator']
    linkaddy = config['networks']['rinkeby']['link_token']
    keyhash = config['networks']['rinkeby']['keyhash']
    advanced_collectible = AdvancedCollectible.deploy(vrfcoord, linkaddy, keyhash, {"from": devaccount})
    fund = fund_contract(advanced_collectible)
    return fund
