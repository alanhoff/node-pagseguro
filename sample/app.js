//modules and dependencies

var express	= require("express");
var routes  = require('./routes');
var api     = require('./routes/api');
var app     = express.createServer();


//configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.set('view options', {
    layout: false
  });
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.static(__dirname + '/public'));
  app.use(app.router);
});

app.configure('development', function(){
   app.use(express.errorHandler({ dumpExceptions: true, showStack: true}));
});

app.configure('production', function(){
   app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);
app.post('/api/checkOut', api.checkOut);

app.listen(5000,  function(){
   console.log("Server stated on port %d in mode %s",app.address().port, app.settings.env);
});



