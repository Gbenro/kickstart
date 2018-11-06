import web3 from './web3';
import CampaignFactory from './build/CampaignFactory';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x1B331ab2B018AD501D8E090054100Ac13562A599'
);

export default instance;
