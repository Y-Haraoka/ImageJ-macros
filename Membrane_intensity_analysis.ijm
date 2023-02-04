//Do someting for selected folder
saveDir = getDirectory("Choose a Save Directory");

//GFP細胞およびF-actinのチャンネルを入力する
items = newArray("C1", "C2", "C3", "C4");

Dialog.create("Mosaic Cell Channel Information");
Dialog.addMessage("Choice the channels of Cells");
Dialog.addChoice("MosaicCells", items);
Dialog.show();
MosaicCell_Choice = Dialog.getChoice();

Dialog.create("Protein of Interest Channel Information");
Dialog.addChoice("Protein Of Interest", items);
Dialog.show();
PoI_Choice = Dialog.getChoice();

//ROIを設定する
setTool("polygon");
waitForUser("ROI selection", "Select ROI using rectangle tool, then click \"OK\".");
	
run("Clear Outside", "stack"); //ROI以外のシグナルを削除する

oriName = getTitle();
run("16-bit");
run("Split Channels");

//Mosaic細胞と定量するタンパク質について、それぞれの名前を設定する
MosaicName = MosaicCell_Choice+"-"+oriName;
PoIName = PoI_Choice+"-"+oriName;

//アルファベット順に名前をSortした際に、それぞれの細胞がまとまるようにChannelの情報は文頭ではなく文末になるように名前を変更する
Renamed_MosaicName = oriName+"_MosaicCell_"+MosaicCell_Choice
Renamed_PoIName = oriName+"_ProteinOfInterest_"+PoI_Choice

//各々の画像の名前を変更
selectWindow(MosaicName);
rename(Renamed_MosaicName);
saveAs("Tiff", saveDir+Renamed_MosaicName);
MosaicCell_id = getImageID();

selectWindow(PoIName);
rename(Renamed_PoIName);
saveAs("Tiff", saveDir+Renamed_PoIName);
PoI_id = getImageID();

//Maskを作る前にMosaic細胞にガウスブラシしたのちにMaskを作製する
selectImage(MosaicCell_id);
run("Gaussian Blur...", "sigma=1.50");
MosaicCell_GB_id = getImageID();

setAutoThreshold("Otsu dark");
run("Convert to Mask");
//Drun("Watershed"); //複数の隣接した細胞について解析するなら必要かも？？

run("Analyze Particles...", "  show=[Masks] clear include");
Mask_name = Renamed_MosaicName+"_Masked";
rename(Mask_name);

//2回Duplicateして、もともとの画像名に_Dilated or _Erodedをつけた名前を設定する。
Dil_name = Mask_name+"_Dilated";
Erode_name = Mask_name+"_Eroded";

selectWindow(Mask_name);
run("Duplicate...", "title=Dilate_img");
selectWindow("Dilate_img");
rename(Dil_name);

selectWindow(Mask_name);
run("Duplicate...", "title=Erode_img");
selectWindow("Erode_img");
rename(Erode_name);


selectWindow(Dil_name);
run("Dilate");
Dil_id = getImageID();


selectWindow(Erode_name);
run("Erode");
run("Erode");
Erode_id = getImageID();


imageCalculator("Difference create",Erode_id, Dil_id);

Rim_name = Mask_name+"_Rim";
rename(Rim_name);
Rim_id = getImageID();


//作製したRimをもとに膜タンパク質の蛍光強度を測定する。
run("Create Selection");
selectImage(PoI_id);
run("Restore Selection");
run("Measure");
saveAs("Results", saveDir+oriName+".csv");

//Close all data
selectImage(Erode_id);
saveAs("Tiff", saveDir+Erode_name);
close();

selectImage(Dil_id);
saveAs("Tiff", saveDir+Dil_name);
close();

selectImage(Rim_id);
saveAs("Tiff", saveDir+Rim_name);
close();

selectImage(MosaicCell_GB_id);
saveAs("Tiff", saveDir+Renamed_MosaicName+"_GaussBul");
close(MosaicCell_GB_id);

close(Renamed_MosaicName+".tif");
close(Renamed_PoIName+".tif");
close(Mask_name);
close("Results");

close();
