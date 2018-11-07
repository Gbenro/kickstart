import React,{Component} from 'react';
import Layout from '../../../components/layout';
import {Button,Table} from 'semantic-ui-react'
import {Link} from '../../../routes';
import Campaign from '../../../ethereum/campaign';
import RequestRow from '../../../components/requestrow';

class RequestIndex extends Component{
    static async getInitialProps(props){

        const {address} = props.query;
        const campaign = Campaign(address);
        const requestsCount = await campaign.methods.getRequestsCount().call();
        const approversCount= await campaign.methods.approversCount().call();
        //want to get all the requests first then render them after 
        const requests = await Promise.all(
            Array(parseInt(requestsCount)).fill().map((element,index)  =>{
                return campaign.methods.requests(index).call();
            })
        );
        return{address,requests, requestsCount, approversCount};
    }

    renderRow(){
        return this.props.requests.map((request,index) =>{
            return <RequestRow 

                        key={index}
                        id = {index}
                        request={request}
                        address={this.props.address}
                        approversCount={this.props.approversCount}
            />
        });
    }

    render(){
        const {Header, Row, HeaderCell,Body} = Table;

        return (
            <Layout>
            <h3>Request</h3>
            <Link route={`/campaigns/${this.props.address}/requests/new`}>
                <a>
                    <Button primary> Add Request</Button>
                </a>
            </Link>

            <Table>
            <Header>
                <Row>
                    <HeaderCell>ID</HeaderCell>
                    <HeaderCell>Description</HeaderCell>
                    <HeaderCell>Amount</HeaderCell>
                    <HeaderCell>Recipient</HeaderCell>
                    <HeaderCell>Approval</HeaderCell>
                    <HeaderCell>Approve</HeaderCell>
                    <HeaderCell>Finalize</HeaderCell>
                </Row>
            </Header>
            <Body>
            {this.renderRow()}
            </Body>
            </Table>
            </Layout>
        )
    }
}
export default RequestIndex;