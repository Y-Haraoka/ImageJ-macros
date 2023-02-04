//選択したフォルダーの画像をZ-projectionして、マージ画像と個々の画像をそれぞれRGBに変換して保存する

openDir = getDirectory("Choose a Processing Directory");
saveDir = getDirectory("Choose a Save Directory");
list = getFileList(openDir);

//For文でフォルダー内の個々のファイルに対して定義した関数(operation)で処理する
for (i=0; i < list.length; i++){
	operation();
};

print("Macro Finished");


//以下、定義した関数。
function operation(){
	open(openDir+list[i]);
	
	run("Z Project...", "projection=[Max Intensity]");
	run("Scale Bar...", "width=20 height=112 thickness=5 font=10 color=White background=None location=[Lower Right] horizontal bold overlay");
	
	ori_name = getTitle;
	ori_id = getImageID();
	dotIndex = indexOf(ori_name, ".");
	title = substring(ori_name, 0, dotIndex);
	
	//元々の画像はMergeでDuplicateした画像はseparatedにする
	run("Duplicate...", "title="+ori_name+"_marged duplicate");
	separeted_name = getTitle;
	
	
	run("Split Channels");
	
	C1_name = "C1-"+separeted_name;
	C2_name = "C2-"+separeted_name;
	C3_name = "C3-"+separeted_name;
	
	selectWindow(C1_name);
	C1_id = getImageID();
	run("RGB Color");
	
	C1_newname = title+"_C1_"+"_RGB.tif";
	
	rename(C1_newname);
	saveAs("tiff", saveDir+C1_newname);
	close(C1_newname);
	
	selectWindow(C2_name);
	C2_id = getImageID();
	run("RGB Color");
	C2_newname = title+"_C2_"+"_RGB.tif";
	rename(C2_newname);
	saveAs("tiff", saveDir+C2_newname);
	close(C2_newname);
	
	selectWindow(C3_name);
	C3_id = getImageID();
	run("RGB Color");
	C3_newname = title+"_C3_"+"_RGB.tif";
	rename(C3_newname);
	saveAs("tiff", saveDir+C3_newname);
	close(C3_newname);
	
	Ori_newname = title+"_Marged_"+"_RGB.tif";
	selectImage(ori_id);
	run("Make Composite"); //Z-ProjectしただけだったらマージにできていないのでMake Compositeする必要があった！
	run("RGB Color");
	rename(Ori_newname);
	saveAs("tiff", saveDir+Ori_newname);
	close(Ori_newname);
	
	close("*");
	}
