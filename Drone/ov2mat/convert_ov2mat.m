% converts OV saved data+stim file pair to a .mat file

function a = convert_ov2mat(inputOvFilename, outputMatFilename)

	openvibeConvert = '"C:\Program Files (x86)\openvibe-2.1.0\openvibe-convert.cmd"';
	
	csvFn = regexprep(inputOvFilename, '\.ov$', '\.csv');	
	stimFn = regexprep(inputOvFilename, '\.ov$', '\.csv\.stims\.csv');	

	fprintf(1, 'File %s ... \n', inputOvFilename);
	fprintf(1, '  Converting to CSV pair...\n');
	fprintf(1, '    Signal : %s\n', csvFn);
	fprintf(1, '    Markers: %s\n', stimFn);
	
	cmd = sprintf('%s %s %s', openvibeConvert, inputOvFilename, csvFn);
	system(cmd);
	
	fprintf(1, '  Loading pair...\n');
	
    data=readtable(csvFn,'delimiter',';','HeaderLines',1);
	stims=readtable(stimFn,'delimiter',';','HeaderLines',1);
	data=readtable(csvFn,'delimiter',';');
	stims=readtable(stimFn,'delimiter',';');
	
	channelNames = data.Properties.VariableNames;

	data = table2array(data);
	stims = table2array(stims);
	sampleTime = data(:,1);
	samplingFreq = data(1,end);
	eegData = data(:,2:end-1);
	channelNames = channelNames(2:end-1);
	
	fprintf(1, '  Saving to %s...\n', outputMatFilename);
	
	save(outputMatFilename, 'stims','sampleTime', 'eegData', 'samplingFreq', 'channelNames');
		
	fprintf(1, '  Deleting temp files...\n');
	
	delete(csvFn);
	delete(stimFn);
	a = 0;
end