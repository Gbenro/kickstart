import React,{Component} from 'react';
import Layout from '../../components/layout';
import Campaign from '../../ethereum/campaign';
import {Card} from 'semantic-ui-react';
import web3 from '../../ethereum/web3';
import Web3 from 'web3';


class CampaignShow extends Component{
    static async getInitialProps(props){
      const campaign = Campaign(props.query.address);

      const summary = await campaign.methods.getSummary().call();

        return {
            minimumContribution: summary[0],
            balance: summary[1],
            requestsCount: summary[2],
            approversCount: summary[3],
            manager:summary[4]

        };
    }

    renderCards(){
        const {
            balance,manager,
            minimumContribution,
            requestsCount,
            approversCount
        } = this.props;

        const items = [
            {
                header: manager,
                meta:'Address of Manager',
                description:
                    'Manager created this Campaign and can request to withdraw money',
                style:{overflowWrap:'break-word'}
            },

            {
                header: minimumContribution,
                meta:'Minimun Contribution in (wei)',
                description:
                    'You must contribut this much wei to become an approver',
                style:{overflowWrap:'break-word'}
            },
            {
                header: requestsCount,
                meta:'Numbers of Request',
                description:
                    'A request tries to withdraw money from the contract. Requests must be approved by 50% of approvers',
                style:{overflowWrap:'break-word'}
            },
            {
                header: approversCount,
                meta:'Numbers of Approvers',
                description:
                    'Number of the people who have contribute',
                style:{overflowWrap:'break-word'}
            },
            {
                header: Web3.utils.fromWei(balance, 'ether'),
                meta:'Campaign Balance (ether)',
                description:
                    'The Balance shows the amount of monet left in this campaign',
                style:{overflowWrap:'break-word'}
            }

        ];
        return <Card.Group items= {items} />;
    }
    render(){
        return(
            <Layout>
                 <h3> Campaign Show</h3>
                 {this.renderCards()}
            </Layout>
        );
    }
}

export default CampaignShow;