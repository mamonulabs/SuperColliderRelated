//Step 1
SynthDef("iSimple",{
	arg aamp,afreq,apan,adur;
	var sound,alter,fm,env,mix;
	sound=SinOsc.ar(afreq);
	fm=SinOsc.ar(0.2)*(aamp*0.5);
	env=Env.new([0.000001,1,1,0.000001],[1,adur*0.5,0.5*adur],'exp');
	env=EnvGen.ar(env,doneAction:2);
	mix=sound*(aamp+fm);
	mix=Pan2.ar(mix,apan)*env;
	Out.ar(0,mix);
}).add;


Synth("iSimple",[\aamp,0.5,\afreq,150,\apan,0,\adur,10]);

Env.new([0.00001,0.995,0.995,0.00001],[2,5,5],\exp).plot;

