app.controller("Organizer", function($scope, $http, $timeout, $log) {

    var ac = getAudioContext();
    $scope.points = [];
    $scope.soundsToLoad = 0;
    $scope.loadedSounds = 0;

    $scope.playFieldWidth = 600;
    $scope.playFieldHeight = 600;
    $scope.playFieldTop = 50;
    $scope.playFieldLeft = 50;
    $scope.pointHalfSize = 10;

    $scope.colors = colorPalette;

    var soundType = "webm";
    var uap = new UAParser();
    $log.log(JSON.stringify(uap.getResult()));
    if (uap.getBrowser().name.match(/IE/) || uap.getBrowser().name.match(/Edge/)) soundType = "mp3";


    var displayX = function(x) {return $scope.pointHalfSize+Math.floor(x*($scope.playFieldWidth-2*$scope.pointHalfSize));}
    var displayY = function(y) {return $scope.pointHalfSize+Math.floor(y*($scope.playFieldHeight-2*$scope.pointHalfSize));}
    var displayW = function(w) {return Math.floor(w*($scope.playFieldWidth-2*$scope.pointHalfSize));}
    var displayH = function(h) {return Math.floor(h*($scope.playFieldHeight-2*$scope.pointHalfSize));}

    var minHPH = 100;
    var maxHPH = 320;
    $scope.hPanelHeight = 100;
    $scope.hPanelWidth = 100;
    var minVPW = 250;
    var maxVPW = 400;
    $scope.vPanelHeight = 200;
    $scope.vPanelWidth = 200;
    $scope.verticalLayout = false;

    var reScale = function () {
	var w = window.innerWidth;
	if (w<700) w=700;
	var h = window.innerHeight;
	if (h<500) h=500;
	if (h-minHPH > w-minVPW) {
	    $scope.verticalLayout = true;
	    $scope.hPanelHeight = Math.min(maxHPH, Math.max(minHPH, h-w-10));
	    $scope.hPanelWidth = w-20;
	    $scope.playFieldHeight = $scope.playFieldWidth = Math.min(w-20, h-$scope.hPanelHeight-30);
	    $scope.playFieldTop = $scope.hPanelHeight+10+Math.round((h-$scope.playFieldHeight-$scope.hPanelHeight-10)/2);
	    $scope.playFieldLeft = Math.round((window.innerWidth-$scope.playFieldWidth)/2);
	} else {
	    $scope.verticalLayout = false;
	    $scope.vPanelWidth = Math.min(maxVPW, Math.max(minVPW, w-h-10));
	    $scope.vPanelHeight = h-20;
	    $scope.playFieldHeight = $scope.playFieldWidth = Math.min(h-20, w-$scope.vPanelWidth-30);
	    $scope.playFieldLeft = $scope.vPanelWidth+10+Math.round((w-$scope.playFieldWidth-$scope.vPanelWidth-10)/2);
	    $scope.playFieldTop = Math.round((window.innerHeight-$scope.playFieldHeight)/2);
	}
	$scope.pointHalfSize = Math.round(($scope.playFieldHeight+$scope.playFieldWidth)/150);
	$scope.points.forEach(function(val) {
	    val.x = displayX(val.realX);
	    val.y = displayY(val.realY);
	});
    }

    window.addEventListener("resize", function(){reScale(); $scope.$apply();});
    $timeout(reScale, 100);

    var loadSound = function () {
	if ($scope.loadedSounds == $scope.soundsToLoad) return;
	new Sample("sounds/"+soundType+"/"+sounds[$scope.loadedSounds].file+"."+soundType, function(s){
	    $scope.points[$scope.loadedSounds].sample = s;
	    $scope.loadedSounds++;
	    $scope.$apply();
	    loadSound();
	}, ac);
    }

all = [
  ' ',
      'mdsProjectionReferenceInstruments',
      'mdsProjectionReferencePlayingTechniques',
    'mdsProjectionSubjectsClustering_5',
    'mdsProjectionSubjectsClustering_8',
    'mdsProjectionSubjectsConsensusClustering'
  ];

  nums = Array.apply(null, {length: 32}).map(Number.call, Number).map(String);
  nums.shift();
 nums.forEach(function(e){
  all.push ('subjectJudgment_'+e)})

  $scope.fileNames = all;

    $scope.fileServerSelected = function(elem) {
		var file = 'dataVis/'+elem.value+'.json';

		var mainInfo = $http.get(file).success(function(data) {
		var minX=1e9, maxX=-1e9, minY=1e9, maxY=-1e9;
		data.x.forEach(function(v,i) {
		    if (v.length) data.x[i] = v[0];
		});
		data.y.forEach(function(v,i) {
		    if (v.length) data.y[i] = v[0];
		});
		data.x.forEach(function(v) {
		    if (v<minX) minX = v;
		    if (v>maxX) maxX = v;
		});
		console.log([minX, maxX]);
		data.x.forEach(function(v,i) {
		    data.x[i] = .05+.9*((v-minX)/(maxX-minX));
		});
		console.log(data.x);
		data.y.forEach(function(v) {
		    if (v<minY) minY = v;
		    if (v>maxY) maxY = v;
		});
		console.log([minY, maxY]);
		data.y.forEach(function(v,i) {
		    data.y[i] = .05+.9*((v-minY)/(maxY-minY));
		});
		console.log(data.y);
		$scope.points.forEach(function(v,i) {
		    v.realX = data.x[i];
		    v.realY = data.y[i];
		    v.color = (data.color[i] ? colorPalette[data.color[i]-1] : "");
		});
		reScale();
		    })};



    $scope.fileSelected = function(elem) {
  	var file = elem.files[0];
	console.log(file);
	if (!file) return;
	if (typeof window.FileReader !== 'function') {
	    alert("The file API isn't supported on this browser.");
	    return;
	}
	var fr = new FileReader();
	fr.onload = function(e) {
	    $timeout(function() {
		lines = e.target.result;
		var data = JSON.parse(lines);
		var minX=1e9, maxX=-1e9, minY=1e9, maxY=-1e9;
		data.x.forEach(function(v,i) {
		    if (v.length) data.x[i] = v[0];
		});
		data.y.forEach(function(v,i) {
		    if (v.length) data.y[i] = v[0];
		});
		data.x.forEach(function(v) {
		    if (v<minX) minX = v;
		    if (v>maxX) maxX = v;
		});
		console.log([minX, maxX]);
		data.x.forEach(function(v,i) {
		    data.x[i] = .05+.9*((v-minX)/(maxX-minX));
		});
		console.log(data.x);
		data.y.forEach(function(v) {
		    if (v<minY) minY = v;
		    if (v>maxY) maxY = v;
		});
		console.log([minY, maxY]);
		data.y.forEach(function(v,i) {
		    data.y[i] = .05+.9*((v-minY)/(maxY-minY));
		});
		console.log(data.y);
		$scope.points.forEach(function(v,i) {
		    v.realX = data.x[i];
		    v.realY = data.y[i];
		    v.color = (data.color[i] ? colorPalette[data.color[i]-1] : "");
		});
		reScale();
	    });
	}
	fr.readAsText(file);
    }

    $scope.playSound = function(point) {
	if (point.sample)
	    point.sample.play();
    }

    $scope.stopSound = function(point) {
	if (point.sample)
	    point.sample.stop();
    }

    var id=0;
    $scope.points = [];
    $scope.loadedSounds = $scope.soundsToLoad = 0;
    sounds.forEach(function(val) {
	$scope.soundsToLoad++;
	$scope.points.push({
	    id: id++,
	    name: val.name,
	    sample: null,
	    realX: 0,
	    realY: 0,
	    color: 0
	});
    });
    loadSound();


});
