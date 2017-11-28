app = angular.module('filter', []);

app.controller("Filter", function ($scope, $http) {

    $scope.toJson = function(o){return angular.toJson(o, 2);};
    $scope.result = [];

    $http.get("ticelxp1_subject_mix_tresh_11.json").then(function(response) {
	response.data.objects.forEach(function(o) {
	    if (o.sounds.some(function(s){return s.match(/C4/);})) {
		var s = o.sounds.find(function(s){return s.match(/\-mf/) && s.match(/C4/);})
		if (s) {
		    $scope.result.push({instrument:o.instrument, mode:o.mode, hasC4:true, hasMf:true, path:o.path+"/"+s});
		} else {
		    var sounds = [];
		    s = o.sounds.forEach(function(s){if(s.match(/C4/)) sounds.push(s);})
		    $scope.result.push({instrument:o.instrument, mode:o.mode, hasC4:true, hasMf:false, path:o.path+"/"+sounds.join(" ")});
		}
	    } else {
		$scope.result.push({instrument:o.instrument, mode:o.mode, hasC4:false, hasMf:false, path:o.path+"/"+o.sounds.join(" ")});
	    }
	});
    });
});
