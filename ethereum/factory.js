import web3 from './web3';
import CampaignFactory from './build/CampaignFactory';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0xE53753F91414D77fD25e7636C1B1e42a4607C560'
);

export default instance;
