//StarDist 2Dを使って細胞をカウントするためのMacro (半自動)

//使用するchannnelはCtrl＋Fで「ch00」を選択&コピーして別のDirにペーストするといい。
//If文で作るのは断念した。string型の取り扱い方を学ぶ必要がある。

//Do someting for selected folder
openDir = getDirectory("Choose a Processing Directory");
saveDir = getDirectory("Choose a Save Directory");
list = getFileList(openDir);

run("Set Measurements...", "area mean shape display redirect=None decimal=3");


for (i=0; i < list.length; i++){
	operation();
};

print("Macro Finished")


//Define operations
function operation(){
	open(openDir+list[i]);

	//ファイルの名前を取得
	original_name = getTitle();
	dotIndex = indexOf(original_name, ".");
	title = substring(original_name, 0, dotIndex);
	
	//手動でROIを選択する
	setTool("rectangle");
	waitForUser("ROI selection", "Select ROI using rectangle tool, then click \"OK\".");
	
	
	run("Crop");
	run("16-bit");
	
	
	//'input'を画像のTitleのままにしてStarDistをするとエラーが出た。いったん文字列（”16-bit_img”）に変換すると上手くいった。なぜかは不明。
	newname = "16-bit_img";
	rename(newname);
	
	//Star Dist 2Dを行う。パロメータは以下の通り。
	//probability / score threshold (probThresh):'0.5'
	//overlap threshold (nmsThresh):'0.15'
	run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input': '16-bit_img', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'0.0', 'percentileTop':'100.0', 'probThresh':'0.5', 'nmsThresh':'0.15', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	roiManager("Measure");
	saveAs("Results", saveDir+title+".csv");
	
	
	//StarDist画像も保存
	selectWindow("Label Image");
	run("RGB Color");
	SDname = title+"_StarDisted.tif";
	rename(SDname);
	
	selectWindow(SDname);
	saveAs("Tiff", saveDir+SDname);
	close(SDname);
	
	
	//16ビットにした画像も保存
	selectWindow(newname);
	bit_name = title + "_16bit";
	rename(bit_name);
	saveAs("Tiff", saveDir+bit_name+".tif");
	
	
	//ファイルたちを閉じる
	//見直したいときもあるので一応コメントアウト
	close(bit_name);
	close(newname);
	close("Results");
	close();
	}			
	
