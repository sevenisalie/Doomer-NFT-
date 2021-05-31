from brownie import *
import time
import os

STATIC_SEED = 420
def main():
    devaccount = accounts.add(os.getenv("PRIVATE_KEY"))
    doomerFactory = AdvancedCollectible[len(AdvancedCollectible) - 1]
     #just a cool way to always work on most recently deployed versoin of our contract AdvancedColelctible

    transaction = doomerFactory.createCollectible(
        STATIC_SEED,
        "None",
        {"from": devaccount},
    )
    transaction.wait(1) #cool way to sleep/await a transactoin
    time.wait(100)
    #read event from smart contract and use it to figure out the type of doomer
    requestId = doomerFactory.events['requestedCollectible']['requestId']
    tokenId = doomerFactory.requestIdToTokenId(requestId)
    color = doomerFactory.requestIdToColor(requestId)
    print(f"You got a {color} DoomerGuy")
    print(f"This is {tokenId} Doomerguy")