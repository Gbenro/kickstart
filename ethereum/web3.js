import Web3 from "web3";


let web3;
// checking to see if we are on the server or the browser and if metamask is running
if (typeof window !== "undefined" && typeof window.web3 !== "undefined") {
  //we are in the browser and metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  // we are on the server *OR* the user is not running metamask
  const provider = new Web3.providers.HttpProvider(
    "https://rinkeby.infura.io/TtUrxmqmedKiVhPY77Ve"
  );
  web3 = new Web3(provider);
}

export default web3;
