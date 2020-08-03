//Remove Music, Hear Sound
//Joo Won Park
//Last Updated: 5/19/2020
//www.joowonpark.net
//RMHS Bandcamp
//http://joowonpark.bandcamp.com/album/rmhs

//Instruction: In Supercollider, select Menu->Language->Evaluate File

//Step 5

//Rec setup
s.recSampleFormat_('int24');
//unixCmd("killall scsynth");

// GUI
~height=Window.screenBounds.height*0.6;
~width=Window.screenBounds.width*0.33;

~cpanel = Window.new("RMHS");
~cpanel.bounds=Rect(Window.screenBounds.width*0.1,Window.screenBounds.height*0.1,~width,~height);

~cpanel.front;

~gostop = Button(~cpanel,Rect(~width*0.1,~height*0.05,~width*0.8,~height*0.1));
~gostop.font= Font("Courier",20);
~gostop.states=[["Start (with fade-in)"],["Reset"]];

~record=CheckBox(~cpanel,Rect(~width*0.1,~height*0.15,~width*0.5,~height*0.05),"record at start");
~record.font= Font("Courier",15);
//randomize


~amptext=StaticText(~cpanel,Rect(~width*0.1,~height*0.2,~width*0.9,~height*0.05));
~amptext.string="loudness (range: 0.0-1.0)";
~amptext.font=Font("Courier",15);
~amp=TextField(~cpanel,Rect(~width*0.1,~height*0.25,~width*0.2,~height*0.05));
~amp.font=Font("Courier",15);

~harmtext=StaticText(~cpanel,Rect(~width*0.1,~height*0.33,~width*0.9,~height*0.05));
~harmtext.string="number of harmonics (range: 1-20)";
~harmtext.font=Font("Courier",15);
~harmonics=TextField(~cpanel,Rect(~width*0.1,~height*0.38,~width*0.2,~height*0.05));
~harmonics.font=Font("Courier",15);

~fundtext=StaticText(~cpanel,Rect(~width*0.1,~height*0.46,~width*0.9,~height*0.05));
~fundtext.string="fundamental frequency (Hz)";
~fundtext.font=Font("Courier",15);
~fundamental=TextField(~cpanel,Rect(~width*0.1,~height*0.51,~width*0.2,~height*0.05));
~fundamental.font=Font("Courier",15);

~intertext=StaticText(~cpanel,Rect(~width*0.1,~height*0.59,~width*0.9,~height*0.05));
~intertext.string="interval (half steps, range: 0-24)";
~intertext.font=Font("Courier",15);
~interval=TextField(~cpanel,Rect(~width*0.1,~height*0.64,~width*0.2,~height*0.05));
~interval.font=Font("Courier",15);

~durtext=StaticText(~cpanel,Rect(~width*0.1,~height*0.72,~width*0.9,~height*0.05));
~durtext.string="duration (seconds, excluding fade-in time)";
~durtext.font=Font("Courier",15);
~dur=TextField(~cpanel,Rect(~width*0.1,~height*0.77,~width*0.2,~height*0.05));
~dur.font=Font("Courier",15);

~pickforme=CheckBox(~cpanel,Rect(~width*0.1,~height*0.85,~width*0.5,~height*0.05),"randomize");
~pickforme.font= Font("Courier",15);

~credit=StaticText(~cpanel,Rect(~width*0.1,~height*0.91,~width*0.9,~height*0.05));
~credit.string="by Joo Won Park  ( www.joowonpark.net )";
~credit.font=Font("Courier",12);

~record.value=0;
~amp.value=0.5;
~harmonics.value=12;
~fundamental.value=100;
~interval.value=5;
~dur.value=100;

