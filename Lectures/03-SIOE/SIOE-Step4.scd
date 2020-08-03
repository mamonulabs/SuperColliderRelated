//Simple Is Opposite of Easy : Suepercut remixer
//by Joo Won Park
//Last Updated: 7/7/2020
//www.joowonpark.net/sioe
//ISJS is part of CMPE Project

//Instruction to Run in SuperCollider: In Supercollider, select Menu->Language->Evaluate File


s.recSampleFormat_('int24');
//unixCmd("killall scsynth");

s.waitForBoot{
	~buff=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");


	(
		~loadthings={
			//2. SynthDef and functions
			SynthDef("AllOne",{
				arg aamp,arate,aatk,arel,aloc;
				var env,loc,sound,mix;
				env=Env.perc(aatk,arel,1,Rand(-5.0,-4.0));
				env=EnvGen.kr(env,doneAction:2);
				loc=~buff.numFrames*aloc;
				sound=PlayBuf.ar(~buff.numChannels,~buff.bufnum,arate,1,loc,1);

				if(~buff.numChannels==1,
					{mix=Pan2.ar(sound,Rand(-1.0,1.0));},
					{mix=Pan2.ar(sound.sum,Rand(-1.0,1.0));}
				);

				Out.ar(0,mix*0.9*aamp*env)

			}).add;


			//Gradual Process

			~sioe={
				arg repeat,swait,release;
				var beat;
				beat=60/swait*4;
				~routprocess=Routine({
					"first half".postln;
					repeat.do{
						arg voice;
						var forward,reverse;
						forward=voice+1;
						reverse=(repeat-(voice+1));
						forward.do{
							arg counter;
							var startpos;
							startpos=(counter+1)/repeat;
							Synth("AllOne",[\aamp,1/(forward*0.8),\arate,1,\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
						};
						beat.wait;
					};
					"second half".postln;
					repeat.do{
						arg voice;
						var forward,reverse;
						forward=voice+1;
						reverse=(repeat-(voice+1));
						reverse.do{
							arg counter;
							var startpos;
							startpos=(counter+1)/repeat;
							Synth("AllOne",[\aamp,1/(reverse*0.8),\arate,1,\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
						};
						beat.wait;
					}
				});
				~routprocess.reset;~routprocess.play;
			};

			~sioe1shot={
				arg repeat0,release;
				var repeat;
				repeat=repeat0.clip(1,100);
				repeat.do{
					arg counter;
					var startpos;
					startpos=(counter+1)/repeat;
					//startpos.postln;
					Synth("AllOne",[\aamp,1/(repeat*0.4),\arate,1,\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos])
				};
			};

		};

	);

	//GUI
	~height=Window.screenBounds.height*0.6;
	~width=Window.screenBounds.width*0.35;

	~cpanel3 = Window.new("SIOE");
	~cpanel3.bounds=Rect(Window.screenBounds.width*0.02,Window.screenBounds.height*0.1,~width,~height);
	~cpanel3.front;

	~title=StaticText(~cpanel3,Rect(~width*0.1,~height*0.025,~width*0.8,~height*0.05));
	~title.string="Condense a song into a single percussion sound or a triangular remix";
	~title.font=Font("Courier",13);

	~credit=StaticText(~cpanel3,Rect(~width*0.1,~height*0.95,~width*0.8,~height*0.05));
	~credit.string="by Joo Won Park  ( www.joowonpark.net/cmpe )";
	~credit.font=Font("Courier",13);

	~dragdrop = DragSink(~cpanel3, Rect(~width*0.1,~height*0.1,~width*0.8,~height*0.05));
	~dragdrop.font=Font("Courier",12);
	~dragdrop.string = " drag & drop a sound file here (wav or aif only)";
	~dragdrop.receiveDragHandler={arg incoming;
		~dragdrop.object = View.currentDrag.value;
		//arg action prevents Buffer reading error
		~buff=Buffer.read(s,~dragdrop.object,
			action:{
				~loadthings.value(0);
			}
		);
		//dummy synth
	};

	~gostop = Button(~cpanel3,Rect(~width*0.1,~height*0.2,~width*0.4,~height*0.075));
	~gostop.font= Font("Courier",15);
	~gostop.states=[
		["Start Short Sound",Color.black,Color.white],
		["Stop"]
	];

	~gostop2 = Button(~cpanel3,Rect(~width*0.1,~height*0.3,~width*0.8,~height*0.075));
	~gostop2.font= Font("Courier",15);
	~gostop2.states=[
		["Start Long Sound",Color.black,Color.white],
		["Stop"]
	];

	//record
	~record=CheckBox(~cpanel3,Rect(~width*0.1,~height*0.4,~width*0.5,~height*0.05),"record at start");
	~record.font= Font("Courier",15);

	//
	~donumtext=StaticText(~cpanel3,Rect(~width*0.1,~height*0.5,~width*0.8,~height*0.05));
	~donumtext.string="Repeats (1-100)";
	~donumtext.font=Font("Courier",15);
	~donum=TextField(~cpanel3,Rect(~width*0.1,~height*0.55,~width*0.2,~height*0.05));
	~donum.font=Font("Courier",15);
	~donum.value=10;

	~tempotext=StaticText(~cpanel3,Rect(~width*0.1,~height*0.6,~width*0.8,~height*0.05));
	~tempotext.string="Tempo (BPM, 1-1500)";
	~tempotext.font=Font("Courier",15);
	~tempo=TextField(~cpanel3,Rect(~width*0.1,~height*0.65,~width*0.2,~height*0.05));
	~tempo.font=Font("Courier",15);
	~tempo.value=120;

	~lengthtext=StaticText(~cpanel3,Rect(~width*0.1,~height*0.7,~width*0.8,~height*0.05));
	~lengthtext.string="Hit Length (0.01-10 seconds)";
	~lengthtext.font=Font("Courier",15);
	~length=TextField(~cpanel3,Rect(~width*0.1,~height*0.75,~width*0.2,~height*0.05));
	~length.font=Font("Courier",15);
	~length.value=3;


	//onclose
	~cpanel3.onClose_({s.freeAll;s.stopRecording});

	//actions
	~gostop.action={
		arg buttstate;

		if (buttstate.value==1,
			{
				if (~record.value.asBoolean==true, {
					~recpath= thisProcess.platform.recordingsDir +/+ "SIOE_" ++ Date.localtime.stamp ++ "." ++ (s.recHeaderFormat);
					s.record(~recpath);
				});
				~loadthings.value(0);
				//the core

				~sioe1shot.value(
					~donum.string.asInt.clip(1.0,100.0),
					~length.string.asFloat.clip(0.00001,10);
				);

				~gostop2.enabled=0;
				~gostop2.visible=0;
				~donum.enabled=0;
				~tempo.enabled=0;
				~length.enabled=0;
				~record.enabled=0;
			}
		);
		if (buttstate.value==0,
			{
				if (~record.value.asBoolean==true, {
					s.stopRecording;
					~recpath.dirname.openOS;
				});
				//~routprocess.stop;
				~gostop2.enabled=1;
				~gostop2.visible=1;
				~donum.enabled=1;
				~tempo.enabled=1;
				~length.enabled=1;
				~record.enabled=1;
				~record.enabled=1;
			},
		);
	};

	~gostop2.action={
		arg buttstate;

		if (buttstate.value==1,
			{
				if (~record.value.asBoolean==true, {
					~recpath= thisProcess.platform.recordingsDir +/+ "SIOE" ++ Date.localtime.stamp ++ "." ++ (s.recHeaderFormat);
					s.record(~recpath);
				});
				~loadthings.value(0);
				//the core
				//arg repeat,bpm,release
				~sioe.value(
					~donum.string.asInt.clip(1.0,100.0),
					~tempo.string.asFloat.clip(1,3000),
					~length.string.asFloat.clip(0.00001,10);
				);
				~gostop.enabled=0;
				~gostop.visible=0;
				~donum.enabled=0;
				~tempo.enabled=0;
				~length.enabled=0;
				~record.enabled=0;


				~record.enabled=0;
			}
		);
		if (buttstate.value==0,
			{
				if (~record.value.asBoolean==true, {
					s.stopRecording;
					~recpath.dirname.openOS;
				});
				~routprocess.stop;
				~gostop.enabled=1;
				~gostop.visible=1;
				~donum.enabled=1;
				~tempo.enabled=1;
				~length.enabled=1;
				~record.enabled=1;
				~record.enabled=1;
			},
		);
	};

CmdPeriod.add({~cpanel3.close});
};//end of waitForBoot

