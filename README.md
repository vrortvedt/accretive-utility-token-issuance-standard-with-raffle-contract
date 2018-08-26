# accretive-issuance-token-standard
Ethereum utility token issuance model where supply is incremented as the token is used

# **Accretive Utility Token Issuance Model**

## **Overview**
The project provides for the accretive minting and issuance of fungible utility tokens utilized by a dApp according to the dApp’s award system.  Instead of tokens being pre-mined (minting all token supply at the moment the token is created) or issued on a time-based automated schedule regardless of token demand or use (as in PoW or PoS block rewards), an accretive utility token issuance model accurately reflects the dApp’s utility while providing users a method to acquire tokens without regard to their economic power.  It also proposes a compensation framework (see The Developer’s Bit section) that is intended to equitably and transparently reward developers in direct proportion to the utility of their dApp.

## **Design Mechanisms**
The mechanics for accretive token issuance built on the [ERC20 fungible token standard](https://theethereum.wiki/w/index.php/ERC20_Token_Standard "Title") and are straightforward:  
1. Create a dApp-specific token and set its total supply to 0.
1. Conduct an award event within the dApp and mint the number of tokens to be awarded for the event, with the default setting being one token per legitimate event participant
1. Transfer 7/8ths of the newly-minted tokens to the award recipient and 1/8th to the dApp developers
1. Increment the total supply by the amount awarded
1. Publish a record of token issuance participants and awardees in storage to the blockchain

There are many applications for an accretive utility token (henceforth AUT) issuance model, and some are discussed below in the User Stories section, but as an example let’s imagine a dApp where verified users compete to submit winning captions for images, a la the New Yorker caption contest.  Following notification of an upcoming award event from the dApp, let’s say that 50 uPort verified users sign up to participate in a caption contest to earn CPTN tokens.  The contest will run for one hour, within which time entrants must both submit a caption and rank some meaningful number of other submitted captions (e.g. sort ten randomly assigned captions submitted by other participants from worst to best) in order to be eligible to claim the token award.   At the conclusion of the award event, if we imagine that 32 users satisfied the award eligibility requirements, the submitter of the top-ranked caption would receive 28 (7/8ths of the total) newly minted CPTN tokens, the dApp developers would receive 4 (1/8th of the total) CPTN tokens and the total CPTN token supply would increase by 32.   Over time, the total CPTN supply will serve as a proxy for how useful the dApp is.

One major advantage of the AUT issuance model is that the total token supply reflects the actual utility of the underlying dApp rather than serving as a barometer for the number of speculators who may not intend to use the dApp but rather are hoping to offload the tokens on others at a profit.  A poorly designed dApp with few actual users will be reflected in an anemic token supply with infrequent issuance events, whereas a popular dApp could be appropriately measured through the number of people actively using it and incrementing its token supply.  The token supply can serve as a signal to would-be users to help them discover actually useful dApps rather than those that sound like they might be useful (coming down with a case of white-paperitis).

Of course, dApps or dApp users may attempt to game the AUT system through use of bots to artificially increase the total supply and give the false impression of utility.  Therefore an AUT issuance model should be coupled with certain identity verification protocols, such as through use of uPort DIDs and rewards for whistleblowers for the discovery of Potemkin accounts.  dApps may include their own award eligibility requirements, but a successful AUT issuance model would be built on a floor of identity verification techniques.

This issuance model also allows for nearly-free participation in award events that allows talented users to amass tokens regardless of their ability to pay.  

Because this model would not allow tokens to be pre-sold as it requires a functioning dApp, and any value wrapped up in the tokens themselves would be created through the efforts of the users of the dApp rather than its developers, it would also appear to fail to meet the Howey test for US securities.  

## **The Developers’ Bit**
Developers of utility dApps may choose to use an AUT issuance model that provides them with token rewards for building a useful dApp in direct proportion to the utility of their dApp.  The concept of the “developer’s bit” is proposed, whereby one-eighth (as there are eight bits in a byte) of the newly minted the developer-controlled address that created the AUT token.  This would align the developers’ interests in receiving a return on their labor with the users’ interests in utilizing fun and engaging decentralized applications.  In the presale/ICO model, developers may lose the incentive to deliver an excellent utility dApp after they have already reaped substantial gains before the product even exists.  In the scheduled-release PoW/PoS model, the total token supply would not signal the utility of the dApp token, only the amount of time that has elapsed since it was launched.

The goal is to create a compensation standard that is baked into the issuance mechanism and that satisfies the community's sense of fairness while appropriately incentivizing (that is, neither under- nor over-incentivizing) developers to create the most useful dApps.

## **User Stories**
* A raffle organizer deploys the contract, becomes its owner via the constructor and sends a transaction via
the openEvent function to open a new raffle.
* Upon deployment, ERC20-compliant RaffleTokens (RFT) are instantiated with a totalSupply of 0
* Participants enter the raffle by sending a transaction via the "enter" function
* Once there are at least two entrants in the raffle, the owner can call "pickWinner" which pseudorandomly chooses a winner
of the raffle, closes the raffle to new entrants and clears the array of current entrants.
* At the moment that a winner is picked, 1 RFT is minted for each entrant, so a minimum of 2 RFT tokens per raffle.
* Also at that moment, the winner is transferred 7/8ths of the minted RFT, and the owner who deployed the contract is 
transferred 1/8th of the minted RFT
* Token balances are stored on the blockchain, and the owner may open a new raffle from the same deployed contract by repeating the first step.  


## **Potential Applications - User Stories**
* Helga, 30 - social game enthusiast
Uses social trust game dApp to play blockchain version of Mafia (aka Werewolf), with members of surviving faction splitting the newly issued tokens.
* Gunnar, 49 - digital artist 
Uses dApp to enter competition with other digital artists to create and evaluate digital artworks within a limited period of time. 
* Joe, 15 - pun enthusiast
Uses dApp to enter timed wordplay contests, with competitors having limited time to submit their best linguistic joke based on some randomized input like a news headline or an unusual photograph.
* Carly, 40 - amateur meteorologist
Uses weather prediction competition dApp to earn reputation as judicious and precise weather forecaster.  She would submit predictions for the high and low temperatures, as well as teh amount of rain one week from now.  A heavily utilized weather forecasting dApp could serve to improve accuracy and availability of weather forecasts.  

## **Library packages**
This contract uses the following OpenZeppelin libraries:
* [math/SafeMath.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol "Title") 
* [ownership/Ownable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol "Title")  
* [lifecycle/Pausable.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol "Title")
* [token/ERC20/ERC20.sol](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol "Title")


 
