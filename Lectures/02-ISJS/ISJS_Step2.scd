//ISJS
//Step-by-Step procedure
//Joo Won Park
//www.joowonpark.net/cmpe

//Step 2 - Make 2 variations of S(iPlayBack)

// drag-drop audio files (wav or aif, not mp3) and replace filepath
~buff=Buffer.read(s,"/Users/muaadmin/Desktop/samples/beatbox.aif");
~buff2=Buffer.read(s,"/Users/muaadmin/Desktop/samples/nimb.aif");
~buff3=Buffer.read(s,"/Users/muaadmin/Desktop/samples/Chicken.aif");

//or use the default audiofile
~buff=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
~buff2=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
~buff3=Buffer.read(s, Platform.resourceDir +/+ "sounds/SinedPink.aiff");

~buff.play;
~buff2.play;
~buff3.play;

(
//buff1
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

	mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger)); //change source.sum to source if using a mono sample
	Out.ar(0,mix);

}).add;

//buff2
SynthDef("iPlayBack2",{
	arg aamp,arate,apan;
	var source,trigger,startposition,triggerrate,mix;

	//starting position change
	startposition=MouseX.kr(0,1);

	//trigger
	triggerrate=MouseY.kr(0.1,35);
	trigger=LFPulse.kr(triggerrate,add:-0.5);

	//play sample
	source=PlayBuf.ar(~buff2.numChannels,~buff2.bufnum,arate,trigger,~buff2.numFrames*startposition,1)*aamp;

	mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger));
	Out.ar(0,mix);

}).add;

//buff3
SynthDef("iPlayBack3",{
	arg aamp,arate,apan;
	var source,trigger,startposition,triggerrate,mix;

	//starting position change
	startposition=MouseX.kr(0,1);

	//trigger
	triggerrate=MouseY.kr(0.1,35);
	trigger=LFPulse.kr(triggerrate,add:-0.5);

	//play sample
	source=PlayBuf.ar(~buff3.numChannels,~buff3.bufnum,arate,trigger,~buff3.numFrames*startposition,1)*aamp;

	mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger));
	Out.ar(0,mix);

}).add;

);

//run the following codes to make sound
(
Synth("iPlayBack",[\aamp,0.65,\arate,1,\apan,1]);
Synth("iPlayBack2",[\aamp,0.35,\arate,1.5,\apan,0.5]);
Synth("iPlayBack3",[\aamp,0.65,\arate,1,\apan,0.5]);
);
