function Sample (url, callback, audioContext) {
    this.ac = audioContext;
    this.callback = callback;
    url = url.replace("#", "%23");
    if (this.ac) {
	var request = new XMLHttpRequest();
	request.open('GET', url, true);
	request.responseType = 'arraybuffer';
	request.onload = function (request) {
	    this.ac.decodeAudioData(request.target.response, Sample.prototype.bufferInit.bind(this),
				    function () {alert("Problème de décodage du fichier audio\n"+url);});
	}.bind(this);
	request.send();
    } else {
	this.audio = new Audio(url);
	this.audio.autoplay = false;
	var checkInterval = setInterval(function(){
	    if (this.audio.readyState == HTMLMediaElement.HAVE_ENOUGH_DATA) {
		clearInterval(checkInterval);
		this.callback(this);
	    }
	}.bind(this), 100);
    }
}

Sample.prototype.bufferInit = function(buffer) {
    this.buffer = buffer;
    this.bufferLength = this.buffer.getChannelData(0).length;
    this.duration = this.bufferLength/this.buffer.sampleRate;
    if (this.callback) this.callback(this);
}

Sample.prototype.play = function (amp) {
    if (!amp) amp = 1;
    if (this.ac) {
	this.gainNode = this.ac.createGain();
	this.gainNode.gain.value = amp;
	this.gainNode.connect(this.ac.destination);
	this.bufferNode = this.ac.createBufferSource();
	this.bufferNode.buffer = this.buffer;
	this.bufferNode.connect(this.gainNode);
	this.bufferNode.start(this.ac.currentTime+.01);
    } else {
	this.audio.volume = amp;
	this.audio.currentTime = 0;
	this.audio.play();
    }
}

Sample.prototype.stop = function () {
    if (this.bufferNode) {
	var time = this.ac.currentTime;
	this.gainNode.gain.setValueAtTime(this.gainNode.gain.value, time);
	this.gainNode.gain.linearRampToValueAtTime(0, time+.1);
	this.bufferNode.stop(time+.2);
	this.bufferNode = this.gainNode = null;
    } else if (this.audio) {
	this.audio.pause();
    }
    this.playing = false;
}
