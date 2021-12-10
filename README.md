# Chainlink Random Character Creation

This repo is a starting point for creating:

1. NFTs built with verifiable RNG using the [Chainlink VRF](https://docs.chain.link/docs/get-a-random-number)
2. Create dynamic NFTs that change based on real world data. [By using decentralized oracles to get data.](https://docs.chain.link/docs/make-a-http-get-request)
3. Adding your randomized NFTs to the [OpenSea Marketplace](https://opensea.io/)

Skip down to [deploy To Opensea](#deploy-to-opensea) - to see how to add a tokenURI

## Quickstart

Right now this repo only works with Rinkeby. Run the following.

### Setup Environment Variables

You'll need a `MNEMONIC` and a rinkeby `RINKEBY_RPC_URL` environment variable. Your `MNEMONIC` is your seed phrase of your wallet. You can find an `RINKEBY_RPC_URL` from node provider services like [Infura](https://infura.io/)

Then, you can create a `.env` file with the following.

```bash
MNEMONIC='cat dog frog....'
RINKEBY_RPC_URL='https://rinkeby.infura.io/ffffff'
```

Or, set them in a `bash_profile` file or export them directly into your terminal. You can learn more about [environment variables here](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html).

To run them directly in your terminal, run:

```bash
export MNEMONIC='cat dog frog....'
export RINKEBY_RPC_URL='https://rinkeby.infura.io/ffffff'
```

### Deploy

```bash
npx hardhat deploy
```

### Funds a contract with LINK

```bash
npx hardhat fund-link --contract, heroCharacter.address
```

### Request a random character

```bash
npx hardhat request-random-character --contract heroCharacter.address
```

### Generate a character

```bash
npx hardhat get-character --contract heroCharacter.address
```
