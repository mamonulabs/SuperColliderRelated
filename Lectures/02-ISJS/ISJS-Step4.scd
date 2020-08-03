//I-Shim-Jun-Shim (communicating through hearts)
//Joo Won Park
//Last Updated: 5/20/2020
//www.joowonpark.net/isjs
//ISJS is part of CMPE Project

//Instruction to Run in SuperCollider: In Supercollider, select Menu->Language->Evaluate File

s.recSampleFormat_('int24');

s.waitForBoot{
	~buff=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	~buff2=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
	~buff3=Buffer.read(s, Platform.resourceDir +/+ "sounds/SinedPink.aiff");


	//GUI
	~height=Window.screenBounds.height*0.6;
	~width=Window.screenBounds.width*0.33;

	~cpanel2 = Window.new("ISJS");
	~cpanel2.bounds=Rect(Window.screenBounds.width*0.02,Window.screenBounds.height*0.1,~width,~height);
	~cpanel2.front;

	~title=StaticText(~cpanel2,Rect(~width*0.1,~height*0.025,~width*0.8,~height*0.05));
	~title.string="Stutter three audio files using a mouse";
	~title.font=Font("Courier",15);


	~dragdrop = DragSink(~cpanel2, Rect(~width*0.1,~height*0.1,~width*0.8,~height*0.05));
	~dragdrop.font=Font("Courier",12);
	~dragdrop.background=Color.green;
	~dragdrop.string = "drag & drop a sound file #1 here (wav or aif only)";
	~dragdrop.receiveDragHandler={arg incoming;
		~dragdrop.object = View.currentDrag.value;
		~buff=Buffer.read(s,~dragdrop.object);
	};

	~dragdrop2 = DragSink(~cpanel2, Rect(~width*0.1,~height*0.175,~width*0.8,~height*0.05));
	~dragdrop2.font=Font("Courier",12);
	~dragdrop2.background=Color.yellow;
	~dragdrop2.string = "drag & drop a sound file #2 here (wav or aif only)";
	~dragdrop2.receiveDragHandler={arg incoming;
		~dragdrop2.object = View.currentDrag.value;
		~buff2=Buffer.read(s,~dragdrop2.object);
	};

	~dragdrop3 = DragSink(~cpanel2, Rect(~width*0.1,~height*0.25,~width*0.8,~height*0.05));
	~dragdrop3.font=Font("Courier",12);
	~dragdrop3.background=Color.magenta;
	~dragdrop3.string = "drag & drop a sound file #3 here (wav or aif only)";
	~dragdrop3.receiveDragHandler={arg incoming;
		~dragdrop3.object = View.currentDrag.value;
		~buff3=Buffer.read(s,~dragdrop3.object);
	};

	~gostop = Button(~cpanel2,Rect(~width*0.1,~height*0.35,~width*0.8,~height*0.075));
	~gostop.font= Font("Courier",15);
	~gostop.states=[
		["1. Load audio files",Color.black,Color.white],
		["2. Start stuttering"],
		["3. Stop"]
	];

	//record
~record=CheckBox(~cpanel2,Rect(~width*0.1,~height*0.45,~width*0.5,~height*0.05),"record at start");
~record.font= Font("Courier",15);

//knobs
	~control=StaticText(~cpanel2,Rect(~width*0.1,~height*0.55,~width*0.2,~height*0.05));
	~control.string="Rate";
	~control.font=Font("Courier",15);

	~control2=StaticText(~cpanel2,Rect(~width*0.25,~height*0.55,~width*0.5,~height*0.05));
	~control2.string="Volume";
	~control2.font=Font("Courier",15);

	~knob=Knob(~cpanel2,Rect(~width*0.1,~height*0.6,~width*0.1,~height*0.1));
	~knob.color=[Color.green];
	~knob.value=0.5;
	~knob.action={arg dial;NodeControl(~instr1,1).value=dial.value.linlin(0.0,1.0,0.3,1.7);};

	~slider=Slider(~cpanel2,Rect(~width*0.25,~height*0.6,~width*0.65,~height*0.1));
	~slider.orientation='\horizontal';
	~slider.background=Color.green;
	~slider.thumbSize=40; ~slider.value=0.5;
	~slider.action={arg fader;NodeControl(~instr1,0).value=fader.value};

	~knob2=Knob(~cpanel2,Rect(~width*0.1,~height*0.72,~width*0.1,~height*0.1));
	~knob2.value=0.5;
	~knob2.color=[Color.yellow];
	~knob2.action={arg dial;NodeControl(~instr2,1).value=dial.value.linlin(0.0,1.0,0.3,1.7);};
	~slider2=Slider(~cpanel2,Rect(~width*0.25,~height*0.72,~width*0.65,~height*0.1));
	~slider2.orientation='\horizontal';
	~slider2.background=Color.yellow;
	~slider2.thumbSize=40; ~slider2.value=0.5;
	~slider2.action={arg fader;NodeControl(~instr2,0).value=fader.value};

	~knob3=Knob(~cpanel2,Rect(~width*0.1,~height*0.84,~width*0.1,~height*0.1));
	~knob3.value=0.5;
	~knob3.color=[Color.magenta];
	~knob3.action={arg dial;NodeControl(~instr3,1).value=dial.value.linlin(0.0,1.0,0.3,1.7);};

	~slider3=Slider(~cpanel2,Rect(~width*0.25,~height*0.84,~width*0.65,~height*0.1));
	~slider3.orientation='\horizontal';
	~slider3.background=Color.magenta;
	~slider3.thumbSize=40; ~slider3.value=0.5;
	~slider3.action={arg fader;NodeControl(~instr3,0).value=fader.value};

		~credit=StaticText(~cpanel2,Rect(~width*0.1,~height*0.95,~width*0.8,~height*0.05));
	~credit.string="by Joo Won Park  ( www.joowonpark.net )";
	~credit.font=Font("Courier",12);

	~cpanel2.onClose_({s.freeAll;s.stopRecording});

	~gostop.action={
		arg buttstate;

		if (buttstate.value==1,
			{~loadsamples.value(0);}
		);
		if (buttstate.value==2,
			{
				if (~record.value.asBoolean==true, {
				~recpath= thisProcess.platform.recordingsDir +/+ "ISJS_" ++ Date.localtime.stamp ++ "." ++ (s.recHeaderFormat);
				s.record(~recpath);
			});
				~instr1=Synth("PlayBack",[\aamp,2,\arate,1.1,\apan,rrand(0.3,1.0)]);
				~instr2=Synth("PlayBack2",[\aamp,0.8,\arate,1.03,\apan,rrand(0.3,1.0)]);
				~instr3=Synth("PlayBack3",[\aamp,1,\arate,1.2,\apan,rrand(0.3,1.0)]);
					~record.enabled=0;
			}
		);
		if (buttstate.value==0,
			{
					if (~record.value.asBoolean==true, {
				s.stopRecording;
				~recpath.dirname.openOS;
				});
				~instr1.free;
				~instr2.free;
				~instr3.free;

					~record.enabled=1;
			},
		);
	};
	//button


	~loadsamples={
		SynthDef("PlayBack",{
			arg aamp,arate,apan; //6
			var source,trigger,startposition,triggerrate,ampvar,mix;

			startposition=MouseX.kr(0,1); //2
			triggerrate=MouseY.kr(0.1,35); //3
			trigger=LFPulse.kr(triggerrate,add:-0.5); //3
			ampvar=TRand.kr(0.9,1.2,trigger);

			source=PlayBuf.ar(~buff.numChannels,~buff.bufnum,arate,trigger,~buff.numFrames*startposition,1)*aamp; //2,3
			if (~buff.numChannels==1,
				{mix=Pan2.ar(source,TRand.kr(apan.neg,apan,trigger));},
				{mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger));});

			Out.ar(0,mix*ampvar); //5

		}).add;

		SynthDef("PlayBack2",{
			arg aamp,arate,apan;
			var source,trigger,startposition,triggerrate,ampvar,mix;

			startposition=MouseX.kr(0,1);
			triggerrate=MouseY.kr(0.1,35);
			trigger=LFPulse.kr(triggerrate,add:-0.5);
			ampvar=TRand.kr(0.9,1.2,trigger);


			source=PlayBuf.ar(~buff2.numChannels,~buff2.bufnum,arate,trigger,~buff2.numFrames*startposition,1)*aamp;

			if (~buff2.numChannels==1,
				{mix=Pan2.ar(source,TRand.kr(apan.neg,apan,trigger));},
				{mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger));});
			Out.ar(0,mix*ampvar);

		}).add;

		SynthDef("PlayBack3",{
			arg aamp,arate,apan;
			var source,trigger,startposition,triggerrate,ampvar,mix,rm;

			startposition=MouseX.kr(0,1);
			triggerrate=MouseY.kr(0.1,35);
			trigger=LFPulse.kr(triggerrate,add:-0.5);
			ampvar=TRand.kr(0.9,1.2,trigger);


			source=PlayBuf.ar(~buff3.numChannels,~buff3.bufnum,arate,trigger,~buff3.numFrames*startposition,1)*aamp;
			if (~buff3.numChannels==1,
				{mix=Pan2.ar(source,TRand.kr(apan.neg,apan,trigger));},
				{mix=Pan2.ar(source.sum,TRand.kr(apan.neg,apan,trigger));});

			Out.ar(0,mix*ampvar);

		}).add;

	};//end of loadsamples

	CmdPeriod.add({~cpanel2.close});

	//SystemClock

	SystemClock.sched(2,{
		~loadsamples.value(0);
	});

	//~loadsamples.value(0);
};
