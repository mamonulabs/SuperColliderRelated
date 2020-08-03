//Step 4

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

~rmhs.value(0.35,10,50,4/3,20);




