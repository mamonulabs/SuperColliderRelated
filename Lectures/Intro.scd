//Computer Music Composition
//Joo Won Park
//Introduction
//https://docs.google.com/presentation/d/1-9e1kL4rI6zqaW2MQzJxZ2t3DeqbdK7PMZ1Iran8LLs/edit?usp=sharing

//Step 1 - Make an Instrument
SynthDef("iBleeper",{
	arg aamp,aatk,arel,afreq,acf,apos;
	var env,sound,filter,panner,mix;

	env=Env.perc(aatk,arel);
	env=EnvGen.kr(env,doneAction:2);

	sound=Impulse.ar(afreq*env);
	filter= BPF.ar(sound,acf*env+20);
	panner= Pan2.ar(filter,apos);

	mix=panner*env*aamp;

	Out.ar(0,mix);

}).add;

//test it
Synth("iBleeper",[\aamp,1.5,\aatk,3,\arel,3,\afreq,80,\acf,3000,\apos,0]);


//Step 2 Make a Loop
Routine({
	10.do{
		arg counter;

		Synth("iBleeper",[\aamp,2,\aatk,0.2,\arel,1,
			\afreq,80,\acf,(counter+1)*200,\apos,0]);
		0.25.wait;
	}

}).play;


//Step 3 Make a function with randomization
~beeprout={
	arg repeat,freq,cf;
	Routine({
		var atk;
		repeat.do{
			arg counter;
			atk=rrand(0.5,3);
			Synth("iBleeper",[\aamp,rrand(0.4,0.7),\aatk,atk,\arel,atk*3,\afreq,freq,\acf,(counter+1)*cf,\apos,rrand(-1.0,1.0)]);
			[0.1,0.15,0.2].choose.wait;

		}

	}).play;
};
//test it. make variations
//~beeprout.value(repeat,freq,cf increments);
~beeprout.value(30,50,100);
~beeprout.value(30,15,100);
~beeprout.value(30,500,100);


//Step 4 short composition
//run the lines below. Improvise timing. Multiple runs are OK
//~beeprout.value(repeat,freq,cf increments);

~beeprout.value(30,15,100);
~beeprout.value(30,100,100);
~beeprout.value(25,500,80);

~beeprout.value(rrand(20,30),rrand(100,300),rrand(80,300))