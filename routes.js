const routes = require('next-routes')();

routes
.add('/campaigns/new','/campaigns/new')
.add('/campaigns/:address','/campaigns/show')//":" shows what goes next address" is a wild card
.add('/campaigns/:address/requests','/campaigns/requests/index')
.add(`/campaigns/:address/requests/new`, `/campaigns/requests/new`);

module.exports = routes;
