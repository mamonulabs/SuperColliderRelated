//SIOE - asynchronous remixer
//Simple is Opposite of Easy
//by Joo Won Park
//www.joowonpark.net/sioe
//SIOE is part of CMPE project

//Step 2. Make one-shot, play all loop

~oneShot={
	arg density,repeat,release;
	density.do{
		arg counter;
		var startpos;
		startpos=(counter+1)/repeat;
		//automatic volume control & automatic "splicer"
		Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
	};
};

//arg density, repeat, release
~oneShot.value(10,5,2);
~oneShot.value(10,2,2);

~oneShotTimed={
	arg density,repeat,release;
	Routine({
		density.do{
			arg counter;
			var startpos;
			startpos=(counter+1)/repeat;
			Synth("iAllone",[\aamp,1/(density*0.8),\aatk,rrand(0.01,0.3),\arel,rrand(release*0.5,release),\aloc,startpos]);
			1.wait;
		};
	}).play;
};

~oneShotTimed.value(10,10,2);