const routes = require('next-routes')();

routes
.add('/campaigns/new','/campaigns/new')
.add('/campaigns/:address','/campaigns/show');//":" shows that what goes next address" is a wild card


module.exports = routes;