~gostop.action={
	arg buttstate;

	if (buttstate.value==1,
		{
			//~rmhs.value( amp,repeat,fundamental,ratio,dur);
			~rmhs.value(
				(~amp.string.asFloat.clip(0.0,1.0))*0.25,
				~harmonics.string.asInteger.clip(1,20),
				~fundamental.string.asFloat.clip(0,20000),
				~interval.string.asFloat.clip(0,24.0).midiratio,
				~dur.string.asFloat.abs);

			if (~record.value.asBoolean==true, {
				~recpath= thisProcess.platform.recordingsDir +/+ "RMHS_" ++ Date.localtime.stamp ++ "." ++ (s.recHeaderFormat);
				s.record(~recpath);
			});

			if (~pickforme.value.asBoolean==true,{
				~amp.value=rrand(0.05,0.5).round(0.01);
				~harmonics.value=rrand(4,16);
				~fundamental.value=rrand(30,150);
				~interval.value=rrand(0,14).round(0.5);
				~dur.value=rrand(20,200);

			});
			~record.enabled=0;
			~amp.enabled=0;
			~harmonics.enabled=0;
			~fundamental.enabled=0;
			~interval.enabled=0;
			~dur.enabled=0;
			~pickforme.enabled=0;
		},
	);

	if (buttstate.value==0,
		{
			if (~record.value.asBoolean==true, {
				s.stopRecording;
				~recpath.dirname.openOS;
			});
			~record.enabled=1;
			~amp.enabled=1;
			~harmonics.enabled=1;
			~fundamental.enabled=1;
			~interval.enabled=1;
			~dur.enabled=1;
			~pickforme.enabled=1;
			s.freeAll;
		},
	);
};

~cpanel.onClose_({s.freeAll;s.stopRecording});

//initialization
~amp.enabled=0;
~harmonics.enabled=0;
~fundamental.enabled=0;
~interval.enabled=0;
~dur.enabled=0;
~gostop.enabled=0;
~pickforme.enabled=0;

s.waitForBoot{
	SynthDef("iSimple",{
		arg aamp,afreq,apan,adur;
		var sound,randtrigg,ring,trigfreq,env,mix;

		trigfreq=Rand(0.0,0.3);
		randtrigg=TRand.kr(0,afreq*0.02,Dust.kr(trigfreq));
		randtrigg=Lag.kr(randtrigg,1/trigfreq*0.5);

		env=Env.new([0.000001,1,1,0.000001],[Rand(3.0,20.0),adur*0.5,Rand(0.5,1.0)*adur],'exp');
		env=EnvGen.ar(env,doneAction:2);

		sound=SinOsc.ar(afreq+randtrigg);
		ring=SinOsc.ar(Rand(0.002,0.02),Rand(0,pi))*(aamp*0.5);

		mix=sound*(aamp+ring);
		mix=Pan2.ar(mix,apan)*env;
		Out.ar(0,mix);
	}).add;

	//remove music, hear sound
	~rmhs={
		arg amp=0.1,repeat=14,fundamental=200,ratio=3/2,dur=100;
		//root
		((repeat*3/4).round(1)).do{
			arg counter;
			var vamp;
			vamp=(2/3)/(counter+1);
			Synth("iSimple",[\aamp,amp*2*vamp,\afreq,fundamental*(counter+1),\apan,0,\adur,dur]);
		};
		//right
		repeat.do{
			arg counter;
			var vamp;
			vamp=(2/3)/(counter+1);
			Synth("iSimple",[\aamp,amp*vamp,\afreq,fundamental*(counter+1)*ratio,\apan,rrand(0.2,0.7),\adur,dur]);
		};
		//left
		repeat.do{
			arg counter;
			var vamp;
			vamp=(2/3)/(counter+1);
			Synth("iSimple",[\aamp,amp*vamp,\afreq,fundamental*(counter+1)*ratio,\apan,rrand(-0.7,-0.2),\adur,dur]);
		};

	};

	~gostop.enabled=1;
	~record.enabled=1;
	~amp.enabled=1;
	~harmonics.enabled=1;
	~fundamental.enabled=1;
	~interval.enabled=1;
	~dur.enabled=1;
	~pickforme.enabled=1;
	CmdPeriod.add({~cpanel.close});

};//end of waitForBoot