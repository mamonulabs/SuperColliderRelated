//ISJS
//Step-by-Step procedure
//Joo Won Park
//www.joowonpark.net/cmpe

//Step 1

//load a sample to a buffer;
~buff=Buffer.read(s,"/Users/muaadmin/Desktop/samples/beatbox.aif"); // drag-drop audio files (wav or aif, not mp3) here
//or use the default audiofile
~buff=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
~buff.play;

SynthDef("iPlayBack",{
	arg aamp,arate,apan;
	var source,trigger,startposition,triggerrate,mix;

	//starting position change
	startposition=MouseX.kr(0,1);

	//trigger
	triggerrate=MouseY.kr(0.1,35);
	trigger=LFPulse.kr(triggerrate,add:-0.5);

	//play sample
	source=PlayBuf.ar(~buff.numChannels,~buff.bufnum,arate,trigger,~buff.numFrames*startposition,1)*aamp;

	mix=Pan2.ar(source,TRand.kr(apan.neg,apan,trigger));
	Out.ar(0,mix);

}).add;

Synth("iPlayBack",[\aamp,0.8,\arate,1,\apan,0]);