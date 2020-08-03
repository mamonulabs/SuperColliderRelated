//SIOE - asynchronous remixer
//Simple is Opposite of Easy
//by Joo Won Park
//www.joowonpark.net/sioe
//SIOE is part of CMPE project

//Step 1 - Make A Synth

~buff=Buffer.read(s,"/Users/muaadmin/Desktop/samples/Halabuji.wav");

//simplified version of ISJS instrument with one addition
SynthDef("iAllone",{

	arg aamp,aatk,arel,aloc;
	var env,loc,sound,mix;

	//envelope
	env=Env.perc(aatk,arel,curve:Rand(-5.0,-4.0));
	env=EnvGen.kr(env,doneAction:2);

	//sample player
	loc=~buff.numFrames*aloc;
	sound=PlayBuf.ar(~buff.numChannels,~buff.bufnum,1,1,loc,1);

	//mono-stereo detector
	if(~buff.numChannels==1,
		{mix=Pan2.ar(sound,Rand(-1.0,1.0));},
		{mix=Pan2.ar(sound.sum,Rand(-1.0,1.0));}
	);

	Out.ar(0,mix*0.9*aamp*env)

}).add;

Synth("iAllone",[\aamp,1,\aatk,0.4,\arel,3,\aloc,0.1]);
Synth("iAllone",[\aamp,1,\aatk,0.05,\arel,1,\aloc,0.9]);







