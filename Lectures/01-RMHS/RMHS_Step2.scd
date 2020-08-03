//Step2
//with vamp
10.do{
	arg counter;
	var vamp;
	vamp=(2/3)/(counter+1);
	Synth("iSimple",[
		\aamp,0.2*vamp,
		\afreq,50*(counter+1),
		\apan,0,
		\adur,10
	]);
};

//w/o vamp
10.do{
	arg counter;
	var vamp;
	vamp=(counter+1);
	Synth("iSimple",[\aamp,0.1*2/3,\afreq,50*(counter+1),\apan,0,\adur,10]);
};

