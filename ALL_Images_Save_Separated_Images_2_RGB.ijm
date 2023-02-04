//Select open and save foldes
openDir = getDirectory("Choose a Processing Directory");
saveDir = getDirectory("Choose a Save Directory");
list = getFileList(openDir);

for (i=0; i < list.length; i++){
	operation();
};

print("Macro Finished")

//Define operations
function operation(){
	open(openDir+list[i]);
	original_name = getTitle;
	dotIndex = indexOf(original_name, ".");
	title = substring(original_name, 0, dotIndex);

	run("Z Project...", "projection=[Max Intensity]");
	run("Scale Bar...", "width=20 height=112 thickness=5 font=10 color=White background=None location=[Lower Right] horizontal bold overlay");
	_name=getTitle;

	run("Duplicate...", "title="+_name+"_marged duplicate");
	separeted_name=getTitle;

	run("Split Channels");

	C1_name = "C1-"+separeted_name;
	C2_name = "C2-"+separeted_name;
	C3_name = "C3-"+separeted_name;

	selectWindow(C1_name);
	run("RGB Color");
	C1_newname = title+"_C1_"+"RGB.tif";
	rename(C1_newname);
	saveAs("tiff", saveDir+C1_newname);
	close(C1_newname);

	selectWindow(C2_name);
	run("RGB Color");
	C2_newname = title+"_C2_"+"RGB.tif";
	rename(C2_newname);
	saveAs("tiff", saveDir+C2_newname);
	close(C2_newname);
	
	selectWindow(C3_name);
	run("RGB Color");
	C3_newname = title+"_C3_"+"RGB.tif";
	rename(C3_newname);
	saveAs("tiff", saveDir+C3_newname);
	close(C3_newname);
	
	selectWindow(_name);
	run("RGB Color");
	newname = title+"_Marged_"+"RGB.tif";
	rename(newname);
	saveAs("tiff", saveDir+newname);
	close(newname);
	
	close();
	close(original_name);
	}
	
