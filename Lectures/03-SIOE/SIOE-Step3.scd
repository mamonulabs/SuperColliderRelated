//SIOE - asynchronous remixer
//Simple is Opposite of Easy
//by Joo Won Park
//www.joowonpark.net/sioe
//SIOE is part of CMPE project

//Step 3. Make a sequenced "build-up" and "build-down" loops

~firsthalf={
	arg repeat,swait,release;
	var beat;
	beat=60/swait*4; //convert BPM to a whole note

	Routine({
		"first half".postln;
		repeat.do{
			arg vcounter;
			var density;
			density=vcounter+1;
			density.do{
				arg counter;
				var startpos;
				startpos=(counter+1)/repeat;
				Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);

			};
			("# of voices per measure: "++density).postln;
			beat.wait;
		};
	}).play;

};

//arg repeat, swait (in BPM), release
~firsthalf.value(10,150,2);

~secondhalf={
	arg repeat,swait,release;
	var beat;
	beat=60/swait*4; //convert BPM to a whole note

	Routine({
		"first half".postln;
		repeat.do{
			arg vcounter;
			var density;
			//density=vcounter+1;
			density=(repeat-(vcounter+1));
			density.do{
				arg counter;
				var startpos;
				startpos=(counter+1)/repeat;
				Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);

			};
			("# of voices per measure: "++density).postln;
			beat.wait;
		};
	}).play;

};

//arg repeat, swait (in BPM), release
~secondhalf.value(10,150,2);

//Put ~firsthalf and ~secondhalf together in sequence

~sioe={
	arg repeat,swait,release;
	var beat;
	beat=60/swait*4;
	~routprocess=Routine({
		"first half".postln;
		repeat.do{
			arg vcounter;
			var density;
			density=vcounter+1;
			//reverse=(repeat-(vcounter+1));
			density.do{
				arg counter;
				var startpos;
				startpos=(counter+1)/repeat;
				Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
			};
			("# of voices per measure: "++density).postln;
			beat.wait;
		};

		"second half".postln;
		repeat.do{
			arg vcounter;
			var density;
			//forward=vcounter+1;
			density=(repeat-(vcounter+1));
			density.do{
				arg counter;
				var startpos;
				startpos=(counter+1)/repeat;
				Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
			};
			("# of voices per measure: "++density).postln;
			beat.wait;
		}
	});
	~routprocess.reset;~routprocess.play;
};

//arg repeat, swait (in BPM), release
~sioe.value(10,150,2);
~sioe.value(30,700,1);
