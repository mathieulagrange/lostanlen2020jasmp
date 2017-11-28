var server = require('http').createServer();
var io = require('socket.io').listen(server);
var md5 = require('js-md5');
var parser = require('ua-parser-js');
const fs = require('fs');

var port = 3007;

// Load base sound data
var soundData = require("./soundList.json");
soundData.sounds.forEach(function(s,i) {
    var col = Math.floor(i/6);
    var row = i%6;
    s.x = col/13 + .5*Math.random()/13;
    s.y = row/6 + .5*Math.random()/6;
});

console.log("Loaded sound data, current version = "+soundData.version);

var nodemailer = require('nodemailer');

// create reusable transporter object using the default SMTP transport
var transporter = nodemailer.createTransport({
     service: 'gmail', // no need to set host or port etc.
     auth: {
	 user: "mathias.rossignol@gmail.com",
	 pass: "inekmiggycpuqjmf"
     }
});


io.on('connection', function(socket) {
    console.log("User connected");
    var userEmail = "";
    var fileName = "";
    var language = "fr";
    var userData = null;
    var finalized = false;
    var acceptContact = false;
    var browsers = [];

    socket.on('checkUser', function(data) {
	var email = data.email;
	if (data.hasOwnProperty("language")) language = data.language;
	// If user exists, loads json data containing last state of organization saved for this user into "userData" and sends it as response
	// Else notifies the client that user doesn't exist
	userEmail = email;
	var emailEnc = md5(email);
	fileName = "userData/"+emailEnc+".json";
	fs.stat(fileName, function(err, stats) {
	    socket.emit('userCheckResult', {'exists':err==null});
	    if (!err) {
		console.log("Known user "+userEmail);
		fs.readFile(fileName, function(err, uData) {
		    var dat = JSON.parse(uData);
		    if (!data.hasOwnProperty("language") && dat.hasOwnProperty("language"))
			language = dat.language;
		    userData = dat.organization;
		    finalized = dat.finalized;
		    acceptContact = dat.acceptContact;
		    if (dat.browsers) browsers = dat.browsers;
		    browsers.push(parser(socket.request.headers['user-agent']));
		    socket.emit('userData', userData);
		});
	    }
	});
    });

    socket.on('newUser', function(data) {
	var email = data.email;
	if (data.hasOwnProperty("language")) language = data.language;
	// Creates initial data, using base data and random positioning / colors,
	// saves it to file, and sends it to user
	userEmail = email;
	finalized = false;
	browsers = [parser(socket.request.headers['user-agent'])];
	console.log("Sending email to new user "+userEmail);

	// send mail with defined transport object
	var subject = "Bienvenue";
	if (language=="en")
	    subject = "Welcome";
	var text = "Merci d'avoir rejoint notre équipe d'expérimentation !\n\nAprès avoir fermé le site de test, vous pourrez retrouver et modifier votre travail à cette adresse : http://soundthings.org/ticel/groupSounds2?email="+email+"&lang=fr , ou bien en entrant de nouveau votre adresse à la page d'accueil du site.\n\nCordialement,\nl'équipe de développement TICEL\n\n---\nCe message a été envoyé à "+email+". Si vous pensez l'avoir reçu par erreur, merci de nous contacter par retour de mail.";
	if (language == "en")
	    text = "Thank you for joining our experimentation team!\n\nAfter closing your browser window, you can get back to your work and modify it at any time by following this link: http://soundthings.org/ticel/groupSounds2?email="+email+"&lang=en , or by going to the experiment page and providing your email address again.\n\nBest regards,\nthe TICEL development team\n\n---\nThis message was sent to "+email+". If you think you received it by mistake, please contact us by answering this email."
	transporter.sendMail({
	    from: '"TICEL project" <mathias.rossignol@gmail.com>', // sender address
	    to: email,
	    cc: "mathias.rossignol@gmail.com",
	    subject: subject, // Subject line
	    text: text, // plaintext body
	}, function(error, info){
	    if(error){
		console.log("Erreur à l'envoi du message :");
		console.log(error);
	    }
	    console.log('Message sent: ' + info.response);
	});

	var emailEnc = md5(email);
	fileName = "userData/"+emailEnc+".json";
	userData = [];
	soundData.sounds.forEach(function(v) {
	    userData.push({'name':v.name, 'file':v.file, 'x':v.x, 'y':v.y, 'color':v.color, 'moved':false});
	});
	fs.writeFile(fileName, JSON.stringify({'email':userEmail, 'finalized':false, 'acceptContact':false, 'language':language, 'organization':userData}), function(){
		    socket.emit('userData', userData);
	});
    });

    socket.on('pointChange', function(pointData) {
	// Updates "userData" to reflect modifications
	if (pointData.hasOwnProperty("x"))
	    userData[pointData.id].x = pointData.x;
	if (pointData.hasOwnProperty("y"))
	    userData[pointData.id].y = pointData.y;
	if (pointData.hasOwnProperty("color"))
	    userData[pointData.id].color = pointData.color;
	if (pointData.hasOwnProperty("moved"))
	    userData[pointData.id].moved = pointData.moved;
    });

    socket.on('disconnect', function() {
	console.log("User "+userEmail+" leaving.");
	// Saves "userData" to file
	if (userData) fs.writeFile(fileName, JSON.stringify({'email':userEmail, 'finalized':finalized, 'acceptContact':acceptContact, 'browsers':browsers, 'language':language, 'organization':userData}), function(){});
    });

    socket.on('save', function() {
	// Saves "userData" to file
	if (userData) fs.writeFile(fileName, JSON.stringify({'email':userEmail, 'finalized':finalized, 'acceptContact':acceptContact, 'browsers':browsers, 'language':language, 'organization':userData}), function(){});
    });

    socket.on('finalize', function() {
	finalized = true;
    });

    socket.on('acceptContact', function() {
	acceptContact = true;
    });

});

server.listen(port, function() {
    console.log("Listening on port " + port);
});
