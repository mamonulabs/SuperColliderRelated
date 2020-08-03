//Step 3

SynthDef("iSimple",{
	arg aamp,afreq,apan,adur;
	var sound,randtrigg,fm,trigfreq,env,mix;

	trigfreq=Rand(0.0,0.3);
	randtrigg=TRand.kr(0,afreq*0.02,Dust.kr(trigfreq));
	randtrigg=Lag.kr(randtrigg,0.5/trigfreq);

	env=Env.new([0.000001,1,1,0.000001],[Rand(3.0,20.0),adur*0.5,Rand(0.5,1.0)*adur],'exp');
	env=EnvGen.ar(env,doneAction:2);

	sound=SinOsc.ar(afreq+randtrigg);
	fm=SinOsc.ar(Rand(0.002,0.02),Rand(0,pi))*(aamp*0.5);

	mix=sound*(aamp+fm);
	mix=Pan2.ar(mix,apan)*env;
	Out.ar(0,mix);
}).add;

//from Step 2
~center=10.do{
	arg counter;
	var vamp;
	vamp=(2/3)/(counter+1);
	Synth("iSimple",[
		\aamp,0.2*vamp,
		\afreq,50*(counter+1),
		\apan,0,
		\adur,20
	]);
};

